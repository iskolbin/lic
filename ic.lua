local ic = {}

function ic.range( x0, dx, n, xs )
	xs = xs or {}
	local n_ = #xs
	for i = 1, n do
		xs[i] = x0 + dx*(i-1)
	end
	for i = n+1, n_ do
		xs[i] = nil
	end
	return xs
end

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

function ic.unpack1( xs, abxs, ys )
	ys = ys or {}
	local g, a, b, maxx, x, ok = 1, 0, 0, 0, xs[1], true
	for i = 1, #abxs, 3 do
		a, b, maxx = abxs[i], abxs[i+1], abxs[i+2]
		while ok and x <= maxx do
			ys[g] = a*x + b
			g = g + 1
			x = xs[g]
			ok = x ~= nil
		end
		if not ok then
			break
		end
	end
	if xs[g-1] < maxx then
		xs[g], ys[g] = maxx, a*maxx + b
	end
	return ys
end

function ic.pack2( xs, ys, err, abcxs )
	abcxs = abcxs or {}
	local a1, b1, c1 = 0, 0, 0
	local l, r, n, g = 1, 3, #ys, 1
	if n < 2 or #xs ~= n then
		return abcxs
	end
	local abs = math.abs
	local xl, xr, yl, yr = xs[l], xs[r], ys[l], ys[r]
	local a, b, c = 0, 0, 0
	while r <= n do	
		local ok = true
		for m = l+1, r-1 do
			local xm, ym = xs[m], ys[m]
			local d = (ym - yl) / (xm - xl)
			a = ((yr - yl) / (xr - xl) - d) / (xr - xm)
			b = d - (xm + xl)*a
			c = ym - xl*xl*a - xl*b
			if abs( a*xm*xm + b*xm + c - ym ) > err then
				abcxs[g], abcxs[g+1], abcxs[g+2], abcxs[g+3] = a1, b1, c1, xs[r-1]
				g, l, r, ok = g+4, r-1, r+1, false
				xl, yl = xs[l], ys[l]
				if r > n then
					return abcxs
				end
				break
			end
		end
		if ok then
			a1, b1, c1, r = a, b, c, r+1
			xr, yr = xs[r], ys[r]
		end
	end
	abcxs[g], abcxs[g+1], abcxs[g+2], abcxs[g+3] = a1, b1, c1, xs[n]
	return abcxs
end

function ic.unpack2( xs, abcxs, ys )
	ys = ys or {}
	local g, a, b, c, maxx, x, ok = 1, 0, 0, 0, 0, xs[1], true
	for i = 1, #abcxs, 4 do
		a, b, c, maxx = abcxs[i], abcxs[i+1], abcxs[i+2], abcxs[i+3]
		while ok and x <= maxx do
			ys[g] = a*x*x + b*x + c
			g = g + 1
			x = xs[g]
			ok = x ~= nil
		end
		if not ok then
			break
		end
	end
	if xs[g-1] < maxx then
		ys[g] = a*maxx*maxx + b*maxx + c
	end
	return xs, ys
end

return ic
