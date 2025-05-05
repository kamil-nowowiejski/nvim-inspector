-- to run this test put ":source" in vim command

require('tests.manualTests.runtimepath')

local sut = require('inspector')
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

sut.showTests(tests)
