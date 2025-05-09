local sut = require('inspector.testRunners.utils')
local assert = require('luassert')

describe('parseCmd', function()
    it('space separated', function()
        local actual = sut.parseCmd('dotnet test C:\\GitRepos\\MyProject\\MySubfolder\\MyProj.csproj --filter FullyQualifiedName~=Ala.Ma.Kota')
        local expected = {
            'dotnet',
            'test',
            'C:\\GitRepos\\MyProject\\MySubfolder\\MyProj.csproj',
            '--filter',
            'FullyQualifiedName~=Ala.Ma.Kota'
        }
        assert.are.same(expected, actual)
    end)

    it('argument enclosed in single quotes', function()
        local actual = sut.parseCmd("C:\\GitRepos\\MyProject\\node_modules\\.bin\\jest -t 'this is enclosed in single quotes' --second-arg")
        local expected = {
            'C:\\GitRepos\\MyProject\\node_modules\\.bin\\jest',
            '-t',
            'this is enclosed in single quotes',
            '--second-arg'
        }
        assert.are.same(expected, actual)
    end)


    it('argument enclosed in duble quotes', function()
        local actual = sut.parseCmd('C:\\GitRepos\\MyProject\\node_modules\\.bin\\jest -t "this is enclosed in single quotes" --second-arg')
        local expected = {
            'C:\\GitRepos\\MyProject\\node_modules\\.bin\\jest',
            '-t',
            'this is enclosed in single quotes',
            '--second-arg'
        }
        assert.are.same(expected, actual)
    end)
end)
