local M = {}

M.setup = function()
    require('inspector.explorer').setup()
    require('inspector.runners').setupVimTest()
end

return M
