vim.api.nvim_create_user_command("KlerosRoll", function(opts)
	local expr = opts.args or "d20"
	local dice = require("kleros.dice")
	local results, total = dice.roll_dice(expr)

	print(string.format("Rolled %s: [%s] = %d", expr, table.concat(results, ", "), total))
end, { nargs = "?" })
