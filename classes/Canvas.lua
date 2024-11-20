---@meta

---@class Canvas
---@field Canvas love.Canvas
---@field ClearColor Color
Canvas = {}
Canvas.__index = Canvas
Canvas.__tostring = function()
	return "Canvas"
end

---@param width number Width of the canvas
---@param height number Height of the canvas
---@return Canvas
---@nodiscard
function Canvas.new(width, height)
	local self = setmetatable({
		Canvas = love.graphics.newCanvas(width, height);
		ClearColor = Color.new(0, 0, 0, 0);
	}, Canvas)

	return self
end

--- Sets Love2D's current Canvas to this one, making all draw calls inside the callback be rendered in the Canvas.
---@param callback fun()
function Canvas:Use(callback)
	love.graphics.setCanvas(self.Canvas)
	callback()
	love.graphics.setCanvas()
end

--- Draws the Canvas to the screen.
function Canvas:Draw()
	love.graphics.draw(self.Canvas)
end

--- Clears the Canvas, using the ClearColor.
function Canvas:Clear()
	love.graphics.clear(self.ClearColor.R, self.ClearColor.G, self.ClearColor.B, self.ClearColor.A)
end
