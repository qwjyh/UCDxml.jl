# parse xml

import EzXML

# type definitions
include("typedef.jl")

##############################################################
# code point set

function get_codepoint(node::EzXML.Node)::CodePointsSet
    cps = try
        cp = parse(UInt32, node["cp"], base = 16)
        SingleCodePoint(cp)
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

# """
# # Fields
# - `bc`: bidirectional class (currently as String)
# - `bidi_M`: mirrored property
# - `bmg`: mirrored image of the glyph
# - `bidi_c`: bidi_control
# - `bpt`: bidi paired bracket type (enum)
# - `bpb`: bidi paired bracket properties
# """
# struct BidirectionalProperties
#     bc::BidirectionalClass
#     Bidi_M::Bool
#     bmg::Union{Nothing, SingleCodePoint}
#     Bidi_C::Bool
#     bpt::BidiPairdBracketType
#     bpb::Union{Nothing, SingleCodePoint}
# end

# @enum BidirectionalClass begin
#     AL; AN;
#     B; BN;
#     CS;
#     EN; ES; ET;
#     FSI;
#     L; LRE; LRI; LRO;
#     NSM;
#     ON;
#     PDF; PDI;
#     R; RLE; RLI; RLO;
#     S;
#     WS;
# end

# @enum BidiPairdBracketType o c n

# """
# # Fields
# - `dt`: decomposition type (enum)
# - `dm`: mapping (Nothing or Vec of SingleCodePoint)
# - `CE`: composition exclusion
# - `Comp_Ex`: full composition exclusion
# - `NFC_QC`: NFC_Quick_Check
# - `NFD_QC`: NFD_Quick_Check
# - `NFKC_QC`: NFKC_Quick_Check
# - `NFKD_QC`: NFKD_Quick_Check
# - `XO_NFC`: Expands_On_NFC
# - `XO_NFD`: Expands_On_NFD
# - `XO_NFKD`: Expands_On_NFKD
# - `XO_NFKC`: Expands_On_NFKC
# - `FC_NFKC`: FC_NFKC_Closure
# """
# struct DecompositionProperties
#     dt::DecompositionType
#     dm::Union{Nothing, Vector{SingleCodePoint}}
#     CE::Bool
#     Comp_Ex::Bool
#     NFC_QC::YNM
#     NFD_QC::YN
#     NFKC_QC::YNM
#     NFKD_QC::YN
#     XO_NFC::Bool
#     XO_NFD::Bool
#     XO_NFKC::Bool
#     XO_NFKD::Bool
#     FC_NFKC::Union{Nothing, Vector{SingleCodePoint}}
# end

# @enum DecompositionType begin
#     can; con; enc; fin; font; fra;
#     init; iso; med; nar; nb; smi;
#     sqr; sub; sup; vert; wide; none;
# end

# @enum YNM YMN_Yes YMN_No YMN_Maybe
# @enum YN YN_Yes YN_No

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
