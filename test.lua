local ic = require('ic')

local functions = {
	line = function( x ) return 5*x - 21 end,
	parab = function( x ) return 3*x*x + 4*x - 1 end,
	modul = function( x ) return math.abs( 4 + x*x - x ) end,
	sin = math.sin,
	sqrt = math.sqrt,
	tan = math.tan,
}


local function case( name, f, err, n )
	local xs, ys = {}, {}
	for i = 1, n do
		local x = 0.01*(i-1)
		if f(x) ~= 0/0 and f(x) ~= math.huge and f(x) ~= -math.huge then
			xs[#xs+1], ys[#ys+1] = x, f(x)
		end
	end
	local abxs = ic.pack1( xs, ys, err )
	local abcxs = ic.pack2( xs, ys, err )
	local ys1_ = ic.unpack1( xs, abxs )
	local ys2_ = ic.unpack2( xs, abcxs )
	for i = 1, #ys do
		assert( math.abs(ys1_[i] - ys[i]) <= 2*err, ys1_[i] .. '-' .. ys[i] .. '=' .. math.abs(ys1_[i]-ys[i]) )
		assert( math.abs(ys2_[i] - ys[i]) <= 2*err, ys2_[i] .. '-' .. ys[i] .. '=' .. math.abs(ys2_[i]-ys[i]) )
	end
	print( name, 'B:', #xs + #ys, '1:', #abxs, '2:', #abcxs, 'r1:', (#xs+#ys)/#abxs, 'r2:', (#xs+#ys)/#abcxs )
end

for _, err in ipairs{0.1,0.01, 0.001, 0.0001, 0.00001} do
	for _, n in ipairs{2, 51, 973, 5713} do
		print( 'err:', err, 'n:', n )
		for name, f in pairs( functions ) do
			case( name, f, err, n )
		end
		print( '---')
	end
end
