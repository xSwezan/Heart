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
		love.graphics.origin()
		love.graphics.translate(
			self.Position.X,
			self.Position.Y
		)
		love.graphics.scale(self.Scale.X, self.Scale.Y)
		love.graphics.rotate(math.rad(self.Rotation))
		love.graphics.print(
			self.Text,
			-self.Size.X * self.AnchorPoint.X,
			-self.Size.Y * self.AnchorPoint.Y
		)
		love.graphics.pop()
	end

	self.Color:Use(function()
		self.Font:UseWithSize(self.FontSize, function()
			draw()
		end)
	end)
end
