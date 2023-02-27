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
        string(val, base=16, pad=4)
    else
        string(val, base=16, pad=6)
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
