local M = {}

function M.setup()
    math.randomseed(os.time())
end

function M.roll_die(sides)
    return math.random(1, sides)
end

return M
