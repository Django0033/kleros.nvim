local M = {}

M.dice = require("kleros.dice")
M.table_roll = require("kleros.table_roll")

function M.setup()
	M.dice.setup()
end

return M
