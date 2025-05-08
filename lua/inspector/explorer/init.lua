local M = {}


M.setup = function()
    require('inspector.colorscheme')
end

--- @param tests Test[]
M.showTests = function(tests)
    require('inspector.explorer.ui.testTreeView').showTests(tests)
end

return M
