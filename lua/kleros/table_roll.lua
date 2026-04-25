local M = {}

local dice = require("kleros.dice")
local user_tables = require("kleros.user_tables")
local constants = require("kleros.constants")

local PLACEHOLDER = constants.PLACEHOLDER_PLACE
local ERROR_PREFIX = constants.ERROR_PREFIX

local function find_table_by_name(table_name, tables_index)
	if not table_name or not tables_index then return nil end
	for tbl_key, tbl_module in pairs(tables_index) do
		if tbl_key:lower() == table_name:lower() then
			return tbl_module[tbl_key]
		end
	end
	return nil
end

local function get_select_subtables(tbl)
	local subs = {}
	for key, val in pairs(tbl.entries or {}) do
		if type(key) == "string" and val and val.name then
			table.insert(subs, key)
		end
	end
	table.sort(subs)
	return subs
end

local function roll_in_range(tbl, total)
	for _, ent in ipairs(tbl.entries) do
		if total >= ent.min and total <= ent.max then
			return ent.result
		end
	end
	return nil
end

local function roll_simple_or_range(tbl)
	if not tbl then return nil, 0 end
	local _, total = dice.roll_dice(tbl.dice)
	local entry = ""

	if tbl.type == "range" then
		entry = roll_in_range(tbl, total)
	else
		entry = tbl.entries[total] or ""
	end

	return total, entry
end

local function is_list(tbl)
	if type(tbl) ~= "table" then return false end
	local count = 0
	for _ in pairs(tbl) do count = count + 1 end
	local has_numeric = false
	for k, _ in pairs(tbl) do
		if type(k) == "number" then
			has_numeric = true
			break
		end
	end
	return has_numeric and count > 0
end

local function find_sub_table(sub_name, parent_tbl, tables_index)
	if not sub_name then return nil end

	local sub_name_clean = sub_name:gsub("[+-]", "")
	local sub_name_lower = sub_name_clean:lower()

	if parent_tbl and parent_tbl.sub_tables then
		if is_list(parent_tbl.sub_tables) then
			for _, val in ipairs(parent_tbl.sub_tables) do
				if type(val) == "string" then
					local val_lower = val:lower()
					if val_lower == sub_name_lower or val_lower:match(sub_name_lower) or sub_name_lower:match(val_lower) then
						if tables_index and tables_index[val] then
							return tables_index[val][val]
						end
					end
				end
			end
		else
			for key, val in pairs(parent_tbl.sub_tables) do
				if key:lower() == sub_name_lower then
					if type(val) == "string" and tables_index and tables_index[val] then
						return tables_index[val][val]
					end
					return val
				end
			end
		end
	end

	if tables_index then
		for tbl_key, tbl_module in pairs(tables_index) do
			local tbl_key_lower = tbl_key:lower()
			if tbl_key_lower == sub_name_lower then
				return tbl_module[tbl_key]
			end
		end
		for tbl_key, tbl_module in pairs(tables_index) do
			local tbl_key_lower = tbl_key:lower()
			if tbl_key_lower:match(sub_name_lower) or sub_name_lower:match(tbl_key_lower) then
				return tbl_module[tbl_key]
			end
		end
	end

	return nil
end

local function resolve_place(tbl, tables_index)
	local place_tbl = nil

	if tbl and tbl.sub_tables then
		for key, val in pairs(tbl.sub_tables) do
			if type(key) == "string" and key:lower():match("place") then
				if type(val) == "string" and tables_index and tables_index[val] then
					place_tbl = tables_index[val][val]
				elseif type(val) == "table" then
					place_tbl = val
				end
				break
			end
		end
	end

	if not place_tbl and tables_index then
		for tbl_key, tbl_module in pairs(tables_index) do
			if tbl_key:lower():match("place") then
				place_tbl = tbl_module[tbl_key]
				break
			end
		end
	end

	if not place_tbl then return nil end

	if place_tbl.type == "select" then
		local keys = {}
		for key, _ in pairs(place_tbl.entries) do
			table.insert(keys, key)
		end
		table.sort(keys)
		local _, select_total = dice.roll_dice(place_tbl.dice)
		local selected_key = keys[(select_total % #keys) + 1]
		local sub_tbl = place_tbl.entries[selected_key]
		if sub_tbl then
			_, sub_tbl = roll_simple_or_range(sub_tbl)
			return sub_tbl
		end
		return nil
	end

	if place_tbl.place_types then
		local _, place_total = dice.roll_dice(place_tbl.dice)
		local place_type_entry = nil
		for _, ent in pairs(place_tbl.place_types) do
			if ent.min and ent.max and place_total >= ent.min and place_total <= ent.max then
				place_type_entry = ent
				break
			end
		end
		if place_type_entry then
			local place_detail_tbl = place_tbl.entries[place_type_entry.key]
			if place_detail_tbl then
				_, place_detail_tbl = roll_simple_or_range(place_detail_tbl)
				return place_detail_tbl
			end
		end
	end

	return nil
end

local function roll_with_advantage(dice_expr, advantage)
	if not advantage or advantage == "normal" then
		return dice.roll_dice(dice_expr)
	end

	local sides = dice_expr:match("1d(%d+)")
	sides = tonumber(sides) or 100

	local r1 = math.random(1, sides)
	local r2 = math.random(1, sides)
	local total = (advantage == "advantage") and math.max(r1, r2) or math.min(r1, r2)

	return { r1, r2 }, total
end

local function resolve_syllable3(sub_name, tables_index)
	local base_name = sub_name:gsub("[+-]", "")
	local modifier = sub_name:match("[+-]")

	local sub_tbl = find_sub_table(base_name, nil, tables_index)
	if not sub_tbl then return nil end

	local dice_expr = sub_tbl.dice
	local roll_total

	if modifier == "-" then
		roll_total = math.random(1, 10)
	elseif modifier == "+" then
		roll_total = math.random(1, 10) + 10
	else
		roll_total = math.random(1, 20)
	end

	return sub_tbl.entries[roll_total] or ""
end

local function clean_result(result, is_first)
	if is_first then
		return (result or ""):gsub("%([^)]*%)", "")
	else
		return (result or ""):gsub("%(", ""):gsub("%)", "")
	end
end

local function resolve_procedural(tbl, tables_index, advantage)
	local results, total

	if advantage and advantage ~= "normal" then
		results, total = roll_with_advantage(tbl.dice, advantage)
	else
		results, total = dice.roll_dice(tbl.dice)
	end

	local template = nil
	local vowel_suffix = nil

	if tbl.template then
		template = tbl.template
	elseif tbl.entries then
		for _, ent in ipairs(tbl.entries) do
			if total >= ent.min and total <= ent.max then
				template = ent.template
				break
			end
		end
	end

	if not template then
		return total, ERROR_PREFIX .. " invalid procedural table"
	end

	if template:match("[oai]$") then
		vowel_suffix = template:match("[oai]$")
		template = template:gsub("[oai]$", "")
	end

	local result = template
	local is_first = true

	while result:find("%[") do
		local placeholder_start = result:find("%[")
		local placeholder_end = result:find("]", placeholder_start)
		if not placeholder_end then break end

		local placeholder = result:sub(placeholder_start + 1, placeholder_end - 1)
		local is_possessive = placeholder:match("'s$")
		local sub_name = is_possessive and placeholder:gsub("'s$", "") or placeholder
		local sub_result = nil

		if sub_name == PLACEHOLDER then
			sub_result = resolve_place(tbl, tables_index)
		elseif sub_name:lower():match("syllable3") then
			sub_result = resolve_syllable3(sub_name, tables_index)
		else
			local sub_tbl = find_sub_table(sub_name, tbl, tables_index)
			if sub_tbl then
				_, sub_result = roll_simple_or_range(sub_tbl)
			end
		end

		if sub_result then
			sub_result = clean_result(sub_result, is_first)
			is_first = false
			if is_possessive then
				sub_result = sub_result .. "'s"
			end
			result = result:sub(1, placeholder_start - 1) .. sub_result .. result:sub(placeholder_end + 1)
		else
			result = result:sub(1, placeholder_start - 1) .. result:sub(placeholder_end + 1)
		end
	end

if vowel_suffix then
		result = result .. vowel_suffix
	end

	if result ~= "" then
		result = result:sub(1, 1):upper() .. result:sub(2)
	end

	return total, result
end

local function roll_compound(tbl)
	local elements = tbl.elements or 2
	local separator = tbl.separator or ""
	local results, total = dice.roll_dice(tbl.dice)
	local parts = {}

	if tbl.pools then
		for i = 1, elements do
			local pool = tbl.pools["element" .. i]
			if pool then
				local idx = results[i]
				if idx >= 1 and idx <= #pool then
					table.insert(parts, pool[idx])
				end
			end
		end
		return "[" .. table.concat(results, ",") .. "]", table.concat(parts, separator)
	end

	local entry_data = tbl.entries[results[1]]
	for i = 1, elements do
		local key = "element" .. i
		if entry_data[key] then
			table.insert(parts, entry_data[key])
		end
	end
	return total, table.concat(parts, separator)
end

local function parse_table_name(table_name)
	local base_name = table_name
	local advantage = "normal"

	if table_name:match("%!$") then
		base_name = table_name:gsub("%!$", "")
		advantage = "advantage"
	elseif table_name:match("%?$") then
		base_name = table_name:gsub("%?$", "")
		advantage = "disadvantage"
	end

	local subkey = nil
	if base_name:match("%.") then
		subkey = base_name:match("%.(.+)$")
		base_name = base_name:match("^([^%.]+)")
	end

	return base_name, subkey, advantage
end

function M.table_roll(table_name)
	if not table_name or table_name == "" then
		return nil, nil, nil, ERROR_PREFIX .. " table name required"
	end

	local search_name, subkey, advantage = parse_table_name(table_name)

	local builtin_ok, builtin = pcall(require, "kleros.tables")
	local tables_index = builtin_ok and builtin or {}
	local tbl = find_table_by_name(search_name, tables_index)

	if not tbl then
		local kleros = require("kleros")
		local tables_dir = kleros.tables_dir
		if tables_dir then
			user_tables.load_all(tables_dir)
			tbl = user_tables.get(search_name)
		end
	end

	if not tbl then
		return nil, nil, nil, ERROR_PREFIX .. " table '" .. table_name .. "' not found"
	end

	if subkey and tbl.type == "select" then
		for key, val in pairs(tbl.entries or {}) do
			if type(key) == "string" and key:lower() == subkey:lower() then
				tbl = val
				subkey = nil
				break
			end
		end
	end

	if tbl.type == "select" and not subkey then
		local subs = get_select_subtables(tbl)
		return tbl.name, tbl.dice, "", "Select: " .. table.concat(subs, ", ")
	end

	local tbl_name = tbl.name
	local tbl_dice = tbl.dice

	if tbl.type == "procedural" then
		local total, result = resolve_procedural(tbl, tables_index, advantage)
		return tbl_name, tbl_dice, total, result
	end

	if tbl.type == "compound" then
		local total, entry = roll_compound(tbl)
		return tbl_name, tbl_dice, total, entry
	end

	local total, entry = roll_simple_or_range(tbl)
	return tbl_name, tbl_dice, total, entry
end

return M