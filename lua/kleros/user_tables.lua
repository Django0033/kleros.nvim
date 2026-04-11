local json_loader = require "kleros.json_loader"
local M = {}

M.tables = {}

function M.load_all(tables_dir)
    if not vim.fn.isdirectory(tables_dir) then
        return nil, "Error: Directory not found: " .. tables_dir
    end

    local pattern = tables_dir .. "/*.json"
    local files = vim.fn.glob(pattern)

    if not files or files == "" then
        return {}, nil
    end

    local file_list = vim.split(files, "\n")

    for _, filepath in ipairs(file_list) do
        local tbl, err = json_loader.load_file(filepath)

        if err then
            vim.notify("[kleros] Warning: " .. err, vim.log.levels.WARN)
        else
            local valid, err = json_loader.validate_table(tbl)

            if not valid then
                vim.notify("[kleros] Invalid tables: " .. err, vim.log.levels.WARN)
            else
                M.tables[tbl.name] = tbl
            end
        end
    end

    return M.tables, nil
end

function M.get(table_name)
    return M.tables[table_name]
end

function M.list()
    local names = {}

    for name, _ in pairs(M.tables) do
        table.insert(names, name)
    end

    table.sort(names)

    return names
end

return M
