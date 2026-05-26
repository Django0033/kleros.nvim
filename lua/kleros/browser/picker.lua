local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local default_opts = {}

local function make_previewer()
	return previewers.new_buffer_previewer({
		define_preview = function(self, entry)
			local lines = {}
			local tbl_key = entry.value.name
			local tbl = (require("kleros.tables")[tbl_key] or {})[tbl_key]

			if not tbl then
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Table not found: " .. tbl_key })
				return
			end

			table.insert(lines, tbl.name or tbl_key)
			table.insert(lines, "Type: " .. tbl.type .. " | Dice: " .. tbl.dice)
			table.insert(lines, string.rep("-", 40))
			table.insert(lines, "")

			if tbl.type == "simple" then
				for i, v in ipairs(tbl.entries) do
					table.insert(lines, string.format("%-4d %s", i, v))
				end
			elseif tbl.type == "range" then
				for _, e in ipairs(tbl.entries) do
					table.insert(lines, string.format(" %2d-%-3d %s", e.min, e.max, e.result))
				end
			elseif tbl.type == "procedural" then
				for _, e in ipairs(tbl.entries) do
					table.insert(lines, string.format(" %2d-%-3d %s", e.min, e.max, e.template))
				end
			elseif tbl.type == "select" then
				for key, sub in pairs(tbl.entries) do
					table.insert(lines, string.format(" %-20s (%s, %s)", sub.name or key, sub.type, sub.dice or "?"))
				end
			elseif tbl.type == "compound" and tbl.entries then
				for i, e in ipairs(tbl.entries) do
					local text = type(e) == "table" and (e.element1 or e.element2 or vim.inspect(e)) or tostring(e)
					table.insert(lines, string.format(" %-4d %s", i, text))
				end
			end

			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
		end,
	})
end

local M = {}

function M.new()
	local tables_index = require("kleros.tables")
	local results = {}

	for tbl_key, tbl_module in pairs(tables_index) do
		local tbl = tbl_module[tbl_key]
		if tbl then
			table.insert(results, {
				name = tbl_key,
				display = tbl.name or tbl_key,
				type = tbl.type,
				dice = tbl.dice,
			})
		end
	end

	local picker = pickers.new(default_opts, {
		prompt_title = "Kleros Tables",
		finder = finders.new_table({
			results = results,
			entry_maker = function(entry)
				return {
					value = entry,
					display = string.format("%s (%s, %s)", entry.display, entry.type, entry.dice),
					ordinal = entry.name,
				}
			end,
		}),
		sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
		previewer = make_previewer(),
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if not entry then
					return
				end
				local ok, name, dice, total, result = pcall(require("kleros.table_roll").table_roll, entry.value.name)
				if ok then
					vim.notify(string.format("[kleros] %s (%s=%s): %s", name, dice, total, result))
					require("kleros.ui").show_result(name, { dice .. " = " .. total, "", result }, { title = "Kleros" })
				else
					vim.notify("[kleros] Error: " .. tostring(name), vim.log.ERROR)
				end
			end)
			return true
		end,
	})

	return picker
end

return M
