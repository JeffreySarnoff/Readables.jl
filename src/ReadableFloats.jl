module ReadableFloats

export readable,
       Readable,
       decpoint, setdecpoint,
       intsep, setintsep, intgroup, setintgroup,
       fracsep, setfracsep, fracgroup, setfracgroup
       
struct Readable
    decpoint::Char
    intsep::Char
    intgroup::Int
    fracsep::Char
    fracgroup::Int

    function Readable()
        return new('.', ',', 3, '_', 5)
    end
end

decpoint(x::Readable) = x.decpoint
intsep(x::Readable) = x.intsep
intgroup(x::Readable) = x.intgroup
fracsep(x::Readable) = x.fracsep
fracgroup(x::Readable) = x.fracgroup

setdecpoint(x::Readable, decpoint::Char) = Readable(decpoint, x.intsep, x.intgroup, x.fracsep, x.fracgroup)
setintsep(x::Readable, intsep::Char) = Readable(x.decpoint, intsep, x.intgroup, x.fracsep, x.fracgroup)
setintgroup(x::Readable, intgroup::Int) = Readable(x.decpoint, x.intsep, intgroup, x.fracsep, x.fracgroup)
setfracsep(x::Readable, fracsep::Char) = Readable(x.decpoint, x.intsep, x.intgroup, fracsep, x.fracgroup)
setfracgroup(x::Readable, fracgroup::Int) = Readable(x.decpoint, x.intsep, x.intgroup, x.fracsep, fracgroup)

radixprefixes = Dict(2=>"0b", 8=>"0o", 10=>"", 16=>"0x")
radixprefix(x::Int) = get(radixprefixes, x, string("0",x,"R"))

function readable(r::Readable, x::I, radix::Int=10) where {I<:Signed}
    numsign = signbit(x) ? "-" : ""
    str = string(abs(x), base=radix)
    ndigs = length(str)
    ngroups, firstgroup = divrem(ndigs, r.intgroup)
    idx = firstgroup
    if idx > 0
        res = string(str[1:idx], r.intsep)
    else
        res = ""
    end
    while ngroups > 1
        res = string(res, str[idx+1:idx+r.intgroup], r.intsep)
        idx += r.intgroup
        ngroups -= 1
    end
    res = string(res, str[idx+1:idx+r.intgroup])
    return string(numsign, radixprefix(radix), res)   
end

function Base.BigInt(str::AbstractString)
   s = String(strip(str))
   nchars = length(s)
   prec = ceil(Int, log2(10) * nchars) + 16
   holdprec = precision(BigFloat)
   setprecision(BigFloat, prec)
   res = BigInt(BigFloat(s))
   setprecision(BigFloat, holdprec)
   return res
end

end # ReadableFloats
