local BASE = (...):gsub("Label$", "")
require(BASE.."Vector2")
require(BASE.."Rect2D")
require(BASE.."Font")

local ASSETS = (...):gsub("Heart%..+", "Heart/assets/"):gsub("%.", "/")

Label = {
	ALIGN = Rect2D.ALIGN;
}
Label.__index = Label
Label.__tostring = function()
	return "Label"
end
setmetatable(Label, Rect2D)

local function updateSize(self)
	local font = love.graphics.getFont()
	self.Size = Vector2.new(font:getWidth(self.Text), font:getBaseline())
end

function Label.new(text)
	local self = Rect2D.new()
	setmetatable(self, Label)

	self.Text = text
	self.Color = Color.fromRGB(255, 255, 255)
	self.FontSize = 10
	self.Font = Font.new(ASSETS.."Arial.ttf", self.FontSize)

	updateSize(self)

	return self
end

function Label:Draw()
	local function draw()
		updateSize(self)

		love.graphics.push()
		love.graphics.translate(
			self.Position.X,
			self.Position.Y
		)
		love.graphics.scale(self.Scale.X, self.Scale.Y)
		love.graphics.rotate(math.rad(self.Rotation))
		love.graphics.printf(
			self.Text,
			-self:GetAbsoluteSize().X * self.AnchorPoint.X,
			-self:GetAbsoluteSize().Y * self.AnchorPoint.Y,
			self.Size.X,
			"center"
		)
		love.graphics.pop()
	end

	self.Color:Use(function()
		self.Font:UseWithSize(self.FontSize, function()
			draw()
		end)
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
