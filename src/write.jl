##############################################################
# code point set
function out_codepoint(cps::SingleCodePoint)::String
    "UCDxml.SingleCodePoint(UInt32(0x" * format(cps) * "))"
end

function out_codepoint(cps::RangeCodePoint)::String
    "UCDxml.RangeCodePoint(" *
        "UInt32(0x" * string(cps.first, base=16) * ")," *
        "UInt32(0x" * string(cps.last, base=16) * ")" *
    ")"
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
function out_ccc(ccc::UInt8)::String
    "UInt8(" * string(ccc, base=10) * ")"
end

###############################################################
# main
"""
    function write_repertoire(io::IO, ucd::UCDRepertoireNode)::Nothing

Write single ucd repertoire node into `IO`.
"""
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


"""
Write ucd repertoire julia hard code into the file, "ucd_coded.jl"
"""
function write_ucd_coded()
    ucd_repertoire = parse_xml()
    open("ucd_coded.jl", "w") do io
        # println(io, "include(\"typedef.jl\")")
        # println(io, "using UCDxml")
        println(io, "ucd_list = UCDxml.UCDRepertoireNode[]")
        num_ucd_repertoire = length(ucd_repertoire)
        block_size = num_ucd_repertoire ÷ 100
        println(io, "blk = [")
        for (i, ucd) in enumerate(ucd_repertoire)
            if i % block_size == 0
                println(io, "]")
                println(io, "append!(ucd_list, blk)")
                println(io, "blk = [")
            end
            write_repertoire(io, ucd)
            println(io, ",")
        end
        println(io, "]")
        println(io, "append!(ucd_list, blk)")
    end
end
