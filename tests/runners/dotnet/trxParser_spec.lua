local sut = require('inspector.runners.dotnet.trxParser')
local assert = require('luassert')

local function pathToTrx(fileName)
    return vim.fn.stdpath("data") .. '/lazy/inspector/tests/runners/dotnet/trx/'..fileName..'.trx'
end

describe('parse trx', function()
    it('all tests pass', function()
        local actual = sut.parse(pathToTrx('all_tests_pass'))
        --- @type Test[]
        local expected = {
            {
                testName = 'Pass3(index: 1, animal: "cat")',
                duration = '00:00:00.0001570',
                status = "success",
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'Pass3(index: 2, animal: "dog")',
                duration = '00:00:00.0000036',
                status = "success",
                namespaceParts = { 'Test', 'HereAllPass' }
            },
            {
                testName = 'Pass2',
                duration = '00:00:00.0012675',
                status = "success",
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'Pass3(index: 3, animal: "mouse")',
                duration = '00:00:00.0000217',
                status = "success",
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'Pass1',
                duration = '00:00:00.0000400',
                status = "success",
                namespaceParts = {'Test', 'HereAllPass'}
            },
        }

        assert.are.same(expected, actual)
    end)


    it('multiple tests', function()
        local actual = sut.parse(pathToTrx('multiple_tests'))
        --- @type Test[]
        local expected = {
            {
                testName = 'Pass2',
                duration = '00:00:00.0012265',
                status = 'success',
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'ThisOnePasses',
                duration = '00:00:00.0000294',
                status = 'success',
                namespaceParts = {'Test', 'QuickTest'}
            },
            {
                testName = 'Pass3(index: 1, animal: "cat")',
                duration = '00:00:00.0001776',
                status = 'success',
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'Pass3(index: 3, animal: "mouse")',
                duration = '00:00:00.0000407',
                status = 'success',
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'Pass3(index: 2, animal: "dog")',
                duration = '00:00:00.0000046',
                status = 'success',
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'ThisAlsoFails',
                duration = '00:00:00.0010583',
                status = 'failure',
                namespaceParts = {'Test', 'AnotherTest'},
                errorMessage = 'System.Exception : another failure',
                stackTrace = {
                    'at Test.AnotherTest.ThisAlsoFails() in C:\\GitRepos\\timesheeter\\test\\AnotherTest.cs:line 14',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeWithNoArgs(Object obj, BindingFlags invokeAttr)',
                }
            },
            {
                testName = 'Pass1',
                duration = '00:00:00.0000309',
                status = 'success',
                namespaceParts = {'Test', 'HereAllPass'}
            },
            {
                testName = 'ThisOneFails',
                duration = '00:00:00.0001158',
                status = 'failure',
                namespaceParts = {'Test', 'QuickTest'},
                errorMessage = 'System.Exception : critical failure',
                stackTrace = {
                    'at Test.QuickTest.ThisOneFails() in C:\\GitRepos\\timesheeter\\test\\QuickTest.cs:line 8',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeWithNoArgs(Object obj, BindingFlags invokeAttr)',
                }
            },
            {
                testName = 'ThisOneFails',
                duration = '00:00:00.0001435',
                status = 'failure',
                namespaceParts = {'Test', 'AnotherTest'},
                errorMessage = 'System.Exception : kaboom!',
                stackTrace = {
                    'at Test.AnotherTest.ThisOneFails() in C:\\GitRepos\\timesheeter\\test\\AnotherTest.cs:line 8',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeWithNoArgs(Object obj, BindingFlags invokeAttr)',
                }
            },
            {
                testName = 'Run(index: 2, animal: "dog")',
                duration = '00:00:00.0001192',
                status = 'success',
                namespaceParts = {'Test', 'QuickTest'}
            },
            {
                testName = 'Run(index: 1, animal: "cat")',
                duration = '00:00:00.0010432',
                status = 'failure',
                namespaceParts = {'Test', 'QuickTest'},
                errorMessage = 'System.Exception : fail',
                stackTrace = {
                    'at Test.QuickTest.Run(Int32 index, String animal) in C:\\GitRepos\\timesheeter\\test\\QuickTest.cs:line 17',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeDirectByRefWithFewArgs(Object obj, Span`1 copyOfArgs, BindingFlags invokeAttr)',
                }
            },
        }

        assert.are.same(expected, actual)
    end)

    it('single test failed', function()
        local actual = sut.parse(pathToTrx('single_test_failed'))
        --- @type Test[]
        local expected = {
            {
                testName = 'ThisOneFails',
                duration = '00:00:00.0011476',
                status = 'failure',
                namespaceParts = {'Test', 'QuickTest'},
                errorMessage = 'System.Exception : critical failure',
                stackTrace = {
                    'at Test.QuickTest.ThisOneFails() in C:\\GitRepos\\timesheeter\\test\\QuickTest.cs:line 8',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeWithNoArgs(Object obj, BindingFlags invokeAttr)',
                }
            }
        }

        assert.are.same(expected, actual)
    end)


    it('single test passed', function()
        local actual = sut.parse(pathToTrx('single_test_passed'))
        --- @type Test[]
        local expected = {
            {
                testName = 'ThisOnePasses',
                duration = '00:00:00.0012704',
                status = 'success',
                namespaceParts = {'Test', 'QuickTest'}
            }
        }

        assert.are.same(expected, actual)
    end)

    it('theory with success and failures', function()
        local actual = sut.parse(pathToTrx('theory_with_success_and_failures'))
        --- @type Test[]
        local expected = {
            {
                testName = 'ThisOneFails',
                duration = '00:00:00.0001226',
                status = 'failure',
                namespaceParts = {'Test', 'QuickTest'},
                errorMessage = 'System.Exception : critical failure',
                stackTrace = {
                    'at Test.QuickTest.ThisOneFails() in C:\\GitRepos\\timesheeter\\test\\QuickTest.cs:line 8',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeWithNoArgs(Object obj, BindingFlags invokeAttr)',
                }
            },
            {
                testName = 'ThisOnePasses',
                duration = '00:00:00.0000649',
                status = 'success',
                namespaceParts = {'Test', 'QuickTest'}
            },
            {
                testName = 'Run(index: 1, animal: "cat")',
                duration = '00:00:00.0011319',
                status = 'failure',
                namespaceParts = {'Test', 'QuickTest'},
                errorMessage = 'System.Exception : fail',
                stackTrace = {
                    'at Test.QuickTest.Run(Int32 index, String animal) in C:\\GitRepos\\timesheeter\\test\\QuickTest.cs:line 17',
                    'at System.RuntimeMethodHandle.InvokeMethod(Object target, Void** arguments, Signature sig, Boolean isConstructor)',
                    'at System.Reflection.MethodBaseInvoker.InvokeDirectByRefWithFewArgs(Object obj, Span`1 copyOfArgs, BindingFlags invokeAttr)',
                }
            },
            {
                testName = 'Run(index: 2, animal: "dog")',
                duration = '00:00:00.0006753',
                status = 'success',
                namespaceParts = {'Test', 'QuickTest'}
            }
        }

        assert.are.same(expected, actual)
    end)
end)
