local M = {}

--- @param bufferManager BufferManager
M.handleStdout = function(bufferManager, error, data)
    local text = ''
	if data ~= nil then text = data
    elseif error ~= nil then text = error
    else return end
	vim.schedule(function()
		local splitData = vim.split(text, "\r\n")
        if #splitData == 1 then
            splitData = vim.split(text, "\n")
        end
		bufferManager:appendLines(splitData)

		local window = vim.fn.bufwinid(bufferManager:getBufferId())
		local linesCount = vim.api.nvim_buf_line_count(bufferManager:getBufferId())
		vim.api.nvim_win_set_cursor(window, { linesCount, 0 })
	end)
end

--- @param bufferManager BufferManager
M.createStdoutHandler = function(bufferManager)
    return function(error, data)
        M.handleStdout(bufferManager, error, data)
    end
end

return M
