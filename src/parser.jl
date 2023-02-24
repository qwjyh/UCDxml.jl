import EzXML

##############################################################
# code point set
"""
    abstract type CodePointsSet end

There are two types of code point representation.
`SingleCodePoint` and `RangeCodePoint` with `first` and `last` codepoint.
Each codepoint value is `UInt32` (as it is expressed as hexadecimal number with four to six digits, ie. minimum is `0x0000` and maximum is `0xFFFFFF`(UAX#44 #4.2.2))
"""
abstract type CodePointsSet end
struct SingleCodePoint <: CodePointsSet
    cp::UInt32
end
struct RangeCodePoint <: CodePointsSet
    first::UInt32
    last::UInt32
end

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

"""
    @enum CodePointType begin
        reserved
        noncharacter
        surrogate
        char
    end

CodePoint type enum.
"""
@enum CodePointType begin
    reserved
    noncharacter
    surrogate
    char
end

function get_codepointtype(node::EzXML.Node)
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
abstract type Property end

# name
function get_name(node::EzXML.Node)::String
    return node["na"]
end

# name alias
# TODO: replace type with enum
"""
    struct NameAlias <: Property
        alias::String
        type::String
    end

name alias
# Fields
- `alias::String`: name
- `type::String`: type of alias("abbreviation", "alternative", "control", "correction" or "figment")
"""
struct NameAlias <: Property
    alias::String
    type::String
end

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

"""
module for GeneralCategories.
To separate namespace for General Category enum.
"""
module GeneralCategories

using EzXML

export GeneralCategory, get_generalcategory

"""
    @enum GeneralCategory begin
        Lu # Letter, uppercase
        Ll # Letter, lowercase
        Lt # Letter, titlecase
        Lm # Letter, modifier
        Lo # Letter, other
        Mn # Mark, nonspacing
        Mc # Mark, spacing combining
        Me # Mark, enclosing
        Nd # Number, decimal digit
        Nl # Number, letter
        No # Number, other
        Pc # Punctuation, connector
        Pd # Punctuation, dash
        Ps # Punctuation, open
        Pe # Punctuation, close
        Pi # Punctuation, initial quote
        Pf # Punctuation, final quote
        Po # Punctuation, other
        Sm # Symbol, math
        Sc # Symbol, currency
        Sk # Symbol, modifier
        So # Symbol, other
        Zs # Separator, space
        Zl # Separator, line
        Zp # Separator, paragraph
        Cc # Other, control
        Cf # Other, format
        Cs # Other, surrogate
        Co # Other, private use
        Cn # Other, not assigned (including noncharacters)
    end
"""
@enum GeneralCategory begin
    Lu # Letter, uppercase
    Ll # Letter, lowercase
    Lt # Letter, titlecase
    Lm # Letter, modifier
    Lo # Letter, other
    Mn # Mark, nonspacing
    Mc # Mark, spacing combining
    Me # Mark, enclosing
    Nd # Number, decimal digit
    Nl # Number, letter
    No # Number, other
    Pc # Punctuation, connector
    Pd # Punctuation, dash
    Ps # Punctuation, open
    Pe # Punctuation, close
    Pi # Punctuation, initial quote
    Pf # Punctuation, final quote
    Po # Punctuation, other
    Sm # Symbol, math
    Sc # Symbol, currency
    Sk # Symbol, modifier
    So # Symbol, other
    Zs # Separator, space
    Zl # Separator, line
    Zp # Separator, paragraph
    Cc # Other, control
    Cf # Other, format
    Cs # Other, surrogate
    Co # Other, private use
    Cn # Other, not assigned (including noncharacters)
end

function get_generalcategory(node::EzXML.Node)::GeneralCategory
    gc_str = String("")
    try
        gc_str = node["gc"]
    catch
        error("Failed to get gc(General Category).")
    end
    if gc_str == "Lu" Lu
    elseif gc_str == "Ll" Ll
    elseif gc_str == "Lt" Lt
    elseif gc_str == "Lm" Lm
    elseif gc_str == "Lo" Lo
    elseif gc_str == "Mn" Mn
    elseif gc_str == "Mc" Mc
    elseif gc_str == "Me" Me
    elseif gc_str == "Nd" Nd
    elseif gc_str == "Nl" Nl
    elseif gc_str == "No" No
    elseif gc_str == "Pc" Pc
    elseif gc_str == "Pd" Pd
    elseif gc_str == "Ps" Ps
    elseif gc_str == "Pe" Pe
    elseif gc_str == "Pi" Pi
    elseif gc_str == "Pf" Pf
    elseif gc_str == "Po" Po
    elseif gc_str == "Sm" Sm
    elseif gc_str == "Sc" Sc
    elseif gc_str == "Sk" Sk
    elseif gc_str == "So" So
    elseif gc_str == "Zs" Zs
    elseif gc_str == "Zl" Zl
    elseif gc_str == "Zp" Zp
    elseif gc_str == "Cc" Cc
    elseif gc_str == "Cf" Cf
    elseif gc_str == "Cs" Cs
    elseif gc_str == "Co" Co
    elseif gc_str == "Cn" Cn
    else error("No gc matched \n gc = $gc_str")
    end
end

end

using .GeneralCategories


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


"""
    struct UCDRepertoireNode

UAX#42
# Fields
- `type::CodePointType`: `char`, `reserved`, `noncharacter`, `surrogate`
- `cp::CodePointsSet`: single code point or range with first, last
- `na::String`: standard name
- `na1`: 1.0 name
- `name_alias::Vector{NameAlias}`: zero or more
    - `alias`: String
    - `type`: "abbreviation", "alternate", ... etc
- `blk::String`: block
- `gc::GeneralCategory`: general category (enum)
- `ccc`: canonical combining class in decimal
- `bidi`: bidirectional properties (see `BidirectionalProperties` doc for more details)
- `decomp`: see DecompositionProperties
- `numeric`: see NumericProperties
- `joining`: see JoiningProperties
- `lb`: see LineBreakProperties
- `ea`: east asian width
- `sc`: script
- `scx`: script extension
- `isc`: ISO 10646 comment filed
- `hangul`: see HangulProperties
- `indic`: see IndicProperties
"""
struct UCDRepertoireNode
    type::CodePointType
    cp::CodePointsSet
    # age::String
    na::String
    # na1::String
    name_alias::Vector{NameAlias}
    blk::String
    gc::GeneralCategory
    # ccc::Int16 # Canonical Combining Class in Decimal
    # bidi::BidirectionalProperties
    # decomp::DecompositionProperties
    # numeric::NumericProperties
    # joining::JoiningProperties
    # lb::LineBreakProperties
    # ea::EastAsianWidth
    # sc::Script
    # scx::Vector{Script}
    # isc::String
    # hangul::HangulProperties
    # indic::IndicProperties
    # idpt::IdPtProperties
    # fungr
    # bound
    # ideograph
    # miscellaneous
    # unihan
    # nushu
    # emoji::EmojiProperties
end

function get_repertoire_info(node::EzXML.Node)::UCDRepertoireNode
    type = get_codepointtype(node)
    cp = get_codepoint(node)
    na = get_name(node)
    name_alias = get_namealiases(node)
    blk = get_block(node)
    gc = get_generalcategory(node)

    return UCDRepertoireNode(
        type,
        cp,
        na,
        name_alias,
        blk,
        gc,
    )
end

function Base.show(io::IO, r::UCDRepertoireNode)
    dump(io, r)
end

function Base.:(==)(a::T, b::T) where T<:UCDRepertoireNode
    f = fieldnames(T)
    getfield.(Ref(a), f) == getfield.(Ref(b), f)
end


function Base.:(==)(a::T, b::T) where T<:Property
    f = fieldnames(T)
    getfield.(Ref(a), f) == getfield.(Ref(b), f)
end