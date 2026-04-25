local M = {}

M.isDelveSiteName = {
	name = "Ironsworn Delve Site Name",
	type = "procedural",
	dice = "1d100",
	entries = {
		{ min = 1, max = 25, template = "[Description] [Place]" },
		{ min = 26, max = 50, template = "[Place] of [Detail]" },
		{ min = 51, max = 70, template = "[Place] of [Description] [Detail]" },
		{ min = 71, max = 80, template = "[Place] of [Namesake]'s [Detail]" },
		{ min = 81, max = 85, template = "[Namesake]'s [Place]" },
		{ min = 86, max = 95, template = "[Description] [Place] of [Namesake]" },
		{ min = 96, max = 100, template = "[Place] of [Namesake]" },
	},
}

return M