local M = { }

M.HLInspectorTestTreeTestSuccess = 'HLInspectorTestTreeTestSuccess'
M.HLInspectorTestTreeTestFailed = 'HLInspectorTestTreeTestFailed'
M.HLInspectorStackTraceEvenLine = 'HLInspectorStackTraceEvenLine'
M.HLInspectorStackTraceOddLine = 'HLInspectorStackTraceOddLine'
M.HLInspectorStackTraceMyCode = 'HLInspectorStackTraceMyCode'
M.HLInspectorStackTraceErrorMessage = 'HLInspectorStackTraceErrorMessage'
M.HLInspectorStackTraceCursorLine = 'HLInspectorStackTraceCursorLine'
M.HLInspectorStackTraceNormalFloat = 'HLInspectorStackTraceNormalFloat'

M.groups = {
    HLInspectorTestTreeTestSuccess = {
        fg = "#32a852",
    },
    HLInspectorTestTreeTestFailed = {
        fg = "#fc0303",
    },
    HLInspectorStackTraceEvenLine = {
        fg = "#7DAEA3",
    },
    HLInspectorStackTraceOddLine = {
        fg = "#7DAEA3",
    },
    HLInspectorStackTraceMyCode = {
    },
    HLInspectorStackTraceErrorMessage = {
        fg = "#ed4c4c",
    },
    HLInspectorStackTraceCursorLine = {
        -- bg = "#000000"
    },
    HLInspectorStackTraceNormalFloat = {
        bg = '#000000'
    }
}


return M
