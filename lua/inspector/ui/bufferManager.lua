local M = {}

--- @class BufferLine
--- @field text string
--- @field highlight BufferLineHighlight | BufferLineHighlight[]

--- @class BufferLineHighlight
--- @field name string
--- @field start number
--- @field finish number

--- @class BufferManagerConfig
--- @field wrap? boolean defaults to false
--- @field linebreak? boolean defaults to false
--- @field cursorLine? boolean defaults to true
--- @field setupAutoCmds? function
--- @field setupKeymap? function 

--- @type BufferManagerConfig
local defaultConfig = {
    wrap = false,
    linebreak = false,
    cursorLine = true,
    setupAutoCmds = nil,
    setupKeymap = nil
}

M.createNew = function(bufferName, autoCmdGroupName, highlightsNamespace)
    local manager = {
        bufferId = -1
    }

    --- @param config BufferManagerConfig
    local function setWindowOptions(config)
        local opts = { win = vim.fn.bufwinid(manager.bufferId) }
        vim.api.nvim_set_option_value('spell', false, opts)
        vim.api.nvim_set_option_value('wrap', config.wrap, opts)
        vim.api.nvim_set_option_value('linebreak', config.linebreak, opts)
        vim.api.nvim_set_option_value('cursorline', config.cursorLine, opts)
    end

    --- @param config BufferManagerConfig
    local function setBufferOptions(config)
        local opts = { buf = manager.bufferId }
        vim.api.nvim_set_option_value('readonly', true, opts)
        vim.api.nvim_set_option_value('swapfile', false, opts)
    end

    local function setHighlightNamespace()
        local winId = vim.fn.bufwinid(manager.bufferId)
        vim.api.nvim_win_set_hl_ns(winId, highlightsNamespace)
    end

    local function modifyTestBuffer(modifyFunction)
        local opts = { buf = manager.bufferId }
        vim.api.nvim_set_option_value("readonly", false, opts)
        modifyFunction()
        vim.api.nvim_set_option_value("readonly", true, opts)
        vim.api.nvim_set_option_value("modified", false, opts)
    end

    function manager:clear()
        if self.bufferId ~= -1 then
            modifyTestBuffer(function()
                vim.api.nvim_buf_set_lines(self.bufferId, 0, -1, false, {})
            end)
        end
    end

    --- @param config BufferManagerConfig
    function manager:open(config)
        local isBufferVisible = vim.fn.bufwinid(self.bufferId) ~= -1
        if self.bufferId == -1 or isBufferVisible == false then
            local workingConfig = vim.tbl_deep_extend('keep', config, defaultConfig)
            vim.api.nvim_command("belowright split "..bufferName)
            self.bufferId = vim.api.nvim_get_current_buf()
            setBufferOptions(workingConfig)

            local autocmdGroup = vim.api.nvim_create_augroup(autoCmdGroupName, {
                clear = true
            })

            vim.api.nvim_create_autocmd("BufDelete", {
                group = autocmdGroup,
                buffer = self.bufferId,
                callback = function()
                    vim.api.nvim_del_augroup_by_id(autocmdGroup)
                    self.bufferId = -1
                end
            })
            vim.api.nvim_create_autocmd('BufWinEnter', {
                group = autocmdGroup,
                buffer = self.bufferId,
                callback = function()
                    setWindowOptions(workingConfig)
                    setHighlightNamespace()
                end
            })
            if config.setupAutoCmds ~= nil then config.setupAutoCmds(self.bufferId) end
            if config.setupKeymap ~= nil then config.setupKeymap(self.bufferId) end
            setWindowOptions(workingConfig)
            setHighlightNamespace()
        end

        if self.bufferId ~= -1 then
            self:clear()
        end
    end

    --- @param lines BufferLine[] | string[]
    local function setLines(lines, startLine)
        if #lines == 0 then
            return
        end
        local isPlainString = type(lines[1]) == "string"
        modifyTestBuffer(function()
            --populate buffer with text
            local textLines = {}
            if isPlainString then
                textLines = lines
            else
                for _, line in ipairs(lines) do
                    textLines[#textLines + 1] = line.text
                end
            end
            vim.api.nvim_buf_set_lines(manager.bufferId, startLine, -1, false, textLines)

            -- set highlights
            if isPlainString == false then
                for i, line in pairs(lines) do
                    if line.highlight ~= nil then
                        local hls = line.highlight
                        if line.highlight.name ~= nil then
                            hls = {}
                            table.insert(hls, line.highlight)
                        end

                        for _, hl in ipairs(hls) do
                            vim.hl.range(manager.bufferId, highlightsNamespace, hl.name, {i - 1, hl.start}, {i - 1, hl.finish})
                        end
                    end
                end
            end
        end)
    end
    --- @param lines BufferLine[] | string[]
    function manager:setLines(lines) setLines(lines, 0) end

    --- @param lines BufferLine[] | string[]
    function manager:appendLines(lines) setLines(lines, -1) end

    return manager
end

return M
