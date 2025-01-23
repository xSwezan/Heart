--[[

This animation system is heavily inspired by Anim8 (https://github.com/kikito/anim8)
by Enrique García Cota, which is distributed under the MIT license:

	Copyright (c) 2011 Enrique García Cota

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Note: This code has been modified and extended from the original Anim8 by Enrique García Cota.

--]]

---@diagnostic disable: undefined-field
---@meta

local _frames = {}

--- Takes in a "1-6" or 1 and converts to from, to, step
local function toRange(x)
    if (type(x) == "number") then
		return x, x, 1
	end

	x = x:gsub("%s", "")

	local from, to = x:match("^(%d+)-(%d+)$")
	assert(from and to, ("Could not parse interval from %q"):format(x))

	from, to = tonumber(from), tonumber(to)

	return from, to, from <= to and 1 or -1
end

local function createFrame(spriteSheet, x, y)
	return love.graphics.newQuad(
		spriteSheet._origin.X + (x - 1) * spriteSheet._frameSize.X + x * spriteSheet._padding,
		spriteSheet._origin.Y + (y - 1) * spriteSheet._frameSize.Y + y * spriteSheet._padding,
		spriteSheet._frameSize.X,
		spriteSheet._frameSize.Y,
		spriteSheet._imageSize.X,
		spriteSheet._imageSize.Y
	)
end

local function getOrCreateFrame(spriteSheet, x, y)
	local key = spriteSheet._key
	_frames[key] = _frames[key] or {}
	_frames[key][x] = _frames[key][x] or {}
	_frames[key][x][y] = _frames[key][x][y] or createFrame(spriteSheet, x, y)
	return _frames[key][x][y]
end

---@class SpriteSheet
SpriteSheet = {}
SpriteSheet.__index = SpriteSheet
SpriteSheet.__type = "SpriteSheet"
SpriteSheet.__tostring = function()
    return "SpriteSheet"
end
-- SpriteSheet.__call = SpriteSheet.GetFrames
SpriteSheet.__call = function(t, ...)
	return t:GetFrames(...)
end

---@param frameSize Vector2 The size of the frames.
---@param imageSize Vector2 The size of the image.
---@param origin Vector2? The position in pixels where the sprite sheet starts.
---@param padding number? The padding (init pixels) between the different sprites.
---@return SpriteSheet
---@nodiscard
function SpriteSheet.new(frameSize, imageSize, origin, padding)
	origin = origin or Vector2.both(0)
	padding = padding or 0

    local self = setmetatable({
		_frameSize = frameSize;
		_imageSize = imageSize;
		_size = Vector2.new(
			math.floor(imageSize.X / frameSize.X),
			math.floor(imageSize.Y / frameSize.Y)
		);

		_origin = origin;
		_padding = padding;

		_key = table.concat({frameSize.X, frameSize.Y, imageSize.X, imageSize.Y, origin.X, origin.Y, padding}, "-");
    }, SpriteSheet)

    return self
end

function SpriteSheet:GetFrames(...)
	local result = {}
	local args = {...}

	for _, v in ipairs(args) do
		if (type(v) ~= "table") then
			error("SpriteSheet:GetFrames() only supports tables as arguments!")
		end

		local xFrom, xTo, xStep = toRange(v[1])
		local yFrom, yTo, yStep = toRange(v[2])

		if (xFrom) and (yFrom) then
			for y = yFrom, yTo, yStep do
				for x = xFrom, xTo, xStep do
					result[#result + 1] = getOrCreateFrame(self, x, y)
				end
			end
		end
	end

	return result
end

function SpriteSheet:GetAllFrames()
	local result = {}

	for y = 1, self._size.Y do
		for x = 1, self._size.X do
			result[#result + 1] = getOrCreateFrame(self, x, y)
		end
	end

	return result
end
