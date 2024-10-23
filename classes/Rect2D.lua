---@meta

---@class Rect2D
---@field Scale Vector2
---@field Size Vector2
---@field Position Vector2
---@field Rotation number
---@field AnchorPoint Vector2
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
Rect2D.__tostring = function()
	return "Rect2D"
end

---@return Rect2D
---@nodiscard
function Rect2D.new()
	local self = setmetatable({
		Scale = Vector2.new(1, 1);
		Size = Vector2.new(100, 100);
		Position = Vector2.new(0, 0);
		Rotation = 0;
		AnchorPoint = Rect2D.ALIGN.CENTER;
	}, Rect2D)

	return self
end

-- Rotates the Rect2D to point at a position.
---@param at Vector2
---@param offsetDegrees? number
function Rect2D:LookAt(at, offsetDegrees)
	self.Rotation = math.deg(math.atan2(at.Y - self.Position.Y, at.X - self.Position.X)) + 90 + (offsetDegrees or 0)
end

-- Returns the center position of the Rect2D.
---@return Vector2
---@nodiscard
function Rect2D:GetCenter()
    return self.Position - (self.Size * self.Scale * (self.AnchorPoint - 0.5)):Rotate(math.rad(self.Rotation))
end

-- Returns the size in pixels.
---@return Vector2
---@nodiscard
function Rect2D:GetAbsoluteSize()
	return self.Size * self.Scale
end

-- Returns a table of the four corners as Vector2s.
---@return Vector2[]
---@nodiscard
function Rect2D:GetCorners()
    local halfWidth = (self.Size.X * self.Scale.X) / 2
    local halfHeight = (self.Size.Y * self.Scale.Y) / 2

	local center = self:GetCenter();

    local corners = {
        Vector2.new(-halfWidth, -halfHeight),
        Vector2.new( halfWidth, -halfHeight),
        Vector2.new( halfWidth,  halfHeight),
        Vector2.new(-halfWidth,  halfHeight),
    }

    local rotatedCorners = {}
    for _, corner in ipairs(corners) do
        local rotated = corner:Rotate(math.rad(self.Rotation))

        table.insert(rotatedCorners,
			center + rotated
		)
    end

    return rotatedCorners
end

-- TODO: Make a fast version of this that calculates without rotation if Rotation on both Rect2Ds are 0
-- Checks if this Rect2D overlaps with another Rect2D.
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

-- Checks if a point is inside Rect2D.
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

-- Utility function that draws the bounds of the Rect2D.
function Rect2D:DebugDrawBounds()
	love.graphics.push()
	love.graphics.setColor(1, 0, 1, 0.5)
	love.graphics.translate(
		self.Position.X,
		self.Position.Y
	)

	love.graphics.rotate(math.rad(self.Rotation))
	love.graphics.rectangle(
		"fill",
		-self:GetAbsoluteSize().X * self.AnchorPoint.X,
		-self:GetAbsoluteSize().Y * self.AnchorPoint.Y,
		self:GetAbsoluteSize().X,
		self:GetAbsoluteSize().Y
	)
	love.graphics.setColor(1, 1, 1)
	love.graphics.pop()
end

-- Utility function that draws the AnchorPoint of the Rect2D.
function Rect2D:DebugDrawAnchorPoint()
	love.graphics.push()
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle(
		"fill",
		self.Position.X,
		self.Position.Y,
		3
	)
	love.graphics.setColor(1, 1, 1)
	love.graphics.pop()
end

-- Utility function that draws the corners of the Rect2D.
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

-- Utility function that draws the center of the Rect2D.
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

-- Utility function calls all debug draw methods.
function Rect2D:DebugDrawAll()
	self:DebugDrawBounds()
	self:DebugDrawCorners()
	self:DebugDrawCenter()
	self:DebugDrawAnchorPoint()
end
