local M = {}

local function setupAutocommands(keymapsSetup, filePattern)
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = filePattern,
        callback = function(ev) keymapsSetup(ev) end
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = { "LazyVimStarted" },
        callback = function(ev)
            local file = vim.api.nvim_buf_get_name(ev.buf)
            for _, pattern in pairs(filePattern) do
                if file:gmatch(pattern) then
                    keymapsSetup(ev)
                end
            end
        end
    })
end

local function setupDotnetStrategies()
    local function setupDotnetKeymaps(ev)
        vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=dotnetRun<cr>", { buffer = ev.buf})
        vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=dotnetDebug<cr>", { buffer = ev.buf})
    end

    setupAutocommands(setupDotnetKeymaps, { "*.cs" })
end

local function setupJavascriptStrategies()
    local function setupJavascriptKeymaps(ev)
        vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=jsRun<cr>", { buffer = ev.buf})
        vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=jsDebug<cr>", { buffer = ev.buf})
    end

    setupAutocommands(setupJavascriptKeymaps, { "*.js", "*.ts" })
end

M.setupVimTest = function()
    local dotnetRunner = require('inspector.testRunners.dotnet.runner')
    dotnetRunner.setup()
    local jsRunner = require('inspector.testRunners.javascript.runner')

    vim.g["test#custom_strategies"] = {
        dotnetRun = dotnetRunner.run,
        dotnetDebug = dotnetRunner.debug,
        jsRun = jsRunner.run,
        jsDebug = jsRunner.debug
    }

    setupDotnetStrategies()
    setupJavascriptStrategies()
end

return M
