# parse xml

import EzXML

##############################################################
# code point set
function parse_singlecodepoint(str::AbstractString)::SingleCodePoint
    SingleCodePoint(parse(UInt32, str, base = 16))
end

function get_codepoint(node::EzXML.Node)::CodePointsSet
    cps = try
        parse_singlecodepoint(node["cp"])
    catch
        first = parse(UInt32, node["first-cp"], base = 16)
        last = parse(UInt32, node["last-cp"], base = 16)
        RangeCodePoint(first, last)
    end
    return cps
end

function Base.:(==)(a::T, b::T) where T<:SingleCodePoint
    a.cp == b.cp
end

function Base.:(==)(a::T, b::T) where T<:RangeCodePoint
    a.first == b.first && a.last == b.last
end


###############################################################
# code point type

function get_codepointtype(node::EzXML.Node)::CodePointType
    nodename = EzXML.nodename(node)
    if nodename == "char"
        return char
    elseif nodename == "reserved"
        return reserved
    elseif nodename == "noncharacter"
        return noncharacter
    elseif nodename == "surrogate"
        return surrogate
    else
        @error "no code point type matched"
    end
end



#################################################################
# properties

# age
function get_age(node::EzXML.Node)::String
    return node["age"]
end

# name
"replace # with actual number when cp is single code point."
function get_name(node::EzXML.Node, cp::T)::String where T<:CodePointsSet
    raw_na = node["na"]
    # replace '#' with codepoint number to get formal name
    if isnothing(findfirst('#', raw_na))
        return raw_na
    else
        if typeof(cp) == SingleCodePoint
            cp_str = format(cp)
            id = x -> x
            return split(raw_na, '#') |>
                x -> zip(x, fill(cp_str, (length(x) - 1, ))) |>
                Iterators.flatten |>
                x -> mapreduce(id, *, x)
        else
            return raw_na
        end
    end
end

function get_na1(node::EzXML.Node)::String
    return node["na1"]
end

# name alias
function get_namealiases(node::EzXML.Node)::Vector{NameAlias}
    aliases = NameAlias[]
    for child in elements(node)
        push!(
            aliases,
            NameAlias(
                child["alias"],
                child["type"],
            )
        )
    end
    return aliases
end

# Block
function get_block(node::EzXML.Node)::String
    try
        node["blk"]
    catch
        ""
    end
end

# general category
function get_generalcategory(node::EzXML.Node)::GeneralCategory
    gc_str = String("")
    try
        gc_str = node["gc"]
    catch
        error("Failed to get gc(General Category).")
    end
    if gc_str == "Lu" GeneralCategories.Lu
    elseif gc_str == "Ll" GeneralCategories.Ll
    elseif gc_str == "Lt" GeneralCategories.Lt
    elseif gc_str == "Lm" GeneralCategories.Lm
    elseif gc_str == "Lo" GeneralCategories.Lo
    elseif gc_str == "Mn" GeneralCategories.Mn
    elseif gc_str == "Mc" GeneralCategories.Mc
    elseif gc_str == "Me" GeneralCategories.Me
    elseif gc_str == "Nd" GeneralCategories.Nd
    elseif gc_str == "Nl" GeneralCategories.Nl
    elseif gc_str == "No" GeneralCategories.No
    elseif gc_str == "Pc" GeneralCategories.Pc
    elseif gc_str == "Pd" GeneralCategories.Pd
    elseif gc_str == "Ps" GeneralCategories.Ps
    elseif gc_str == "Pe" GeneralCategories.Pe
    elseif gc_str == "Pi" GeneralCategories.Pi
    elseif gc_str == "Pf" GeneralCategories.Pf
    elseif gc_str == "Po" GeneralCategories.Po
    elseif gc_str == "Sm" GeneralCategories.Sm
    elseif gc_str == "Sc" GeneralCategories.Sc
    elseif gc_str == "Sk" GeneralCategories.Sk
    elseif gc_str == "So" GeneralCategories.So
    elseif gc_str == "Zs" GeneralCategories.Zs
    elseif gc_str == "Zl" GeneralCategories.Zl
    elseif gc_str == "Zp" GeneralCategories.Zp
    elseif gc_str == "Cc" GeneralCategories.Cc
    elseif gc_str == "Cf" GeneralCategories.Cf
    elseif gc_str == "Cs" GeneralCategories.Cs
    elseif gc_str == "Co" GeneralCategories.Co
    elseif gc_str == "Cn" GeneralCategories.Cn
    else error("No gc matched \n gc = $gc_str")
    end
end


# ccc (Cannonical Combining Class)
"ccc (Canonical Combining Class). `` 0 \\leq ccc \\leq 240``"
function get_ccc(node::EzXML.Node)::UInt8
    try
        parse(UInt8, node["ccc"], base=10)
    catch
        error("Failed to get ccc.")
    end
end

# bidi
function get_bidirectional_class(node::EzXML.Node)::BidirectionalClass
    bc_str = String("")
    try
        bc_str = node["bc"]
    catch
        error("Failed to get bc(Bidirectional Class).")
    end
    if bc_str == "AL" BidirectionalClasses.AL
    elseif bc_str == "AN" BidirectionalClasses.AN
    elseif bc_str == "B" BidirectionalClasses.B
    elseif bc_str == "BN" BidirectionalClasses.BN
    elseif bc_str == "CS" BidirectionalClasses.CS
    elseif bc_str == "EN" BidirectionalClasses.EN
    elseif bc_str == "ES" BidirectionalClasses.ES
    elseif bc_str == "ET" BidirectionalClasses.ET
    elseif bc_str == "FSI" BidirectionalClasses.FSI
    elseif bc_str == "L" BidirectionalClasses.L
    elseif bc_str == "LRE" BidirectionalClasses.LRE
    elseif bc_str == "LRI" BidirectionalClasses.LRI
    elseif bc_str == "LRO" BidirectionalClasses.LRO
    elseif bc_str == "NSM" BidirectionalClasses.NSM
    elseif bc_str == "ON" BidirectionalClasses.ON
    elseif bc_str == "PDF" BidirectionalClasses.PDF
    elseif bc_str == "PDI" BidirectionalClasses.PDI
    elseif bc_str == "R" BidirectionalClasses.R
    elseif bc_str == "RLE" BidirectionalClasses.RLE
    elseif bc_str == "RLI" BidirectionalClasses.RLI
    elseif bc_str == "RLO" BidirectionalClasses.RLO
    elseif bc_str == "S" BidirectionalClasses.S
    elseif bc_str == "WS" BidirectionalClasses.WS
    else error("No bc matched: bc = $bc_str")
    end
end

"""
Translate bool property strings described in 2.5 Common attributes in UAX#42.
"""
function get_bool(node::EzXML.Node, key::String)::Bool
    if node[key] == "Y"
        return true
    elseif node[key] == "N"
        return false
    else
        error("Bool parse failed: str = $(node[key])")
    end
end

function get_codepointset_or_nothing(node::EzXML.Node, key::String)::Union{Nothing, CodePointsSet}
    if node[key] == String("")
        return nothing
    else
        if node[key] == "#" # this points itself
            # TODO: performance issue?
            return get_codepoint(node)
        else
            return parse_singlecodepoint(node[key]) # TODO: no error handling
        end
    end
end

function get_BidiPairedBracketType(node::EzXML.Node)::BidiPairedBracketType
    bpt_str = String("")
    try
        bpt_str = node["bpt"]
    catch
        error("Failed to get bpt.")
    end
    if bpt_str == "o"
        return BidiPairedBracketTypes.o
    elseif bpt_str == "c"
        return BidiPairedBracketTypes.c
    elseif bpt_str == "n"
        return BidiPairedBracketTypes.n
    else
        error("No bpt matched: bpt = $bpt_str")
    end
end

function get_bidirectional_properties(node::EzXML.Node)::BidirectionalProperties
    return BidirectionalProperties(
        get_bidirectional_class(node),
        get_bool(node, "Bidi_M"),
        get_codepointset_or_nothing(node, "bmg"),
        get_bool(node, "Bidi_C"),
        get_BidiPairedBracketType(node),
        get_codepointset_or_nothing(node, "bpb")
    )
end

# decomposition
function get_DecompositionType(node::EzXML.Node)::DecompositionType
    dt_str = node["dt"]  # try catch?
    if dt_str == "can" DecompositionTypes.can
    elseif dt_str == "com" DecompositionTypes.com
    elseif dt_str == "enc" DecompositionTypes.enc
    elseif dt_str == "fin" DecompositionTypes.fin
    elseif dt_str == "font" DecompositionTypes.font
    elseif dt_str == "fra" DecompositionTypes.fra
    elseif dt_str == "init" DecompositionTypes.init
    elseif dt_str == "iso" DecompositionTypes.iso
    elseif dt_str == "med" DecompositionTypes.med
    elseif dt_str == "nar" DecompositionTypes.nar
    elseif dt_str == "nb" DecompositionTypes.nb
    elseif dt_str == "sml" DecompositionTypes.sml
    elseif dt_str == "sqr" DecompositionTypes.sqr
    elseif dt_str == "sub" DecompositionTypes.sub
    elseif dt_str == "sup" DecompositionTypes.sup
    elseif dt_str == "vert" DecompositionTypes.vert
    elseif dt_str == "wide" DecompositionTypes.wide
    elseif dt_str == "none" DecompositionTypes.none
    else error("No dt matched: dt = $dt_str")
    end
end

function get_singlecodepoint_vec_from_str(node::EzXML.Node, key::String)::Union{CodePointsSet, Vector{SingleCodePoint}}
    str = ""
    try
        str = node[key]
    catch
        error("Failed to get str.")
    end
    if str == "#"
        return get_codepoint(node)
    else
        return split(str, " ") .|> parse_singlecodepoint
    end
end

function get_QuickCheckProperty(node::EzXML.Node, key::String)::QuickCheckProperty
    str = ""
    try
        str = node[key]
    catch
        error("Failed to get str of key $key")
    end
    if str == "Y"
        return QuickCheckProperties.Yes
    elseif str == "N"
        return QuickCheckProperties.No
    elseif str == "M"
        return QuickCheckProperties.Maybe
    else
        error("No qc property matched: $str")
    end
end

function get_DecompositionProperties(node::EzXML.Node)::DecompositionProperties
    return DecompositionProperties(
        get_DecompositionType(node),
        get_singlecodepoint_vec_from_str(node, "dm"),
        get_bool(node, "CE"),
        get_bool(node, "Comp_Ex"),
        get_QuickCheckProperty(node, "NFC_QC"),
        get_QuickCheckProperty(node, "NFD_QC"),
        get_QuickCheckProperty(node, "NFKC_QC"),
        get_QuickCheckProperty(node, "NFKD_QC"),
        get_bool(node, "XO_NFC"),
        get_bool(node, "XO_NFD"),
        get_bool(node, "XO_NFKC"),
        get_bool(node, "XO_NFKD"),
        get_singlecodepoint_vec_from_str(node, "FC_NFKC")
    )
end

# """
# # Fields
# - `nt`: numeric type (enum)
# - `nv`: numeric value {"NaN" | xsd:string { pattern = "-?[0-9]+(/[0-9]+)?" }}?
# """
# struct NumericProperties
#     nt::NumericType
#     nv::String
# end

# @enum NumericType begin
#     None
#     De
#     Di
#     Nu
# end

# """
# # Fields
# - `jt`: joining class
# - `jg`: joining group
# - `Join_C`: Join_Control
# """
# struct JoiningProperties
#     jt::JoiningType
#     jg::String
#     Join_C::Bool
# end
# @enum JoiningType U C T D L R


# "Line_Break property"
# @enum LineBreakProperties begin
#     AI; AL;
#     B2; BA; BB; BK;
#     CB; CJ; CL; CM; CP; CR;
#     EB; EM; EX;
#     GL;
#     H2; H3; HL; HY;
#     ID; IN; IS;
#     JL; JT; JV;
#     LF;
#     NL; NS; NU;
#     OP;
#     PO; PR;
#     QU;
#     RI;
#     SA; SG; SP; SY;
#     WJ;
#     XX;
#     ZW; ZWJ;
# end

# @enum EastAsianWidth begin
#     A; F; H; N; Na; W;
# end


# """
# # Fields
# - `Upper`
# - `Lower`
# - `OUpper`: Other_Uppercase
# - `OLower`: Other_Lowercase
# - `suc`, `slc`, `stc`: simple case mappings
# - `uc`, `lc`, `tc`: non-simple casing
# - `scf`: Simple_Case_Folding
# - `cf`: Case_Folding
# - `CI`: Case_Ignorable
# - `Cased`: Cased
# - `CWCF`: Changes_When_Casefolded
# - `CWCM`: Changes_When_Casemapped
# - `CWL`: Changes_When_Lowercased
# - `CWKCF`: Changes_When_NFKC_Casefolded
# - `CWT`: Changes_When_Titlecased
# - `CWU`: Changes_When_Uppercased
# - `NFKC_CF`: NKFC_Casefold
# """
# struct CaseProperties
#     Upper::Bool
#     Lower::Bool
#     OUpper::Bool
#     OLower::Bool
#     suc::SingleCodePoint
#     slc::SingleCodePoint
#     stc::SingleCodePoint
#     uc::Vector{SingleCodePoint}
#     lc::Vector{SingleCodePoint}
#     tc::Vector{SingleCodePoint}
#     scf::SingleCodePoint
#     cf::Vector{SingleCodePoint}
#     CI::Bool
#     Cased::Bool
#     CWCF::Bool
#     CWCM::Bool
#     CWL::Bool
#     CWKCF::Bool
#     CWT::Bool
#     CWU::Bool
#     NFKC_CF::Vector{SingleCodePoint}
# end

# @enum Script begin
#     Adlm ; Aghb ; Ahom ; Arab ; Armi ; Armn ; Avst
#     Bali ; Bamu ; Bass ; Batk ; Beng ; Bhks
#     Bopo ; Brah ; Brai ; Bugi ; Buhd
#     Cakm ; Cans ; Cari ; Cham ; Cher ; Chrs ; Copt
#     Cpmn ; Cprt ; Cyrl
#     Deva ; Diak ; Dogr ; Dsrt ; Dupl
#     Elba ; Elym ; Egyp ; Ethi
#     Geor ; Glag ; Gong ; Gonm ; Goth ; Gran ; Grek
#     Gujr ; Guru
#     Hang ; Hani ; Hano ; Hatr ; Hebr ; Hira ; Hluw
#     Hmng ; Hmnp ; Hrkt ; Hung
#     Ital
#     Java
#     Kali ; Kana ; Kawi ; Khar ; Khmr ; Khoj ; Kits
#     Knda ; Kthi
#     Lana ; Laoo ; Latn ; Lepc ; Limb ; Lina ; Linb
#     Lisu ; Lyci ; Lydi
#     Mahj ; Maka ; Mand ; Mani ; Marc
#     Medf ; Mend ; Merc ; Mero ; Mlym
#     Modi ; Mong ; Mroo ; Mtei ; Mult ; Mymr
#     Nagm ; Nand ; Narb ; Nbat ; Newa ; Nkoo ; Nshu
#     Ogam ; Olck ; Orkh ; Orya ; Osge ; Osma ; Ougr
#     Palm ; Pauc ; Perm ; Phag ; Phli ; Phlp ; Phnx
#     Plrd ; Prti
#     Qaai
#     Rohg ; Rjng ; Runr
#     Samr ; Sarb ; Saur ; Sgnw ; Shaw ; Shrd ; Sidd
#     Sind ; Sinh ; Sogd ; Sogo ; Sora ; Soyo ; Sund
#     Sylo ; Syrc
#     Tagb ; Takr ; Tale ; Talu ; Taml ; Tang ; Tavt
#     Telu ; Tfng ; Tglg ; Thaa ; Thai ; Tibt ; Tirh
#     Tnsa ; Toto
#     Ugar
#     Vaii ; Vith
#     Wara ; Wcho
#     Xpeo ; Xsux
#     Yezi ; Yiii
#     Zanb ; Zinh ; Zyyy ; Zzzz
# end

# """
# # Fields
# - `hst`: Hangul_Syllable_Type
# - `JSN`: Jamo_Short_Name
# """
# struct HangulProperties
#     hst::HangulSyllableType
#     JSN::String
# end

# @enum HangulSyllableType begin
#     L; LV; LVT; T; V; NA;
# end

# """
# # Fields
# - `InSC`: Indic_Syllabic_Category
# - `InMC`: Indic_Matra_Category
# - `InPC`: Indic_Positional_Category
# """
# struct IndicProperties
#     InSC::String
#     InMC::String
#     InPC::String
# end

# """
# Identifier and Pattern and programming language properties
# __undocumented__
# """
# struct IdPtProperties
#     IDS::Bool
#     OIDS::Bool
#     XIDS::Bool
#     IDC::Bool
#     OIDC::Bool
#     XIDC::Bool
#     Pat_Syn::Bool
#     Pat_WS::Bool
# end


# struct EmojiProperties
#     Emoji::Bool
#     EPres::Bool
#     EMod::Bool
#     EBase::Bool
#     EComp::Bool
#     ExtPict::Bool
# end

##################################################################################
# main

function get_repertoire_info(node::EzXML.Node)::UCDRepertoireNode
    type = get_codepointtype(node)
    cp = get_codepoint(node)
    age = get_age(node)
    na = get_name(node, cp)
    na1 = get_na1(node)
    name_alias = get_namealiases(node)
    blk = get_block(node)
    gc = get_generalcategory(node)
    ccc = get_ccc(node)
    bidi = get_bidirectional_properties(node)
    decomp = get_DecompositionProperties(node)

    return UCDRepertoireNode(
        type,
        cp,
        age,
        na,
        na1,
        name_alias,
        blk,
        gc,
        ccc,
        bidi,
        decomp,
    )
end

function Base.show(io::IO, r::UCDRepertoireNode)
    dump(io, r)
end

function Base.:(==)(a::T, b::T) where T<:UCDRepertoireNode
    fv = fieldnames(T)
    # (map(f->getfield(a, f), fv), map(f->getfield(b, f), fv)) |>
        # zip |>
        # x -> map(x->(x[1]==x[2]), x) |>
        # bv -> reduce(&, bv)
    # map(
    #     x->(x[1]==x[2]),
    #     zip(
    #         map(f->getfield(a, f), fv),
    #         map(f->getfield(b, f), fv)
    #     )
    # ) |>
    #     bv -> reduce(&, bv)
    getfield.(Ref(a), fv) == getfield.(Ref(b), fv)
end


function Base.:(==)(a::T, b::T) where T<:Property
    f = fieldnames(T)
    getfield.(Ref(a), f) == getfield.(Ref(b), f)
end

function diff_ucd(a::T, b::T) where T<:UCDRepertoireNode
    fv = fieldnames(T)
    for f in fv
        if getfield(a, f) != getfield(b, f)
            println("mismatched: $f")
        end
    end
end
