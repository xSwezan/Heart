---@meta

---@class Frame: Rect2D
---@field Color Color
---@field CornerRadius number
---@field OutlineColor Color
---@field OutlineThickness number
---@field OutlineJoin "bevel"|"miter"|"none"
Frame = {
	ALIGN = Rect2D.ALIGN;
	---@enum OutlineJoin
	OUTLINE_JOIN = {
		BEVEL = "bevel";
		MITER = "miter";
		NONE = "none";
	};
}
Frame.__index = Frame
Frame.__type = "Frame"
Frame.__tostring = function()
	return "Frame"
end
setmetatable(Frame, Rect2D)

---@return Frame
---@nodiscard
function Frame.new()
	local self = Rect2D.new() --[[@as Frame]]
	setmetatable(self, Frame)

	self.Color = Color.new(1, 1, 1, 1)
	self.CornerRadius = 0

	self.OutlineColor = Color.new(0, 0, 0, 1)
	self.OutlineThickness = 0
	self.OutlineJoin = Frame.OUTLINE_JOIN.MITER

	return self
end

--- Draws the Frame to the screen.
function Frame:Draw()
	local position = self:GetAbsolutePosition()
	local size = self:GetAbsoluteSize()
	local rotation = self:GetAbsoluteRotation()

	self.Color:Use(function()
		love.graphics.push()
		love.graphics.translate(
			position.X,
			position.Y
		)
		love.graphics.rotate(math.rad(rotation))
		love.graphics.rectangle(
			"fill",
			-size.X * self.AnchorPoint.X,
			-size.Y * self.AnchorPoint.Y,
			size.X,
			size.Y,
			self.CornerRadius,
			self.CornerRadius
		)

		if (self.OutlineThickness > 0) then
			self.OutlineColor:Use(function()
				love.graphics.setLineWidth(self.OutlineThickness)
				love.graphics.setLineJoin(self.OutlineJoin)
				love.graphics.rectangle(
					"line",
					-size.X * self.AnchorPoint.X,
					-size.Y * self.AnchorPoint.Y,
					size.X,
					size.Y,
					self.CornerRadius,
					self.CornerRadius
				)
			end)
		end
		love.graphics.pop()
	end)
end
