local M = { }

M.namespace = vim.api.nvim_create_namespace('InspectorHighlights')
M.extMarkNamespace = vim.api.nvim_create_namespace('InspectorExtMarks')
M.TestTreeTestSuccess = 'TestTreeTestSuccess'
M.TestTreeTestFailed = 'TestTreeTestFailed'
M.StackTraceMyCode = 'StackTraceMyCode'
M.StackTraceLine = 'StackTraceLine'
M.StackTraceErrorMessage = 'StackTraceErrorMessage'
M.CursorLine = 'CursorLine'
M.BuildExplorerErrorHeaderActive = 'BuildExplorerErrorHeaderActive'
M.BuildExplorerErrorHeaderNotActive = 'BuildExplorerErrorHeaderNotActive'
M.BuildExplorerWarningHeaderActive = 'BuildExplorerWarningHeaderActive'
M.BuildExplorerWarningHeaderNotActive = 'BuildExplorerWarningHeaderNotActive'
M.BuildExplorerErrorIcon = 'BuildExplorerErrorIcon'
M.BuildExplorerWarningIcon = 'BuildExplorerWarningIcon'
M.BuildExplorerFileReference = 'BuildExplorerFileReference'

local red = '#ed4c4c'
local violet = '#6C74AE'
local green = '#32a852'
local turquoise = '#7DAEA3'
local darkGrey = '#363636'
local veryDarkGrey = '#0f0f0f'
local lightGrey = '#ABA09D'
local yellow = '#fcba03'

M.groups = {
    TestTreeTestSuccess = {
        fg = green,
    },
    TestTreeTestFailed = {
        fg = red,
    },

    StackTraceLine = {
        fg = turquoise,
    },
    StackTraceMyCode = {
        fg = violet,
    },
    StackTraceErrorMessage = {
        fg = red,
    },
    CursorLine = {
        bg = darkGrey
    },

    NormalFloat = {
        bg = veryDarkGrey,
        fg = lightGrey
    },
    FloatBorder = {
        bg = veryDarkGrey,
        fg = lightGrey
    },
    Normal = {
        bg = veryDarkGrey,
        fg = turquoise
    },

    BuildExplorerErrorHeaderActive = {
        bg = darkGrey,
        fg = red

    },
    BuildExplorerErrorHeaderNotActive = {
        fg = red
    },
    BuildExplorerWarningHeaderActive = {
        bg = darkGrey,
        fg = yellow
    },
    BuildExplorerWarningHeaderNotActive = {
        fg = yellow
    },
    BuildExplorerErrorIcon = {
        fg = red
    },
    BuildExplorerWarningIcon = {
        fg = yellow
    },
    BuildExplorerFileReference = {
        fg = violet
    }
}


return M
