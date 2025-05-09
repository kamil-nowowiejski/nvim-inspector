local M = {}

local mainBuffer = require('inspector.testExplorer.mainBuffer')

--- @type TestsTree
local testsTree = nil

--- @type Line[]
local lines = nil

local function redrawTree()
    lines = require('inspector.testExplorer.testsTree.lineConverter').convertToLines(testsTree)
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
    if selectedNode.nodeType ~= "test" then
        return
    end

	--- @cast selectedNode TestNameNode
    if selectedNode.status == "success" then
        return
    end

    local stackTraceExplorer = require('inspector.testExplorer.stackTrace')
    stackTraceExplorer.show(selectedNode)
end

local function setupLocalKeymaps()
    vim.keymap.set("n", "<CR>", handleEnterKey, { buffer = mainBuffer.getId() })
    vim.keymap.set("n", "o", handleOpenTestDetails, { buffer = mainBuffer.getId() })
end

--- @param tests Test[]
M.showTests = function(tests)
    testsTree = require('inspector.testExplorer.testsTree.testTreeConverter').convertTestsToTestsTree(tests)
    mainBuffer.open()
    redrawTree()
    setupLocalKeymaps()
end
return M
