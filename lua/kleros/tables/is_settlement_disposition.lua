local M = {}

M.is_settlement_disposition = {
	name = "Ironsworn Settlement Disposition",
	type = "range",
	dice = "1d100",
	entries = {
		{ min = 1, max = 5, result = "Hostile" },
		{ min = 6, max = 15, result = "Threatening" },
		{ min = 16, max = 25, result = "Demanding" },
		{ min = 26, max = 35, result = "Unwelcoming" },
		{ min = 36, max = 50, result = "Wary" },
		{ min = 51, max = 60, result = "Indifferent" },
		{ min = 61, max = 70, result = "In need" },
		{ min = 71, max = 80, result = "Welcoming" },
		{ min = 81, max = 90, result = "Friendly" },
		{ min = 91, max = 100, result = "Helpful" },
	},
}

return M