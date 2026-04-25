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

	if tbl.type == "procedural" then
		if not tbl.entries or type(tbl.entries) ~= "table" then
			return false, "Error: procedural tables require 'entries' field"
		end
		for _, entry in ipairs(tbl.entries) do
			if not entry.template or type(entry.template) ~= "string" then
				return false, "Error: procedural entries require 'template' field"
			end
		end
		if tbl.sub_tables then
			if type(tbl.sub_tables) ~= "table" then
				return false, "Error: 'sub_tables' must be a table"
			end
			for sub_name, sub_tbl in pairs(tbl.sub_tables) do
				if type(sub_tbl) ~= "table" then
					return false, "Error: sub_table '" .. sub_name .. "' must be a table"
				end
				if not sub_tbl.name then
					return false, "Error: sub_table '" .. sub_name .. "' requires 'name' field"
				end
				if not sub_tbl.type then
					return false, "Error: sub_table '" .. sub_name .. "' requires 'type' field"
				end
				if not sub_tbl.dice then
					return false, "Error: sub_table '" .. sub_name .. "' requires 'dice' field"
				end
				if not sub_tbl.entries then
					return false, "Error: sub_table '" .. sub_name .. "' requires 'entries' field"
				end
			end
		end
		return true, nil
	end

	if tbl.type == "compound" then
		if not tbl.entries or type(tbl.entries) ~= "table" then
			return false, "Error: compound tables require 'entries' field"
		end
		if tbl.pools and type(tbl.pools) ~= "table" then
			return false, "Error: 'pools' must be a table"
		end
		return true, nil
	end

	if tbl.type == "select" then
		if not tbl.entries or type(tbl.entries) ~= "table" then
			return false, "Error: select tables require 'entries' field"
		end
		return true, nil
	end

	if not tbl.dice or type(tbl.dice) ~= "string" then
		return false, "Error: missing or invalid 'dice' field"
	end

	if not tbl.entries or type(tbl.entries) ~= "table" then
		return false, "Error: missing or invalid 'entries' field"
	end

	return true, nil
end

return M