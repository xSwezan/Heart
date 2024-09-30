local BASE = (...):gsub("Label$", "")
require(BASE.."Vector2")
require(BASE.."Rect2D")

Label = {
	TEXT_ALIGN = {
		TOP_LEFT = Vector2.new(0, 0);
		TOP_RIGHT = Vector2.new(1, 0);
		CENTER = Vector2.new(0.5, 0.5);
		BOTTOM_LEFT = Vector2.new(0, 1);
		BOTTOM_RIGHT = Vector2.new(1, 1);
	};
}
Label.__index = Label
Label.__tostring = function()
	return "Label"
end
setmetatable(Label, Rect2D)

function Label.new(text)
	local self = Rect2D.new()
	setmetatable(self, Label)

	self.Text = text
	self.Color = Color.fromRGB(255, 255, 255)

	return self
end

function Label:Draw()
	self.Color:Use(function()
		local font = love.graphics.getFont()

		love.graphics.print(
			self.Text,
			self.Position.X - font:getWidth(self.Text) * self.AnchorPoint.X,
			self.Position.Y - font:getHeight() * self.AnchorPoint.Y
		)
		-- love.graphics.print(
		-- 	self.Texture,
		-- 	self.Position.X,
		-- 	self.Position.Y,
		-- 	math.rad(self.Rotation),
		-- 	self:GetAbsoluteSize().X / self.Texture:getWidth(),
		-- 	self:GetAbsoluteSize().Y / self.Texture:getHeight(),
		-- 	self.Texture:getWidth() * self.AnchorPoint.X,
		-- 	self.Texture:getHeight() * self.AnchorPoint.Y
		-- )
	end)
end
