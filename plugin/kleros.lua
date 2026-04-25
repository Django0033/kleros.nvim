local function get_table_completion(arglead, cmdline, cursor)
	local all_tables = {}

	-- Check for dot notation (nested table access)
	local main_table = nil
	local subkey_prefix = ""
	if arglead and arglead:match("%.") then
		main_table = arglead:match("^([^%.]+)")
		subkey_prefix = arglead:match("%.(.+)$") or ""
	end

	-- If dot notation, get sub-keys from nested table
	if main_table then
		-- First try to find by key in tables index
		local builtin_ok, builtin = pcall(require, "kleros.tables")
		if builtin_ok and builtin then
			for tbl_key, tbl_module in pairs(builtin) do
				local t = tbl_module[tbl_key]
				-- Match by key (case-insensitive)
				if t and tbl_key:lower() == main_table:lower() then
					if t and t.entries and t.type == "select" then
						for key, _ in pairs(t.entries) do
							local full_key = main_table .. "." .. key
							if subkey_prefix == "" or key:lower():find(subkey_prefix:lower(), 1, true) then
								table.insert(all_tables, full_key)
							end
						end
					end
					break
				end
			end
		end
	-- Normal completion (no dot)
	else
		-- Built-in tables (use key from index)
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
				if v:lower():find(arglead:lower(), 1, true) then
					table.insert(filtered, v)
				end
			end
			all_tables = filtered
		end
	end

	table.sort(all_tables)
	return all_tables
end

vim.api.nvim_create_user_command("Kleros", function(opts)
	local tbl = opts.args
	local tbl_name, tbl_dice, total, entry = require("kleros.table_roll").table_roll(tbl)

	if not entry or type(entry) == "string" and entry:match("^Error:") then
		print(entry or "Unknown error")
		return
	end

	local display_text
	if tbl_dice == "" then
		display_text = tbl_name .. ": " .. entry
	else
		display_text = string.format("tbl: %s %s=%s -> %s", tbl_name, tbl_dice, total, entry)
	end

	print(display_text)
	require("kleros.ui").show_result("Result", { display_text }, { title = "Kleros" })
end, { nargs = "?", complete = get_table_completion })
