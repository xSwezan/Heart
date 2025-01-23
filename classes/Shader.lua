---@meta

---@class Shader
---@field Shader love.Shader
Shader = {}
Shader.__index = Shader
Shader.__type = "Shader"
Shader.__tostring = function()
	return "Shader"
end

---@param code string
---@return Shader
---@nodiscard
function Shader.new(code)
	local self = setmetatable({
		Shader = love.graphics.newShader(code);
	}, Shader)

	return self
end

--- Sets the current shader that Love2D uses while inside the callback.
---@param callback fun()
function Shader:Use(callback)
	love.graphics.setShader(self.Shader)
	callback()
	love.graphics.setShader()
end

--- Sends a value as a uniform to the shader.
---@param name string
---@param value any
function Shader:Send(name, value)
	self.Shader:send(name, value)
end
