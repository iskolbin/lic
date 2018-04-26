return function( x0, dx, ys, err, abxs )
	abxs = abxs or {}
	local a1, b1 = 0, 0
	local i, n, g = 1, #ys, 1
	if n < 2 then
		return abxs
	end
	local abs = math.abs
	for j = i+1, n do
		local a = (ys[i] - ys[j]) / (dx * (i-j))
		local x = dx * (i-1) + x0
		local b = ys[i] - a * x
		local ok = true
		for u = i+1, j-1 do
			if abs( a * (dx * u + x0) + b - ys[u] ) > err then
				abxs[g], abxs[g+1], abxs[g+2] = a1, b1, dx*(j-1)+x0
				g, i, ok = g+3, j-1, false
				break
			end
		end
		if ok then
			a1, b1 = a, b
		end
	end
	abxs[g], abxs[g+1], abxs[g+2] = a1, b1, dx*(n-1)+x0
	return abxs
end
