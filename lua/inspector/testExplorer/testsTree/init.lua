local M = {}

--- @param tests Test[]
M.showTests = function(tests)
    require('inspector.testExplorer.testsTree.testTreeView').showTests(tests)
end

return M
