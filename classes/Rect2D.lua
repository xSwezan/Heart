---@meta

---@class Rect2D
---@field Size UDim2
---@field Scale Vector2
---@field Position UDim2
---@field Rotation number
---@field AnchorPoint Vector2
---@field Parent Rect2D?
Rect2D = {
	ALIGN = {
		TOP_LEFT = Vector2.new(0, 0);
		TOP_CENTER = Vector2.new(0.5, 0);
		TOP_RIGHT = Vector2.new(1, 0);

		MIDDLE_LEFT = Vector2.new(0, 0.5);
		CENTER = Vector2.new(0.5, 0.5);
		MIDDLE_RIGHT = Vector2.new(1, 0.5);

		BOTTOM_LEFT = Vector2.new(0, 1);
		BOTTOM_CENTER = Vector2.new(0.5, 1);
		BOTTOM_RIGHT = Vector2.new(1, 1);
	};
}
Rect2D.__index = Rect2D
Rect2D.__type = "Rect2D"
Rect2D.__tostring = function()
	return "Rect2D"
end

---@return Rect2D
---@nodiscard
function Rect2D.new()
	local self = setmetatable({
		Scale = Vector2.new(1, 1);
		Size = UDim2.fromOffset(100, 100);
		Position = UDim2.new();
		Rotation = 0;
		AnchorPoint = Rect2D.ALIGN.CENTER;
		Parent = nil;
	}, Rect2D)

	return self
end

--- Rotates the Rect2D to point at a position.
---@param at Vector2
---@param offsetDegrees? number
function Rect2D:LookAt(at, offsetDegrees)
	self.Rotation = math.deg(math.atan2(at.Y - self.Position.Y, at.X - self.Position.X)) + 90 + (offsetDegrees or 0)
end

--- Returns the center position of the Rect2D.
---@return Vector2
---@nodiscard
function Rect2D:GetCenter()
    return self:GetAbsolutePosition() + (self:GetAbsoluteSize() * 0.5):Rotate(math.rad(self:GetAbsoluteRotation()))
end

--- Returns the size in pixels.
---@return Vector2
---@nodiscard
function Rect2D:GetAbsoluteSize()
	local parentSize --[[@as Vector2]]
	if (self.Parent) then
		parentSize = self.Parent:GetAbsoluteSize()
	else
		local screenWidth, screenHeight = love.window.getMode()
		parentSize = Vector2.new(screenWidth, screenHeight)
	end

	local scale = self.Scale

	return Vector2.new(
		(parentSize.X * self.Size.X.Scale + self.Size.X.Offset) * scale.X,
		(parentSize.Y * self.Size.Y.Scale + self.Size.Y.Offset) * scale.Y
	)
end

---@return Vector2
---@nodiscard
function Rect2D:GetAbsolutePosition()
	local parentPosition --[[@as Vector2]]
	local parentSize --[[@as Vector2]]
	local parentRotation = 0

	if (self.Parent) then
		parentPosition = self.Parent:GetAbsolutePosition()
		parentSize = self.Parent:GetAbsoluteSize()
		parentRotation = self.Parent:GetAbsoluteRotation()
	else
		parentPosition = Vector2.new(0, 0)

		local screenWidth, screenHeight = love.window.getMode()
		parentSize = Vector2.new(screenWidth, screenHeight)
	end

	local size = self:GetAbsoluteSize()
	local position = self.Position
	local rotation = self:GetAbsoluteRotation()

	local localPosition = Vector2.new(
		(parentSize.X * position.X.Scale + position.X.Offset),
		(parentSize.Y * position.Y.Scale + position.Y.Offset)
	):Rotate(math.rad(parentRotation))

	return parentPosition + localPosition - (size * self.AnchorPoint):Rotate(math.rad(rotation))
end

--- Returns the absolute rotation in degrees.
---@return number
---@nodiscard
function Rect2D:GetAbsoluteRotation()
	local parentRotation = 0
	if (self.Parent) then
		parentRotation = self.Parent:GetAbsoluteRotation()
	end

	return self.Rotation + parentRotation
end

--- Returns a table of the four corners as Vector2s.
---@return Vector2[]
---@nodiscard
function Rect2D:GetCorners()
	local size = self:GetAbsoluteSize()
    local halfWidth = size.X / 2
    local halfHeight = size.Y / 2

	local center = self:GetCenter()

    local corners = {
        Vector2.new(-halfWidth, -halfHeight),
        Vector2.new( halfWidth, -halfHeight),
        Vector2.new( halfWidth,  halfHeight),
        Vector2.new(-halfWidth,  halfHeight),
    }

    local rotatedCorners = {}
    for _, corner in ipairs(corners) do
        local rotated = corner:Rotate(math.rad(self:GetAbsoluteRotation()))

        table.insert(rotatedCorners,
			center + rotated
		)
    end

    return rotatedCorners
end

-- TODO: Make a fast version of this that calculates without rotation if Rotation on both Rect2Ds are 0
--- Checks if this Rect2D overlaps with another Rect2D.
---@param other Rect2D
---@return boolean
---@nodiscard
function Rect2D:Overlaps(other)
	-- if (self.Rotation == 0) and (other.Rotation == 0) then
	-- 	return Rect2D:OverlapsFast()
	-- end

    local cornersA = self:GetCorners()
    local cornersB = other:GetCorners()

    for _, corner in ipairs(cornersA) do
        if (other:PointOverlaps(corner)) then
            return true
        end
    end

    for _, corner in ipairs(cornersB) do
        if (self:PointOverlaps(corner)) then
            return true
        end
    end

    return false
end

--- Checks if a point is inside Rect2D.
---@param point Vector2
---@return boolean
---@nodiscard
function Rect2D:PointOverlaps(point)
    local corners = self:GetCorners()

    local function sign(p1, p2, p3)
        return (p1.X - p3.X) * (p2.Y - p3.Y) - (p2.X - p3.X) * (p1.Y - p3.Y)
    end

    local b1 = sign(point, corners[1], corners[2]) < 0.0
    local b2 = sign(point, corners[2], corners[3]) < 0.0
    local b3 = sign(point, corners[3], corners[4]) < 0.0
    local b4 = sign(point, corners[4], corners[1]) < 0.0

    return (b1 == b2) and (b2 == b3) and (b3 == b4)
end

-->---------------<--
--> Debug Methods <--
-->---------------<--

--- Utility function that draws the bounds of the Rect2D.
function Rect2D:DebugDrawBounds()
	local position = self:GetAbsolutePosition()
	local size = self:GetAbsoluteSize()
	local rotation = self:GetAbsoluteRotation()

	love.graphics.push()
	love.graphics.setColor(1, 0, 1, 0.5)
	love.graphics.translate(
		position.X,
		position.Y
	)

	love.graphics.rotate(math.rad(rotation))
	love.graphics.rectangle(
		"fill",
		0,---size.X * self.AnchorPoint.X,
		0,---size.Y * self.AnchorPoint.Y,
		size.X,
		size.Y
	)
	love.graphics.setColor(1, 1, 1)
	love.graphics.pop()
end

--- Utility function that draws the AnchorPoint of the Rect2D.
function Rect2D:DebugDrawAnchorPoint()
	local position = self:GetAbsolutePosition()
	local size = self:GetAbsoluteSize()
	local rotation = self:GetAbsoluteRotation()

	local finalPosition = position + (size * self.AnchorPoint):Rotate(math.rad(rotation))

	love.graphics.push()
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle(
		"fill",
		finalPosition.X,
		finalPosition.Y,
		3
	)
	love.graphics.setColor(1, 1, 1)
	love.graphics.pop()
end

--- Utility function that draws the corners of the Rect2D.
function Rect2D:DebugDrawCorners()
	love.graphics.push()
	love.graphics.setColor(1, 0, 1, 1)
	for _, corner in pairs(self:GetCorners()) do
		love.graphics.circle(
			"fill",
			corner.X,
			corner.Y,
			3
		)
	end
	love.graphics.setColor(1, 1, 1)
	love.graphics.pop()
end

--- Utility function that draws the center of the Rect2D.
function Rect2D:DebugDrawCenter()
	love.graphics.push()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle(
		"fill",
		self:GetCenter().X,
		self:GetCenter().Y,
		3
	)
	love.graphics.setColor(1, 1, 1)
	love.graphics.pop()
end

--- Utility function calls all debug draw methods.
function Rect2D:DebugDrawAll()
	self:DebugDrawBounds()
	self:DebugDrawCorners()
	self:DebugDrawCenter()
	self:DebugDrawAnchorPoint()
end
