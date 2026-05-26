local M = {}

function M.setup(_opts)
end

function M.is_available()
	local ok, telescope = pcall(require, "telescope")
	return ok and telescope ~= nil
end

return M
