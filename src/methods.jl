# ===============================================
# displaying functions (pretty-print)
# ===============================================

function show_codepoint(cps::SingleCodePoint)::String
    "0x" * uppercase(format(cps))
end

function show_codepoint(cps::RangeCodePoint)::String
    padding = cps.last > 0xFFFF ? 6 : 4
    "0x" * uppercase(string(cps.first, base = 16, pad = padding)) *
    ":0x" * uppercase(string(cps.last, base = 16, pad = padding))
end

Base.Char(cps::SingleCodePoint)::Char = Char(cps.cp)
Base.Char(cps::RangeCodePoint)::Char = error("This node has cp range.")

Base.Char(ucd::UCDRepertoireNode)::Char = begin
    if ucd.type != char
        throw(DomainError(ucd, "No character is assigned to this codepoint."))
    end
    Char(ucd.cp)
end

Base.show(io::IO, ::MIME"text/plain", ucd::UCDRepertoireNode) = begin
    name_string = ucd.na == "" ? ucd.na1 : ucd.na
    name_alias_display = length(ucd.name_alias) == 0 ? "" : map(x -> x.alias, ucd.name_alias)
    char_str = ""
    try
        char_str = " (" * Char(ucd.cp) * ")"
    catch
        char_str = ""
    end
    print(io, """
    UCD repertoire node$char_str:
      type: $(ucd.type)
      cp: $(show_codepoint(ucd.cp)), category: $(ucd.gc)
      name: $(name_string)
      alias: $(name_alias_display)
      block: $(ucd.blk)
      age: $(ucd.age)
      ccc(canonical combining class):
    """)
end