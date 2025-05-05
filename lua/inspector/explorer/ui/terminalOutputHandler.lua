local M = {}

local mainBuffer = require('inspector.explorer.ui.mainBuffer')

M.handleStdout = function(error, data)
    local text = 'nothing to show'
	if data ~= nil then text = data
    elseif error ~= nil then text = error end
	vim.schedule(function()
		local splitData = vim.split(text, "\r\n")
        if #splitData == 1 then
            splitData = vim.split(text, "\n")
        end
		mainBuffer.appendLinesToTestBuffer(splitData)

		local window = vim.api.nvim_call_function("bufwinid", { mainBuffer.getId() })
		local linesCount = vim.api.nvim_buf_line_count(mainBuffer.getId())
		vim.api.nvim_win_set_cursor(window, { linesCount, 0 })
	end)
end

return M
