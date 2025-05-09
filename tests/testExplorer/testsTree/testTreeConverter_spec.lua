local sut = require('inspector.testExplorer.testsTree.testTreeConverter')
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
                stackTrace = { 'line 1_1_1', 'line 1_1_2', 'line 1_1_3', }
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
                stackTrace = { 'line 1_2_1', 'line 1_2_2', 'line 1_2_3', }
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
                stackTrace = { 'line 2_1_1', 'line 2_1_2', 'line 2_1_3', }
            },
            {
                namespaceParts = { 'Root2', 'Namespace1' },
                testName = 'TestEight',
                duration = '00:00:00.0350462',
                status = 'failure',
                errorMessage = 'Expected number empty list',
                stackTrace = { 'line 2_2_1', 'line 2_2_2', 'line 2_2_3', }
            },
        }

        --- @type TestsTree
        local expected = {
            roots = {
                {
                    text = 'Root1',
                    isExpanded = true,
                    status = 'failure',
                    nodeType = 'namespace',
                    children = {
                        {
                            text = 'Part1',
                            isExpanded = true,
                            status = 'failure',
                            nodeType = 'namespace',
                            children = {
                                {
                                    text = 'Part2',
                                    isExpanded = true,
                                    status = 'failure',
                                    nodeType = 'namespace',
                                    children = {
                                        {
                                            text = 'TestOne',
                                            duration = '00:00:00.0012265',
                                            status = 'success',
                                            isExpanded = false,
                                            errorMessage = nil,
                                            stackTrace = nil,
                                            nodeType = 'test',
                                            children = {},
                                        },
                                        {
                                            text = 'TestTwo',
                                            duration = '00:00:00.009574',
                                            status = 'failure',
                                            isExpanded = false,
                                            errorMessage = 'I blew up!',
                                            stackTrace = { 'line 1_1_1', 'line 1_1_2', 'line 1_1_3', },
                                            nodeType = 'test',
                                            children = {}
                                        },
                                    }
                                },
                                {
                                    text = 'Part3',
                                    isExpanded = false,
                                    status = 'success',
                                    nodeType = 'namespace',
                                    children = {
                                        {
                                            text = 'TestInBetween',
                                            duration = '00:00:00.008346573',
                                            status = 'success',
                                            isExpanded = false,
                                            nodeType = 'test',
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
                                    stackTrace = { 'line 1_2_1', 'line 1_2_2', 'line 1_2_3', },
                                    nodeType = 'test',
                                    children = {}
                                }
                            }
                        },
                        {
                            text = 'TestFive',
                            duration = '00:00:00.0993539',
                            status = 'success',
                            isExpanded = false,
                            nodeType = 'test',
                            children = {}
                        },
                        {
                            text = 'TestFour',
                            duration = '00:00:00.095732',
                            status = 'success',
                            isExpanded = false,
                            nodeType = 'test',
                            children = {}
                        },
                    }
                },
                {
                    text = 'Root2',
                    isExpanded = true,
                    status = 'failure',
                    nodeType = 'namespace',
                    children = {
                        {
                            text = 'Namespace1',
                            isExpanded = true,
                            status = 'failure',
                            nodeType = 'namespace',
                            children = {
                                {
                                    text = 'Namespace2',
                                    isExpanded = true,
                                    status = 'failure',
                                    nodeType = 'namespace',
                                    children = {
                                        {
                                            text = 'TestSeven',
                                            duration = '00:00:00.0212435',
                                            status = 'failure',
                                            isExpanded = false,
                                            errorMessage = 'Expected number 2 but got 4',
                                            stackTrace = { 'line 2_1_1', 'line 2_1_2', 'line 2_1_3', },
                                            nodeType = 'test',
                                            children = {}
                                        },
                                        {
                                            text = 'TestSix',
                                            duration = '00:00:00.034350',
                                            status = 'success',
                                            isExpanded = false,
                                            nodeType = 'test',
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
                                    stackTrace = { 'line 2_2_1', 'line 2_2_2', 'line 2_2_3', },
                                    nodeType = 'test',
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
