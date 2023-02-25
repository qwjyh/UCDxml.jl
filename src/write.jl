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

# age
function wrap_str(str_in::String)::String
    "\"" * str_in * "\""
end

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

############################################################
# general category
function out_general_category(gc::GeneralCategory)::String
    if gc == GeneralCategories.Lu "Lu"
    elseif gc == GeneralCategories.Ll "Ll"
    elseif gc == GeneralCategories.Lt "Lt"
    elseif gc == GeneralCategories.Lm "Lm"
    elseif gc == GeneralCategories.Lo "Lo"
    elseif gc == GeneralCategories.Mn "Mn"
    elseif gc == GeneralCategories.Mc "Mc"
    elseif gc == GeneralCategories.Me "Me"
    elseif gc == GeneralCategories.Nd "Nd"
    elseif gc == GeneralCategories.Nl "Nl"
    elseif gc == GeneralCategories.No "No"
    elseif gc == GeneralCategories.Pc "Pc"
    elseif gc == GeneralCategories.Pd "Pd"
    elseif gc == GeneralCategories.Ps "Ps"
    elseif gc == GeneralCategories.Pe "Pe"
    elseif gc == GeneralCategories.Pi "Pi"
    elseif gc == GeneralCategories.Pf "Pf"
    elseif gc == GeneralCategories.Po "Po"
    elseif gc == GeneralCategories.Sm "Sm"
    elseif gc == GeneralCategories.Sc "Sc"
    elseif gc == GeneralCategories.Sk "Sk"
    elseif gc == GeneralCategories.So "So"
    elseif gc == GeneralCategories.Zs "Zs"
    elseif gc == GeneralCategories.Zl "Zl"
    elseif gc == GeneralCategories.Zp "Zp"
    elseif gc == GeneralCategories.Cc "Cc"
    elseif gc == GeneralCategories.Cf "Cf"
    elseif gc == GeneralCategories.Cs "Cs"
    elseif gc == GeneralCategories.Co "Co"
    elseif gc == GeneralCategories.Cn "Cn"
    else error("No gc matched \n gc = $gc_str")
    end
end

# ccc (Canonical Combining Class)
function out_ccc(ccc::Int16)::String
    string(ccc, base=10)
end

###############################################################
# main

function write_repertoire(io::IO, ucd::UCDRepertoireNode)::Nothing
    print(io,
        "UCDxml.UCDRepertoireNode(", join([
            out_codepointtype(ucd.type),
            out_codepoint(ucd.cp),
            wrap_str(ucd.age),
            wrap_str(ucd.na),
            wrap_str(ucd.na1),
            out_name_alias_vec(ucd.name_alias),
            wrap_str(ucd.blk),
            ("UCDxml.GeneralCategories." * out_general_category(ucd.gc)),
            out_ccc(ucd.ccc),
            ], ", "),
        ")",
    )
end



function write_ucd_coded()
    open("ucd_coded.jl", "w") do io
        println(io, "include(\"typedef.jl\")")
    end
end
