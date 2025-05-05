local function isPathIncludedInRtp(path)
    local rtp = vim.opt.rtp:get()
    for _, p in ipairs(rtp) do
        if p == path then
            return true
        end
    end

    return false
end

local inspectorPath = vim.fn.stdpath("data") .. "/lazy/inspector"

if isPathIncludedInRtp(inspectorPath) == false then
    local rtp = vim.opt.rtp:get()
    table.insert(rtp, inspectorPath)
    local rtpString = table.concat(rtp, ',')
    vim.cmd("set runtimepath="..rtpString)
end
