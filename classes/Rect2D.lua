Rect2D = {
	ALIGN = {
		TOP_LEFT = Vector2.new(0, 0);
		TOP_RIGHT = Vector2.new(1, 0);
		CENTER = Vector2.new(0.5, 0.5);
		BOTTOM_LEFT = Vector2.new(0, 1);
		BOTTOM_RIGHT = Vector2.new(1, 1);
	};
}
Rect2D.__index = Rect2D
Rect2D.__tostring = function()
	return "Rect2D"
end

function Rect2D.new()
	local self = setmetatable({
		Scale = Vector2.new(1, 1);
		Size = Vector2.new(0, 0);
		Position = Vector2.new(0, 0);
		Rotation = 0;

		AnchorPoint = Rect2D.ALIGN.CENTER;
	}, Rect2D)

	return self
end

function Rect2D:LookAt(at, offsetDegrees)
	self.Rotation = math.deg(math.atan2(at.Y - self.Position.Y, at.X - self.Position.X)) + 90 + (offsetDegrees or 0)
end

function Rect2D:GetCenter()
	return self.Position - (self.Size * self.Scale * (self.AnchorPoint - 0.5)):Rotate(math.rad(self.Rotation))
end

function Rect2D:GetAbsoluteSize()
	return self.Size * self.Scale
end

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

-- TODO: Make a fast version of this that calculates without Rotation if rotation on both Rect2Ds are 0
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
