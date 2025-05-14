local sut = require('inspector.buildExplorer.ui.linesConverter')
local assert = require('luassert')
local highlights = require('inspector.colorscheme.highlights')

describe('convertToLines', function()
    local diagnostics = {
        warnings = {
            {
                message = 'W9344: This is some serious warning for some serious reasons',
                filePosition = {
                    fileName = 'tests/buildExplorer/ui/manualtest_spec.lua',
                    line = 11,
                    column = 22
                }
            },
            {
                message = "W431: This warning is so long that it needs some Latin literature: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                filePosition = {
                    fileName = 'tests/buildExplorer/ui/manualtest_spec.lua',
                    line = 18,
                    column = 30
                }
            },
            {
                message = 'W952: The last warning',
                filePosition = {
                    fileName = 'lua/inspector/buildExplorer/ui/explorer',
                    line = 20,
                    column = 6
                }
            }
        },
        errors = {
            {
                message = 'E469: This is some serious error but the reson of it happening is quite mysterious.',
                filePosition = {
                    fileName = 'tests/buildExplorer/ui/manualtest_spec.lua',
                    line = 35,
                    column = 22
                }
            },
            {
                message = "E35748: This error is so long that it needs some Latin literature: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                filePosition = {
                    fileName = 'tests/buildExplorer/ui/manualtest_spec.lua',
                    line = 43,
                    column = 30
                }
            },
            {
                message = 'E963: The last error',
                filePosition = {
                    fileName = 'lua/inspector/buildExplorer/ui/explorer',
                    line = 28,
                    column = 9
                }
            }
        }
    }

    it('errors as active tab', function()
        local actualHeader, actualLines = sut.convertToLines(diagnostics, 'errors')
        local expectedHeader = {
            text = '  Errors    Warnings  ',
            highlight = {
                { name = highlights.BuildExplorerErrorHeaderActive, start = 1, finish = 10 },
                { name = highlights.BuildExplorerWarningHeaderNotActive, start = 11, finish = 22 }
            }


        }
        local expectedLines = {
            {
                filePosition = diagnostics.errors[1].filePosition,
                text = 'E469: This is some serious error but the reson of it happening is quite mysterious. tests/buildExplorer/ui/manualtest_spec.lua:(35,22)',
                highlight = {
                    { name = highlights.BuildExplorerIssue, start = 1, finish = 83 },
                    { name = highlights.BuildExplorerFileReference, start = 85, finish = 134 }
                }
            },
            {
                filePosition = diagnostics.errors[2].filePosition,
                text = "E35748: This error is so long that it needs some Latin literature: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. tests/buildExplorer/ui/manualtest_spec.lua:(43,30)",
                highlight = {
                    { name = highlights.BuildExplorerIssue, start = 1, finish = 512},
                    { name = highlights.BuildExplorerFileReference, start = 514, finish = 563 }
                }
            },
            {
                filePosition = diagnostics.errors[3].filePosition,
                text = 'E963: The last error lua/inspector/buildExplorer/ui/explorer:(28,9)',
                highlight = {
                    { name = highlights.BuildExplorerIssue, start = 1, finish = 20 },
                    { name = highlights.BuildExplorerFileReference, start = 22, finish = 67 }
                }
            }
        }

        assert.are.same(expectedHeader, actualHeader)
        assert.are.same(expectedLines, actualLines)
    end)

    it('warnings as active tab', function()
        local actualHeader, actualLines = sut.convertToLines(diagnostics, 'warnings')
        local expectedHeader = {
            text = '  Errors    Warnings  ',
            highlight = {
                { name = highlights.BuildExplorerErrorHeaderNotActive, start = 1, finish = 10 },
                { name = highlights.BuildExplorerWarningHeaderActive, start = 11, finish = 22 }
            }


        }
        local expectedLines = {
            {
                filePosition = diagnostics.warnings[1].filePosition,
                text = 'W9344: This is some serious warning for some serious reasons tests/buildExplorer/ui/manualtest_spec.lua:(11,22)',
                highlight = {
                    { name = highlights.BuildExplorerIssue, start = 1, finish = 60 },
                    { name = highlights.BuildExplorerFileReference, start = 62, finish = 111 }
                }
            },
            {
                filePosition = diagnostics.warnings[2].filePosition,
                text = "W431: This warning is so long that it needs some Latin literature: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. tests/buildExplorer/ui/manualtest_spec.lua:(18,30)",
                highlight = {
                    { name = highlights.BuildExplorerIssue, start = 1, finish = 512 },
                    { name = highlights.BuildExplorerFileReference, start = 514, finish = 563 }
                }
            },
            {
                filePosition = diagnostics.warnings[3].filePosition,
                text = 'W952: The last warning lua/inspector/buildExplorer/ui/explorer:(20,6)',
                highlight = {
                    { name = highlights.BuildExplorerIssue, start = 1, finish = 22 },
                    { name = highlights.BuildExplorerFileReference, start = 24, finish = 69 }
                }
            }
        }

        assert.are.same(expectedHeader, actualHeader)
        assert.are.same(expectedLines, actualLines)

    end)
end)
