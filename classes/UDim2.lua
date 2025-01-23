---@meta

---@class UDim2
---@field X UDim
---@field Y UDim
---@operator add(UDim2): UDim2
---@operator sub(UDim2): UDim2
---@operator unm(UDim2): UDim2
UDim2 = {}
UDim2.__index = UDim2
UDim2.__type = "UDim2"

--- Creates a new UDim2.
---@param xScale number?
---@param xOffset number?
---@param yScale number?
---@param yOffset number?
---@return UDim2
---@nodiscard
function UDim2.new(xScale, xOffset, yScale, yOffset)
	local self = setmetatable({
		X = UDim.new(xScale or 0, xOffset or 0);
		Y = UDim.new(yScale or 0, yOffset or 0);
	}, UDim2)

	return self
end

--- Creates a new UDim2 with scale.
---@param xScale number?
---@param yScale number?
---@return UDim2
---@nodiscard
function UDim2.fromScale(xScale, yScale)
	return UDim2.new(xScale or 0, 0, yScale or 0, 0)
end

--- Creates a new UDim2 with offset.
---@param xOffset number?
---@param yOffset number?
---@return UDim2
---@nodiscard
function UDim2.fromOffset(xOffset, yOffset)
	return UDim2.new(0, xOffset or 0, 0, yOffset or 0)
end

--- Creates a new UDim2 using x and y UDims.
---@param x UDim
---@param y UDim
---@return UDim2
---@nodiscard
function UDim2.fromUDim(x, y)
	return UDim2.new(x.Scale, x.Offset, y.Scale, y.Offset)
end

--- Returns a UDim2 interepolated linearly between this UDim2 and the given *goal* using the *alpha*.
---@param goal UDim2
---@param alpha number
---@return UDim2
---@nodiscard
function UDim2:Lerp(goal, alpha)
	return UDim2.new(
		math.lerp(self.X.Scale, goal.X.Scale, alpha),
		math.lerp(self.X.Offset, goal.X.Offset, alpha),
		math.lerp(self.Y.Scale, goal.Y.Scale, alpha),
		math.lerp(self.Y.Offset, goal.Y.Offset, alpha)
	)
end

function UDim2.__add(rhs, lhs)
	return UDim2.new(
		rhs.X.Scale + lhs.X.Scale,
		rhs.X.Offset + lhs.X.Offset,
		rhs.Y.Scale + lhs.Y.Scale,
		rhs.Y.Offset + lhs.Y.Offset
	)
end

function UDim2.__sub(rhs, lhs)
	return UDim2.new(
		rhs.X.Scale - lhs.X.Scale,
		rhs.X.Offset - lhs.X.Offset,
		rhs.Y.Scale - lhs.Y.Scale,
		rhs.Y.Offset - lhs.Y.Offset
	)
end

function UDim2:__unm()
	return UDim2.new(
		-self.X.Scale,
		-self.X.Offset,
		-self.Y.Scale,
		-self.Y.Offset
	)
end

function UDim2:__tostring()
	return string.format("UDim2(%d, %d, %d, %d)", self.X.Scale, self.X.Offset, self.Y.Scale, self.Y.Offset)
end
