local sut = require('inspector.testExplorer.testsTree.lineConverter')
local assert = require('luassert')

describe('convertToLines', function()
    it('multiple successes and failures', function()
        --- @type TestsTree
        local input = {
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

        local highlights = require('inspector.colorscheme.highlights')
        local successHL = { name = highlights.TestTreeTestSuccess, start = 0, finish = -1 }
        local failHL = { name = highlights.TestTreeTestFailed, start = 0, finish = -1 }

        --- @type Line[]
        local expected = {
            {
                text = "V Root1",
                highlight = failHL,
                treeNode = input.roots[1]
            },
            {
                text = "  V Part1",
                highlight = failHL,
                treeNode = input.roots[1].children[1]
            },
            {
                text = "    V Part2",
                highlight = failHL,
                treeNode = input.roots[1].children[1].children[1]
            },
            {
                text = "      ✓ TestOne",
                highlight = successHL,
                treeNode = input.roots[1].children[1].children[1].children[1]
            },
            {
                text = "      ✗ TestTwo",
                highlight = failHL,
                treeNode = input.roots[1].children[1].children[1].children[2]
            },
            {
                text = "    > Part3",
                highlight = successHL,
                treeNode = input.roots[1].children[1].children[2]
            },
            {
                text = "    ✗ TestThree",
                highlight = failHL,
                treeNode = input.roots[1].children[1].children[3]
            },
            {
                text = "  ✓ TestFive",
                highlight = successHL,
                treeNode = input.roots[1].children[2]
            },
            {
                text = "  ✓ TestFour",
                highlight = successHL,
                treeNode = input.roots[1].children[3]
            },
            {
                text = "V Root2",
                highlight = failHL,
                treeNode = input.roots[2]
            },
            {
                text = "  V Namespace1",
                highlight = failHL,
                treeNode = input.roots[2].children[1]
            },
            {
                text = "    V Namespace2",
                highlight = failHL,
                treeNode = input.roots[2].children[1].children[1]
            },
            {
                text = "      ✗ TestSeven",
                highlight = failHL,
                treeNode = input.roots[2].children[1].children[1].children[1]
            },
            {
                text = "      ✓ TestSix",
                highlight = successHL,
                treeNode = input.roots[2].children[1].children[1].children[2]
            },
            {
                text = "    ✗ TestEight",
                highlight = failHL,
                treeNode = input.roots[2].children[1].children[2]
            }
        }

        local actual = sut.convertToLines(input)
        assert.are.same(expected, actual)
    end)
end)
