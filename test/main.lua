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


local abxs = ic.fpack1( 0, dt, xs, 0.05 )
local abys = ic.fpack1( 0, dt, ys, 0.05 )
local ts_, xs_ = ic.funpack1( 0, dt, abxs )
local ts_, ys_ = ic.funpack1( 0, dt, abys )

function love.draw()
	love.graphics.translate( 100, 100 )
	love.graphics.setPointSize( 4 )
	love.graphics.setColor( 1, 0, 0 )
	for i = 1, #xs do
		love.graphics.points( xscl * xs[i], yscl * ys[i] )
	end
	love.graphics.setColor( 0, 1, 0 )
	for i = 1, #xs_ do
		love.graphics.points( xscl * xs_[i], yscl * ys_[i] )
	end
end
