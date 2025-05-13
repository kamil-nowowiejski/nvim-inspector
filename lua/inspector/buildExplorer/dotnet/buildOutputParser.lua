local M = {}

local function normalizeSlashes(text)
    return text:gsub('\\', '/')
end

local function getBuildOutputLines(buildOutput)
    local normlaizedBuildOutput = normalizeSlashes(buildOutput)
    local buildOutputLines = vim.split(normlaizedBuildOutput, "\r\n")
    if #buildOutputLines == 1 then
        buildOutputLines = vim.split(normlaizedBuildOutput, "\n")
    end
    return buildOutputLines
end

local function getFileName(filePath, cwd)
    local fileName = filePath:gsub(cwd, "")
    local firstChar = fileName:sub(1, 1)
    if firstChar == '\\' or firstChar == '/' then
        return fileName:sub(2)
    end
    return fileName
end

--- @param buildOutputLine string
--- @return Error | nil, Warning | nil
local function parseErrorOrWarning(buildOutputLine, cwd)
    local regex = "^(.*)%((%d+),(%d+)%): (%a+) (.*) %[(.*)]$"
    local filePath, line, column, level, message, project = buildOutputLine:match(regex)

    if message == nil then return nil, nil end

    local function toObject()
        return {
            message = message,
            filePosition = {
                fileName = getFileName(filePath, cwd),
                line = tonumber(line),
                column = tonumber(column)
            }
        }
    end

    local error = nil
    local warning = nil
    if level == 'error' then error = toObject() end
    if level == 'warning' then warning = toObject() end
    return error, warning

end

local function getHash(str)
    local h = 5381;

    for c in str:gmatch(".") do
        h = math.fmod((h * 32 + h) + string.byte(c), 2147483648)
    end
    return h
end

local function dropHashes(collection)
    local indexes = {}
    local valuesByIndex = {}

    for key, v in pairs(collection) do
        if key ~= 'length' then
            valuesByIndex[v.index] = v.value
            table.insert(indexes, v.index)
        end
    end

    table.sort(indexes)

    local result = {}
    for _, v in ipairs(indexes) do
        table.insert(result, valuesByIndex[v])
    end

    return result
end

local function addUniqueValue(collection, value)
    if value == nil then return end
    local hash = getHash(value.message)
    if collection[hash] == nil then
        collection.length = collection.length + 1
        collection[hash] = { value = value, index = collection.length }
    end
end

--- @param buildOutput string 
--- @param cwd string current working directory
--- @return Diagnostics
M.parse = function(buildOutput, cwd)
    local normalizedCwd = normalizeSlashes(cwd)
    local buildOutputLines = getBuildOutputLines(buildOutput)

    local errors = { length = 0 }
    local warnings = { length = 0 }

    for _, line in ipairs(buildOutputLines) do
        local error, warning = parseErrorOrWarning(line, normalizedCwd)
        addUniqueValue(errors, error)
        addUniqueValue(warnings, warning)
    end

    return {
        errors = dropHashes(errors),
        warnings = dropHashes(warnings)
    }
end

return M
