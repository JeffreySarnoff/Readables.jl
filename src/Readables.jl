module Readables

export readable,
       Readable,
       decpoint, setdecpoint,
       intsep, setintsep, intgroup, setintgroup,
       fracsep, setfracsep, fracgroup, setfracgroup

const IMAG_UNIT_STR[1] = "𝛊"
const DUAL_UNIT_STR[1] = "ε"

struct Readable
    decpoint::Char
    intsep::Char
    intgroup::Int
    fracsep::Char
    fracgroup::Int

    function Readable()
        return new('.', ',', 3, '_', 5)
    end
    function Readable(decpoint::Char, intsep::Char, intgroup::Int, fracsep::Char, fracgroup::Int)
        return new(decpoint, intsep, intgroup, fracsep, fracgroup)
    end
end

const READABLE = Readable()

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

setdecpoint(decpoint::Char) = setdecpoint(READABLE, decpoint)
setintsep(intsep::Char) = setintsep(READABLE, intsep)
setintgroup(intgroup::Int) = setintgroup(READABLE, intgroup)
setfracsep(fracsep::Char) = setfracsep(READABLDE, fracsep)
setfracgroup(fracgroup::Int) = setfracgroup(READABLE, fracgroup)

const radixprefixes = Dict(2=>"0b", 8=>"0o", 10=>"", 16=>"0x")
function radixprefix(x::Int)
    res = get(radixprefixes, x, nothing)
    res === nothing && throw(ErrorException("radix $x is not supported"))
    return res
end


function readable(r::Readable, x::R, radix::Int=10) where {R<:Real}
    str = string(x)
    return readable(r, str, radix)
end

function readable(r::Readable, str::String, radix::Int=10)
    if !occursin(READABLE.decpoint, str)
       readable_int(r, BigInt(str), radix)
    else
       ipart, fpart = splitstr(str, READABLE.decpoint)
       if occursin("e", fpart)
          fpart, epart = splitstr(fpart, "e")
          epart = (epart[1] !== '-' && epart[1] !== '+') ? string("e+", epart) : string("e", epart)
       else
          epart = ""
       end
       ripart = readable_int(r, BigInt(ipart), radix)
       rfpart = readable_frac(r, BigInt(fpart), radix)
       string(ripart, r.decpoint, rfpart, epart)
    end
end

readable(io::IO, x::T, radix::Int=10) where {T<:Real} = print(io, readable(READABLE, string(x), radix))
readable(x::T, radix::Int=10) where {T<:Real} = print(Base.stdout, readable(READABLE, string(x), radix))
       
readable(x::String, radix::Int=10) = readable(READABLE, x, radix)

readable(x::F, radix::Int=10) where {F<:AbstractFloat} = readable(READABLE, x, radix)

readable(r::Readable, x::I, radix::Int=10) where {I<:Signed} = readable_int(r, x, radix)
readable(x::I, radix::Int=10) where {I<:Signed} = readable_int(x, radix)

readable(ri::C, radix::Int=10) where {F, C<:Complex{F}} =
    string(readable(real(ri), radix), (signbit(imag(ri)) ? "-" : "+"), readable(abs(imag(ri)), radix), IMAG_UNIT_STR[1])

function readable_int(r::Readable, x::I, radix::Int=10) where {I<:Signed}
    numsign = signbit(x) ? "-" : ""
    str = string(abs(x), base=radix)
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
       
    return string(numsign, radixprefix(radix), res)   
end

readable_int(x::I, radix::Int=10) where {I<:Signed} = readable(READABLE, x, radix)


function readable_frac(r::Readable, x::I, radix::Int=10) where {I<:Signed}
    signbit(x) && throw(ErrorException("negative fractional parts ($x) are not allowed"))
    str = string(abs(x), base=radix)
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

readable_frac(x::I, radix::Int=10) where {I<:Signed} = readable_frac(READABLE, x, radix)


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

splitstr(str::AbstractString, at::Union{String, Char}) = String.(split(str, at))
stripstr(str::AbstractString) = String(strip(str))


function readable(r::Readable, x::T, base::Int=10) where {F, T<:Complex{F}}
    re = real(x)
    im = imag(x)
    sgn = signbit(im) ? " - " : " + "
    im = abs(im)
    re_str = readable(r, string(re), base)
    im_str = readable(r, string(im), base)
    string(re_str, sgn, im_str, IMAG_UNIT_STR[1])
end

readable(x::T, base::Int=10) where {F, T<:Complex{F}} =
    readable(READABLE, x, base)

function readable(r::Readable, x::T, y::T, base::Int=10, unitstr::String) where {T<:Real}
    sgn = signbit(y) ? " - " : " + "
    y = abs(y)
    xstr = readable(string(x))
    ystr = readable(string(y))
    string(xstr, sgn, ystr, unitstr)
end

readable(x::T, y::T, base::Int=10, unitstr::String) where {T<:Real} =
    readable(READABLE, x, y, base, unitstr)

function readable(r::Readable, x::T, base::Int=10) where {T<:Number}
     if hasmethod(T, real)
        re = real(x)      
        if hasmethod(T, imag)
            im = imag(x)
            if isa(im, Real)         
                readable(r, re, im, base, IMAG_UNIT_STR[1])
            else
                throw(DomainError("$T is not supported"))
            end
        elseif hasmethod(T, dual)
            du = dual(x)
            if isa(im, Real)         
                readable(r, re, du, base, DUAL_UNIT_STR[1])
            else
                throw(DomainError("$T is not supported"))
            end
        else
            throw(DomainError("$T is not supported"))
        end
    end           
    throw(DomainError("$T is not supported"))
end

readable(x::T, base::Int=10) where {T<:Number} =
    readable(READABLE, x, base)

end # Readables
