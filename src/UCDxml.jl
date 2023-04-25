module UCDxml

using EzXML

# export ucd_repertoire

include("typedef.jl")
include("parser.jl")
include("parse.jl")
include("write.jl")
include("methods.jl")

include("ucd_coded.jl")

end
