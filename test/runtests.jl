using UCDxml, EzXML
using Test

@testset "UCDxml.jl" begin
    # parse xml for test
    ucd_repertoire = UCDxml.parse_xml("../deps/ucd.all.flat.xml")

    @testset "XML parse" begin
        @test !isempty(read("../deps/ucd.all.flat.xml"))
    end

    char_0x0000_code = """
    UCDxml.UCDRepertoireNode(
        UCDxml.char,
        UCDxml.SingleCodePoint(UInt32(0x0)),
        "1.1",
        "",
        "NULL",
        [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")],
        "ASCII",
        UCDxml.GeneralCategories.Cc,
        UInt8(0),
    )
    """
    char_0x0000 = eval(Meta.parse(char_0x0000_code))

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
            UInt16(0),
        ) == char_0x0000
    end

    @testset "Parse result check" begin
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
            UInt16(0),
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
            UInt16(0),
        )
    end

    @testset "Write result test" begin
        io = IOBuffer()
        @testset "Modules" begin
            @test UCDxml.out_codepointtype(char_0x0000.type) == "UCDxml.char"
            @test (x -> (UCDxml.out_codepointtype(x) |> Meta.parse |> eval) == x)(char_0x0000.type)
            @test UCDxml.out_codepoint(char_0x0000.cp) == "UCDxml.SingleCodePoint(UInt32(0x0000))"
            @test (x -> (UCDxml.out_codepoint(x) |> Meta.parse |> eval) == x)(char_0x0000.cp)
            @test UCDxml.out_name_alias_vec(char_0x0000.name_alias) == "[UCDxml.NameAlias(\"NUL\", \"abbreviation\"), UCDxml.NameAlias(\"NULL\", \"control\")]"
            @test (x -> (UCDxml.out_name_alias_vec(x) |> Meta.parse |> eval) == x)(char_0x0000.name_alias)
            @test UCDxml.out_general_category(char_0x0000.gc) == "Cc"
            @test (x -> (("UCDxml.GeneralCategories." * UCDxml.out_general_category(x)) |> Meta.parse |> eval) == x)(char_0x0000.gc)
        end

        @testset "Parse all UCDRepertoireNode" begin
            UCDxml.write_repertoire(io, char_0x0000)
            out_str = String(take!(io))
            @test eval(Meta.parse(out_str)) == char_0x0000
            rand_node = rand(ucd_repertoire)
            UCDxml.write_repertoire(io, rand_node)
            out_str = String(take!(io))
            @test eval(Meta.parse(out_str)) == rand_node
        end
        
        @testset "Write and parse all UCDRepertoireNode" begin
            for ucd_node in ucd_repertoire
                UCDxml.write_repertoire(io, ucd_node)
                out_str = String(take!(io))
                @test eval(Meta.parse(out_str)) == ucd_node
            end
        end
        close(io)
    end
end
