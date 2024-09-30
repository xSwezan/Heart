Frame = {
	OUTLINE_JOIN = {
		NONE = "none";
		MITER = "miter";
		BEVEL = "bevel";
	};
}
Frame.__index = Frame
Frame.__tostring = function()
	return "Frame"
end
setmetatable(Frame, Rect2D)

function Frame.new()
	local self = Rect2D.new()
	setmetatable(self, Frame)

	self.Color = Color.new(1, 1, 1)
	self.CornerRadius = 0

	self.OutlineColor = Color.new(0, 0, 0)
	self.OutlineThickness = 0
	self.OutlineJoin = Frame.OUTLINE_JOIN.MITER

	return self
end

function Frame:Draw()
	self.Color:Use(function()
		love.graphics.rotate(math.rad(self.Rotation))
		love.graphics.rectangle(
			"fill",
			self.Position.X - self:GetAbsoluteSize().X * self.AnchorPoint.X,
			self.Position.Y - self:GetAbsoluteSize().Y * self.AnchorPoint.Y,
			self:GetAbsoluteSize().X,
			self:GetAbsoluteSize().Y,
			self.CornerRadius,
			self.CornerRadius
		)

		if (self.OutlineThickness > 0) then
			self.OutlineColor:Use(function()
				love.graphics.setLineWidth(self.OutlineThickness)
				love.graphics.setLineJoin(self.OutlineJoin)
				love.graphics.rectangle(
					"line",
					self.Position.X - self:GetAbsoluteSize().X * self.AnchorPoint.X,
					self.Position.Y - self:GetAbsoluteSize().Y * self.AnchorPoint.Y,
					self:GetAbsoluteSize().X,
					self:GetAbsoluteSize().Y,
					self.CornerRadius,
					self.CornerRadius
				)
			end)
		end
	end)
end
