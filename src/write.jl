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
        return "UCDxml.char"
    elseif type == reserved
        return "UCDxml.reserved"
    elseif type == noncharacter
        return "UCDxml.noncharacter"
    elseif type == surrogate
        return "UCDxml.surrogate"
    else
        @error "no code point type matched"
    end
end

##############################################################
# properties

##########################################################
# name_alias
function out_name_alias_vec(nav::Vector{NameAlias})::String
    if length(nav) == 0
        "UCDxml.NameAlias[]"
    else
        "[" *
        join(
            map(out_name_alias, nav),
            ", "
        ) *
        "]"
    end
end

function out_name_alias(na::NameAlias)::String
    "UCDxml.NameAlias(\"" * na.alias * "\", \"" * na.type * "\")"
end

###############################################################
# main

function write_repertoire(io::IO, ucd::UCDRepertoireNode)::Nothing
    println(io,
        "UCDxml.UCDRepertoireNode(",
            out_codepointtype(ucd.type),
            out_codepoint(ucd.cp),
            ucd.age,
            ucd.na,
            ucd.na1,
        ")",
    )
end



function write_ucd_coded()
    open("ucd_coded.jl", "w") do io
        println(io, "include(\"typedef.jl\")")
    end
end
