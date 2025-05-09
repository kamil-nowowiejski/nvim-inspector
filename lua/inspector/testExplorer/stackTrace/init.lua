local M = {}

--- @param testNode TestNameNode
M.show = function(testNode)
    require('inspector.testExplorer.stackTrace.stackTraceExplorer').show(testNode)
end

return M
