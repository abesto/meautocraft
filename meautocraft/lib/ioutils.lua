local function read_file(path)
    local file = fs.open(path, "r")
    if not file then
        printError("Could not open file " .. path)
        return nil
    end

    local data = file.readAll()
    file.close()
    return data
end

local function write_file(path, content)
    local file = fs.open(path, "w")
    if not file then
        printError("Could not open file " .. path)
        return false
    end

    file.write(content)
    file.close()
    return true
end

local function panic(message)
    printError(message)
    printError("Report issues at: https://github.com/abesto/meautocraft/issues")
    error("Exiting with error; see messages above.")
end

return {
    read_file = read_file,
    write_file = write_file,
    panic = panic,
}
