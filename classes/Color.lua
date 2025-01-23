---@meta

---@class Color
---@field R integer Red (0-255)
---@field G integer Green (0-255)
---@field B integer Blue (0-255)
---@field A integer Alpha (0-255)
Color = {}
Color.__index = Color
Color.__type = "Color"

---@param r number Red (0-1)
---@param g number Green (0-1)
---@param b number Blue (0-1)
---@param a number Alpha (0-1)
---@return Color
---@nodiscard
function Color.new(r, g, b, a)
	local self = setmetatable({
		R = r;
		G = g;
		B = b;
		A = a;
	}, Color)

	return self
end

---@param r integer the Red value (0-255)
---@param g integer Green (0-255)
---@param b integer Blue (0-255)
---@return Color
---@nodiscard
function Color.fromRGB(r, g, b)
	return Color.new(r / 255, g / 255, b / 255, 255)
end

---@param r integer Red (0-255)
---@param g integer Green (0-255)
---@param b integer Blue (0-255)
---@param a integer Alpha (0-255)
---@return Color
---@nodiscard
function Color.fromRGBA(r, g, b, a)
	return Color.new(r / 255, g / 255, b / 255, a / 255)
end

--- Returns a vec4 (table) as {R, G, B, A}
---@return number[]
---@nodiscard
function Color:toVec4()
	return {self.R, self.G, self.B, self.A}
end

--- Returns a vec3 (table) as {R, G, B}
---@return number[]
---@nodiscard
function Color:toVec3()
	return {self.R, self.G, self.B}
end

--- Uses the color for draw operations within the callback function.
---@param callback fun()
function Color:Use(callback)
	local lR, lG, lB, lA = love.graphics.getColor()
	love.graphics.setColor(self.R, self.G, self.B, self.A)
	callback()
	love.graphics.setColor(lR, lG, lB, lA)
end

function Color:__tostring()
	return string.format("Color(%d, %d, %d, %d)", self.R, self.G, self.B, self.A)
end