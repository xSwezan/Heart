--- Linearly interpolates between `a` and `b` using `t` as the interpolant.
---@param a number
---@param b number
---@param t number
---@return number
function math.lerp(a, b, t)
	return a + (b - a) * t
end

--- Calculates the inverse linear interpolation of a value within a range.
--- Given a range [a, b], it returns the normalized position of `value` in the range,
--- such that `a` maps to 0 and `b` maps to 1.
---@param a number The start of the range.
---@param b number The end of the range.
---@param v number the value to normalize within the range.
---@return number The normalized position (0 to 1) of `v` within [a, b].
function math.invlerp(a, b, v)
	return (v - a) / (b - a)
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

local function roll(t, _a, _b, _c)
	return not t and (tonumber(_c) and _c>_b and _a or _c) or (not _c and _a and math.random(_a) or roll(nil, _b, _a, roll(t, _a and _a + _c or 0, next(t, _b))))
end
--- Performs a weighted random selection from a dictionary of weights.
--- @param t table A dictionary of keys and their corresponding weights.
--- @return any A randomly selected key based on the weights.
function math.weightedrandom(t)
    return roll(t)
end