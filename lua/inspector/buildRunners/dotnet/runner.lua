local M = {}

local highlights = require('inspector.colorscheme.highlights')
local bufferManager = require('inspector.ui.bufferManager')
                        .createNew('Build Output', 'InspectorBuildOutputAutocmdGroup', highlights.namespace)

---@param project? string
M.runBuild = function(project)
    local cmd = { "dotnet", "build" }
    if project ~= nil then table.insert(cmd, project) end

    bufferManager:open({})
    local diagnosticsExplorer = require('inspector.diagnosticsExplorer')
    diagnosticsExplorer.close()

    local onExit = function(obj)
        vim.schedule(function()
            local lines = vim.api.nvim_buf_get_lines(bufferManager.getBufferId(), 0, -1, false)
            local buildOutputParser = require('inspector.buildExplorer.dotnet.buildOutputParser')
            local diagnostics = buildOutputParser.parse(lines, vim.fn.getcwd())
            if #diagnostics.errors ~= 0 or #diagnostics.warnings ~= 0 then
                diagnosticsExplorer.open(diagnostics)
                bufferManager:close()
            end
        end)
    end

    vim.system(cmd, {
        stdout = require('inspector.ui.terminalOutputHandler').createStdoutHandler(bufferManager),
		text = true,
        cwd = vim.fn.getcwd(),
    }, onExit)
end

M.setup = function()
    vim.api.nvim_create_user_command('Build', function(data) M.runBuild(data.fargs[1]) end, { nargs = "?" })
end


return M
