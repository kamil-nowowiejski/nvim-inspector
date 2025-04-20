local M = {}

local function getJestPath()
    return vim.fn.getcwd() .. '\\node_modules\\.bin\\jest'
end

local function prepareJestCommand(vimTestCmd)
    local utils = require('plugins.vimtest.utils')
	local cmd = utils.parseCmd(vimTestCmd)
    table.remove(cmd, 1)
    table.insert(cmd, 1, getJestPath())
    return cmd
end

M.run = function(vimTestCmd)
	local testExplorer = require("plugins.vimtest.testexplorer")
	testExplorer.open()

    local cmd = prepareJestCommand(vimTestCmd)
	vim.system(cmd, {
        stderr = testExplorer.handleStdout, --this is not a mistake, jest writes to standard error
		text = true,
        cwd = vim.fn.getcwd()
	})
end

M.debug = function(vimTestCmd)
    local cmd = prepareJestCommand(vimTestCmd)
    local config = {
        type = "pwa-node",
        request = "launch",
        name = "",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = cmd[1],
        args = { unpack(cmd, 2)},
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen"
    }
    require("dap").run(config)
end

return M
