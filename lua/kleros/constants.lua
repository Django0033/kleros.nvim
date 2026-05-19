local M = {}

M.TABLE_TYPES = { "simple", "range", "select", "compound", "procedural" }
M.PLACEHOLDER_PLACE = "Place"
M.ERROR_PREFIX = "Error:"
M.DEFAULT_TABLES_DIR = "kleros-tables"

M.DICE_DEFAULTS = {
	DEFAULT_SIDES = 100,
	SYLLABLE3_MODIFIER_RANGE = 10,
	SYLLABLE3_MODIFIER_OFFSET = 10,
	SYLLABLE3_FULL_RANGE = 20,
}

M.ADVANTAGE_TYPES = {
	NORMAL = "normal",
	ADVANTAGE = "advantage",
	DISADVANTAGE = "disadvantage",
}

return M