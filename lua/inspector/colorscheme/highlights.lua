local M = { }

M.namespace = vim.api.nvim_create_namespace('InspectorHighlights')
M.extMarkNamespace = vim.api.nvim_create_namespace('InspectorExtMarks')
M.TestTreeTestSuccess = 'TestTreeTestSuccess'
M.TestTreeTestFailed = 'TestTreeTestFailed'
M.StackTraceMyCode = 'StackTraceMyCode'
M.StackTraceLine = 'StackTraceLine'
M.StackTraceErrorMessage = 'StackTraceErrorMessage'
M.StackTraceCursorLine = 'StackTraceCursorLine'

M.groups = {
    TestTreeTestSuccess = {
        fg = "#32a852",
    },
    TestTreeTestFailed = {
        fg = "#ed4c4c",
    },

    StackTraceLine = {
        fg = "#7DAEA3",
    },
    StackTraceMyCode = {
        fg = "#6C74AE",
    },
    StackTraceErrorMessage = {
        fg = "#ed4c4c",
    },
    StackTraceCursorLine = {
        bg = "#363636"
    },

    NormalFloat = {
        bg = '#0f0f0f',
        fg = '#ABA09D'
    },
    FloatBorder = {
        bg = '#0f0f0f',
        fg = '#ABA09D'
    }
}


return M
