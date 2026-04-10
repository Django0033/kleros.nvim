vim.api.nvim_create_user_command("KlerosRoll", function(opts)
	local sides = tonumber(opts.args) or 20

	print("Rolled: " .. require("kleros.dice").roll_die(sides))
end, { nargs = "?" })
