local sut = require('inspector.explorer.testTreeConverter')
local assert = require('luassert')

describe('convertTestsToTestsTree', function()
    it('multiple successes and failures', function()
        --- @type Test[]
        local tests = {
            {
                namespaceParts = {'Root1', 'Part1', 'Part2'},
                testName = 'TestOne',
                duration = '00:00:00.0012265',
                status = 'success',
            },
            {
                namespaceParts = {'Root1', 'Part1', 'Part2'},
                testName = 'TestTwo',
                duration = '00:00:00.009574',
                status = 'failure',
                errorMessage = 'I blew up!',
                stackTrace = {
                    { line = 'line 1_1_1', isMyCode = false },
                    { line = 'line 1_1_2', isMyCode = true },
                    { line = 'line 1_1_3', isMyCode = false },
                }
            },
            {
                namespaceParts = { 'Root1', 'Part1', 'Part3'},
                testName = 'TestInBetween',
                duration = '00:00:00.008346573',
                status = 'success'
            },
            {
                namespaceParts = {'Root1', 'Part1'},
                testName = 'TestThree',
                duration = '00:00:00.087563',
                status = 'failure',
                errorMessage = 'kaboom!',
                stackTrace = {
                    { line = 'line 1_2_1', isMyCode = false },
                    { line = 'line 1_2_2', isMyCode = false },
                    { line = 'line 1_2_3', isMyCode = true },
                }
            },
            {
                namespaceParts = { 'Root1' },
                testName = 'TestFour',
                duration = '00:00:00.095732',
                status = 'success',
            },
            {
                namespaceParts = { 'Root1' },
                testName = 'TestFive',
                duration = '00:00:00.0993539',
                status = 'success',
            },
            {
                namespaceParts = { 'Root2', 'Namespace1', 'Namespace2' },
                testName = 'TestSix',
                duration = '00:00:00.034350',
                status = 'success',
            },
            {
                namespaceParts = { 'Root2', 'Namespace1', 'Namespace2' },
                testName = 'TestSeven',
                duration = '00:00:00.0212435',
                status = 'failure',
                errorMessage = 'Expected number 2 but got 4',
                stackTrace = {
                    { line = 'line 2_1_1', isMyCode = false },
                    { line = 'line 2_1_2', isMyCode = false },
                    { line = 'line 2_1_3', isMyCode = false },
                }
            },
            {
                namespaceParts = { 'Root2', 'Namespace1' },
                testName = 'TestEight',
                duration = '00:00:00.0350462',
                status = 'failure',
                errorMessage = 'Expected number empty list',
                stackTrace = {
                    { line = 'line 2_2_1', isMyCode = true },
                    { line = 'line 2_2_2', isMyCode = true },
                    { line = 'line 2_2_3', isMyCode = true },
                }
            },
        }

        --- @type TestsTree
        local expected = {
            roots = {
                {
                    text = 'Root1',
                    isExpanded = true,
                    status = 'failure',
                    children = {
                        {
                            text = 'Part1',
                            isExpanded = true,
                            status = 'failure',
                            children = {
                                {
                                    text = 'Part2',
                                    isExpanded = true,
                                    status = 'failure',
                                    children = {
                                        {
                                            text = 'TestOne',
                                            duration = '00:00:00.0012265',
                                            status = 'success',
                                            isExpanded = false,
                                            errorMessage = nil,
                                            stackTrace = nil,
                                            children = {}
                                        },
                                        {
                                            text = 'TestTwo',
                                            duration = '00:00:00.009574',
                                            status = 'failure',
                                            isExpanded = false,
                                            errorMessage = 'I blew up!',
                                            stackTrace = {
                                                { line = 'line 1_1_1', isMyCode = false },
                                                { line = 'line 1_1_2', isMyCode = true },
                                                { line = 'line 1_1_3', isMyCode = false },
                                            },
                                            children = {}
                                        },
                                    }
                                },
                                {
                                    text = 'Part3',
                                    isExpanded = true,
                                    status = 'success',
                                    children = {
                                        {
                                            text = 'TestInBetween',
                                            duration = '00:00:00.008346573',
                                            status = 'success',
                                            isExpanded = false,
                                            children = {}
                                        }
                                    }
                                },
                                {
                                    text = 'TestThree',
                                    duration = '00:00:00.087563',
                                    status = 'failure',
                                    isExpanded = false,
                                    errorMessage = 'kaboom!',
                                    stackTrace = {
                                        { line = 'line 1_2_1', isMyCode = false },
                                        { line = 'line 1_2_2', isMyCode = false },
                                        { line = 'line 1_2_3', isMyCode = true },
                                    },
                                    children = {}
                                }
                            }
                        },
                        {
                            text = 'TestFive',
                            duration = '00:00:00.0993539',
                            status = 'success',
                            isExpanded = false,
                            children = {}
                        },
                        {
                            text = 'TestFour',
                            duration = '00:00:00.095732',
                            status = 'success',
                            isExpanded = false,
                            children = {}
                        },
                    }
                },
                {
                    text = 'Root2',
                    isExpanded = true,
                    status = 'failure',
                    children = {
                        {
                            text = 'Namespace1',
                            isExpanded = true,
                            status = 'failure',
                            children = {
                                {
                                    text = 'Namespace2',
                                    isExpanded = true,
                                    status = 'failure',
                                    children = {
                                        {
                                            text = 'TestSeven',
                                            duration = '00:00:00.0212435',
                                            status = 'failure',
                                            isExpanded = false,
                                            errorMessage = 'Expected number 2 but got 4',
                                            stackTrace = {
                                                { line = 'line 2_1_1', isMyCode = false },
                                                { line = 'line 2_1_2', isMyCode = false },
                                                { line = 'line 2_1_3', isMyCode = false },
                                            },
                                            children = {}
                                        },
                                        {
                                            text = 'TestSix',
                                            duration = '00:00:00.034350',
                                            status = 'success',
                                            isExpanded = false,
                                            children = {}
                                        },
                                    }
                                },
                                {
                                    text = 'TestEight',
                                    duration = '00:00:00.0350462',
                                    status = 'failure',
                                    isExpanded = false,
                                    errorMessage = 'Expected number empty list',
                                    stackTrace = {
                                        { line = 'line 2_2_1', isMyCode = true },
                                        { line = 'line 2_2_2', isMyCode = true },
                                        { line = 'line 2_2_3', isMyCode = true },
                                    },
                                    children = {}
                                }
                            }
                        }
                    }
                }
            }
        }

        local actual = sut.convertTestsToTestsTree(tests)

        assert.are.same(expected, actual)
    end)
end)
