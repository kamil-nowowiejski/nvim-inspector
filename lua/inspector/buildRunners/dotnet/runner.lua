local M = {}

local highlights = require('inspector.colorscheme.highlights')
local bufferManager = require('inspector.ui.bufferManager')
                        .createNew('Build Output', 'InspectorBuildOutputAutocmdGroup', highlights.namespace)

--- @param project? string
--- @param cleanBuild? boolean defaults to false
M.runBuild = function(project, cleanBuild)
    bufferManager:open({
        wrap = true,
        linebreak = true,
    })
    local vimsystemopts = {
        stdout = require('inspector.ui.terminalOutputHandler').createStdoutHandler(bufferManager),
		text = true,
        cwd = vim.fn.getcwd(),
    }

    if cleanBuild then
        local cmd = { "dotnet", "clean" }
        if project ~= nil then table.insert(cmd, project) end
        vim.system(cmd, vimsystemopts)
    end

    local cmd = { "dotnet", "build" }
    if project ~= nil then table.insert(cmd, project) end

    local diagnosticsExplorer = require('inspector.diagnosticsExplorer')
    diagnosticsExplorer.close()

    local onExit = function(obj)
        vim.schedule(function()
            local lines = vim.api.nvim_buf_get_lines(bufferManager.getBufferId(), 0, -1, false)
            local buildOutputParser = require('inspector.buildRunners.dotnet.buildOutputParser')
            local diagnostics = buildOutputParser.parse(lines, vim.fn.getcwd())
            if #diagnostics.errors ~= 0 or #diagnostics.warnings ~= 0 then
                diagnosticsExplorer.open(diagnostics)
                bufferManager:close()
            end
        end)
    end

    vim.system(cmd, vimsystemopts, onExit)
end

M.setup = function()
    local opts = { nargs = "?" }
    local build = function(data) M.runBuild(data.fargs[1]) end
    local buildClean = function(data) M.runBuild(data.fargs[1], true) end
    vim.api.nvim_create_user_command('Build', build, opts)
    vim.api.nvim_create_user_command('B', build, opts)
    vim.api.nvim_create_user_command('BuildClean', buildClean, opts)
    vim.api.nvim_create_user_command('BC', buildClean, opts)
    vim.api.nvim_create_user_command('Bc', buildClean, opts)
end


return M
