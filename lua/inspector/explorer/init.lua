local M = {}


M.setup = function()
    require('inspector.colorscheme').setup()
end

M.open = function()
    require('inspector.explorer.ui.mainBuffer').open()
end

M.handleStdout = function(error, data)
    require('inspector.explorer.ui.terminalOutputHandler').handleStdout(error, data)
end

--- @param tests Test[]
M.showTests = function(tests)
    require('inspector.explorer.ui.testTreeView').showTests(tests)
end

return M
