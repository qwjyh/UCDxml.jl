# type definitions
# using EzXML

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

"""
    format(cp::SingleCodePoint)::String

Return codepoint in `String`.

If ``cp \\leq \\mathrm{FFFF}``, digit is 4, else, digit is 6.
"""
function format(cp::SingleCodePoint)::String
    val = cp.cp # UTint32
    if val <= 0xFFFF
        string(val, base = 16, pad = 4)
    else
        string(val, base = 16, pad = 6)
    end
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

#################################################################
# properties
abstract type Property end

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

# general category
"""
module for GeneralCategories.
To separate namespace for General Category enum.
"""
module GeneralCategories

using EzXML

export GeneralCategory

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

end

using .GeneralCategories

# bidirectional properties

"""
contains BidirectionalClass enum
"""
module BidirectionalClasses

export BidirectionalClass

#! format: off
@enum BidirectionalClass begin
    AL; AN;
    B; BN;
    CS;
    EN; ES; ET;
    FSI;
    L; LRE; LRI; LRO;
    NSM;
    ON;
    PDF; PDI;
    R; RLE; RLI; RLO;
    S;
    WS;
end
#! format: on

end

using .BidirectionalClasses

"""
contains BidiPairedBracketType enum
"""
module BidiPairedBracketTypes

export BidiPairedBracketType

@enum BidiPairedBracketType o c n

end

using .BidiPairedBracketTypes

"""
# Fields
- `bc`: bidirectional class (currently as String)
- `bidi_M`: mirrored property
- `bmg`: mirrored image of the glyph
- `bidi_c`: bidi_control
- `bpt`: bidi paired bracket type (enum)
- `bpb`: bidi paired bracket properties
"""
struct BidirectionalProperties <: Property
    bc::BidirectionalClass
    Bidi_M::Bool
    bmg::Union{Nothing, CodePointsSet}
    Bidi_C::Bool
    bpt::BidiPairedBracketType
    bpb::Union{Nothing, CodePointsSet}
end

# decomposition properties
"DecompositionType enum"
module DecompositionTypes
export DecompositionType

# TODO: use full name?
#! format: off
"see Table 14. of UAX#44 https://www.unicode.org/reports/tr44/#Character_Decomposition_Mappings"
@enum DecompositionType begin
    can; com; enc; fin; font; fra;
    init; iso; med; nar; nb; sml;
    sqr; sub; sup; vert; wide; none;
end
#! format: on

end

using .DecompositionTypes

"QuickCheckProperty enum"
module QuickCheckProperties
export QuickCheckProperty

"""
Defined in "5.7.5 Decomposition and Normalization" of UAX#44.
"""
@enum QuickCheckProperty begin
    No
    Maybe
    Yes
end

end

using .QuickCheckProperties

"""
# Fields
- `dt`: decomposition type (enum)
- `dm`: mapping (Nothing or Vec of SingleCodePoint)
- `CE`: composition exclusion
- `Comp_Ex`: full composition exclusion
- `NFC_QC`: NFC_Quick_Check
- `NFD_QC`: NFD_Quick_Check
- `NFKC_QC`: NFKC_Quick_Check
- `NFKD_QC`: NFKD_Quick_Check
- `XO_NFC`: Expands_On_NFC
- `XO_NFD`: Expands_On_NFD
- `XO_NFKD`: Expands_On_NFKD
- `XO_NFKC`: Expands_On_NFKC
- `FC_NFKC`: FC_NFKC_Closure
"""
struct DecompositionProperties <: Property
    dt::DecompositionType
    dm::Union{CodePointsSet, Vector{SingleCodePoint}}
    CE::Bool
    Comp_Ex::Bool
    NFC_QC::QuickCheckProperty
    NFD_QC::QuickCheckProperty
    NFKC_QC::QuickCheckProperty
    NFKD_QC::QuickCheckProperty
    XO_NFC::Bool
    XO_NFD::Bool
    XO_NFKC::Bool
    XO_NFKD::Bool
    FC_NFKC::Union{CodePointsSet, Vector{SingleCodePoint}}
end

# numeric properties 4.4.9
module NumericTypes
export NumericType
@enum NumericType begin
    None
    De
    Di
    Nu
end
end
using .NumericTypes

"""
# Fields
- `nt`: numeric type (enum)
- `nv`: numeric value(NaN or fractional(Rational))
"""
struct NumericProperties
    nt::NumericType
    nv::Real
end

# joining properties 4.4.10

module JoiningTypes
export JoiningType

"""
    @enum JoiningType begin
        U # Non_Joining
        C # Join_Causing
        T # Transparent
        D # Dual_Joining
        L # Left_Joining
        R # Right_Joining
    end

from Table 9-3 of Unicode
https://www.unicode.org/versions/Unicode15.0.0/ch09.pdf
"""
@enum JoiningType begin
    U # Non_Joining
    C # Join_Causing
    T # Transparent
    D # Dual_Joining
    L # Left_Joining
    R # Right_Joining
end

end
using .JoiningTypes

"""
Basic Arabic and Syriac character shaping properties, such as initial, medial and final shapes. 
See Section 9.2, Arabic in [Unicode].

# Fields
- `jt`: joining class
- `jg`: joining group
- `Join_C`: Join_Control
"""
struct JoiningProperties
    jt::JoiningType
    jg::String
    Join_C::Bool
end

# linebreak properties
module LineBreakProperties
export LineBreakProperty

#! format: off
"""
Line_Break property.
For details, see Table 1. of https://www.unicode.org/reports/tr14/
"""
@enum LineBreakProperty begin
    AI; AL;
    B2; BA; BB; BK;
    CB; CJ; CL; CM; CP; CR;
    EB; EM; EX;
    GL;
    H2; H3; HL; HY;
    ID; IN; IS;
    JL; JT; JV;
    LF;
    NL; NS; NU;
    OP;
    PO; PR;
    QU;
    RI;
    SA; SG; SP; SY;
    WJ;
    XX;
    ZW; ZWJ;
end
#! format: on

end
using .LineBreakProperties

###############################################################################################
# main

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
    age::String
    na::String
    na1::String
    name_alias::Vector{NameAlias}
    blk::String
    gc::GeneralCategory
    ccc::UInt8 # Canonical Combining Class in Decimal
    bidi::BidirectionalProperties
    decomp::DecompositionProperties
    numeric::NumericProperties
    joining::JoiningProperties
    lb::LineBreakProperty
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
