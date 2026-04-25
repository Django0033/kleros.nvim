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

local function name_to_key(name)
	local key = name:gsub("[^%w]", ""):lower()
	key = key:gsub("(%l)(%u)", "%1%2")
	return key
end

local function find_parent_key(tbl, tables_index)
	if not tables_index then return "" end
	for tbl_key, tbl_module in pairs(tables_index) do
		if tbl_module and tbl_module[tbl_key] and tbl_module[tbl_key].name == tbl.name then
			return tbl_key
		end
	end
	return ""
end

local function find_sub_table_by_name(sub_name, parent_key, tables_index)
	if not tables_index then return nil end
	local search_patterns = {
		parent_key .. sub_name,
		sub_name,
	}

	for tbl_key, tbl_module in pairs(tables_index) do
		for _, pattern in ipairs(search_patterns) do
			if tbl_key:lower() == pattern:lower() then
				return tbl_module[tbl_key]
			end
		end
	end
	return nil
end

local function roll_sub_table(sub_tbl)
	if not sub_tbl then return nil end
	if sub_tbl.type == "select" then return nil end

	local _, sub_total = dice.roll_dice(sub_tbl.dice)
	local sub_entry = ""

	if sub_tbl.type == "range" then
		for _, ent in ipairs(sub_tbl.entries) do
			if sub_total >= ent.min and sub_total <= ent.max then
				sub_entry = ent.result
				break
			end
		end
	elseif sub_tbl.type == "simple" then
		sub_entry = sub_tbl.entries[sub_total] or ""
	elseif sub_tbl.type == "compound" then
		local _, _, _, compound_result = M.table_roll(sub_tbl.name)
		sub_entry = compound_result or ""
	end

	return sub_entry
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

	local index_ok, tables_index = pcall(require, "kleros.tables")
	if index_ok and tables_index then
		local tbl_module = find_table_in_index(table_name, tables_index)
		if tbl_module then
			tbl = tbl_module
		end
	end

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
			if type(key) == "string" and key:lower() == subkey:lower() then
				tbl = val
				break
			end
		end
	elseif tbl.type == "select" then
		local subs = {}
		for key, _ in pairs(tbl.entries or {}) do
			if type(key) == "string" then
				table.insert(subs, key)
			end
		end
		table.sort(subs)
		return tbl.name, "", "", "Available sub-tables: " .. table.concat(subs, ", ")
	end

	local tbl_name = tbl.name
	local tbl_type = tbl.type
	local tbl_dice = tbl.dice
	local entry = ""

	if tbl_type == "procedural" then
		local _, total = dice.roll_dice(tbl.dice)
		local pattern = nil

		for _, ent in ipairs(tbl.entries) do
			if total >= ent.min and total <= ent.max then
				pattern = ent
				break
			end
		end

		if not pattern or not pattern.template then
			return tbl_name, tbl_dice, total, "Error: invalid pattern"
		end

		local template = pattern.template
		local result = template

		for placeholder in template:gmatch("%[([^%]]+)%]") do
			local is_possessive = false
			local sub_table_name = placeholder

			if placeholder:match("'s$") then
				is_possessive = true
				sub_table_name = placeholder:gsub("'s$", "")
			end

			local sub_result = nil

			if sub_table_name == "Place" then
				local parent_key = find_parent_key(tbl, tables_index)
				local place_tbl = find_sub_table_by_name("Place", parent_key, tables_index)

				if place_tbl then
					local _, place_total = dice.roll_dice(place_tbl.dice)
					local place_type_entry = nil

					for _, ent in pairs(place_tbl.place_types or {}) do
						if ent.min and ent.max and place_total >= ent.min and place_total <= ent.max then
							place_type_entry = ent
							break
						end
					end

					if place_type_entry and place_tbl.entries[place_type_entry.key] then
						local place_detail_tbl = place_tbl.entries[place_type_entry.key]
						local _, detail_total = dice.roll_dice(place_detail_tbl.dice)
						local place_detail = ""

						for _, ent in ipairs(place_detail_tbl.entries) do
							if detail_total >= ent.min and detail_total <= ent.max then
								place_detail = ent.result
								break
							end
						end

						if is_possessive then
							sub_result = place_detail .. "'s"
						else
							sub_result = place_detail
						end
					end
				end
			else
				local parent_key = find_parent_key(tbl, tables_index)
				local sub_tbl = find_sub_table_by_name(sub_table_name, parent_key, tables_index)

				if sub_tbl then
					sub_result = roll_sub_table(sub_tbl)
					if is_possessive and sub_result then
						sub_result = sub_result .. "'s"
					end
				end
			end

			if sub_result then
				local escaped_placeholder = placeholder:gsub("'", "\\'")
				result = result:gsub("%[" .. escaped_placeholder .. "%]", sub_result)
			end
		end

		return tbl_name, tbl_dice, total, result
	end

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