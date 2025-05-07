local M = { }

local function normalizeSlashes(text)
    return text:gsub('\\', '/')
end

local function getPatterns(projectDir)
    return {
        'in '..projectDir..'/?(.*%.cs):line (%d+)$' --C#
    }
end

local function tryMatchPattern(line, projectDir, pattern)
    local filePath, lineNumber = line:match(pattern)
    local highlightStart = line:find(projectDir)
    if filePath == nil then return nil end

    --- @type StackTraceFileRef
    return {
        fileName = filePath,
        line = tonumber(lineNumber),
        highlight = {
            start = highlightStart,
            finish = -1
        }
    }
end


--- @param line string
--- @param projectDir string project (or solution) directory
--- @return StackTraceFileRef | nil #if stack trace line is not from my code then returns nil 
M.resolve = function(line, projectDir)
    local normalizedLine = normalizeSlashes(line)
    local normalizedProjectDir = normalizeSlashes(projectDir)

    local patterns = getPatterns(normalizedProjectDir)
    for _, pattern in ipairs(patterns) do
        local fileRef = tryMatchPattern(normalizedLine, normalizedProjectDir, pattern)
        if fileRef ~= nil then return fileRef end
    end
    return nil
end

return M
