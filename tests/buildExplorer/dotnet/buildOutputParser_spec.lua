local sut = require('inspector.buildExplorer.dotnet.buildOutputParser')
local assert = require('luassert')

local function readFileContent(filePath)
	local file = assert(io.open(filePath, "r"))
	local content = file:read("*all")
	file:close()
    return content
end

local function getTestFilePath(fileName)
    return vim.fn.stdpath("data") .. '/lazy/nvim-inspector/tests/buildExplorer/dotnet/data/'..fileName..'.txt'
end

--- @param fileName string
--- @param expected Diagnostics
local function runTest(fileName, expected)
    local buildOutput = readFileContent(getTestFilePath(fileName))
    local cwd = 'c:\\GitRepos\\TimeSheeter'
    local actual = sut.parse(buildOutput, cwd)
    assert.are.same(expected, actual)
end

describe('parse', function()
    it('errors only', function()
        ---@type Diagnostics
        local expected = {
            errors = {
                {
                    message = "CS0246: The type or namespace name 'NotKnownType' could not be found (are you missing a using directive or an assembly reference?)",
                    filePosition = {
                        fileName = 'Server/Database/Company.cs',
                        line = 14,
                        column = 12
                    }
                }
            },
            warnings = {}

        }
        runTest('errorsOnly', expected)
    end)

    it('warnings only', function()
        runTest('warningsOnly', {
            errors = {},
            warnings = {
                {
                    message = 'CS8625: Cannot convert null literal to non-nullable reference type.',
                    filePosition = {
                        fileName = 'Server/Api/EarningsApiController.cs',
                        line = 21,
                        column = 19
                    }
                },
                {
                    message = "xUnit1026: Theory method 'Run' on test class 'QuickTest' does not use parameter 'animal'. Use the parameter, or remove the parameter and associated data. (https://xunit.net/xunit.analyzers/rules/xUnit1026)",
                    filePosition = {
                        fileName = 'Test/QuickTest.cs',
                        line = 14,
                        column = 39
                    }
                }
            }

        })
    end)

    it('warnings and errors', function()
        runTest('errorAndWarning', {
            errors = {
                {
                    message = "CS0246: The type or namespace name 'ThisIsmyType' could not be found (are you missing a using directive or an assembly reference?)",
                    filePosition = {
                        fileName = 'Server/Api/InvoiceTemplateController.cs',
                        line = 23,
                        column = 9
                    }
                }
            },
            warnings = {
                {
                    message = 'CS8625: Cannot convert null literal to non-nullable reference type.',
                    filePosition = {
                        fileName = 'Server/Api/EarningsApiController.cs',
                        line = 21,
                        column = 19
                    }
                },
                {
                    message = "CS0168: The variable 's' is declared but never used",
                    filePosition = {
                        fileName = 'Server/Api/InvoiceTemplateController.cs',
                        line = 23,
                        column = 22
                    }
                }

            }

        })
    end)

    it('error from another project', function()
        runTest('errorButFromOtherProject', {
            errors = {
                {
                    message = "CS0246: The type or namespace name 'NotKnownType' could not be found (are you missing a using directive or an assembly reference?)",
                    filePosition = {
                        fileName = 'c:/GitRepos/AnotherProject/Server/Database/Company.cs',
                        line = 14,
                        column = 12,
                    }
                }
            },
            warnings = {}

        })
    end)
end)

