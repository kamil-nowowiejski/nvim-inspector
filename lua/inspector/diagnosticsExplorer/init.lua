local M = {}

local explorer = require('inspector.diagnosticsExplorer.explorer')

--- @param diagnostics Diagnostics
M.open = function(diagnostics) explorer.open(diagnostics) end
M.close = function() explorer.close() end

return M
