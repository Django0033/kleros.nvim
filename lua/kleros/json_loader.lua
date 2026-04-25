local M = {}

function M.load_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil, "Error: cannot open file " .. path
	end

	local content = file:read("*all")
	file:close()

	if not content or content == "" then
		return nil, "Error: Empty file " .. path
	end

	local success, decoded = pcall(vim.json.decode, content)
	if not success then
		return nil, "Error: Invalid JSON in " .. path .. ": " .. decoded
	end

	return decoded, nil
end

local function validate_entries(tbl, entry_type)
	if not tbl.entries or type(tbl.entries) ~= "table" then
		return false, "Error: missing 'entries' field"
	end

	if entry_type == "array" then
		for i, v in ipairs(tbl.entries) do
			if type(v) ~= "string" then
				return false, "Error: entries must be strings"
			end
		end
	elseif entry_type == "range" then
		for i, ent in ipairs(tbl.entries) do
			if type(ent) ~= "table" or not ent.min or not ent.max or not ent.result then
				return false, "Error: entries must have min, max, result"
			end
		end
	end

	return true, nil
end

local validators = {
	simple = function(tbl)
		if not tbl.dice or type(tbl.dice) ~= "string" then
			return false, "Error: missing 'dice' field"
		end
		return validate_entries(tbl, "array")
	end,

	range = function(tbl)
		if not tbl.dice or type(tbl.dice) ~= "string" then
			return false, "Error: missing 'dice' field"
		end
		return validate_entries(tbl, "range")
	end,

	select = function(tbl)
		return validate_entries(tbl, "select")
	end,

	compound = function(tbl)
		if not tbl.entries or type(tbl.entries) ~= "table" then
			return false, "Error: missing 'entries' field"
		end
		if tbl.pools and type(tbl.pools) ~= "table" then
			return false, "Error: 'pools' must be a table"
		end
		return true, nil
	end,

	procedural = function(tbl)
		if tbl.template and type(tbl.template) == "string" then
			return true, nil
		end
		if not tbl.entries or type(tbl.entries) ~= "table" then
			return false, "Error: procedural requires 'template' or 'entries'"
		end
		for _, entry in ipairs(tbl.entries) do
			if not entry.template or type(entry.template) ~= "string" then
				return false, "Error: entries require 'template' field"
			end
		end
		return true, nil
	end,
}

function M.validate_table(tbl)
	if type(tbl) ~= "table" then
		return false, "Error: table must be a table"
	end

	if not tbl.name or type(tbl.name) ~= "string" then
		return false, "Error: missing or invalid 'name' field"
	end

	if not tbl.type or type(tbl.type) ~= "string" then
		return false, "Error: missing or invalid 'type' field"
	end

	local valid_types = { "simple", "range", "select", "compound", "procedural" }
	local is_valid_type = false
	for _, v in ipairs(valid_types) do
		if tbl.type == v then
			is_valid_type = true
			break
		end
	end

	if not is_valid_type then
		return false, "Error: type must be 'simple', 'range', 'select', 'compound', or 'procedural'"
	end

	return validators[tbl.type](tbl)
end

return M