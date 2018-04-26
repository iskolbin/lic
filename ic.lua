local ic = {}

function ic.pack1( xs, ys, err, abxs )
	abxs = abxs or {}
	local a1, b1 = 0, 0
	local i, j, n, g = 1, 2, #ys, 1
	if n < 2 or #xs ~= n then
		return abxs
	end
	local abs = math.abs
	while j <= n do
		local a = (ys[i] - ys[j]) / (xs[i] - xs[j])
		local b = ys[j] - a * xs[j]
		local ok = true
		for u = i+1, j-1 do
			if abs( a * xs[u] + b - ys[u] ) > err then
				abxs[g], abxs[g+1], abxs[g+2] = a1, b1, xs[j-1]
				g, i, ok = g+3, j-1, false
				break
			end
		end
		if ok then
			a1, b1, j = a, b, j+1
		end
	end
	abxs[g], abxs[g+1], abxs[g+2] = a1, b1, xs[n]
	return abxs
end

function ic.fpack1( x0, dx, ys, err, abxs )
	abxs = abxs or {}
	local a1, b1, x1 = 0, 0, 0
	local i, j, n, g = 1, 2, #ys, 1
	if n < 2 then
		return abxs
	end
	local abs = math.abs
	while j <= n do
		local a = (ys[i] - ys[j]) / (dx * (i-j))
		local x = dx * (j-1) + x0
		local b = ys[j] - a * x
		local ok = true
		for u = i+1, j-1 do
			if abs( a * (dx * (u-1) + x0) + b - ys[u] ) > err then
				abxs[g], abxs[g+1], abxs[g+2] = a1, b1, x1
				g, i, ok = g+3, j-1, false
				break
			end
		end
		if ok then
			a1, b1, x1, j = a, b, x, j+1
		end
	end
	abxs[g], abxs[g+1], abxs[g+2] = a1, b1, x1
	return abxs
end

function ic.funpack1( x0, dx, abxs, xs, ys )
	xs, ys = xs or {}, ys or {}
	local x, g, a, b, maxx = x0, 1, 0, 0, 0
	for i = 1, #abxs, 3 do
		a, b, maxx = abxs[i], abxs[i+1], abxs[i+2]
		while x <= maxx do
			xs[g], ys[g] = x, a*x + b
			x = x + dx
			g = g + 1
		end
	end
	if xs[g-1] < maxx then
		xs[g], ys[g] = maxx, a*maxx + b
	end
	return xs, ys
end

return ic
