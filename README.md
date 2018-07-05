# Readables.jl
### Make extended precision numbers readable.

| Copyright © 2018 by Jeffrey Sarnoff.  | This work is made available under The MIT License. |
|:--------------------------------------|:------------------------------------------------:|


-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/TimesDates.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/Readables.jl)
 
----


## Use

```julia
julia> using Readables

julia> setprecision(BigFloat, 160);
julia> prn(val) = println("\n\t", string(val), "\n\t", readable(val));

julia> val = (pi/2)^9; prn(val)

	58.22089713563711
	58.22089_71356_3711

julia> val= (BigFloat(pi)/2)^9; prn(val)

	5.8220897135637132161151176564921201882554800340637e+01
	5.82208_97135_63713_21611_51176_56492_12018_82554_80034_0637e+01

julia> setprecision(BigFloat,192);

julia> val = (BigFloat(pi))^115; ival = trunc(BigInt, val); prn(ival)

	1486741142588149449007460570055579083524909316281177999404
	1,486,741,142,588,149,449,007,460,570,055,579,083,524,909,316,281,177,999,404

```

## Customize

```julia

julia> config = setintsep(setintgroup(12), '.');

julia> ival = trunc(BigInt, (BigFloat(pi))^64);
julia> readable(config, ival)
"65704006.445717084572.022626334540"
```

### exported configurables

We assume a `Real` value has an integer componant and a fractional componant (either may be zero).

`intgroup, fracgroup` is the number of digits used to form digit subsequences in the integer and fractional parts

`intsep, fracsep` is the `Char` used to separate groups in the integer and fractional parts

- decpoint, setdecpoint
- intsep, fracsep, setintsep, setfracsep
- intgroup, fracgroup, setintgroup, setfracgroup


----
