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
    else error("No gc matched: $gc")
    end
end

# ccc (Canonical Combining Class)
function out_ccc(ccc::UInt8)::String
    "UInt8(" * string(ccc, base=10) * ")"
end

###############################################################
# Bidi
function out_BidirectionalClass(bc::BidirectionalClass)::String
    if bc == BidirectionalClasses.AL "AL"
    elseif bc == BidirectionalClasses.AN "AN"
    elseif bc == BidirectionalClasses.B "B"
    elseif bc == BidirectionalClasses.BN "BN"
    elseif bc == BidirectionalClasses.CS "CS"
    elseif bc == BidirectionalClasses.EN "EN"
    elseif bc == BidirectionalClasses.ES "ES"
    elseif bc == BidirectionalClasses.ET "ET"
    elseif bc == BidirectionalClasses.FSI "FSI"
    elseif bc == BidirectionalClasses.L "L"
    elseif bc == BidirectionalClasses.LRE "LRE"
    elseif bc == BidirectionalClasses.LRI "LRI"
    elseif bc == BidirectionalClasses.LRO "LRO"
    elseif bc == BidirectionalClasses.NSM "NSM"
    elseif bc == BidirectionalClasses.ON "ON"
    elseif bc == BidirectionalClasses.PDF "PDF"
    elseif bc == BidirectionalClasses.PDI "PDI"
    elseif bc == BidirectionalClasses.R "R"
    elseif bc == BidirectionalClasses.RLE "RLE"
    elseif bc == BidirectionalClasses.RLI "RLI"
    elseif bc == BidirectionalClasses.RLO "RLO"
    elseif bc == BidirectionalClasses.S "S"
    elseif bc == BidirectionalClasses.WS "WS"
    else error("No bc mathced: $bc")
    end
end

function out_bool(b::Bool)::String
    b ? "true" : "false"
end

function out_codepointset_or_nothing(cp_n::Union{Nothing, CodePointsSet})::String
    if isnothing(cp_n)
        "nothing"
    else
        out_codepoint(cp_n)
    end
end

function out_BidiPairedBracketType(bpt::BidiPairedBracketType)::String
    if bpt == BidiPairedBracketTypes.o
        return "o"
    elseif bpt == BidiPairedBracketTypes.c
        return "c"
    elseif bpt == BidiPairedBracketTypes.n
        return "n"
    else
        error("No bpt matched: bpt = $bpt_str")
    end
end

function out_BidirectionalProperties(bidi::BidirectionalProperties)::String
    "UCDxml.BidirectionalProperties(" * join([
        ("UCDxml.BidirectionalClasses." * out_BidirectionalClass(bidi.bc)),
        out_bool(bidi.Bidi_M),
        out_codepointset_or_nothing(bidi.bmg),
        out_bool(bidi.Bidi_C),
        ("UCDxml.BidiPairedBracketTypes." * out_BidiPairedBracketType(bidi.bpt)),
        out_codepointset_or_nothing(bidi.bpb),
    ], ", ") * ")"
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
            out_BidirectionalProperties(ucd.bidi),
            ], ", "),
        ")",
    )
end


"""
    function write_ucd_coded(;source_path::String, out_path::String)

Write ucd repertoire julia hard code into the file, `out_path`

# KW Arguments
- `source_path::String`: source xml location
- `out_path::String`: output .jl file location
"""
function write_ucd_coded(;source_path::String = "ucd.all.flat.xml", out_path::String = "ucd_coded.jl")
    ucd_repertoire = parse_xml(source_path)
    open(out_path, "w") do io
        # separate definition to avoid stack overflow
        println(io, """
        \"""
            ucd_list::Vector{UCDxml.UCDRepertoireNode}
        
        List of all UCD entries.
        \"""
        """)
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
