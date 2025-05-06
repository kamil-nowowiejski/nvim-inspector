local M = { }

local highlights = require('inspector.colorscheme.highlights')
local cursorLineExtmarkId = -1

local function setHighlights(buf)
    vim.hl.range(buf, 1, highlights.HLInspectorStackTraceErrorMessage, {0, 0}, {0, -1})

    local linesCount = vim.api.nvim_buf_line_count(buf)
    for i=2,linesCount,1 do
        local hlName = nil
        if i%2 == 0 then
            hlName = highlights.HLInspectorStackTraceEvenLine
        else
            hlName = highlights.HLInspectorStackTraceOddLine
        end
        vim.hl.range(buf, 1, hlName, {i, 0}, {i, -1})
    end


end

--- @param testNode TestNameNode
M.show = function(testNode)

    local testDetailsLines = { testNode.errorMessage, "" }
    for _, stackTraceLine in ipairs(testNode.stackTrace) do
        table.insert(testDetailsLines, #testDetailsLines + 1, stackTraceLine.line)
    end
    local tempBuffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(tempBuffer, 0, -1, false, testDetailsLines)

    setHighlights(tempBuffer)

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

    local setOptionOpts = { scope = "local", win = winId }
    vim.api.nvim_set_option_value('number', false, setOptionOpts)
    vim.api.nvim_set_option_value('relativenumber', false, setOptionOpts)
    vim.api.nvim_set_option_value('wrap', true, setOptionOpts)
    vim.api.nvim_set_option_value('colorcolumn', '', setOptionOpts)
    vim.api.nvim_set_option_value('spell', false, setOptionOpts)
    vim.api.nvim_set_option_value('signcolumn', 'no', setOptionOpts)
    vim.api.nvim_set_option_value('cursorline', false, setOptionOpts)
    vim.api.nvim_set_option_value('winhighlight', 'NormalFloat:'..highlights.HLInspectorStackTraceNormalFloat, setOptionOpts)
    linebreak
    wrapmargin

    vim.api.nvim_create_autocmd('BufLeave', {
        buffer = tempBuffer,
        callback = function(data)
            vim.api.nvim_del_autocmd(data.id)
            vim.api.nvim_buf_delete(tempBuffer, {force = true})
        end
    })

    vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = tempBuffer,
        callback = function()
            local cursorLine = vim.api.nvim_win_get_cursor(winId)[1] - 1
            local opts = {
                end_row = cursorLine,
                line_hl_group = highlights.HLInspectorStackTraceCursorLine,
                hl_eol = true,
                priority = 100
            }
            if cursorLineExtmarkId ~= -1 then
                opts.id = cursorLineExtmarkId
            end
            cursorLineExtmarkId = vim.api.nvim_buf_set_extmark(tempBuffer, 1, cursorLine, 0, opts)
        end
    })
end

return M
