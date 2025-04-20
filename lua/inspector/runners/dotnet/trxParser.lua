local M = {}

local function readFileContent(filePath)
	local file = assert(io.open(filePath, "r"))
	local content = file:read("*all")
	file:close()
	return content:sub(4) -- this line removes BOM bytes
end

local function getTrxTree(fileContent)
	local xml2lua = require("xml2lua")
	local handler = require("xmlhandler.tree"):new()
	local parser = xml2lua.parser(handler)
	parser:parse(fileContent)
	return handler.root
end

local function getNamespaceAndName(testName)
    local namespaceParts = {}
    local currentPart = {}
    local isLastPart = false

    for char in testName:gmatch('.') do
        if isLastPart then
            table.insert(currentPart, char)
        elseif char == '.' then
            table.insert(namespaceParts, table.concat(currentPart))
            currentPart = {}
        elseif char == '(' then
            isLastPart = true
            table.insert(currentPart, char)
        else
            table.insert(currentPart, char)
        end
    end

    return {
        testName = table.concat(currentPart),
        namespaceParts = namespaceParts
    }
end

--- @return Test
local function parseTest(unitTestResult)
	local getStatus = function()
		if unitTestResult._attr.outcome == "Failed" then
			return "failure"
		elseif unitTestResult._attr.outcome == "Passed" then
			return "success"
		else
			error("Unknown TRX test status " .. unitTestResult._attr.outcome)
		end
	end

	local getErrorMessage = function()
		if unitTestResult.Output ~= nil then
			return unitTestResult.Output.ErrorInfo.Message
		end
	end

	local getStackTrace = function()
        local stackTrace = {}
		if unitTestResult.Output ~= nil then
            local splitStackTrace = vim.split(unitTestResult.Output.ErrorInfo.StackTrace, '\r\n')
			for _, stackTraceLine in ipairs(splitStackTrace) do
                --- @type StackTraceLine
                local line = { line = stackTraceLine:gsub("^%s*(.-)%s*$", "%1"), isMyCode = false }
                table.insert(stackTrace, line)
            end
            return stackTrace
		end
	end

    local names = getNamespaceAndName(unitTestResult._attr.testName)
	return {
		testName = names.testName,
        namespaceParts = names.namespaceParts,
		status = getStatus(),
		duration = unitTestResult._attr.duration,
		errorMessage = getErrorMessage(),
		stackTrace = getStackTrace(),
	}
end

--- @return Test[]
M.parse = function(trxPath)
	local fileContent = readFileContent(trxPath)
	local trxTree = getTrxTree(fileContent)

	local unitTestResults = nil
	if trxTree.TestRun.Results ~= nil then
		unitTestResults = trxTree.TestRun.Results.UnitTestResult
	elseif trxTree.TestRun[1].Results ~= nil then
		unitTestResults = trxTree.TestRun[1].Results.UnitTestResult
	else
		error("Implement better TRX parsing")
	end

    local tests = {}
    if #unitTestResults > 0 then
        --- @type Test[]
        for _, value in ipairs(unitTestResults) do
            local test = parseTest(value)
            tests[#tests + 1] = test
        end
    else
        local test = parseTest(unitTestResults)
        table.insert(tests, test)
    end

	return tests
end

return M
