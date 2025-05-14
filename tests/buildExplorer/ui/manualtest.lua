local sut = require('inspector.buildExplorer.ui.explorer')


--- @type Diagnostics
local diagnostics = {
    warnings = {
        {
            message = 'W9344: This is some serious warning for some serious reasons',
            filePosition = {
                fileName = 'tests/buildExplorer/ui/manualtest.lua',
                line = 11,
                column = 22
            }
        },
        {
            message = "W431: This warning is so long that it needs some Latin literature: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            filePosition = {
                fileName = 'tests/buildExplorer/ui/manualtest.lua',
                line = 18,
                column = 30
            }
        },
        {
            message = 'W952: The last warning',
            filePosition = {
                fileName = 'lua/inspector/buildExplorer/ui/explorer.lua',
                line = 20,
                column = 6
            }
        }
    },
    errors = {
        {
            message = 'E469: This is some serious error but the reson of it happening is quite mysterious.',
            filePosition = {
                fileName = 'tests/buildExplorer/ui/manualtest.lua',
                line = 35,
                column = 22
            }
        },
        {
            message = "E35748: This error is so long that it needs some Latin literature: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            filePosition = {
                fileName = 'tests/buildExplorer/ui/manualtest.lua',
                line = 43,
                column = 30
            }
        },
        {
            message = 'E963: The last error',
            filePosition = {
                fileName = 'lua/inspector/buildExplorer/ui/explorer.lua',
                line = 28,
                column = 9
            }
        }
    }
}

sut.open(diagnostics)
