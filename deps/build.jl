#=
About build process.

UCDxml doesn't include hard coded UCD in git, because it's too big.
Instead, UCDxml exports hard coded UCD during build process.
During the build,
1. downloads and extracts xml file from zip archive on unicode.org
2. create temporary UCDxml module, parse xml and write hardcoded UCD in julia.

TODO: #7 using Pkg.Artifacts or Scratch?
=#

# download xml file
# write ucd in julia
using Downloads, ZipFile

# 1. Download
zip_archive = Downloads.download("https://www.unicode.org/Public/UCD/latest/ucdxml/ucd.all.flat.zip")
r = ZipFile.Reader(zip_archive)
open("ucd.all.flat.xml", "w") do io
    write(io, read(r.files[1], String))
end
println(pwd())
close(r)

# 2. write
# 2.1 build temporary UCDxml module
module UCDxml

using EzXML

include("../src/typedef.jl")
include("../src/parser.jl")
include("../src/parse.jl")
include("../src/write.jl")

end
# 2.2 execute write_ucd_coded
UCDxml.write_ucd_coded(; source_path = "../deps/ucd.all.flat.xml", out_path = "../src/ucd_coded.jl")
