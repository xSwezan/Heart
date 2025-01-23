---@meta

---@class UDim
---@field Scale number
---@field Offset number
---@operator add(UDim): UDim
---@operator sub(UDim): UDim
---@operator unm(UDim): UDim
UDim = {}
UDim.__index = UDim
UDim.__type = "UDim"

--- Creates a new UDim with the x and y components.
---@param scale number?
---@param offset number?
---@return UDim
---@nodiscard
function UDim.new(scale, offset)
	local self = setmetatable({
		Scale = scale or 0;
		Offset = offset or 0;
	}, UDim)

	return self
end

--- Creates a new UDim with scale.
---@param scale number?
---@return UDim
---@nodiscard
function UDim.fromScale(scale)
	return UDim.new(scale or 0, 0)
end

--- Creates a new UDim with offset.
---@param offset number?
---@return UDim
---@nodiscard
function UDim.fromOffset(offset)
	return UDim.new(0, offset or 0)
end

function UDim.__add(rhs, lhs)
	return UDim.new(rhs.Scale + lhs.Scale, rhs.Offset + lhs.Offset)
end

function UDim.__sub(rhs, lhs)
	return UDim.new(rhs.Scale - lhs.Scale, rhs.Offset - lhs.Offset)
end

function UDim:__unm()
	return UDim.new(-self.Scale, -self.Offset)
end

function UDim:__tostring()
	return string.format("UDim(%d, %d)", self.Scale, self.Offset)
end
