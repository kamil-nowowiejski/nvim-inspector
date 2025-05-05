local M = {}

local mainBuffer = require('inspector.explorer.ui.mainBuffer')

--- @type TestsTree
local testsTree = nil

--- @type Line[]
local lines = nil

local function redrawTree()
    lines = require("plugins.vimtest.lineConverter").convertToLines(testsTree)
	mainBuffer.clearTestBuffer()
	mainBuffer.appendLinesToTestBuffer(lines)
end

local function handleEnterKey()
	local window = vim.api.nvim_call_function("bufwinid", { mainBuffer.getId() })
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1] - 1
    lines[row].treeNode.isExpanded = not lines[row].treeNode.isExpanded
    redrawTree()
    vim.api.nvim_win_set_cursor(window, pos)
end

local function handleOpenTestDetails()
	local window = vim.api.nvim_call_function("bufwinid", { mainBuffer.getId() })
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1] - 1

    local selectedNode = lines[row].treeNode
    if getmetatable(selectedNode).type ~= "TestNameNode" then
        return
    end

	--- @cast selectedNode TestNameNode
    if selectedNode.status == "success" then
        return
    end

    local testDetailsLines = { selectedNode.errorMessage, "" }
    for _, value in ipairs(selectedNode.stackTrace) do
        table.insert(testDetailsLines, #testDetailsLines + 1, value)
    end
    local tempBuffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(tempBuffer, 0, -1, false, testDetailsLines)

    local sizeFactor = 0.7
    local width = math.floor(vim.o.columns * sizeFactor)
    local height = math.floor(vim.o.lines * sizeFactor)

    local winId = vim.api.nvim_open_win(tempBuffer, true, {
        relative = 'editor',
        width = width,
        height = height,
        zindex = 1000,
        row = (vim.o.lines/2) - height/2,
        col = (vim.o.columns/2) - width/2
    });

    local setOptionOpts = { scope = "local", win = winId }
    vim.api.nvim_set_option_value('number', false, setOptionOpts)
    vim.api.nvim_set_option_value('relativenumber', false, setOptionOpts)
    vim.api.nvim_set_option_value('wrap', true, setOptionOpts)
    vim.api.nvim_set_option_value('colorcolumn', '', setOptionOpts)
    vim.api.nvim_set_option_value('spell', false, setOptionOpts)

    vim.api.nvim_create_autocmd('BufLeave', {
        buffer = tempBuffer,
        callback = function(data)
            vim.api.nvim_del_autocmd(data.id)
            vim.api.nvim_buf_delete(tempBuffer, {force = true})
        end
    })
end

local function setupLocalKeymaps()
    vim.keymap.set("n", "<CR>", handleEnterKey, { buffer = mainBuffer.getId() })
    vim.keymap.set("n", "o", handleOpenTestDetails, { buffer = mainBuffer.getId() })
end

--- @param tests Test[]
M.showTests = function(tests)
    testsTree = require('inspector.explorer.testTreeConverter').convertTestsToTestsTree(tests)
    redrawTree()
    setupLocalKeymaps()
end
return M
