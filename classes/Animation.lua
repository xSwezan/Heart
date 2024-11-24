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

local function seekFrameIndex(intervals, timer)
	local high, low, i = #intervals - 1, 1, 1

	while (low <= high) do
		i = math.floor((low + high) / 2)

		if (timer >= intervals[i + 1]) then
			low = i + 1
		elseif (timer <  intervals[i]) then
			high = i - 1
		else
			return i
		end
	end

	return i
end

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

local function parseDurations(durations, frameCount)
	local result = {}
	if (type(durations) == "number") then
		for i = 1, frameCount do
			result[i] = durations
		end
	else
		for key, duration in pairs(durations) do
			assert(type(duration) == "number", "The value [" .. tostring(duration) .. "] should be a number")

			local min, max, step = toRange(key)
			for i = min, max, step do
				result[i] = duration
			end
		end
	end

	if (#result < frameCount) then
		error("The durations table has length of " .. tostring(#result) .. ", but it should be >= " .. tostring(frameCount))
	end

	return result
end

local function parseIntervals(durations)
	local result, time = {0}, 0
	for i = 1, #durations do
		time = time + durations[i]
		result[i + 1] = time
	end
	return result, time
end

---@alias AnimationFrame love.Quad

---@class Animation
---@field Looped boolean Whether the animation will repeat after finishing.
---@field Paused boolean Whether the animation is paused.
---@field Speed number Speed of the animation (default is 1). Negative numbers playes the animation backwards, positive numbers plays the animation forward, and 0 pauses it.
---@field Ended Signal Fired whenever the animation ended.
---@field OnLoop Signal Fired whenever the animation looped.
---@field FrameChanged Signal Fired whenever the frame changes.
Animation = {}
Animation.__index = Animation
Animation.__tostring = function()
    return "Animation"
end

local animations = {}

---@param frames AnimationFrame[]
---@param durations number|number[]
---@return Animation
---@nodiscard
function Animation.new(frames, durations)
	durations = parseDurations(durations, #frames)
	local intervals, totalDuration = parseIntervals(durations)

    local self = setmetatable({
        Looped = false;
        Paused = false;
        Speed = 1;

		Ended = Signal.new();
		OnLoop = Signal.new();
		FrameChanged = Signal.new();

        _frames = frames;
        _durations = durations;
		_intervals = intervals;
		_totalDuration = totalDuration;
        _timer = 0;
        _lastUpdate = 0;
        _playing = false;
		_frameIndex = 1;
    }, Animation)

	table.insert(animations, self)

    return self
end

--- Plays the animation from `fromFrameIndex`, if none is given; it will play from the start.
function Animation:Play(fromFrameIndex)
    self:GoToFrame(fromFrameIndex or 1)
    self._playing = true
end

--- Stops the animation from playing.
function Animation:Stop()
    self._playing = false
	self.Ended:Fire()
end

--- Skips to the given frameIndex (starting at 1).
---@param frameIndex number
function Animation:GoToFrame(frameIndex)
    self._frameIndex = frameIndex
    self._timer = self._intervals[self._frameIndex]
end

--- Moves the animation to its last frame.
function Animation:GoToEnd()
    self._frameIndex = #self._frames
    self._timer = self._totalDuration
end

--- Moves the animation to its last frame.
function Animation:GoToStart()
    self._frameIndex = 1
    self._timer = 0
end

--- Pauses the animation.
function Animation:Pause()
    self.Paused = true
end

--- Unpauses the animation.
function Animation:Unpause()
    self.Paused = false
end

--- Returns if animation is playing or not.
---@return boolean playing
---@nodiscard
function Animation:IsPlaying()
    return (self._playing) and not (self.Paused)
end

--- Returns the current frame index.
---@return number frameIndex
---@nodiscard
function Animation:GetCurrentFrame()
	return self._frameIndex
end

--- Draws anim8 animation using a sprite.
---@param sprite Sprite
function Animation:Draw(sprite)
    sprite.Color:Use(function()
		love.graphics.draw(
			sprite.Texture,
            self._frames[self._frameIndex],
			sprite.Position.X,
			sprite.Position.Y,
			math.rad(sprite.Rotation),
			sprite:GetAbsoluteSize().X / sprite.Size.X, ---! All these sprite.Size are suppossed(?) to be sprite.Texture:getWidth() and sprite.Texture:getHeight()
			sprite:GetAbsoluteSize().Y / sprite.Size.Y, ---! All these sprite.Size are suppossed(?) to be sprite.Texture:getWidth() and sprite.Texture:getHeight()
			sprite.Size.X * sprite.AnchorPoint.X, ---! All these sprite.Size are suppossed(?) to be sprite.Texture:getWidth() and sprite.Texture:getHeight()
			sprite.Size.Y * sprite.AnchorPoint.Y ---! All these sprite.Size are suppossed(?) to be sprite.Texture:getWidth() and sprite.Texture:getHeight()
		)
	end)
end

---@param dt number
function Animation:_update(dt)
    if not (self:IsPlaying()) then return end

    self._timer = self._timer + dt * self.Speed

    local loops = math.floor(self._timer / self._totalDuration)
    if (loops ~= 0) then
        if not (self.Looped) then
            self:Stop()
            return
        end
        self._timer = self._timer - self._totalDuration * loops
		self.OnLoop:Fire()
    end

	local oldFrame = self._frameIndex
    self._frameIndex = seekFrameIndex(self._intervals, self._timer)

	if (oldFrame ~= self._frameIndex) then
		self.FrameChanged:Fire(oldFrame, self._frameIndex)
	end
end

function Animation._updateAll(dt)
	for _, animation in pairs(animations) do
		animation:_update(dt)
	end
end
