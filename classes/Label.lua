---@meta

local BASE = (...):gsub("Label$", "")
require(BASE.."Vector2")
require(BASE.."Rect2D")
require(BASE.."Font")

local ASSETS = (...):gsub("Heart%..+", "Heart/assets/"):gsub("%.", "/")

---@class Label: Rect2D
---@field Text string
---@field Color Color
---@field FontSize number
---@field Font Font
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


---@param text? string The text to create the label with.
---@return Label
---@nodiscard
function Label.new(text)
	local self = Rect2D.new() --[[@as Label]]
	setmetatable(self, Label)

	self.Text = text or "Label"
	self.Color = Color.fromRGB(255, 255, 255)
	self.FontSize = 10
	self.Font = Font.new(ASSETS.."Arial.ttf", self.FontSize)

	updateSize(self)

	return self
end

--- Draws the Label to the screen.
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
