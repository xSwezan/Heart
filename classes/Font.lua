---@meta

---@class Font
---@field Fonts love.Font[]
---@field private _defaultSize number
---@field private _data string
Font = {}
Font.__index = Font
Font.__tostring = function()
	return "Font"
end
local loadedFonts = {}

---@param filename string
---@return Font
---@nodiscard
function Font.new(filename, size)
	if (loadedFonts[filename]) then
		return loadedFonts[filename]
	end

	local self = setmetatable({
		Fonts = {};

		_defaultSize = size;
		_data = filename;
	}, Font)

	local _ = self:GetFont(size)
	loadedFonts[filename] = self

	return self
end

-- Returns a Love2D font with the given  size. If
-- size is nil, the size used when  the  font  was
-- created will be used.
---@param size? number
---@return love.Font
---@nodiscard
function Font:GetFont(size)
	if (size == nil) then
		return self.Fonts[self._defaultSize]
	end

	if (self.Fonts[size]) then
		return self.Fonts[size]
	end

	local newFont = love.graphics.newFont(self._data, size)
	self.Fonts[size] = newFont

	return newFont
end

-- Uses font (with the size the Font  was  created
-- with) while inside callback and  sets  back  to
-- the previous font after.
---@param callback fun()
function Font:Use(callback)
	local lastFont = love.graphics.getFont()
	love.graphics.setFont(self:GetFont(self._defaultSize))
	callback()
	love.graphics.setFont(lastFont)
end

-- Uses  font  (with  custom  size)  while  inside
-- callback and sets back  to  the  previous  font
-- after.
---@param size number
---@param callback fun()
function Font:UseWithSize(size, callback)
	local lastFont = love.graphics.getFont()
	love.graphics.setFont(self:GetFont(size))
	callback()
	love.graphics.setFont(lastFont)
end

-- Sets Love2D's current font.
function Font:Set()
	love.graphics.setFont(self:GetFont())
end
