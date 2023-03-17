using UCDxml, EzXML
using Test

# switch full test
full_test = !haskey(ENV, "SMALL_TEST")
xml_path = full_test ? "../deps/ucd.all.flat.xml" : "../deps/small.xml"

@testset "UCDxml.jl" begin
    # parse xml for test
    ucd_repertoire = UCDxml.parse_xml(xml_path)

    @testset "XML parse" begin
        @test !isempty(read(xml_path))
    end

    # <char cp="0000" age="1.1" na="" JSN="" gc="Cc" ccc="0" dt="none" dm="#" nt="None" nv="NaN" bc="BN" bpt="n" bpb="#" Bidi_M="N" bmg="" suc="#" slc="#" stc="#" uc="#" lc="#" tc="#" scf="#" cf="#" jt="U" jg="No_Joining_Group" ea="N" lb="CM" sc="Zyyy" scx="Zyyy" Dash="N" WSpace="N" Hyphen="N" QMark="N" Radical="N" Ideo="N" UIdeo="N" IDSB="N" IDST="N" hst="NA" DI="N" ODI="N" Alpha="N" OAlpha="N" Upper="N" OUpper="N" Lower="N" OLower="N" Math="N" OMath="N" Hex="N" AHex="N" NChar="N" VS="N" Bidi_C="N" Join_C="N" Gr_Base="N" Gr_Ext="N" OGr_Ext="N" Gr_Link="N" STerm="N" Ext="N" Term="N" Dia="N" Dep="N" IDS="N" OIDS="N" XIDS="N" IDC="N" OIDC="N" XIDC="N" SD="N" LOE="N" Pat_WS="N" Pat_Syn="N" GCB="CN" WB="XX" SB="XX" CE="N" Comp_Ex="N" NFC_QC="Y" NFD_QC="Y" NFKC_QC="Y" NFKD_QC="Y" XO_NFC="N" XO_NFD="N" XO_NFKC="N" XO_NFKD="N" FC_NFKC="#" CI="N" Cased="N" CWCF="N" CWCM="N" CWKCF="N" CWL="N" CWT="N" CWU="N" NFKC_CF="#" InSC="Other" InPC="NA" PCM="N" vo="R" RI="N" blk="ASCII" isc="" na1="NULL" Emoji="N" EPres="N" EMod="N" EBase="N" EComp="N" ExtPict="N">
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
        UCDxml.BidirectionalProperties(UCDxml.BidirectionalClasses.BN, false, nothing, false, UCDxml.BidiPairedBracketTypes.n, UCDxml.SingleCodePoint(UInt32(0x0))),
        UCDxml.DecompositionProperties(UCDxml.DecompositionTypes.none, UCDxml.SingleCodePoint(UInt32(0x0)), false, false, UCDxml.QuickCheckProperties.Yes, UCDxml.QuickCheckProperties.Yes, UCDxml.QuickCheckProperties.Yes, UCDxml.QuickCheckProperties.Yes, false, false, false, false, UCDxml.SingleCodePoint(UInt32(0x0))),
        UCDxml.NumericProperties(UCDxml.NumericTypes.None, NaN)
    )
    """
    char_0x0000 = eval(Meta.parse(char_0x0000_code))

    @testset "Type and func test" begin
        @test UCDxml.SingleCodePoint(UInt32(0x0)) == UCDxml.SingleCodePoint(UInt32(0x0))
        @test UCDxml.RangeCodePoint(UInt32(0x0), UInt32(0x100)) == UCDxml.RangeCodePoint(UInt32(0x0), UInt32(0x100))
        @test UCDxml.char == UCDxml.char
        @test UCDxml.NameAlias("NUL", "abbreviation") == UCDxml.NameAlias("NUL", "abbreviation")
        @test [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")] == [UCDxml.NameAlias("NUL", "abbreviation"), UCDxml.NameAlias("NULL", "control")]
        @test eval(Meta.parse(char_0x0000_code)) == char_0x0000
    end

    @testset "Parse result check" begin
        # NULL
        @test ucd_repertoire[1] == eval(Meta.parse(char_0x0000_code))
        # CJK ideograph
        # na should be replaced with its cp
        # <char cp="3402" age="3.0" na="CJK UNIFIED IDEOGRAPH-#" JSN="" gc="Lo" ccc="0" dt="none" dm="#" nt="None" nv="NaN" bc="L" bpt="n" bpb="#" Bidi_M="N" bmg="" suc="#" slc="#" stc="#" uc="#" lc="#" tc="#" scf="#" cf="#" jt="U" jg="No_Joining_Group" ea="W" lb="ID" sc="Hani" scx="Hani" Dash="N" WSpace="N" Hyphen="N" QMark="N" Radical="N" Ideo="Y" UIdeo="Y" IDSB="N" IDST="N" hst="NA" DI="N" ODI="N" Alpha="Y" OAlpha="N" Upper="N" OUpper="N" Lower="N" OLower="N" Math="N" OMath="N" Hex="N" AHex="N" NChar="N" VS="N" Bidi_C="N" Join_C="N" Gr_Base="Y" Gr_Ext="N" OGr_Ext="N" Gr_Link="N" STerm="N" Ext="N" Term="N" Dia="N" Dep="N" IDS="Y" OIDS="N" XIDS="Y" IDC="Y" OIDC="N" XIDC="Y" SD="N" LOE="N" Pat_WS="N" Pat_Syn="N" GCB="XX" WB="XX" SB="LE" CE="N" Comp_Ex="N" NFC_QC="Y" NFD_QC="Y" NFKC_QC="Y" NFKD_QC="Y" XO_NFC="N" XO_NFD="N" XO_NFKC="N" XO_NFKD="N" FC_NFKC="#" CI="N" Cased="N" CWCF="N" CWCM="N" CWKCF="N" CWL="N" CWT="N" CWU="N" NFKC_CF="#" InSC="Other" InPC="NA" PCM="N" vo="U" RI="N" blk="CJK_Ext_A" kCompatibilityVariant="" kRSUnicode="1.5" kIRG_GSource="" kIRG_TSource="" kIRG_JSource="JA3-2E23" kIRG_KSource="" kIRG_KPSource="" kIRG_VSource="" kIRG_HSource="" kIRG_USource="" kIRG_MSource="" kIRG_UKSource="" kIRG_SSource="" kJIS0213="1,14,03" kDefinition="(J) non-standard form of U+559C 喜, to like, love, enjoy; a joyful thing" kNelson="0265" kCangjie="PPP" kKangXi="0078.101" kIRGKangXi="0078.101" kRSAdobe_Japan1_6="C+13698+1.1.5 V+13697+21.2.4 V+13699+1.1.5" kTotalStrokes="6" isc="" na1="" Emoji="N" EPres="N" EMod="N" EBase="N" EComp="N" ExtPict="N"/>
        if full_test
            @test ucd_repertoire[0x30E8] == UCDxml.UCDRepertoireNode(
                UCDxml.char,
                UCDxml.SingleCodePoint(UInt32(0x3402)),
                "3.0",
                "CJK UNIFIED IDEOGRAPH-3402",
                "",
                [],
                "CJK_Ext_A",
                UCDxml.GeneralCategories.Lo,
                UInt8(0),
                UCDxml.BidirectionalProperties(UCDxml.BidirectionalClasses.L, false, nothing, false, UCDxml.BidiPairedBracketTypes.n, UCDxml.SingleCodePoint(UInt32(0x3402))),
                UCDxml.DecompositionProperties(UCDxml.DecompositionTypes.none, UCDxml.SingleCodePoint(UInt32(0x3402)), false, false, UCDxml.QuickCheckProperties.Yes, UCDxml.QuickCheckProperties.Yes, UCDxml.QuickCheckProperties.Yes, UCDxml.QuickCheckProperties.Yes, false, false, false, false, UCDxml.SingleCodePoint(UInt32(0x3402))),
                UCDxml.NumericProperties(UCDxml.NumericTypes.None, NaN)
            )
        end
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
            # 0
            UCDxml.write_repertoire(io, char_0x0000)
            out_str = String(take!(io))
            @test eval(Meta.parse(out_str)) == char_0x0000
            # random
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

    @testset "Exported result check" begin
        @testset "Check all hardcoded data is correct" begin
            for (raw_ucd, hardcoded_ucd) in zip(ucd_repertoire, UCDxml.ucd_list)
                @test raw_ucd == hardcoded_ucd
            end
        end
    end
end
