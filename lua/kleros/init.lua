local M = {}

M.config = require("kleros.config")
M.dice = require("kleros.dice")
M.table_roll = require("kleros.table_roll")
M.ui = require("kleros.ui")
M.tables_dir = nil

function M.setup(opts)
	opts = opts or {}
	M.config.setup(opts)
	M.tables_dir = opts.tables_dir or vim.fn.stdpath("config") .. "/kleros-tables"
	M.dice.setup()
end

return M
