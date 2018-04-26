return function( xs, ys, err, abxs )
	abxs = abxs or {}
	local a1, b1 = 0, 0
	local i, n, g = 1, #ys, 1
	if n < 2 or n ~= #xs then
		return abxs
	end
	local abs = math.abs
	for j = i+1, n do
		local a = (ys[i] - ys[j]) / (xs[i] - xs[j])
		local b = ys[i] - a * xs[i]
		local ok = true
		for u = i+1, j-1 do
			if abs( a * xs[u] + b - ys[u] ) > err then
				abxs[g], abxs[g+1], abxs[g+2] = a1, b1, xs[j-1]
				g, i, oa = g+3, j-1, false
				break
			end
		end
		if ok then
			a1, b1 = a, b
		end
	end
	abxs[g], abxs[g+1], abxs[g+2] = a1, b1, xs[n]
	return abxs
end
