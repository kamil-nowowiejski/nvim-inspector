local M = {}

M.setup = function()
    require('inspector.colorscheme').setup()
    require('inspector.buildRunners').setup()

    vim.api.nvim_create_user_command("InspectorCancel", function()
        require('inspector.ui.currentCommand').killCurrentCommand()
    end, {})

    vim.api.nvim_create_user_command("IC", "InspectorCancel", {})
end

M.setupVimTest = function()
    require('inspector.testRunners').setupVimTest()
end

return M
