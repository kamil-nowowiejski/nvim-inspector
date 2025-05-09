local M = {}

M.setup = function()
    require('inspector.testExplorer').setup()
end

M.setupVimTest = function()
    require('inspector.testRunners').setupVimTest()
end

return M
