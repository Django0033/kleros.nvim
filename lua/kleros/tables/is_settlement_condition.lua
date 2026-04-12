local M = {}

M.is_settlement_condition = {
	name = "Ironsworn Settlement Condition",
	type = "range",
	dice = "1d100",
	entries = {
		{ min = 1, max = 5, result = "Abandoned" },
		{ min = 6, max = 10, result = "Devastated" },
		{ min = 11, max = 15, result = "Besieged" },
		{ min = 16, max = 20, result = "Under construction" },
		{ min = 21, max = 35, result = "Wretched" },
		{ min = 36, max = 50, result = "Ramshackle" },
		{ min = 51, max = 70, result = "Modest" },
		{ min = 71, max = 85, result = "Well-kept" },
		{ min = 86, max = 95, result = "Prosperous" },
		{ min = 96, max = 100, result = "Grand" },
	},
}

return M