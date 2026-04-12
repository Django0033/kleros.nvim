local M = {}

M.is_settlement_name_generator = {
	name = "Ironsworn Settlement Name Generator",
	type = "compound",
	dice = "2d60",
	elements = 2,
	pools = {
		element1 = {
			"Lost", "Gloom", "Night", "Stone", "Bright", "Dusk", "White", "Grim", "Wrath", "Sword",
			"Wyrm", "Shield", "Keld", "Low", "Troll", "New", "Mead", "Drift", "Wolf", "Long",
			"Iron", "Shale", "Woad", "Rock", "Murk", "Moon", "Fire", "Green", "Gold", "Mourn",
			"Forge", "Fallow", "Red", "Wyrd", "Bleak", "Wood", "Gray", "Draug", "High", "Raven",
			"Deep", "Tide", "Ash", "Frost", "Dark", "Storm", "Ember", "Flint", "Thorn", "Axe",
			"Black", "Nettle", "Broad", "Hearth", "Ice", "Bitter", "Great", "Bear", "Skarn", "Shade"
		},
		element2 = {
			"grove", "haven", "bourne", "bridge", "peak", "shard", "glade", "hold", "stead", "crest",
			"rock", "fall", "mark", "fen", "barrow", "ford", "wood", "run", "croft", "knoll",
			"march", "reach", "bluff", "holt", "home", "hope", "wark", "burrow", "glen", "mist",
			"break", "mire", "brook", "wick", "harrow", "hall", "watch", "well", "gate", "mount",
			"ridge", "ward", "mere", "field", "river", "hill", "tarn", "spire", "scar", "roost",
			"shade", "stone", "nest", "pass", "point", "vault", "cairn", "hollow", "moor", "crag"
		},
	},
}

return M