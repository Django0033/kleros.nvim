local M = {}

local function get_telescope()
	local ok, telescope = pcall(require, "telescope")
	return ok and telescope or nil
end

local function get_table_roll()
	return require("kleros.table_roll")
end

local function get_table_index()
	local ok, tables = pcall(require, "kleros.tables")
	return ok and tables or {}
end

M.loaded = false

function M.setup(opts)
	opts = opts or {}
	M.loaded = true
end

function M.is_available()
	return get_telescope() ~= nil
end

return M
