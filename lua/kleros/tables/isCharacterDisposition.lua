local M = {}

M.isCharacterDisposition = {
	name = "Ironsworn Character Disposition",
	type = "range",
	dice = "1d100",
	entries = {
		{ min = 1, max = 6, result = "Helpful" },
		{ min = 7, max = 13, result = "Friendly" },
		{ min = 14, max = 20, result = "Cooperative" },
		{ min = 21, max = 28, result = "Curious" },
		{ min = 29, max = 36, result = "Indifferent" },
		{ min = 37, max = 47, result = "Suspicious" },
		{ min = 48, max = 57, result = "Wanting" },
		{ min = 58, max = 67, result = "Desperate" },
		{ min = 68, max = 76, result = "Demanding" },
		{ min = 77, max = 85, result = "Unfriendly" },
		{ min = 86, max = 93, result = "Threatening" },
		{ min = 94, max = 100, result = "Hostile" },
	},
}

return M