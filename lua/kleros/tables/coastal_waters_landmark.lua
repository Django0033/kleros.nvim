local M = {}

M.coastal_waters_landmark = {
    name = "Coastal Waters Landmark",
    type = "range",
    dice = "1d100",
    entries = {
        { min = 1, max = 4, result = "Anchorage" },
        { min = 5, max = 8, result = "Sargassum" },
        { min = 9, max = 13, result = "Wreck" },
        { min = 14, max = 17, result = "Harbor" },
        { min = 18, max = 21, result = "Beacon" },
        { min = 22, max = 25, result = "Shoal" },
        { min = 26, max = 30, result = "Fjord" },
        { min = 31, max = 34, result = "Estuary" },
        { min = 35, max = 38, result = "Sea arch" },
        { min = 39, max = 42, result = "Cove" },
        { min = 43, max = 46, result = "Bay" },
        { min = 47, max = 50, result = "Iceberg" },
        { min = 51, max = 55, result = "Island" },
        { min = 56, max = 59, result = "Settlement" },
        { min = 60, max = 63, result = "Ice shelf" },
        { min = 64, max = 68, result = "Sea cave" },
        { min = 69, max = 72, result = "Ruins" },
        { min = 73, max = 76, result = "Landing" },
        { min = 77, max = 80, result = "Kelp forest" },
        { min = 81, max = 84, result = "Sea stack" },
        { min = 85, max = 88, result = "Islet" },
        { min = 89, max = 92, result = "Beach" },
        { min = 93, max = 96, result = "Sea cliff" },
        { min = 97, max = 100, result = "Anomaly" },
    }
}

return M