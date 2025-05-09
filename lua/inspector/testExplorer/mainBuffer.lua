local M = {}

--- @type number
local mainBufferId = -1
local highlights = require('inspector.colorscheme.highlights')

M.getId = function() return mainBufferId end

local function modifyTestBuffer(modifyFunction)
	local opts = {
		buf = mainBufferId,
	}
	vim.api.nvim_set_option_value("readonly", false, opts)
	modifyFunction()
	vim.api.nvim_set_option_value("readonly", true, opts)
	vim.api.nvim_set_option_value("modified", false, opts)
end

M.clearTestBuffer = function()
    if mainBufferId ~= -1 then
        modifyTestBuffer(function()
            vim.api.nvim_buf_set_lines(mainBufferId, 0, -1, false, {})
        end)
    end
end

local function setHighlightNamespace()
    local winId = vim.fn.bufwinid(mainBufferId)
    vim.api.nvim_win_set_hl_ns(winId, highlights.namespace)
end

local function setWindowOptions()
    local winId = vim.fn.bufwinid(mainBufferId)
    vim.api.nvim_set_option_value('spell', false, { win = winId } )
end

M.open = function()
	local isBufferVisible = vim.fn.bufwinid(mainBufferId) ~= -1
	if mainBufferId == -1 or isBufferVisible == false then
		vim.api.nvim_command("belowright split 'Test Output'")
		mainBufferId = vim.api.nvim_get_current_buf()
        local opts = { buf = mainBufferId }
        vim.api.nvim_set_option_value('readonly', true, opts)
        vim.api.nvim_set_option_value('swapfile', false, opts)

        local autocmdGroup = vim.api.nvim_create_augroup('InspctorMainBufferAutocmdGroup', {
            clear = true
        })

        vim.api.nvim_create_autocmd("BufDelete", {
            group = autocmdGroup,
            buffer = mainBufferId,
            callback = function()
                vim.api.nvim_del_augroup_by_id(autocmdGroup)
                mainBufferId = -1
            end
        })
        vim.api.nvim_create_autocmd('BufWinEnter', {
            group = autocmdGroup,
            buffer = mainBufferId,
            callback = function()
                setWindowOptions()
                setHighlightNamespace()
            end
        })
        setWindowOptions()
        setHighlightNamespace()
	end

	if mainBufferId ~= -1 then
		M.clearTestBuffer()
	end
end

--- @param lines Line[] | string[]
M.appendLinesToTestBuffer = function(lines)
	if #lines == 0 then
		return
	end
	local isPlainString = type(lines[1]) == "string"
	modifyTestBuffer(function()
		--populate buffer with text
		local textLines = {}
		if isPlainString then
			textLines = lines
		else
			for _, line in pairs(lines) do
				textLines[#textLines + 1] = line.text
			end
		end
		vim.api.nvim_buf_set_lines(mainBufferId, -1, -1, false, textLines)

		-- set highlights
		if isPlainString == false then
			for i, line in pairs(lines) do
				if line.highlight ~= nil then
                    vim.hl.range(mainBufferId, highlights.namespace, line.highlight.name, {i, line.highlight.start}, {i, line.highlight.finish})
				end
			end
		end
	end)
end

return M
