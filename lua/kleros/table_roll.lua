local M = {}

local dice = require("kleros.dice")
local user_tables = require("kleros.user_tables")

function M.table_roll(table_name)
	if not table_name or table_name == "" then
		return nil, nil, "Error: table name required"
	end

	local tbl = nil
	local subkey = nil

	-- Check for dot notation (e.g., "is_settlement_type.settled_lands")
	if table_name:match("%.") then
		subkey = table_name:match("%.(.+)$")
		table_name = table_name:match("^([^%.]+)")
	end

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

	-- If subkey exists, use the nested table
	if subkey and tbl.entries and tbl.entries[subkey] then
		tbl = tbl.entries[subkey]
	end

	local tbl_name = tbl.name
	local tbl_type = tbl.type
	local tbl_dice = tbl.dice
	local entry = ""

	if tbl_type == "compound" then
		local elements = tbl.elements or 2
		local separator = tbl.separator or ""
		local results, total = dice.roll_dice(tbl.dice)
		local parts = {}

		-- Check if pools exist for compound tables
		if tbl.pools then
			for i = 1, elements do
				local pool_key = "element" .. i
				local pool = tbl.pools[pool_key]
				if pool then
					local roll_index = results[i]
					if roll_index >= 1 and roll_index <= #pool then
						table.insert(parts, pool[roll_index])
					end
				end
			end
			entry = table.concat(parts, separator)
			-- Format total as array for compound with pools
			total = "[" .. table.concat(results, ",") .. "]"
			return tbl_name, tbl_dice, total, entry
		end

		-- Fallback to entries-based compound (legacy behavior)
		local entry_data = tbl.entries[results[1]]
		for i = 1, elements do
			local key = "element" .. i
			if entry_data[key] then
				table.insert(parts, entry_data[key])
			end
		end
		entry = table.concat(parts, separator)
		return tbl_name, tbl_dice, total, entry
	end

	local _, total = dice.roll_dice(tbl.dice)

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
