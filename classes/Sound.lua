---@meta

---@class Sound
---@field Source love.Source
---@field Volume number
---@field Looped boolean
---@field Pitch number
---@field Position number
Sound = {}
Sound.__index = Sound
Sound.__tostring = function()
	return "Sound"
end

---@param filename string The filepath to the audio file. Supported formats are: `mp3`, `ogg`, and `wav`.
---@return Sound
---@nodiscard
function Sound.new(filename)
	local self = setmetatable({
		Source = love.audio.newSource(filename, "stream");

		Volume = 1.0;
		Looped = false;
		Pitch = 1.0;
		Position = 0.0;
	}, Sound)

	return self
end

-->---------<--
--> Methods <--
-->---------<--

--- Plays the Sound from the start.
function Sound:Play()
	self.Source:stop()
	self.Source:play()
end

--- Stops the Sound from playing.
function Sound:Stop()
	self.Source:stop()
end

--- Pauses the Sound.
function Sound:Pause()
	self.Source:pause()
end

--- Resumes the paused Sound.
function Sound:Resume()
	self.Source:play()
end

-->-------------<--
--> Metamethods <--
-->-------------<--

---@private
function Sound:__newindex(index, value)
	if (index == "Volume") then
		self.Source:setVolume(value)
	elseif (index == "Looped") then
		self.Source:setLooping(value)
	elseif (index == "Pitch") then
		self.Source:setPitch(value)
	elseif (index == "Position") then
		self.Source:seek(value, "seconds")
		return
	end

	rawset(index, value)
end

function Sound:__index(index)
	if (index == "Position") then
		return self.Source:getPosition()
	end

	return rawget(self, index)
end
