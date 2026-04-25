local M = {}

M.jNameGenerator = {
	name = "Juice Name Generator",
	type = "procedural",
	dice = "1d20",
	sub_tables = {
		"jSyllable1",
		"jSyllable2",
		"jSyllable3",
	},
	entries = {
		{ min = 1, max = 1, template = "[jSyllable1][jSyllable2]o" },
		{ min = 2, max = 3, template = "[jSyllable1][jSyllable2]" },
		{ min = 4, max = 4, template = "[jSyllable2][jSyllable3-]o" },
		{ min = 5, max = 6, template = "[jSyllable2][jSyllable3-]" },
		{ min = 7, max = 7, template = "[jSyllable1][jSyllable2][jSyllable3-]o" },
		{ min = 8, max = 9, template = "[jSyllable1][jSyllable2][jSyllable3-]" },
		{ min = 10, max = 11, template = "[jSyllable1][jSyllable1][jSyllable1]" },
		{ min = 12, max = 12, template = "[jSyllable1][jSyllable2][jSyllable3]" },
		{ min = 13, max = 13, template = "[jSyllable1][jSyllable2]a" },
		{ min = 14, max = 14, template = "[jSyllable1][jSyllable2]i" },
		{ min = 15, max = 15, template = "[jSyllable2][jSyllable3-]a" },
		{ min = 16, max = 16, template = "[jSyllable2][jSyllable3-]i" },
		{ min = 17, max = 17, template = "[jSyllable2][jSyllable3+]" },
		{ min = 18, max = 18, template = "[jSyllable1][jSyllable2][jSyllable3-]a" },
		{ min = 19, max = 19, template = "[jSyllable1][jSyllable2][jSyllable3-]i" },
		{ min = 20, max = 20, template = "[jSyllable1][jSyllable2][jSyllable3+]" },
	},
}

return M