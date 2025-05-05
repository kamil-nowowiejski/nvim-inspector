local sut = require('inspector.explorer.ui.mainBuffer')
local mock = require('luassert.mock')
local assert = require('luassert')

describe("getId", function()
    it("explorer not initialized", function()
        local actual = sut.getId()
        assert.equals(-1, actual)
    end)
end)

describe("open", function()
    it("explorer was never opened", function()
        -- arrange
        local mainBufferId = 1234
        local apiMock = mock(vim.api, true)
        local oldBufwinnr = vim.fn.bufwinnr
        vim.fn.bufwinnr = function(buf) return -1 end
        apiMock.nvim_get_current_buf.returns(mainBufferId)

        -- act
        sut.open()
        vim.fn.bufwinnr = oldBufwinnr

        -- assert
        assert.stub(apiMock.nvim_command).was_called_with("belowright split 'Test Output'")
        assert.stub(apiMock.nvim_set_option_value).was_called_with('readonly', true, { buf = mainBufferId })
        assert.stub(apiMock.nvim_set_option_value).was_called_with('swapfile', false, { buf = mainBufferId })
        assert.equals(mainBufferId, sut.getId())
    end)
end)
