local M = {}

local testTreeExplorer = require('inspector.testExplorer.testsTree.testTreeView')

M.open = function()
    testTreeExplorer.open()
end

M.createStdoutHandler = function()
    return testTreeExplorer.createStdoutHandler()
end

M.handleStdout = function(bufferId, error, data)
    require('inspector.ui.terminalOutputHandler').handleStdout(bufferId, error, data)
end

--- @param tests Test[]
M.showTests = function(tests)
    testTreeExplorer.showTests(tests)
end

return M
