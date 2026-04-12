local M = {}

M.test_table = require("kleros.tables.test_table")
M.test_range_table = require("kleros.tables.test_range_table")
M.action = require("kleros.tables.action")
M.theme = require("kleros.tables.theme")
M.prompt_build = require("kleros.tables.prompt_build")
M.descriptor = require("kleros.tables.descriptor")
M.focus = require("kleros.tables.focus")
M.overland_landmark = require("kleros.tables.overland_landmark")
M.overland_waypoint = require("kleros.tables.overland_waypoint")
M.overland_peril = require("kleros.tables.overland_peril")
M.overland_opportunity = require("kleros.tables.overland_opportunity")
M.coastal_waters_landmark = require("kleros.tables.coastal_waters_landmark")
M.coastal_waters_waypoint = require("kleros.tables.coastal_waters_waypoint")

return M
