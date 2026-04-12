local function get_table_completion(arglead, cmdline, cursor)
	local all_tables = {}

	-- Built-in tables (use key = filename)
	local builtin_ok, builtin = pcall(require, "kleros.tables")
	if builtin_ok and builtin then
		for key, _ in pairs(builtin) do
			table.insert(all_tables, key)
		end
	end

	-- User tables from JSON (use filename as key)
	local kleros = require("kleros")
	if kleros.tables_dir then
		local user_tables = require("kleros.user_tables")
		local user_ok, user = pcall(user_tables.load_all, kleros.tables_dir)
		if user_ok and user then
			for key, _ in pairs(user) do
				table.insert(all_tables, key)
			end
		end
	end

	-- Filter by arglead
	if arglead and arglead ~= "" then
		local filtered = {}
		for _, v in ipairs(all_tables) do
			if v:lower():match("^" .. arglead:lower()) then
				table.insert(filtered, v)
			end
		end
		all_tables = filtered
	end

	table.sort(all_tables)
	return all_tables
end

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
end, { nargs = "?", complete = get_table_completion })
