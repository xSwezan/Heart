function math.lerp(a, b, t)
	return a + (b - a) * t
end

function math.clamp(number, min, max)
	return math.min(math.max(number, min), max)
end
