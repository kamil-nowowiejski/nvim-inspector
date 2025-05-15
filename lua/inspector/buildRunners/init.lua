local M = {}

M.setup = function()
    require('inspector.buildRunners.dotnet.runner').setup()
end

return M
