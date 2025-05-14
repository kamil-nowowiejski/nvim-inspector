local M = {}


local highlights = require('inspector.colorscheme.highlights')
local bufferManager = require('inspector.ui.bufferManager')
                        .createNew("Build Output", 'InspectorBuildExplorerAutocmdGroup', highlights.namespace)

local activeTab = 'errors'
local cursorLineExtmarkId = -1

--- @type { [number]: FilePosition }  keys are indexes of lines in the actual buffer
local filePositions = nil

local function goToFile(bufferId)
    local buildExplorerWinId = vim.fn.bufwinid(bufferId)
    local lineNumber = vim.api.nvim_win_get_cursor(buildExplorerWinId)[1]
    local fileRef = filePositions[lineNumber]
    if fileRef == nil then return end

    local fileExists = vim.fn.filereadable(fileRef.fileName) == 1
    if fileExists == false then
        error("File '"..fileRef.fileName.."' not found")
    else
        local bufs = vim.api.nvim_list_bufs()
        for _, bufId in ipairs(bufs) do
            local bufName = vim.api.nvim_buf_get_name(bufId)
            bufName = bufName:gsub("\\", "/")
            local targetWinId = vim.fn.bufwinid(bufId)
            local isNameMatch = string.find(bufName, fileRef.fileName) ~= nil
            if isNameMatch and targetWinId ~= -1  then
                vim.api.nvim_set_current_win(targetWinId)
                vim.api.nvim_win_set_cursor(targetWinId, {fileRef.line, 0})
                return
            end
        end
        vim.cmd('topleft split '..fileRef.fileName)
        vim.api.nvim_win_set_cursor(0, {fileRef.line, fileRef.column - 1})
    end
end

--- @param diagnostics Diagnostics
M.open = function(diagnostics)
    local linesConverter = require('lua.inspector.buildExplorer.ui.linesConverter')
    local headerLine, diagnosticLines = linesConverter.convertToLines(diagnostics, activeTab)

    filePositions = {}
    for i, line in ipairs(diagnosticLines) do
        filePositions[i + 1] = line.filePosition
    end

    table.insert(diagnosticLines, 1, headerLine)
    bufferManager:open({
        wrap = true,
        linebreak = true,
        cursorLine = false,
        setupKeymap = function(bufferId)
            vim.keymap.set("n", "<CR>", function() goToFile(bufferId) end, {buffer = bufferId})
        end,
        setupAutoCmds = function(bufferId)
            vim.api.nvim_create_autocmd('CursorMoved', {
                buffer = bufferId,
                callback = function()
                    local winId = vim.fn.bufwinid(bufferId)
                    local cursorLine = vim.api.nvim_win_get_cursor(winId)[1] - 1
                    if cursorLine == 0 and cursorLineExtmarkId ~= -1 then
                        vim.api.nvim_buf_del_extmark(bufferId, highlights.extMarkNamespace, cursorLineExtmarkId)
                    elseif cursorLine > 0 then
                        local opts = {
                            end_row = cursorLine,
                            line_hl_group = highlights.CursorLine,
                            hl_eol = true,
                            priority = 100
                        }
                        if cursorLineExtmarkId ~= -1 then
                            opts.id = cursorLineExtmarkId
                        end
                        cursorLineExtmarkId = vim.api.nvim_buf_set_extmark(bufferId, highlights.extMarkNamespace, cursorLine, 0, opts)
                    end
                end
            })
        end
    })

    bufferManager:setLines(diagnosticLines)
end

return M

