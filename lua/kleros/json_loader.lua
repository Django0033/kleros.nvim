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

	-- Should expand to accept more types
	if tbl.type ~= "simple" and tbl.type ~= "range" then
		return false, "Error: type must be 'simple' or 'range'"
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
