local M = {}

local currentCommandHandle = nil

M.cancelSignal = 15 -- this is termination signal in vim.system, other numbers don't work

M.setCurrentCommandHandle = function(handle)
    currentCommandHandle = handle
end

M.killCurrentCommand = function()
    if currentCommandHandle ~= nil then
        currentCommandHandle:kill(M.cancelSignal)
    end
end

return M
