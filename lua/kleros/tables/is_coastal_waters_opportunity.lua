local M = {}

M.is_coastal_waters_opportunity = {
    name = "Ironsworn Coastal Waters Opportunity",
    type = "range",
    dice = "1d100",
    entries = {
        { min = 1, max = 5, result = "A fortuitous wind or current speeds your way" },
        { min = 6, max = 10, result = "Ideal weather takes hold" },
        { min = 11, max = 15, result = "There are plentiful fishing opportunities in these waters" },
        { min = 16, max = 19, result = "A desolate shoreline settlement or camp offers scavenging opportunities" },
        { min = 20, max = 23, result = "A nearby settlement flies a friendly banner" },
        { min = 24, max = 27, result = "A nearby shore offers plentiful opportunities for hunting or foraging" },
        { min = 28, max = 31, result = "A sheltered bay offers safe harbor" },
        { min = 32, max = 35, result = "An intriguing shoreline location offers opportunities for exploration" },
        { min = 36, max = 39, result = "You find an ideal location for a safe landing" },
        { min = 40, max = 43, result = "You find clear passage through otherwise perilous seas" },
        { min = 44, max = 47, result = "You spot a shipwreck ripe for the picking" },
        { min = 48, max = 51, result = "Something about this journey sparks a fond or helpful memory" },
        { min = 52, max = 54, result = "A clue offers insight into a current quest or mystery" },
        { min = 55, max = 57, result = "A friendly sea creature or bird keeps pace with you—a good omen" },
        { min = 58, max = 60, result = "A large ship offers the potential comforts and safety of a community" },
        { min = 61, max = 63, result = "An awe-inspiring vista offers comfort or inspiration" },
        { min = 64, max = 66, result = "You are forewarned of a lurking danger" },
        { min = 67, max = 69, result = "You encounter a helpful or useful animal" },
        { min = 70, max = 72, result = "You experience a moment of fellowship or inner peace" },
        { min = 73, max = 75, result = "You spot a friendly ship or boat" },
        { min = 76, max = 78, result = "A key landmark comes into view" },
        { min = 79, max = 81, result = "A helpful mariner crosses your path" },
        { min = 82, max = 84, result = "A monument or relic reveals something of the history of this area" },
        { min = 85, max = 87, result = "The winds or terrain offer the means to avoid a threat" },
        { min = 88, max = 90, result = "You learn or improve a helpful skill" },
        { min = 91, max = 92, result = "A supernatural entity offers helpful guidance" },
        { min = 93, max = 94, result = "An otherwise dangerous sea creature shows benign interest in you" },
        { min = 95, max = 96, result = "You encounter a majestic or previously unknown creature" },
        { min = 97, max = 98, result = "You experience a helpful dream or vision" },
        { min = 99, max = 100, result = "You spot an object or resource of great value" },
    }
}

return M