local M = {}

--- @alias ActiveTab 'errors' | 'warnings'

local highlights = require('inspector.colorscheme.highlights')

--- @param diagnostics Diagnostics
--- @param activeTab ActiveTab
--- @return BufferLine
local function createHeaderLines(diagnostics, activeTab)
    local errorHlName = highlights.BuildExplorerErrorHeaderNotActive
    local warningHlName = highlights.BuildExplorerWarningHeaderNotActive

    if activeTab == 'errors' then
        errorHlName = highlights.BuildExplorerErrorHeaderActive
    elseif activeTab == 'warnings' then
            warningHlName = highlights.BuildExplorerWarningHeaderActive
    end

    local errors = '   Errors ('..#diagnostics.errors..')   '
    local warnings = '   Warnings ('..#diagnostics.warnings..')   '
    return {
        text = errors..warnings,
        highlight = {
            { name = errorHlName, start = 0, finish = #errors },
            { name = warningHlName, start = #errors - 1, finish = #errors + #warnings }
        }
    }
end

--- @param diagnostics Diagnostics
--- @param activeTab ActiveTab
--- @return DiagnosictsLine[]
local function createDiagnosticLines(diagnostics, activeTab)
    local issues = {}
    local prefix = '*'
    local prefixHl = ''
    if activeTab == 'errors' then
        issues = diagnostics.errors
        prefix = ''
        prefixHl = highlights.BuildExplorerErrorIcon
    elseif activeTab == 'warnings' then
        issues = diagnostics.warnings
        prefix = ''
        prefixHl = highlights.BuildExplorerWarningIcon
    end

    local lines = {}
    for _, issue in ipairs(issues) do
        local message = prefix..'   '..issue.message
        local text = message..' '..issue.filePosition.fileName..':('..issue.filePosition.line..','..issue.filePosition.column..')'
        --- @type DiagnosictsLine
        local line = {
            filePosition = issue.filePosition,
            text = text,
            highlight = {
                { name = prefixHl, start = 0, finish = 1 },
                { name = highlights.BuildExplorerFileReference, start = #message + 1, finish = #text - 1}
            }
        }

        table.insert(lines, line)
    end

    return lines
end

--- @overload fun(diagnostics: Diagnostics, activeTab: ActiveTab): BufferLine, DiagnosictsLine[]
M.convertToLines = function(diagnostics, activeTab)
    local headerLine = createHeaderLines(diagnostics, activeTab)
    local lines = createDiagnosticLines(diagnostics, activeTab)

    return headerLine, lines
end

return M
