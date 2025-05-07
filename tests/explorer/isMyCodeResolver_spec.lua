local sut = require('inspector.explorer.isMyCodeResolver')
local assert = require('luassert')

describe('resolve - dotnet style', function()

    --- @type StackTraceFileRef
    local expected = {
        fileName = 'EnterpriseApp/DataAccess/DatabaseConnection.cs',
        line = 157,
        highlight = {
            start = 64,
            finish = -1
        }
    }

    it('backslashes in input path and backslashes in project dir', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:\\GitRepos\\MyProject\\EnterpriseApp\\DataAccess\\DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:\\GitRepos\\MyProject")
        assert.are.same(expected, actual)
    end)

    it('backslashes in input path and frontslashes in project dir', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:\\GitRepos\\MyProject\\EnterpriseApp\\DataAccess\\DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:/GitRepos/MyProject")
        assert.are.same(expected, actual)
    end)

    it('frontslashes in input path and backslashes in project dir', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:/GitRepos/MyProject/EnterpriseApp/DataAccess/DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:\\GitRepos\\MyProject")
        assert.are.same(expected, actual)
    end)

    it('frontslashes in input path and frontslashes in project dir', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:/GitRepos/MyProject/EnterpriseApp/DataAccess/DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:/GitRepos/MyProject")
        assert.are.same(expected, actual)
    end)

    it('project dir ends with frontslash', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:/GitRepos/MyProject/EnterpriseApp/DataAccess/DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:/GitRepos/MyProject/")
        assert.are.same(expected, actual)
    end)


    it('project dir ends with backslash', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:/GitRepos/MyProject/EnterpriseApp/DataAccess/DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:\\GitRepos\\MyProject\\")
        assert.are.same(expected, actual)
    end)

    it('projet dir does not end with any slash', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:/GitRepos/MyProject/EnterpriseApp/DataAccess/DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:/GitRepos/MyProject")
        assert.are.same(expected, actual)
    end)

    it('this is not my code - path to file included', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:/TotallyDifferentPath/MyProject/EnterpriseApp/DataAccess/DatabaseConnection.cs:line 157'
        local actual = sut.resolve(input, "C:/GitRepos/MyProject")
        assert.are.same(nil, actual)
    end)

    it('this is not my code - no path to file', function()
        local input = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query)'
        local actual = sut.resolve(input, "C:/GitRepos/MyProject")
        assert.are.same(nil, actual)
    end)
end)
