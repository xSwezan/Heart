Input = {
	---@enum KeyCode
	KEYCODE = {
		RETURN = "return",
		ESCAPE = "escape",
		BACKSPACE = "backspace",
		TAB = "tab",
		SPACE = "space",
		EXCLAIM = "!",
		QUOTEDBL = "\"",
		HASH = "#",
		PERCENT = "%",
		DOLLAR = "$",
		AMPERSAND = "&",
		QUOTE = "'",
		LEFTPAREN = "(",
		RIGHTPAREN = ")",
		ASTERISK = "*",
		PLUS = "+",
		COMMA = ",",
		MINUS = "-",
		PERIOD = ".",
		SLASH = "/",
		ZERO = "0",
		ONE = "1",
		TWO = "2",
		THREE = "3",
		FOUR = "4",
		FIVE = "5",
		SIX = "6",
		SEVEN = "7",
		EIGHT = "8",
		NINE = "9",
		COLON = ":",
		SEMICOLON = ";",
		LESS = "<",
		EQUALS = "=",
		GREATER = ">",
		QUESTION = "?",
		AT = "@",

		LEFTBRACKET = "[",
		BACKSLASH = "\\",
		RIGHTBRACKET = "]",
		CARET = "^",
		UNDERSCORE = "_",
		BACKQUOTE = "`",
		A = "a",
		B = "b",
		C = "c",
		D = "d",
		E = "e",
		F = "f",
		G = "g",
		H = "h",
		I = "i",
		J = "j",
		K = "k",
		L = "l",
		M = "m",
		N = "n",
		O = "o",
		P = "p",
		Q = "q",
		R = "r",
		S = "s",
		T = "t",
		U = "u",
		V = "v",
		W = "w",
		X = "x",
		Y = "y",
		Z = "z",

		-- Function keys
		F1 = "f1",
		F2 = "f2",
		F3 = "f3",
		F4 = "f4",
		F5 = "f5",
		F6 = "f6",
		F7 = "f7",
		F8 = "f8",
		F9 = "f9",
		F10 = "f10",
		F11 = "f11",
		F12 = "f12",

		-- Arrow keys
		UP = "up",
		DOWN = "down",
		LEFT = "left",
		RIGHT = "right",

		PAGE_UP = "pageup",
		PAGE_DOWN = "pagedown",

		-- Other common keys
		CAPSLOCK = "capslock",
		LSHIFT = "lshift",
		RSHIFT = "rshift",
		LCTRL = "lctrl",
		RCTRL = "rctrl",
		LALT = "lalt",
		RALT = "ralt",
		INSERT = "insert",
		DELETE = "delete",
		HOME = "home",
		END = "end",
		PAGEUP = "pageup",
		PAGEDOWN = "pagedown",
		NUMLOCK = "numlock",
		PRINTSCREEN = "printscreen",
		SCROLLLOCK = "scrolllock",

		-- Keypad numbers
		KP_0 = "kp0",
		KP_1 = "kp1",
		KP_2 = "kp2",
		KP_3 = "kp3",
		KP_4 = "kp4",
		KP_5 = "kp5",
		KP_6 = "kp6",
		KP_7 = "kp7",
		KP_8 = "kp8",
		KP_9 = "kp9",

		-- Keypad operators
		KP_DIVIDE = "kp/",
		KP_MULTIPLY = "kp*",
		KP_MINUS = "kp-",
		KP_PLUS = "kp+",
		KP_ENTER = "kpenter",
		KP_PERIOD = "kp.",
		KP_COMMA = "kp,",
		KP_EQUALS = "kp=",
	};
	---@enum MouseButton
	MOUSE = {
		LEFT = 1;
		RIGHT = 2;
		MIDDLE = 3;
	};
}

local registeredKeycodes = {}
local keyCodesDown = {}
local connections = {
	inputDown = {};
	inputUp = {};

	mouseDown = {};
	mouseUp = {};
	mouseDoubleClick = {};
	mouseMove = {};
}

-- Passed  callback  gets  called when any of
-- the keycodes in  the  provided  table  get
-- pressed. Returns a disconnect function.
---@param keyCodes KeyCode[]
---@param callback fun()
---@return fun()
function Input.InputDown(keyCodes, callback)
	for _, keyCode in pairs(keyCodes) do
		connections.inputDown[keyCode] = connections.inputDown[keyCode] or {}
		table.insert(connections.inputDown[keyCode], callback)

		registeredKeycodes[keyCode] = true
	end

	return function()
		for _, keyCode in pairs(keyCodes) do
			table.remove(
				connections.inputDown[keyCode],
				table.find(connections.inputDown[keyCode], callback)
			)
		end
	end
end

-- Passed  callback  gets  called when any of
-- the keycodes in  the  provided  table  get
-- released. Returns a disconnect function.
---@param keyCodes KeyCode[]
---@param callback fun()
---@return fun()
function Input.InputUp(keyCodes, callback)
	for _, keyCode in pairs(keyCodes) do
		connections.inputUp[keyCode] = connections.inputUp[keyCode] or {}
		table.insert(connections.inputUp[keyCode], callback)

		registeredKeycodes[keyCode] = true
	end

	return function()
		for _, keyCode in pairs(keyCodes) do
			table.remove(
				connections.inputUp[keyCode],
				table.find(connections.inputUp[keyCode], callback)
			)
		end
	end
end

-- Passed callback gets called every time the
-- user presses the passed mouseButton,  with
-- the parameters: (clickPosition). Returns a
-- disconnect function.
---@param mouseButton MouseButton
---@param callback fun(clickPosition: Vector2)
---@return fun()
function Input.MouseDown(mouseButton, callback)
	connections.mouseDown[mouseButton] = connections.mouseDown[mouseButton] or {}
	table.insert(connections.mouseDown[mouseButton], callback)

	return function()
		table.remove(
			connections.mouseDown[mouseButton],
			table.find(connections.mouseDown[mouseButton], callback)
		)
	end
end


-- Passed callback gets called every time the
-- user releases the passed mouseButton, with
-- the parameters: (clickPosition). Returns a
-- disconnect function.
---@param mouseButton MouseButton
---@param callback fun(clickPosition: Vector2)
---@return fun()
function Input.MouseUp(mouseButton, callback)
	connections.mouseUp[mouseButton] = connections.mouseUp[mouseButton] or {}
	table.insert(connections.mouseUp[mouseButton], callback)

	return function()
		table.remove(
			connections.mouseUp[mouseButton],
			table.find(connections.mouseUp[mouseButton], callback)
		)
	end
end

-- Passed callback gets called every time the
-- user double clicks the passed mouseButton,
-- with   the   parameters:  (clickPosition).
-- Returns a disconnect function.
---@param mouseButton MouseButton
---@param callback fun(clickPosition: Vector2)
---@return fun()
function Input.MouseDoubleClick(mouseButton, callback)
	connections.mouseDoubleClick[mouseButton] = connections.mouseDoubleClick[mouseButton] or {}
	table.insert(connections.mouseDoubleClick[mouseButton], callback)

	return function()
		table.remove(
			connections.mouseDoubleClick[mouseButton],
			table.find(connections.mouseDoubleClick[mouseButton], callback)
		)
	end
end

-- Passed callback gets called every time the
-- mouse moves, with the parameters:  (newPo-
-- sition,       delta).       Returns      a
-- disconnect function.
---@param callback fun(position: Vector2, delta: Vector2)
---@return fun()
function Input.MouseMove(callback)
	table.insert(connections.mouseMove, callback)

	return function()
		table.remove(
			connections.mouseMove,
			table.find(connections.mouseMove, callback)
		)
	end
end

-- Returns true if the passed KeyCode is down.
---@param keyCode KeyCode
---@return boolean
function Input.IsDown(keyCode)
	return (keyCodesDown[keyCode] == true) or (love.keyboard.isDown(keyCode --[[@as love.KeyConstant]]))
end

-- Returns true if any of the passed KeyCodes are down.
---@param keyCodes KeyCode[]
---@return boolean
function Input.IsAnyDown(keyCodes)
	for _, keyCode in pairs(keyCodes) do
		if (Input.IsDown(keyCode)) then
			return true
		end
	end

	return false
end

-- Returns true if all of the passed KeyCodes are down.
---@param keyCodes KeyCode[]
---@return boolean
function Input.AreAllDown(keyCodes)
	for _, keyCode in pairs(keyCodes) do
		if not (Input.IsDown(keyCode)) then
			return false
		end
	end

	return true
end

---@param dt number DeltaTime
---@private
function Input._update(dt)
	for keyCode in pairs(registeredKeycodes) do
		if (love.keyboard.isDown(keyCode)) then
			if not (keyCodesDown[keyCode]) and (connections.inputDown[keyCode]) then
				for _, callback in pairs(connections.inputDown[keyCode]) do
					Task.spawn(callback)
				end
			end

			keyCodesDown[keyCode] = true
		else
			if (keyCodesDown[keyCode]) and (connections.inputUp[keyCode]) then
				for _, callback in pairs(connections.inputUp[keyCode]) do
					Task.spawn(callback)
				end
			end
			keyCodesDown[keyCode] = nil
		end
	end
end

-->----------------<--
--> Love Functions <--
-->----------------<--

function love.mousepressed(x, y, button, isTouch, presses)
	local clickPosition = Vector2.new(x, y)

	if (connections.mouseDown[button]) then
		for _, callback in pairs(connections.mouseDown[button]) do
			Task.spawn(callback, clickPosition)
		end
	end

	if (presses == 2) and (connections.mouseDoubleClick[button]) then
		for _, callback in pairs(connections.mouseDoubleClick[button]) do
			Task.spawn(callback, clickPosition)
		end
	end
end

function love.mousereleased(x, y, button, isTouch, presses)
	local clickPosition = Vector2.new(x, y)

	if (connections.mouseUp[button]) then
		for _, callback in pairs(connections.mouseUp[button]) do
			Task.spawn(callback, clickPosition)
		end
	end
end

function love.mousemoved(x, y, dx, dy)
	local position = Vector2.new(x, y)
	local delta = Vector2.new(dx, dy)

	for _, callback in pairs(connections.mouseMove) do
		Task.spawn(callback, position, delta)
	end
end
