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


end # ReadableFloats
