local M = {}

M.setup = function()
    require('inspector.colorscheme').setup()
    require('inspector.buildRunners').setup()
end

M.setupVimTest = function()
    require('inspector.testRunners').setupVimTest()
end

return M
