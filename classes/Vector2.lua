---@meta

---@class Vector2
---@field X number
---@field Y number
---@operator add(Vector2 | number): Vector2
---@operator sub(Vector2 | number): Vector2
---@operator mul(Vector2 | number): Vector2
---@operator div(Vector2 | number): Vector2
---@operator unm(Vector2 | number): Vector2
Vector2 = {}
Vector2.__index = Vector2
Vector2.__type = "Vector2"

local function makeVector2(value)
	if (type(value) == "number") then
		return Vector2.new(value, value)
	end

	return value
end

--- Creates a new Vector2 with the x and y components.
---@param x number?
---@param y number?
---@return Vector2
---@nodiscard
function Vector2.new(x, y)
	local self = setmetatable({
		X = x or 0;
		Y = y or 0;
	}, Vector2)

	return self
end

--- Creates a new Vector2 with x and y set to the value.
---@param value number
---@return Vector2
---@nodiscard
function Vector2.both(value)
	return Vector2.new(value, value)
end

---@param angle number
---@return Vector2
---@nodiscard
function Vector2:Rotate(angle)
	if (angle == 0) then
		return Vector2.new(self.X, self.Y)
	end

    local cos = math.cos(angle)
    local sin = math.sin(angle)
    return Vector2.new(self.X * cos - self.Y * sin, self.X * sin + self.Y * cos)
end

--- Returns the dot product between this Vector2 and *other*.
---@param other Vector2
---@return number
---@nodiscard
function Vector2:Dot(other)
    return self.X * other.X + self.Y * other.Y
end

--- Returns a new Vector2 reflected against the passed *normal*.
---@param normal Vector2
---@return Vector2
---@nodiscard
function Vector2:Reflect(normal)
    return self - normal * 2 * self:Dot(normal)
end

--- Returns a new Vector2 clamped between min and max.
---@param min Vector2
---@param max Vector2
---@return Vector2
---@nodiscard
function Vector2:Clamp(min, max)
	return Vector2.new(
		math.min(math.max(self.X, min.X), max.X),
		math.min(math.max(self.Y, min.Y), max.Y)
	)
end

--- Returns a new Vector2 that is moved *distance* toward a *position*.
---@param position Vector2
---@param distance number
---@return Vector2
---@nodiscard
function Vector2:MoveTowards(position, distance)
	return self + (position - self):Unit() * distance
end

--- Returns the magnitude (distance) of the vector.
---@return number
---@nodiscard
function Vector2:Magnitude()
	return math.sqrt(self.X * self.X + self.Y * self.Y)
end

--- Returns a new vector with the length of 1 (the unit vector).
---@return Vector2
---@nodiscard
function Vector2:Unit()
	return self / self:Magnitude()
end

--- Returns a new copy of the Vector2.
---@return Vector2
---@nodiscard
function Vector2:Copy()
	return Vector2.new(self.X, self.Y)
end

function Vector2.__add(rhs, lhs)
	rhs = makeVector2(rhs)
	lhs = makeVector2(lhs)
	return Vector2.new(rhs.X + lhs.X, rhs.Y + lhs.Y)
end

function Vector2.__sub(rhs, lhs)
	rhs = makeVector2(rhs)
	lhs = makeVector2(lhs)
	return Vector2.new(rhs.X - lhs.X, rhs.Y - lhs.Y)
end

function Vector2.__mul(rhs, lhs)
	rhs = makeVector2(rhs)
	lhs = makeVector2(lhs)
	return Vector2.new(rhs.X * lhs.X, rhs.Y * lhs.Y)
end

function Vector2.__div(rhs, lhs)
	rhs = makeVector2(rhs)
	lhs = makeVector2(lhs)
	return Vector2.new(rhs.X / lhs.X, rhs.Y / lhs.Y)
end

function Vector2:__unm()
	return Vector2.new(-self.X, -self.Y)
end

function Vector2:__tostring()
	return string.format("Vector2(%d, %d)", self.X, self.Y)
end
