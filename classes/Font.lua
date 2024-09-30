Font = {}
Font.__index = Font
Font.__tostring = function()
	return "Font"
end
local loadedFonts = {}

function Font.new(pathOrData, size)
	if (loadedFonts[pathOrData]) then
		return loadedFonts[pathOrData]
	end

	local self = setmetatable({
		Fonts = {};
		Rasterizers = {};
		DefaultSize = size;

		_data = pathOrData;
	}, Font)

	self:GetFont(size)
	loadedFonts[pathOrData] = self

	return self
end

-- Returns a Love2D font with the given  size  (if
-- size is nil, the size used when  the  font  was
-- created will be used).
function Font:GetFont(size)
	if (size == nil) then
		return self.Fonts[self.DefaultSize]
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
-- the previous font after
function Font:Use(callback)
	local lastFont = love.graphics.getFont()
	love.graphics.setFont(self:GetFont(self.DefaultSize))
	callback()
	love.graphics.setFont(lastFont)
end

-- Uses  font  (with  custom  size)  while  inside
-- callback and sets back  to  the  previous  font
-- after.
function Font:UseWithSize(size, callback)
	local lastFont = love.graphics.getFont()
	love.graphics.setFont(self:GetFont(size))
	callback()
	love.graphics.setFont(lastFont)
end

-- Sets Love2D's current font
function Font:Set()
	love.graphics.setFont(self:GetFont())
end
