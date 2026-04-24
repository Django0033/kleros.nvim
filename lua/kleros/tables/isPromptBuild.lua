local M = {}

M.isPromptBuild = {
    name = "Ironsworn Prompt Build",
    type = "range",
    dice = "1d100",
    entries = {
        { min = 1, max = 20, result = "Action + Theme" },
        { min = 21, max = 40, result = "Descriptor + Focus" },
        { min = 41, max = 55, result = "Action + Focus" },
        { min = 56, max = 70, result = "Descriptor + Theme" },
        { min = 71, max = 85, result = "Action + Descriptor + Focus" },
        { min = 86, max = 100, result = "Action + Descriptor + Theme" },
    },
}

return M