local M = {}

local highlights = require('inspector.colorscheme.highlights')
local bufferManager = require('inspector.ui.bufferManager')
                        .createNew('Test Output', 'InspectorTestExplorerAutocmdGroup', highlights.namespace)

--- @type TestsTree
local testsTree = nil

--- @type Line[]
local lines = nil

local function redrawTree()
    lines = require('inspector.testExplorer.testsTree.lineConverter').convertToLines(testsTree)
    bufferManager:clear()
    bufferManager:setLines(lines)
end

local function handleEnterKey()
    if vim.api.nvim_get_current_buf() ~= bufferManager:getBufferId() then return end

	local window = vim.api.nvim_call_function("bufwinid", { bufferManager:getBufferId() })
    if window == -1 then return end
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1]
    if lines[row].treeNode.nodeType == "test" then return end
    lines[row].treeNode.isExpanded = not lines[row].treeNode.isExpanded
    redrawTree()
    vim.api.nvim_win_set_cursor(window, pos)
end

local function handleOpenTestDetails()
    if vim.api.nvim_get_current_buf() ~= bufferManager:getBufferId() then return end

	local window = vim.api.nvim_call_function("bufwinid", { bufferManager:getBufferId() })
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1]

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

local function setupLocalKeymaps(bufferId)
    vim.keymap.set("n", "<CR>", handleEnterKey, { buffer = bufferId })
    vim.keymap.set("n", "o", handleOpenTestDetails, { buffer = bufferId })
end

M.open = function()
    bufferManager:open({ setupKeymap = setupLocalKeymaps })
 end

--- @param tests Test[]
M.showTests = function(tests)
    testsTree = require('inspector.testExplorer.testsTree.testTreeConverter').convertTestsToTestsTree(tests)
    M.open()
    redrawTree()
    setupLocalKeymaps(bufferManager:getBufferId())
end

M.createStdoutHandler = function()
    return require('inspector.ui.terminalOutputHandler').createStdoutHandler(bufferManager)
end
return M
