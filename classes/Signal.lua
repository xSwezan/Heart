---@diagnostic disable: undefined-field
---@meta

---@class Signal
Signal = {}
Signal.__index = Signal
Signal.__type = "Signal"
Signal.__tostring = function()
	return "Signal"
end

---@return Signal
---@nodiscard
function Signal.new()
	local self = setmetatable({
		_connections = {};
		_onceConnections = {};
	}, Signal)

	return self
end

--- The provided callback will be called whenever the Signal is fired.
---@generic C
---@return C disconnect When called; the connection will disconnect.
function Signal:Connect(callback)
	table.insert(self._connections, callback)

	return function()
		local index = table.find(self._connections, callback)
		if not (index) then return end

		table.remove(self._connections, index)
	end
end

--- The provided callback will be called whenever the Signal is fired, only once.
---@return fun() disconnect When called; the connection will disconnect.
function Signal:Once(callback)
	table.insert(self._onceConnections, callback)

	return function()
		local index = table.find(self._onceConnections, callback)
		if not (index) then return end

		table.remove(self._onceConnections, index)
	end
end

--- Yields the current thread until the Signal is fired.
function Signal:Wait()
	local fired = false

	self:Once(function()
		print("FIRIRIIEIOAWEIOJAOWJIEJIOAWEJIOAWEJIO")
		fired = true
	end)

	print("waiting")
	repeat
		print("trying to wait")
		Task.wait(0.1)
	until fired
	print("waited")
end

--- Fires the Signal and passes the provided arguments to the connected callbacks.
---@param ... any The arguments to send to the connected callbacks.
function Signal:Fire(...)
	local args = {...}

	--- Connections
	for _, callback in ipairs(self._connections) do
		Task.spawn(callback, unpack(args))
	end

	--- Once connections
	for _, callback in ipairs(self._onceConnections) do
		Task.spawn(callback, unpack(args))
		print(callback)
	end
	self._onceConnections = {}
end
