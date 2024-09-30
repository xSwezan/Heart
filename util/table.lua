-- Clears a table
function table.clear(tbl)
	for i in pairs(tbl) do
		tbl[i] = nil
	end
end

-- Within the given array-like table haystack,  find  the  first  occurrence  of
-- value needle, starting from index init or the beginning if not  provided.  If
-- the value is not found, nil is returned.
function table.find(haystack, needle, init)
	for i = (init or 1), #haystack do
		if (haystack[i] == needle) then
			return i
		end
	end
end
