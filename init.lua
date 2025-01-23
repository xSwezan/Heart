--[[

 /$$   /$$                                 /$$
| $$  | $$                                | $$
| $$  | $$  /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$
| $$$$$$$$ /$$__  $$ |____  $$ /$$__  $$|_  $$_/
| $$__  $$| $$$$$$$$  /$$$$$$$| $$  \__/  | $$
| $$  | $$| $$_____/ /$$__  $$| $$        | $$ /$$
| $$  | $$|  $$$$$$$|  $$$$$$$| $$        |  $$$$/
|__/  |__/ \_______/ \_______/|__/         \___/

--]]

local BASE = (...).."."

require(BASE.."classes.SpriteSheet")
require(BASE.."classes.Animation")
require(BASE.."classes.Vector2")
require(BASE.."classes.Canvas")
require(BASE.."classes.Signal")
require(BASE.."classes.Sprite")
require(BASE.."classes.Spring")
require(BASE.."classes.Shader")
require(BASE.."classes.Rect2D")
require(BASE.."classes.Frame")
require(BASE.."classes.Label")
require(BASE.."classes.Sound")
require(BASE.."classes.Color")
require(BASE.."classes.Input")
require(BASE.."classes.UDim2")
require(BASE.."classes.UDim")
require(BASE.."classes.Font")
require(BASE.."classes.Task")

require(BASE.."util.math")
require(BASE.."util.table")

SpriteSheet = SpriteSheet
Animation = Animation
Vector2 = Vector2
Canvas = Canvas
Signal = Signal
Sprite = Sprite
Spring = Spring
Shader = Shader
Rect2D = Rect2D
Frame = Frame
Label = Label
Sound = Sound
Color = Color
Input = Input
UDim2 = UDim2
UDim = UDim
Font = Font
Task = Task

Heart = {}

--- Updates Heart, required to make the library work as expected.
---@param dt number
function Heart.update(dt)
	Task._update(dt)
	Input._update(dt)
	Animation._updateAll(dt)
end

--- Returns the Heart type of its only argument. If there is none; it returns type(value).
---@param value any
---@return string
---@nodiscard
function typeof(value)
	local t = type(value)
	if (t == "table") then
		local classType = rawget(value, "__type") or value.__type
		if (classType ~= nil) then
			return classType
		end
	end

	return t
end
