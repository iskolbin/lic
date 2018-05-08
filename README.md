Lua interpolative compression
=============================

Consider you have dense table of precise calculations and want to reduce
it size somehow. For example you have simulated coordinates of moving body
and want to store them more compactly. One of the possible approaches is
to store table of coeffitients of interpolative polynoms and restore needed
data from them. This library evaluates this coeffitients for 1st and 2nd
order polynoms. 

ic.pack1( xs, ys, err[, abxs ])
-------------------------------

Evaluate linear interpolators coeffitients with maximal absolute error not
greater than `err`. Arguments `xs` must be monotonous, `ys` is any non-nan,
non-infinity numbers array. Also you can pass output array.

ic.unpack1( xs, abxs[, ys])
---------------------------

Fills `ys` with arguments and values from coeffitients `abxs` on `xs`. If
`ys` is not passed free array is created.

ic.pack2( xs, ys, err[, abcxs ])
--------------------------------

Evaluate quadratic interpolators coeffitients with maximal absolute error not
greater than `err`. Arguments `xs` must be monotonous, `ys` is any non-nan,
non-infinity numbers array. Also you can pass output array.

ic.unpack2( xs, abcxs[, ys])
----------------------------

Fills `ys` with arguments and values from coeffitients `abcxs` on `xs`. If
`ys` is not passed free array is created.
