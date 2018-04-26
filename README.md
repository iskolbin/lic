Lua interpolative compression
=============================

Library which transforms series of values into series of polymomial coeffitients
of the interpolators. Rationale of this is to reduce data size needed. For
example you have highly accurate coordinates of the body during physics
simulations and if you want to make some demo of it you don't need the whole array
of the coorinates, you can approximate with some precision them reducing needed
memory.

ic.pack1( xs, ys, err[, abxs ])
-------------------------------

Evaluate linear interpolators coeffitients with maximal absolute error not
greater than `err`. Arguments `xs` must be monotonous, `ys` is any nonnan
numbers array. Also you can pass output array.

ic.fpack1( x0, dx, ys, err[, abxs ])
------------------------------------

Same as `pack1` but with homogeneous distributed arguments starting from `x0`
with step `dx`.

ic.funpack1( x0, dx, abxs[, xs, ys])
------------------------------------

Fills `xs` and `ys` with arguments and values from coeffitients `abxs`.
