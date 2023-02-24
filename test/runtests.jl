using UCDxml
using Test

@testset "UCDxml.jl" begin
    # Write your tests here.

    @testset "XML parse" begin
        @test !isempty(read("../deps/ucd.all.flat.xml"))
    end

    char_0x0000 = UCDxml.UCDRepertoireNode(
        UCDxml.char,
        UCDxml.SingleCodePoint(UInt32(0x0)),
        "1.1",
        "",
        "NULL",
        [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")],
        "ASCII",
        UCDxml.GeneralCategories.Cc,
    )

    @testset "Type and func test" begin
        @test UCDxml.SingleCodePoint(UInt32(0x0)) == UCDxml.SingleCodePoint(UInt32(0x0))
        @test UCDxml.RangeCodePoint(UInt32(0x0), UInt32(0x100)) == UCDxml.RangeCodePoint(UInt32(0x0), UInt32(0x100))
        @test UCDxml.char == UCDxml.char
        @test UCDxml.NameAlias("NUL", "abbreviation") == UCDxml.NameAlias("NUL", "abbreviation")
        @test [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")] == [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")]
        @test UCDxml.UCDRepertoireNode(
            UCDxml.char,
            UCDxml.SingleCodePoint(UInt32(0x0)),
            "1.1",
            "",
            "NULL",
            [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")],
            "ASCII",
            UCDxml.GeneralCategories.Cc,
        ) == char_0x0000
    end

    @testset "Result check" begin
        # NULL
        @test ucd_repertoire[1] == UCDxml.UCDRepertoireNode(
            UCDxml.char,
            UCDxml.SingleCodePoint(UInt32(0x0)),
            "1.1",
            "",
            "NULL",
            [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")],
            "ASCII",
            UCDxml.GeneralCategories.Cc,
        )
        # CJK ideograph
        # na should be replaced with its cp
        @test ucd_repertoire[0x30E8] == UCDxml.UCDRepertoireNode(
            UCDxml.char,
            UCDxml.SingleCodePoint(UInt32(0x3402)),
            "3.0",
            "CJK UNIFIED IDEOGRAPH-3402",
            "",
            [],
            "CJK_Ext_A",
            UCDxml.GeneralCategories.Lo,
        )
    end
end
