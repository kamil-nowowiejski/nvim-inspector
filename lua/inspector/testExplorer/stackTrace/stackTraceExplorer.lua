local M = { }

local highlights = require('inspector.colorscheme.highlights')
local cursorLineExtmarkId = -1

--- @type { [number]: StackTraceFileRef } key is the line number (1-based)
local fileRefs = nil

--- @param buf integer
--- @param stackTrace string[]
local function setHighlights(buf, stackTrace)
    vim.hl.range(buf, highlights.namespace, highlights.StackTraceErrorMessage, {0, 0}, {0, -1})

    local isMyCodeResolver = require('inspector.testExplorer.stackTrace.isMyCodeResolver')
    fileRefs = {}
    for i, line in ipairs(stackTrace) do
        local lineNumber = i + 1
        vim.hl.range(buf, highlights.namespace, highlights.StackTraceLine, {lineNumber, 0}, {lineNumber, -1})

        local stackTraceFileRef = isMyCodeResolver.resolve(line, vim.fn.getcwd())
        if stackTraceFileRef ~= nil then
            fileRefs[lineNumber] = stackTraceFileRef
            vim.hl.range(buf, highlights.namespace, highlights.StackTraceMyCode,
                {lineNumber, stackTraceFileRef.highlight.start - 1},
                {lineNumber, stackTraceFileRef.highlight.finish})
        end
    end
end

local function goToFile(winId)
    local lineNumber = vim.api.nvim_win_get_cursor(0)[1] - 1
    local fileRef = fileRefs[lineNumber]
    if fileRef == nil then return end

    local fileExists = vim.fn.filereadable(fileRef.fileName) == 1
    if fileExists == false then
        error('File not foud')
    else
        vim.api.nvim_win_close(winId, true)
        vim.cmd('e '..fileRef.fileName)
        vim.api.nvim_win_set_cursor(0, {fileRef.line, 0})
    end
end

--- @param testNode TestNameNode
M.show = function(testNode)
    local testDetailsLines = { testNode.errorMessage, "" }
    for _, stackTraceLine in ipairs(testNode.stackTrace) do
        table.insert(testDetailsLines, #testDetailsLines + 1, stackTraceLine)
    end
    local tempBuffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(tempBuffer, 0, -1, false, testDetailsLines)

    setHighlights(tempBuffer, testNode.stackTrace)

    local sizeFactor = 0.8
    local width = math.floor(vim.o.columns * sizeFactor)
    local height = math.floor(vim.o.lines * sizeFactor)

    local winId = vim.api.nvim_open_win(tempBuffer, true, {
        relative = 'editor',
        width = width,
        height = height,
        zindex = 1000,
        row = (vim.o.lines/2) - height/2,
        col = (vim.o.columns/2) - width/2,
        border = 'single'
    });
    vim.api.nvim_win_set_hl_ns(winId, highlights.namespace)

    local winOpts = { scope = "local", win = winId }
    vim.api.nvim_set_option_value('number', false, winOpts)
    vim.api.nvim_set_option_value('relativenumber', false, winOpts)
    vim.api.nvim_set_option_value('wrap', true, winOpts)
    vim.api.nvim_set_option_value('colorcolumn', '', winOpts)
    vim.api.nvim_set_option_value('spell', false, winOpts)
    vim.api.nvim_set_option_value('signcolumn', 'no', winOpts)
    vim.api.nvim_set_option_value('cursorline', false, winOpts)
    vim.api.nvim_set_option_value('linebreak', true, winOpts)

    vim.keymap.set("n", "<CR>", function() goToFile(winId) end, { buffer = tempBuffer })

    vim.api.nvim_create_autocmd('BufLeave', {
        buffer = tempBuffer,
        callback = function(data)
            vim.api.nvim_del_autocmd(data.id)
            vim.api.nvim_buf_delete(tempBuffer, {force = true})
        end
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        buffer = tempBuffer,
        callback = function()
            vim.api.nvim_win_set_hl_ns(winId, highlights.namespace)
        end
    })

    vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = tempBuffer,
        callback = function()
            local cursorLine = vim.api.nvim_win_get_cursor(winId)[1] - 1
            if cursorLine <= 1 and cursorLineExtmarkId ~= -1 then
                vim.api.nvim_buf_del_extmark(tempBuffer, highlights.extMarkNamespace, cursorLineExtmarkId)
                return
            elseif cursorLine > 1 then
                local opts = {
                    end_row = cursorLine,
                    line_hl_group = highlights.StackTraceCursorLine,
                    hl_eol = true,
                    priority = 100
                }
                if cursorLineExtmarkId ~= -1 then
                    opts.id = cursorLineExtmarkId
                end
                cursorLineExtmarkId = vim.api.nvim_buf_set_extmark(tempBuffer, highlights.extMarkNamespace, cursorLine, 0, opts)

            end
        end
    })
end

return M
