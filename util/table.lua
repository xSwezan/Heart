--- Sets all keys in the given table to nil.
---@param t table
function table.clear(t)
	for i in pairs(t) do
		t[i] = nil
	end
end

--- Returns the index of the first occurrence of needle within haystack starting from init.
---@param haystack table
---@param needle any
---@param init number?
---@nodiscard
function table.find(haystack, needle, init)
	for i = (init or 1), #haystack do
		if (haystack[i] == needle) then
			return i
		end
	end
end
