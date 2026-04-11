local M = {}

local dice = require("kleros.dice")
local user_tables = require("kleros.user_tables")

function M.table_roll(table_name)
	if not table_name or table_name == "" then
		return nil, nil, "Error: table name required"
	end

	local tbl = nil

	-- Buscar en built-in tables
	local success, tbl_module = pcall(require, "kleros.tables." .. table_name)
	if success and tbl_module then
		tbl = tbl_module[table_name]
	end

	-- Si no encontró, buscar en user tables
	if not tbl then
		local kleros = require("kleros")
		local tables_dir = kleros.tables_dir

		if tables_dir then
			user_tables.load_all(tables_dir)
			tbl = user_tables.get(table_name)
		end
	end

	-- Si no se encontró en ningún lado
	if not tbl then
		return nil, nil, nil, "Error: table '" .. table_name .. "' not found"
	end

	local tbl_name = tbl.name
	local tbl_type = tbl.type
	local tbl_dice = tbl.dice
	local _, total = dice.roll_dice(tbl.dice)
	local entry = ""

	if tbl_type == "range" then
		for _, ent in ipairs(tbl.entries) do
			if total >= ent.min and total <= ent.max then
				entry = ent.result
			end
		end
	else
		entry = tbl.entries[total]
	end

	return tbl_name, tbl_dice, total, entry
end

return M
