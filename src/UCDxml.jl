module UCDxml

using EzXML
include("parser.jl")

export ucd_repertoire

# use flat version, which doesn't use group mechanism
ucd = readxml("deps/ucd.all.flat.xml")
repertoire = elements(elements(ucd.root)[2])

ucd_repertoire = map(
    get_repertoire_info,
    repertoire
)

end
