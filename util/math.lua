--- Linearly interpolates between `a` and `b` using `t` as the interpolant.
---@param a number
---@param b number
---@param t number
---@return number
function math.lerp(a, b, t)
	return a + (b - a) * t
end

--- Returns a number between `min` and `max`, inclusive.
---@param x number
---@param min number
---@param max number
---@return number
function math.clamp(x, min, max)
	return math.min(math.max(x, min), max)
end

--- Maps a number from one range to another.
---@param x number
---@param inmin number
---@param inmax number
---@param outmin number
---@param outmax number
---@return number
function math.map(x, inmin, inmax, outmin, outmax)
	return outmin + (x - inmin) * (outmax - outmin) / (inmax - inmin)
end
