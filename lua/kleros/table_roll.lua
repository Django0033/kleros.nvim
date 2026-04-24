local M = {}

local dice = require("kleros.dice")
local user_tables = require("kleros.user_tables")

local function find_table_in_index(table_name, index)
	if not index then return nil end
	for tbl_key, tbl_module in pairs(index) do
		if tbl_key:lower() == table_name:lower() then
			return tbl_module[tbl_key]
		end
	end
	return nil
end

function M.table_roll(table_name)
	if not table_name or table_name == "" then
		return nil, nil, "Error: table name required"
	end

	local subkey = nil
	if table_name:match("%.") then
		subkey = table_name:match("%.(.+)$")
		table_name = table_name:match("^([^%.]+)")
	end

	local tbl = nil

	-- Use tables index for lookup
	local index_ok, tables_index = pcall(require, "kleros.tables")
	if index_ok and tables_index then
		local tbl_module = find_table_in_index(table_name, tables_index)
		if tbl_module then
			tbl = tbl_module
		end
	end

	-- Fallback to user tables
	if not tbl then
		local kleros = require("kleros")
		local tables_dir = kleros.tables_dir
		if tables_dir then
			user_tables.load_all(tables_dir)
			tbl = user_tables.get(table_name)
		end
	end

	if not tbl then
		return nil, nil, nil, "Error: table '" .. table_name .. "' not found"
	end

	if subkey then
		for key, val in pairs(tbl.entries or {}) do
			if key:lower() == subkey:lower() then
				tbl = val
				break
			end
		end
	elseif tbl.type == "select" then
		local subs = {}
		for key, _ in pairs(tbl.entries or {}) do
			table.insert(subs, key)
		end
		table.sort(subs)
		return tbl.name, "", "", "Available sub-tables: " .. table.concat(subs, ", ")
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
			total = "[" .. table.concat(results, ",") .. "]"
			return tbl_name, tbl_dice, total, entry
		end

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