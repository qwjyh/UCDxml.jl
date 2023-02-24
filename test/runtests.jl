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
        "",
        [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")]
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
            "",
            [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")]
        ) == char_0x0000
    end

    @testset "Result check" begin
        @test ucd_repertoire[1] == UCDxml.UCDRepertoireNode(
            UCDxml.char,
            UCDxml.SingleCodePoint(UInt32(0x0)),
            "",
            [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")]
        )
    end
end
