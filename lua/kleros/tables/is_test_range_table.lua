local M = {}

M.is_test_range_table = {
	name = "Ironsworn Test Range Table",
	type = "range",
	dice = "1d6",
	entries = {
		{ min = 1, max = 2, result = "Result 1" },
		{ min = 3, max = 4, result = "Result 2" },
		{ min = 5, max = 6, result = "Result 3" },
	},
}

return M
