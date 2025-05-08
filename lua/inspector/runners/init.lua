local M = {}

local function getVimTestStrategies()
    return vim.g["test#custom_strategies"]
end

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
    local dotnetRunner = require('inspector.runners.dotnet.runner')
    dotnetRunner.setup()

    local strategies = getVimTestStrategies()
    strategies.dotnetRun = dotnetRunner.run
    strategies.dotnetDebug = dotnetRunner.debug

    local function setupDotnetKeymaps(ev)
        vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=dotnetRun<cr>", { buffer = ev.buf})
        vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=dotnetDebug<cr>", { buffer = ev.buf})
    end

    setupAutocommands(setupDotnetKeymaps, { "*.cs" })
end

local function setupJavascriptStrategies()
    local jsRunner = require('inspector.runners.javascript.runner')

    local strategies = getVimTestStrategies()
    strategies.jsRun = jsRunner.run
    strategies.jsDebug = jsRunner.debug

    local function setupJavascriptKeymaps(ev)
        vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest -strategy=jsRun<cr>", { buffer = ev.buf})
        vim.keymap.set("n", "<leader>dn", "<cmd>TestNearest -strategy=jsDebug<cr>", { buffer = ev.buf})
    end

    setupAutocommands(setupJavascriptKeymaps, { "*.js", "*.ts" })
end

M.setupVimTest = function()
    setupDotnetStrategies()
    setupJavascriptStrategies()
end

return M
