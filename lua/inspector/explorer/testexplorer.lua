local M = {}

--- @type number
local testExplorerBuffer = -1

--- @type TestsTree
local testsTree = nil

--- @type Line[]
local lines = nil

local function modifyTestBuffer(modifyFunction)
	local setOptionOpts = {
		buf = testExplorerBuffer,
	}
	vim.api.nvim_set_option_value("readonly", false, setOptionOpts)
	modifyFunction()
	vim.api.nvim_set_option_value("readonly", true, setOptionOpts)
	vim.api.nvim_set_option_value("modified", false, setOptionOpts)
end

local function clearTestBuffer()
	modifyTestBuffer(function()
		vim.api.nvim_buf_set_lines(testExplorerBuffer, 0, -1, false, {})
	end)
end

--- @param lines Line[] | string[]
local function appendLinesToTestBuffer(lines)
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
		vim.api.nvim_buf_set_lines(testExplorerBuffer, -1, -1, false, textLines)

		-- set highlights
		if isPlainString == false then
			for i, line in pairs(lines) do
				if line.highlight ~= nil then
					vim.api.nvim_buf_add_highlight(
						testExplorerBuffer,
						-1,
						line.highlight.name,
						i,
						line.highlight.start,
						line.highlight.finish
					)
				end
			end
		end
	end)
end

M.open = function()
	local isBufferVisible = vim.api.nvim_call_function("bufwinnr", { testExplorerBuffer }) ~= -1
	if testExplorerBuffer == -1 or isBufferVisible == false then
		vim.api.nvim_command("belowright split 'Test Output'")
		testExplorerBuffer = vim.api.nvim_get_current_buf()
        vim.api.nvim_set_option_value('readonly', true, { buf = testExplorerBuffer })
        vim.api.nvim_set_option_value('swapfile', false, { buf = testExplorerBuffer })
	end

	if testExplorerBuffer ~= -1 then
		clearTestBuffer()
	end
end

M.handleStdout = function(error, data)
    local text = 'nothing to show'
	if data ~= nil then text = data
    elseif error ~= nil then text = error end
	vim.schedule(function()
		local splitData = vim.split(text, "\r\n")
        if #splitData == 1 then
            splitData = vim.split(text, "\n")
        end
		appendLinesToTestBuffer(splitData)

		local window = vim.api.nvim_call_function("bufwinid", { testExplorerBuffer })
		local linesCount = vim.api.nvim_buf_line_count(testExplorerBuffer)
		vim.api.nvim_win_set_cursor(window, { linesCount, 0 })
	end)
end

local function redrawTree()
    lines = require("plugins.vimtest.lineConverter").convertToLines(testsTree)
	clearTestBuffer()
	appendLinesToTestBuffer(lines)
end

local function handleEnterKey()
	local window = vim.api.nvim_call_function("bufwinid", { testExplorerBuffer })
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1] - 1
    lines[row].treeNode.isExpanded = not lines[row].treeNode.isExpanded
    redrawTree()
    vim.api.nvim_win_set_cursor(window, pos)
end

local function handleOpenTestDetails()
	local window = vim.api.nvim_call_function("bufwinid", { testExplorerBuffer })
    local pos = vim.api.nvim_win_get_cursor(window)
    local row = pos[1] - 1

    local selectedNode = lines[row].treeNode
    if getmetatable(selectedNode).type ~= "TestNameNode" then
        return
    end

	--- @cast selectedNode TestNameNode
    if selectedNode.status == "success" then
        return
    end

    local testDetailsLines = { selectedNode.errorMessage, "" }
    for _, value in ipairs(selectedNode.stackTrace) do
        table.insert(testDetailsLines, #testDetailsLines + 1, value)
    end
    local tempBuffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(tempBuffer, 0, -1, false, testDetailsLines)

    local sizeFactor = 0.7
    local width = math.floor(vim.o.columns * sizeFactor)
    local height = math.floor(vim.o.lines * sizeFactor)

    local winId = vim.api.nvim_open_win(tempBuffer, true, {
        relative = 'editor',
        width = width,
        height = height,
        zindex = 1000,
        row = (vim.o.lines/2) - height/2,
        col = (vim.o.columns/2) - width/2
    });

    local setOptionOpts = { scope = "local", win = winId }
    vim.api.nvim_set_option_value('number', false, setOptionOpts)
    vim.api.nvim_set_option_value('relativenumber', false, setOptionOpts)
    vim.api.nvim_set_option_value('wrap', true, setOptionOpts)
    vim.api.nvim_set_option_value('colorcolumn', '', setOptionOpts)
    vim.api.nvim_set_option_value('spell', false, setOptionOpts)

    vim.api.nvim_create_autocmd('BufLeave', {
        buffer = tempBuffer,
        callback = function(data)
            vim.api.nvim_del_autocmd(data.id)
            vim.api.nvim_buf_delete(tempBuffer, {force = true})
        end
    })
end

local function setupLocalKeymaps()
    vim.keymap.set("n", "<CR>", handleEnterKey, { buffer = testExplorerBuffer })
    vim.keymap.set("n", "o", handleOpenTestDetails, { buffer = testExplorerBuffer })
end

--- @param tests Test[]
M.showTests = function(tests)
    testsTree = require('plugins.vimtest.testTreeConverter').convertTestsToTestsTree(tests)
    redrawTree()
    setupLocalKeymaps()
end


local function _openExplorerForTesting()
    M.open()
    M.showTests({
        {
            testName = "test 1",
            namespaceParts = { "UnitTest", "Namespace1", "Namespace2", "Class1", "Class2" },
            status = "success",
            duration = "333",
        },
        {
            testName = "test 2",
            namespaceParts = { "UnitTest", "Namespace1", "Namespace2", "Class1" },
            status = "failure",
            duration = "546",
            errorMessage = "Buum",
            stackTrace = { "sss", "fff", "ggg" },
        },
        {
            testName = "test 3",
            namespaceParts = { "IntegrationTest", "Namespace1", "Namespace2", "Class1"},
            status = "failure",
            duration = "83435",
            errorMessage = "This blew up",
            stackTrace = { "aaaa", "jklhdgh", "hugdjgdjghjdhjghjgh" },
        }
    })
end

_openExplorerForTesting()

return M
