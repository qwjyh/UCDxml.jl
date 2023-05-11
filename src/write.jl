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
        error("No bpt matched: bpt = $bpt")
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
# decomp
function out_DecompositionType(dt::DecompositionType)::String
    if dt == DecompositionTypes.can "can"
    elseif dt == DecompositionTypes.com "com"
    elseif dt == DecompositionTypes.enc "enc"
    elseif dt == DecompositionTypes.fin "fin"
    elseif dt == DecompositionTypes.font "font"
    elseif dt == DecompositionTypes.fra "fra"
    elseif dt == DecompositionTypes.init "init"
    elseif dt == DecompositionTypes.iso "iso"
    elseif dt == DecompositionTypes.med "med"
    elseif dt == DecompositionTypes.nar "nar"
    elseif dt == DecompositionTypes.nb "nb"
    elseif dt == DecompositionTypes.sml "sml"
    elseif dt == DecompositionTypes.sqr "sqr"
    elseif dt == DecompositionTypes.sub "sub"
    elseif dt == DecompositionTypes.sup "sup"
    elseif dt == DecompositionTypes.vert "vert"
    elseif dt == DecompositionTypes.wide "wide"
    elseif dt == DecompositionTypes.none "none"
    else error("No dt matched: dt = $dt")
    end
end

function out_singlecodepoint_vec_or_cpset(cps::CodePointsSet)::String
    out_codepoint(cps)
end
function out_singlecodepoint_vec_or_cpset(cps::Vector{SingleCodePoint})::String
    "[" * join(map(out_codepoint, cps), ", ") * "]"
end

function out_QuickCheckProperty(qcp::QuickCheckProperty)::String
    if qcp == QuickCheckProperties.Yes "UCDxml.QuickCheckProperties.Yes"
    elseif qcp == QuickCheckProperties.No "UCDxml.QuickCheckProperties.No"
    elseif qcp == QuickCheckProperties.Maybe "UCDxml.QuickCheckProperties.Maybe"
    else error("No QuickCheckProperties matched: $qcp")
    end
end

function out_DecompositionProperties(decomp::DecompositionProperties)::String
    "UCDxml.DecompositionProperties(" * join([
        ("UCDxml.DecompositionTypes." * out_DecompositionType(decomp.dt)),
        out_singlecodepoint_vec_or_cpset(decomp.dm),
        out_bool(decomp.CE),
        out_bool(decomp.Comp_Ex),
        out_QuickCheckProperty(decomp.NFC_QC),
        out_QuickCheckProperty(decomp.NFD_QC),
        out_QuickCheckProperty(decomp.NFKC_QC),
        out_QuickCheckProperty(decomp.NFKD_QC),
        out_bool(decomp.XO_NFC),
        out_bool(decomp.XO_NFD),
        out_bool(decomp.XO_NFKC),
        out_bool(decomp.XO_NFKD),
        out_singlecodepoint_vec_or_cpset(decomp.FC_NFKC),
    ], ", ") * ")"
end

###############################################################
# numeric
function out_NumericType(nt::NumericType)::String
    "UCDxml." * if nt == NumericTypes.None "NumericTypes.None"
    elseif nt == NumericTypes.De "NumericTypes.De"
    elseif nt == NumericTypes.Di "NumericTypes.Di"
    elseif nt == NumericTypes.Nu "NumericTypes.Nu"
    else error("No nt matched.")
    end
end

function out_NumericProperties(numeric::NumericProperties)::String
    "UCDxml.NumericProperties(" *
        out_NumericType(numeric.nt) * ", " *
        string(numeric.nv) * ", " *
    ")"
end

###############################################################
# joining
function out_JoiningType(jt::JoiningType)::String
    "UCDxml." * if jt == JoiningTypes.U "JoiningTypes.U"
    elseif jt == JoiningTypes.C "JoiningTypes.C"
    elseif jt == JoiningTypes.T "JoiningTypes.T"
    elseif jt == JoiningTypes.D "JoiningTypes.D"
    elseif jt == JoiningTypes.L "JoiningTypes.L"
    elseif jt == JoiningTypes.R "JoiningTypes.R"
    else error("No jt matched.")
    end
end

function out_JoiningProperties(joining::JoiningProperties)::String
    "UCDxml.JoiningProperties(" *
        out_JoiningType(joining.jt) * ", " *
        wrap_str(joining.jg) * ", " *
        out_bool(joining.Join_C) * ", " *
    ")"
end

###############################################################
# lb
function out_LineBreakProperty(lb::LineBreakProperty)::String
    "UCDxml." * if lb == LineBreakProperties.AI "LineBreakProperties.AI"
    elseif lb == LineBreakProperties.AL "LineBreakProperties.AL"
    elseif lb == LineBreakProperties.B2 "LineBreakProperties.B2"
    elseif lb == LineBreakProperties.BA "LineBreakProperties.BA"
    elseif lb == LineBreakProperties.BB "LineBreakProperties.BB"
    elseif lb == LineBreakProperties.BK "LineBreakProperties.BK"
    elseif lb == LineBreakProperties.CB "LineBreakProperties.CB"
    elseif lb == LineBreakProperties.CJ "LineBreakProperties.CJ"
    elseif lb == LineBreakProperties.CL "LineBreakProperties.CL"
    elseif lb == LineBreakProperties.CM "LineBreakProperties.CM"
    elseif lb == LineBreakProperties.CP "LineBreakProperties.CP"
    elseif lb == LineBreakProperties.CR "LineBreakProperties.CR"
    elseif lb == LineBreakProperties.EB "LineBreakProperties.EB"
    elseif lb == LineBreakProperties.EM "LineBreakProperties.EM"
    elseif lb == LineBreakProperties.EX "LineBreakProperties.EX"
    elseif lb == LineBreakProperties.GL "LineBreakProperties.GL"
    elseif lb == LineBreakProperties.H2 "LineBreakProperties.H2"
    elseif lb == LineBreakProperties.H3 "LineBreakProperties.H3"
    elseif lb == LineBreakProperties.HL "LineBreakProperties.HL"
    elseif lb == LineBreakProperties.HY "LineBreakProperties.HY"
    elseif lb == LineBreakProperties.ID "LineBreakProperties.ID"
    elseif lb == LineBreakProperties.IN "LineBreakProperties.IN"
    elseif lb == LineBreakProperties.IS "LineBreakProperties.IS"
    elseif lb == LineBreakProperties.JL "LineBreakProperties.JL"
    elseif lb == LineBreakProperties.JT "LineBreakProperties.JT"
    elseif lb == LineBreakProperties.JV "LineBreakProperties.JV"
    elseif lb == LineBreakProperties.LF "LineBreakProperties.LF"
    elseif lb == LineBreakProperties.NL "LineBreakProperties.NL"
    elseif lb == LineBreakProperties.NS "LineBreakProperties.NS"
    elseif lb == LineBreakProperties.NU "LineBreakProperties.NU"
    elseif lb == LineBreakProperties.OP "LineBreakProperties.OP"
    elseif lb == LineBreakProperties.PO "LineBreakProperties.PO"
    elseif lb == LineBreakProperties.PR "LineBreakProperties.PR"
    elseif lb == LineBreakProperties.QU "LineBreakProperties.QU"
    elseif lb == LineBreakProperties.RI "LineBreakProperties.RI"
    elseif lb == LineBreakProperties.SA "LineBreakProperties.SA"
    elseif lb == LineBreakProperties.SG "LineBreakProperties.SG"
    elseif lb == LineBreakProperties.SP "LineBreakProperties.SP"
    elseif lb == LineBreakProperties.SY "LineBreakProperties.SY"
    elseif lb == LineBreakProperties.WJ "LineBreakProperties.WJ"
    elseif lb == LineBreakProperties.XX "LineBreakProperties.XX"
    elseif lb == LineBreakProperties.ZW "LineBreakProperties.ZW"
    elseif lb == LineBreakProperties.ZWJ "LineBreakProperties.ZWJ"
    else error("No lb matched.")
    end
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
            out_DecompositionProperties(ucd.decomp),
            out_NumericProperties(ucd.numeric),
            out_JoiningProperties(ucd.joining),
            out_LineBreakProperty(ucd.lb),
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
        print(io, """
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
            # show(io, ucd)
            println(io, ",")
        end
        println(io, "]")
        println(io, "append!(ucd_list, blk)")
    end
end
