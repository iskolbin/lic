local love = assert( _G.love )
local ic = require('ic')

local xs, ys = {}, {}
local N = 31
local dt = math.pi/(N-1)
local xscl, yscl = 200, 150
for i = 0, N-1 do
	xs[#xs+1] = i*dt
	ys[#ys+1] = math.sin( xs[#xs] )
end
for i = 2, N do
	xs[#xs+1] = (N-i)*dt
	ys[#ys+1] = 2*math.sin( xs[#xs] )
end
for i = 0, N-1 do
	xs[#xs+1] = i*dt
	ys[#ys+1] = 1.5*math.sin( xs[#xs] )
end


local ts = ic.range( 0, dt, #xs )
local abxs = ic.pack1( ts, xs, 0.05 )
local abys = ic.pack1( ts, ys, 0.05 )
local abcys = ic.pack2( ts, ys, 0.05 )
local xs = ic.unpack1( ts, abxs )
local ys_ = ic.unpack1( ts, abys )
local ys2_ = ic.unpack2( ts, abcys )
--local ts_, xs_ = ic.funpack1( 0, dt, abxs )
--local ts_, ys_ = ic.funpack1( 0, dt, abys )
--[[
local abcys = ic.fpack2( 0, dt, ys, 0.05 )
local ts2_, ys2_ = ic.funpack2( 0, dt, abcys )
--]]
function love.draw()
	love.graphics.translate( 100, 100 )
	love.graphics.setPointSize( 4 )
	love.graphics.setColor( 1, 1, 0 )
	for i = 1, #xs do
		love.graphics.points( xscl * xs[i], yscl * ys[i] )
	end
	love.graphics.setPointSize( 3 )
	love.graphics.setColor( 0, 1, 0 )
	for i = 1, #xs do
		love.graphics.points( xscl * xs[i], yscl * ys_[i] )
	end
	love.graphics.setPointSize( 2 )
	love.graphics.setColor( 1, 0, 0 )
	for i = 1, #xs do
		love.graphics.points( xscl * xs[i], yscl * ys2_[i] )
	end
	--[[
	for i = 1, #ys2_ do
		love.graphics.points( xscl * xs_[i], yscl * ys2_[i] + 400 )
	end
	--]]
end
