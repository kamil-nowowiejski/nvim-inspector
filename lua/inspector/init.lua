local M = {}

M.setup = function()
    require('inspector.explorer').setup()
end

M.setupVimTest = function()
    require('inspector.runners').setupVimTest()
end

return M
