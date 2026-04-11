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
