---@meta

---@class Padding
---@field Top UDim
---@field Bottom UDim
---@field Left UDim
---@field Right UDim
Padding = {}
Padding.__index = Padding
Padding.__type = "Padding"
Padding.__tostring = function()
	return "Padding"
end

---@param udim UDim?
---@return UDim
---@nodiscard
local function copy(udim)
	if (udim == nil) then
		return UDim.new()
	end

	return UDim.new(udim.Scale, udim.Offset)
end

-->-------------------<--
--> UDim Constructors <--
-->-------------------<--

--- Creates a new Padding.
---@param top UDim?
---@param bottom UDim?
---@param left UDim?
---@param right UDim?
---@return Padding
---@nodiscard
function Padding.new(top, bottom, left, right) ---! Maybe change this to take scale, offset for all directions instead
	local self = setmetatable({
		Top = copy(top);
		Bottom = copy(bottom);
		Left = copy(left);
		Right = copy(right);
	}, Padding)

	return self
end

--- Creates a new Padding using UDims. Same as `Padding.new`.
---@param top UDim?
---@param bottom UDim?
---@param left UDim?
---@param right UDim?
---@return Padding
---@nodiscard
function Padding.fromUDim(top, bottom, left, right)
	return Padding.new(top, bottom, left, right)
end

--- Creates a new Padding with same padding in all directions.
---@param vertical UDim?
---@param horizontal UDim?
---@return Padding
---@nodiscard
function Padding.fromUDimAxes(vertical, horizontal)
	return Padding.fromUDim(
		copy(vertical),
		copy(vertical),
		copy(horizontal),
		copy(horizontal)
	)
end

--- Creates a new Padding with same padding in all directions.
---@param padding UDim?
---@return Padding
---@nodiscard
function Padding.fromUDimAll(padding)
	return Padding.fromUDim(
		copy(padding),
		copy(padding),
		copy(padding),
		copy(padding)
	)
end

-->--------------------<--
--> Scale Constructors <--
-->--------------------<--

--- Creates a new Padding with scale.
---@param top number?
---@param bottom number?
---@param left number?
---@param right number?
---@return Padding
---@nodiscard
function Padding.fromScale(top, bottom, left, right)
	return Padding.fromUDim(
		UDim.new(top or 0, 0),
		UDim.new(bottom or 0, 0),
		UDim.new(left or 0, 0),
		UDim.new(right or 0, 0)
	)
end

--- Creates a new Padding with scale in vertical and horizontal directions.
---@param vertical number?
---@param horizontal number?
---@return Padding
---@nodiscard
function Padding.fromScaleAxes(vertical, horizontal)
	vertical = vertical or 0
	horizontal = horizontal or 0

	return Padding.fromUDim(
		UDim.new(vertical, 0),
		UDim.new(vertical, 0),
		UDim.new(horizontal, 0),
		UDim.new(horizontal, 0)
	)
end

--- Creates a new Padding with same scale in all directions.
---@param scale number?
---@return Padding
---@nodiscard
function Padding.fromScaleAll(scale)
	return Padding.fromUDimAll(UDim.new(scale or 0, 0))
end

-->---------------------<--
--> Offset Constructors <--
-->---------------------<--

--- Creates a new Padding with offset.
---@param top number?
---@param bottom number?
---@param left number?
---@param right number?
---@return Padding
---@nodiscard
function Padding.fromOffset(top, bottom, left, right)
	return Padding.fromUDim(
		UDim.new(0, top or 0),
		UDim.new(0, bottom or 0),
		UDim.new(0, left or 0),
		UDim.new(0, right or 0)
	)
end

--- Creates a new Padding with offset in vertical and horizontal directions.
---@param vertical number?
---@param horizontal number?
---@return Padding
---@nodiscard
function Padding.fromOffsetAxes(vertical, horizontal)
	return Padding.fromUDim(
		UDim.new(0, vertical or 0),
		UDim.new(0, vertical or 0),
		UDim.new(0, horizontal or 0),
		UDim.new(0, horizontal or 0)
	)
end

--- Creates a new Padding with same offset in all directions.
---@param offset number?
---@return Padding
---@nodiscard
function Padding.fromOffsetAll(offset)
	return Padding.fromUDimAll(UDim.new(0, offset or 0))
end
