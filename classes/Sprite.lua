local BASE = (...):gsub("Sprite$", "")
require(BASE.."Vector2")
require(BASE.."Rect2D")
require(BASE.."Color")

Sprite = {
	ALIGN = Rect2D.ALIGN;
}
Sprite.__index = Sprite
Sprite.__tostring = function()
	return "Sprite"
end
setmetatable(Sprite, Rect2D)

function Sprite.new(path)
	local self = Rect2D.new()
	setmetatable(self, Sprite)

	self.Texture = nil
	self.Color = Color.new(1, 1, 1)

	self:SetTexture(path)

	return self
end

function Sprite:SetTexture(path)
	local Texture = love.graphics.newImage(path);
	self.Texture = Texture
	self.Size = Vector2.new(Texture:getWidth(), Texture:getHeight())
end

function Sprite:Draw()
	self.Color:Use(function()
		love.graphics.draw(
			self.Texture,
			self.Position.X,
			self.Position.Y,
			math.rad(self.Rotation),
			self:GetAbsoluteSize().X / self.Texture:getWidth(),
			self:GetAbsoluteSize().Y / self.Texture:getHeight(),
			self.Texture:getWidth() * self.AnchorPoint.X,
			self.Texture:getHeight() * self.AnchorPoint.Y
		)
	end)
end
