local M = {}

local lastTestRunTrxFile = vim.fn.stdpath("data") .. "/LastTestRun.trx"


M.setup = function()
	local dap = require("dap")
	dap.adapters.netcoredgbForTests = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
		args = { "--interpreter=vscode" },
	}
end

M.run = function(vimTestCmd)
	local testExplorer = require("plugins.vimtest.testexplorer")
	testExplorer.open()

    local utils = require('plugins.vimtest.utils')
	local cmd = utils.parseCmd(vimTestCmd)
    table.insert(cmd, "--no-restore")
	table.insert(cmd, "--logger")
	table.insert(cmd, "trx;LogFileName=" .. lastTestRunTrxFile)

	local onExit = function()
		vim.schedule(function()
			local trxParser = require("plugins.vimtest.trxparser")
			local tests = trxParser.parse(lastTestRunTrxFile)
			testExplorer.open()
			testExplorer.showTests(tests)
		end)
	end

	vim.system(cmd, {
		stdout = testExplorer.handleStdout,
		text = true,
	}, onExit)
end

M.debug = function(vimTestCmd)
	local debuggerStarted = false
	local handleStdout = function(error, data)
		if data == nil then
			return
		end
		local dotnetPid = string.match(data, "Process Id%p%s(%d+)")
		if debuggerStarted == false and dotnetPid ~= nil then
			debuggerStarted = true
			vim.schedule(function()
				require("dap").run({
					type = "netcoredgbForTests",
					request = "attach",
					name = "",
					processId = dotnetPid,
				})
			end)
		end
	end

    local utils = require('plugins.vimtest.utils')
	local cmd = utils.parseCmd(vimTestCmd)

	vim.system(cmd, {
		stdout = handleStdout,
		text = true,
		env = { ["VSTEST_HOST_DEBUG"] = "1" },
	})
end

return M
