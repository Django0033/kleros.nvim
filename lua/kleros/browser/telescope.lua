local M = {}

function M.register()
	local ok, telescope = pcall(require, "telescope")
	if not ok then
		return false
	end
    local ext_ok, _ = pcall(require, "telescope._extensions.kleros")
    if not ext_ok then
        return false
    end

	telescope.load_extension("kleros")
	return true
end

function M.load_extension()
	local ok, _ = pcall(require, "telescope._extensions.kleros")
	return ok
end

return M
