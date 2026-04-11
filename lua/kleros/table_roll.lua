local M = {}

local dice = require("kleros.dice")

function M.table_roll(table_name)
	if not table_name or table_name == "" then
		return nil, nil, "Error: table name required"
	end

	local success, tbl_module = pcall(require, "kleros.tables." .. table_name)

	if not success or not tbl_module then
		return nil, nil, "Error: table module not found"
	end

	local tbl = tbl_module[table_name]

	if not tbl then
		return nil, nil, "Error: table '" .. table_name .. "' not found in module"
	end

	local tbl = require("kleros.tables." .. table_name)[table_name]
	local tbl_dice = tbl.dice
	local _, total = dice.roll_dice(tbl.dice)
	local entry = tbl.entries[total]

	return tbl_dice, total, entry
end

return M
