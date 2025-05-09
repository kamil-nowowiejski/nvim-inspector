local M = {}


M.setup = function()
    require('inspector.colorscheme').setup()
end

M.open = function()
    require('inspector.testExplorer.mainBuffer').open()
end

M.handleStdout = function(error, data)
    require('inspector.testExplorer.terminalOutputHandler').handleStdout(error, data)
end

--- @param tests Test[]
M.showTests = function(tests)
    require('inspector.testExplorer.testsTree.testTreeView').showTests(tests)
end

return M
