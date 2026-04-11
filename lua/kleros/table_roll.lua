local M = {}

local dice = require("kleros.dice")

function M.table_roll(table_name)
	local tbl = require("kleros.tables." .. table_name)[table_name]
	local tbl_dice = tbl.dice
	local _, total = dice.roll_dice(tbl.dice)
	local entry = tbl.entries[total]

	return tbl_dice, total, entry
end

return M
