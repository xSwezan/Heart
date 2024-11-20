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
