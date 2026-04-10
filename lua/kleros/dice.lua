local M = {}

function M.setup()
	math.randomseed(os.time())
end

local function roll_die(sides)
	return math.random(1, sides)
end

local function parse(expr)
	local count, sides = expr:match("(%d*)d(%d+)")
	count = tonumber(count) or 1
	sides = tonumber(sides)

	return count, sides
end

function M.roll_dice(expr)
	local count, sides = parse(expr)
	local results = {}
	local total = 0

	for _ = 1, count do
		local roll = roll_die(sides)
		table.insert(results, roll)
		total = total + roll
	end

	return results, total
end

return M
