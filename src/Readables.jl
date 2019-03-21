module Readables

export Readable,
       setreadables!,
       readable, readablestring,
       decpoint, setdecpoint,
       intsep, setintsep, intgroup, setintgroup,
       fracsep, setfracsep, fracgroup, setfracgroup

const IMAG_UNIT_STR = ["𝛊"]
const DUAL_UNIT_STR = ["ε"]

const IntGroupSize  = Ref(3)
const FracGroupSize = Ref(5)
const IntSepChar    = Ref(',')
const FracSepChar   = Ref('_')
const DecimalPoint  = Ref('.')

function setreadables!(; intgroupsize::Int  = IntGroupSize[],
                         fracgroupsize::Int = FracGroupSize[],
                         intsepchar::Char   = IntSepChar[],
                         fracsepchar::Char  = FracSepChar[],
                         decimalpoint::Char = DecimalPoint[],
                         )
    IntGroupSize[]  = intgroupsize
    FracGroupSize[] = fracgroupsize
    IntSepChar[]    = intsepchar
    FracSepChar[]   = fracsepchar
    DecimalPoint[]  = decimalpoint
    return nothing
end


struct Readable
    intgroupsize::Int
    fracgroupsize::Int
    fracsepchar::Char
    intsepchar::Char
    decimalpoint::Char

    function Readable(intgroupsize::Int, fracgroupsize::Int, intsepchar::Char, fracsepchar::Char, decimalpoint::Char)
       if !(0 < intgroupsize && 0 < fracgroupsize)
       throw(ErrorException("groups must be > 0 ($intgroupsize, $fracgroupsize)"))
       end    
       return new(intgroupsize, fracgroupsize, intsepchar, fracsepchar, decimalpoint)
    end
end

Readable(;groupby::Int=IntGroupSize[], sepchar::Char=IntSepChar[],
    intgroupsize::Int=groupby, 
    fracgroupsize::Int=(groupby != IntGroupSize[] ? groupby : FracGroupSize[]),
    intsepchar::Char=sepchar,
    fracsepchar::Char=(sepchar != IntSepChar[] ? sepchar : FracSepChar[]),
    decimalpoint::Char=DecimalPoint[]
    ) =
    Readable(intgroupsize, fracgroupsize, intsepchar, fracsepchar, decimalpoint)

struct Readable
    intgroupsize::Int
    fracgroupsize::Int
    fracsepchar::Char
    intsepchar::Char
    decimalpoint::Char

    function Readable(intgroupsize::Int, fracgroupsize::Int, intsepchar::Char, fracsepchar::Char, decimalpoint::Char)
        if !(0 < intgroupsize && 0 < fracgroupsize)
            throw(ErrorException("groups must be > 0 ($intgroupsize, $fracgroupsize)"))
        end
        return new(intgroupsize, fracgroupsize, intsepchar, fracsepchar, decimalpoint)
    end
end

Readable(;groupsize::Int=IntGroupSize[], sepchar::Char=IntSepChar[],
          intgroupsize::Int=groupsize, 
          fracgroupsize::Int=(groupsize != IntGroupSize[] ? groupsize : FracGroupSize[]),
          intsepchar::Char=sepchar,
          fracsepchar::Char=(sepchar != IntSepChar[] ? sepchar : FracSepChar[]),
          decimalpoint::Char=DecimalPoint[]
          ) =
    Readable(intgroupsize, fracgroupsize, intsepchar, fracsepchar, decimalpoint)
       


const baseprefixes = Dict(2=>"0b", 8=>"0o", 10=>"", 16=>"0x")

function baseprefix(x::Int)
    res = get(baseprefixes, x, nothing)
    res === nothing && throw(ErrorException("base $x is not supported"))
    return res
end







const READABLE = Readable()

decpoint(x::Readable) = x.decpoint
intsep(x::Readable) = x.intsep
intgroup(x::Readable) = x.intgroup
fracsep(x::Readable) = x.fracsep
fracgroup(x::Readable) = x.fracgroup







readablestring(x::T; base::Int=10, groupby::Int) where {T} = readablestring(Readable(groupby=groupby), x, base=base)
readablestring(x::T; base::Int=10, sepwith::Char) where {T} = readablestring(Readable(sepwith=sepwith), x, base=base)
readablestring(x::T; base::Int=10, groupby::Int, sepwith::Char) where {T} =
    readablestring(Readable(groupby=groupby, sepwith=sepwith), x, base=base)

readablestring(r::Readable, x::T, base::Int=10) where {T<:Signed} =
    readable_int(r, x, base)

readablestring(x::T, base::Int=10) where {T<:Signed} =
    readablestring(READABLE, x, base)

function readablestring(r::Readable, x::T, base::Int=10) where {T<:AbstractFloat}
    str = string(x)
    return readablestring(r, str, base)
end

readablestring(x::T, base::Int=10) where {T<:AbstractFloat} =
    readablestring(READABLE, x, base)



function readable(io::IO, r::Readable, x::T, base::Int=10) where {T<:Signed}
    str = readablestring(r, x, base)
    print(io, str)
end

readable(io::IO, x::T, base::Int=10) where {T<:Signed} =
    readable(io, READABLE, x, base)

readable(r::Readable, x::T, base::Int=10) where {T<:Signed} =
    readable(Base.stdout, r, x, base)

readable(x::T, base::Int=10) where {F, T<:Signed} =
    readable(Base.stdout, READABLE, x, base)


function readable(io::IO, r::Readable, x::T, base::Int=10) where {T<:AbstractFloat}
    str = readablestring(r, x, base)
    print(io, str)
end

readable(io::IO, x::T, base::Int=10) where {T<:AbstractFloat} =
    readable(io, READABLE, x, base)

readable(r::Readable, x::T, base::Int=10) where {T<:AbstractFloat} =
    readable(Base.stdout, r, x, base)

readable(x::T, base::Int=10) where {F, T<:AbstractFloat} =
    readable(Base.stdout, READABLE, x, base)




function readablestring(r::Readable, x::T, base::Int=10) where {T<:Real}
    str = string(x)
    return readablestring(r, str, base)
end

readablestring(x::T, base::Int=10) where {T<:Real} =
    readablestring(READABLE, x, base)

function readable(io::IO, r::Readable, x::T, base::Int=10) where {T<:Real}
    str = readablestring(r, x, base)
    print(io, str)
end

readable(io::IO, x::T, base::Int=10) where {T<:Real} =
    readable(io, READABLE, x, base)

readable(r::Readable, x::T, base::Int=10) where {T<:Real} =
    readable(Base.stdout, r, x, base)

readable(x::T, base::Int=10) where {F, T<:Real} =
    readable(Base.stdout, READABLE, x, base)



function readablestring(r::Readable, x::T, base::Int=10) where {F, T<:Complex{F}}
    re = real(x)
    im = imag(x)
    sgn = signbit(im) ? " - " : " + "
    im = abs(im)
    re_str = readable(r, string(re), base)
    im_str = readable(r, string(im), base)
    return string(re_str, sgn, im_str, IMAG_UNIT_STR[1])
end

readablestring(x::T, base::Int=10) where {F, T<:Complex{F}} =
    readablestring(READABLE, x, base)

function readable(io::IO, r::Readable, x::T, base::Int=10) where {F, T<:Complex{F}}
    str = readablestring(r, x, base)
    print(io, str)
end

readable(io::IO, x::T, base::Int=10) where {F, T<:Complex{F}} =
    readable(io, READABLE, x, base)

readable(r::Readable, x::T, base::Int=10) where {F, T<:Complex{F}} =
    readable(Base.stdout, r, x, base)

readable(x::T, base::Int=10) where {F, T<:Complex{F}} =
    readable(Base.stdout, READABLE, x, base)



function readablestring(r::Readable, x::T, base::Int=10) where {T<:Number}
     if hasmethod(real, (T,))
        re = real(x)      
        if hasmethod(imag, (T,))
            im = imag(x)
            if isa(im, Real)         
                readablestring(r, re, im, IMAG_UNIT_STR[1], base)
            else
                throw(DomainError("$T is not supported"))
            end
        elseif hasmethod(dual, (T,))
            du = dual(x)
            if isa(im, Real)         
                readablestring(r, re, du, DUAL_UNIT_STR[1], base)
            else
                throw(DomainError("$T is not supported"))
            end
        else
            throw(DomainError("$T is not supported"))
        end
    else           
       throw(DomainError("$T is not supported"))
    end   
end

readablestring(x::T, base::Int=10) where {T<:Number} =
    readablestring(READABLE, x, base)

function readablestring(r::Readable, x::T, y::T, unitstr::String, base::Int=10)  where {T<:Real}
    sgn = signbit(y) ? " - " : " + "
    y = abs(y)
    xstr = readablestring(r, x, base)
    ystr = readablestring(r, y, base)
    return string(xstr, sgn, ystr, unitstr)
end

readablestring(x::T, y::T, unitstr::String, base::Int=10) where {T<:Real} =
    readablestring(READABLE, x, y, unitstr, base)


function readable(io::IO, r::Readable, x::T, base::Int=10) where {T<:Number}
    str = readablestring(r, x, base)
    print(io, str)
end

readable(io::IO, x::T, base::Int=10) where {T<:Number} =
    readable(io, READABLE, x, base)

readable(r::Readable, x::T, base::Int=10) where {T<:Number} =
    readable(Base.stdout, r, x, base)

readable(x::T, base::Int=10) where {T<:Number} =
    readable(Base.stdout, READABLE, x, base)



splitstr(str::AbstractString, at::Union{String, Char}) = String.(split(str, at))
stripstr(str::AbstractString) = String(strip(str))

function readablestring(r::Readable, str::String, base::Int=10)
    if !occursin(READABLE.decpoint, str)
       readable_int(r, BigInt(str), base)
    else
       ipart, fpart = splitstr(str, READABLE.decpoint)
       if occursin("e", fpart)
          fpart, epart = splitstr(fpart, "e")
          epart = (epart[1] !== '-' && epart[1] !== '+') ? string("e+", epart) : string("e", epart)
       else
          epart = ""
       end
       ripart = readable_int(r, BigInt(ipart), base)
       rfpart = readable_frac(r, BigInt(fpart), base)
       string(ripart, r.decpoint, rfpart, epart)
    end
end

       
readablestring(x::String, base::Int=10) =
    readablestring(READABLE, x, base)



function readable_int(r::Readable, x::I, base::Int=10) where {I<:Signed}
    numsign = signbit(x) ? "-" : ""
    str = string(abs(x), base=base)
    ndigs = length(str)
    ngroups, firstgroup = divrem(ndigs, r.intgroup)
       
    ngroups == 0 && return str
              
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
       
    return string(numsign, baseprefix(base), res)   
end

readable_int(x::I, base::Int=10) where {I<:Signed} = readable(READABLE, x, base)


function readable_frac(r::Readable, x::I, base::Int=10) where {I<:Signed}
    signbit(x) && throw(ErrorException("negative fractional parts ($x) are not allowed"))
    str = string(abs(x), base=base)
    ndigs = length(str)
    ngroups, lastgroup = divrem(ndigs, r.fracgroup)
       
    ngroups == 0 && return str
       
    idx = 0
    res = ""
       
    while ngroups > 1
        res = string(res, str[idx+1:idx+r.fracgroup], r.fracsep)
        idx += r.fracgroup
        ngroups -= 1
    end
    if lastgroup == 0
        res = string(res, str[idx+1:end])
    else
        res = string(res, str[idx+1:idx+r.fracgroup], r.fracsep, str[idx+r.fracgroup+1:end])
    end
   
    return res   
end

readable_frac(x::I, base::Int=10) where {I<:Signed} = readable_frac(READABLE, x, base)


function Base.BigInt(str::AbstractString)
   s = stripstr(str)
   nchars = length(s)
   prec = ceil(Int, log2(10) * nchars) + 16
   holdprec = precision(BigFloat)
   setprecision(BigFloat, prec)
   res = BigInt(BigFloat(s))
   setprecision(BigFloat, holdprec)
   return res
end

Base.BigInt(str::SubString) = BigInt(String(str))


end # Readables
