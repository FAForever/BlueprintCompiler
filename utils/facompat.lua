-- If we're running inside Forged Alliance, we need to behave a little differently.
-- This provides canonical versions of certain functions: either standard library editions or GPG
-- ones.

local FaCompat = {}

-- Return a list of all files in a given directory, recursively.
function FaCompat.DiskFindFiles(dir, pattern)
    local p = io.popen('find "' .. dir .. '" -type f -name ' .. pattern)

    local lines = {}
    for l in p:lines() do
        table.insert(lines, l)
    end

    io.close(p)

    return lines
end

FaCompat.doscript = dofile

return FaCompat
