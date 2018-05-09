--[[

 ic - v0.1.1 - public domain Lua interpolative compression library
 no warranty implied; use at your own risk

 author: Ilya Kolbin (iskolbin@gmail.com)
 url: github.com/iskolbin/lic

 See documentation in README file.

 COMPATIBILITY

 Lua 5.1, 5.2, 5.3, LuaJIT 1, 2

 LICENSE

 See end of file for license information.

--]]

local ic = {}

function ic.range( x0, dx, n, xs_ )
	local xs = xs_ or {}
	for i = 1, n do
		xs[i] = x0 + dx*(i-1)
	end
	return xs
end

function ic.pack1( xs, ys, err, abxs_ )
	local abxs = abxs_ or {}
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

function ic.unpack1( xs, abxs, ys_ )
	local ys = ys_ or {}
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

function ic.pack2( xs, ys, err, abcxs_ )
	local abcxs = abcxs_ or {}
	local n = #ys
	local af, bf, cf = 0, 0, 0
	local l, r, g = 1, 3, 1
	if n < 2 or n ~= #xs then
		return abcxs
	elseif n == 2 then
		af = 0
		bf = (ys[l]-ys[l+1])/(xs[l]-xs[l+1])
		cf = ys[l+1]-bf*xs[l+1]
	end
	local abs = math.abs
	while r <= n do
		local fit = true
		for m = l+1, r-1 do
			fit = true
			local d = (ys[r]-ys[l]) / (xs[r]-xs[l])
			local a = ((ys[m]-ys[l]) / (xs[m]-xs[l]) - d) / (xs[m]-xs[r])
			local b = d - a * (xs[r]+xs[l])
			local c = ys[l] - xs[l]*d + xs[l]*xs[r]*a
			for u = l+1, r-1 do
				if abs( a*xs[u]*xs[u] + b*xs[u] + c - ys[u] ) > err then
					fit = false
					break -- for u
				end
			end -- for u
			if fit then
				af, bf, cf = a, b, c
				break -- for m
			end
		end -- for m
		if fit then
			r = r+1
		else
			abcxs[g], abcxs[g+1], abcxs[g+2], abcxs[g+3] = af, bf, cf, xs[r-1]
			l, r, g = r-1, r+1, g+4
			if r > n then
				af = 0
				bf = (ys[l]-ys[l+1])/(xs[l]-xs[l+1])
				cf = ys[l+1] - bf*xs[l+1]
			end
		end
	end -- while
	abcxs[g], abcxs[g+1], abcxs[g+2], abcxs[g+3] = af, bf, cf, xs[#xs]
	return abcxs
end

function ic.unpack2( xs, abcxs, ys_ )
	local ys = ys_ or {}
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
	return ys
end

return ic

--[[
------------------------------------------------------------------------------
This software is available under 2 licenses -- choose whichever you prefer.
------------------------------------------------------------------------------
ALTERNATIVE A - MIT License
Copyright (c) 2018 Ilya Kolbin
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
------------------------------------------------------------------------------
ALTERNATIVE B - Public Domain (www.unlicense.org)
This is free and unencumbered software released into the public domain.
Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
software, either in source code form or as a compiled binary, for any purpose,
commercial or non-commercial, and by any means.
In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and to
the detriment of our heirs and successors. We intend this dedication to be an
overt act of relinquishment in perpetuity of all present and future rights to
this software under copyright law.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
------------------------------------------------------------------------------
--]]
