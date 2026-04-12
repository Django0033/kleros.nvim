local M = {}

M.is_settlement_type = {
	name = "Ironsworn Settlement Type",
	type = "select",
	entries = {
		settled_lands = {
			name = "Settled Lands",
			type = "range",
			dice = "1d100",
			entries = {
				{
					min = 1,
					max = 15,
					result = "Stead - Tiny, self-sustaining settlement with a few family dwellings",
				},
				{
					min = 16,
					max = 25,
					result = "Camp - Temporary settlement for nomadic people, soldiers, or seasonal workers",
				},
				{
					min = 26,
					max = 30,
					result = "Outpost - Border or frontier settlement for defense, trade, or exploration",
				},
				{
					min = 31,
					max = 55,
					result = "Hamlet - Small settlement with a few homes, limited services, and informal leadership",
				},
				{
					min = 56,
					max = 85,
					result = "Village - Moderate-size settlement with communal buildings and recognized leadership",
				},
				{
					min = 86,
					max = 100,
					result = "Hold - Large, fortified settlement with diverse trade skills and well-established leadership",
				},
			},
		},
		boundary_lands = {
			name = "Boundary Lands",
			type = "range",
			dice = "1d100",
			entries = {
				{
					min = 1,
					max = 20,
					result = "Stead - Tiny, self-sustaining settlement with a few family dwellings",
				},
				{
					min = 21,
					max = 35,
					result = "Camp - Temporary settlement for nomadic people, soldiers, or seasonal workers",
				},
				{
					min = 36,
					max = 60,
					result = "Outpost - Border or frontier settlement for defense, trade, or exploration",
				},
				{
					min = 61,
					max = 80,
					result = "Hamlet - Small settlement with a few homes, limited services, and informal leadership",
				},
				{
					min = 81,
					max = 95,
					result = "Village - Moderate-size settlement with communal buildings and recognized leadership",
				},
				{
					min = 96,
					max = 100,
					result = "Hold - Large, fortified settlement with diverse trade skills and well-established leadership",
				},
			},
		},
		remote_lands = {
			name = "Remote Lands",
			type = "range",
			dice = "1d100",
			entries = {
				{
					min = 1,
					max = 25,
					result = "Stead - Tiny, self-sustaining settlement with a few family dwellings",
				},
				{
					min = 26,
					max = 50,
					result = "Camp - Temporary settlement for nomadic people, soldiers, or seasonal workers",
				},
				{
					min = 51,
					max = 75,
					result = "Outpost - Border or frontier settlement for defense, trade, or exploration",
				},
				{
					min = 76,
					max = 90,
					result = "Hamlet - Small settlement with a few homes, limited services, and informal leadership",
				},
				{
					min = 91,
					max = 98,
					result = "Village - Moderate-size settlement with communal buildings and recognized leadership",
				},
				{
					min = 99,
					max = 100,
					result = "Hold - Large, fortified settlement with diverse trade skills and well-established leadership",
				},
			},
		},
	},
}

return M
