##############################################################
# code point set
function out_codepoint(cps::SingleCodePoint)::String
    "UCDxml.SingleCodePoint(UInt32(" * format(cps) * "))"
end

function out_codepoint(cps::RangeCodePoint)::String
    "UCDxml.RangeCodePoint(\
        UInt32(" * string(cps.first, base=16) * "),\
        UInt32(" * string(cps.last, base=16) * ")\
    )"
end

###############################################################
# code point type
function out_codepointtype(type::CodePointType)::String
    if type == char
        return "char"
    elseif type == reserved
        return "reserved"
    elseif type == noncharacter
        return "noncharacter"
    elseif type == surrogate
        return "surrogate"
    else
        @error "no code point type matched"
    end
end


###############################################################
# main

function write_repertoire(io::IO, ucd::UCDRepertoireNode)::Nothing
    println(io,
        "UCDxml.UCDRepertoireNode(",
            out_codepoint(ucd.cp),
        ")"
    )
end



function write_ucd_coded()
    open("ucd_coded.jl", "w") do io
        println(io, "include(\"typedef.jl\")")
    end
end
