vim.api.nvim_create_user_command("KlerosRoll", function(opts)
	local expr = opts.args or "d20"
	local dice = require("kleros.dice")
	local results, total = dice.roll_dice(expr)

	print(string.format("Rolled %s: [%s] = %d", expr, table.concat(results, ", "), total))
end, { nargs = "?" })

vim.api.nvim_create_user_command("KlerosTables", function(opts)
	local tbl = opts.args
	local tbl_name, tbl_dice, total, entry = require("kleros.table_roll").table_roll(tbl)

	if not entry or type(entry) == "string" and entry:match("^Error:") then
		print(entry or "Unknown error")
		return
	end

	print(string.format("tbl: %s %s=%s -> %s", tbl_name, tbl_dice, total, entry))
end, { nargs = "?" })
