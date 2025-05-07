local M = {}

M.registerColors = function()
    local highlights = require('inspector.colorscheme.highlights')
    for group, options in pairs(highlights.groups) do
        vim.api.nvim_set_hl(highlights.namespace, group, options)
    end
end

M.setup = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = M.registerColors,
    })
end

return M
