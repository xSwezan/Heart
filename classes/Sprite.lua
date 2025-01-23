---@meta

local BASE = (...):gsub("Sprite$", "")
require(BASE.."Vector2")
require(BASE.."Rect2D")
require(BASE.."UDim2")
require(BASE.."Color")

---@class Sprite: Rect2D
---@field Texture love.Texture
---@field Color Color
Sprite = {
	ALIGN = Rect2D.ALIGN;
}
Sprite.__index = Sprite
Sprite.__type = "Sprite"
Sprite.__tostring = function()
	return "Sprite"
end
setmetatable(Sprite, Rect2D)

---@param filename string
---@return Sprite
---@nodiscard
function Sprite.new(filename)
	local self = Rect2D.new() --[[@as Sprite]]
	setmetatable(self, Sprite)

	self.Texture = nil
	self.Color = Color.new(1, 1, 1, 1)

	self:SetTexture(filename)
	self.Size = UDim2.fromOffset(self.Texture:getWidth(), self.Texture:getHeight())

	return self
end

---@param filename string
function Sprite:SetTexture(filename)
	self.Texture = love.graphics.newImage(filename)
end

--- Draws the Sprite to the screen.
function Sprite:Draw()
	local position = self:GetAbsolutePosition()
	local size = self:GetAbsoluteSize()
	local rotation = self:GetAbsoluteRotation()

	self.Color:Use(function()
		love.graphics.draw(
			self.Texture,
			position.X,
			position.Y,
			math.rad(rotation),
			size.X / self.Texture:getWidth(),
			size.Y / self.Texture:getHeight(),
			0,--self.Texture:getWidth() * self.AnchorPoint.X,
			0--self.Texture:getHeight() * self.AnchorPoint.Y
		)
	end)
end
