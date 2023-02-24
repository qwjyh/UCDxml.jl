# download xml file
using Downloads, ZipFile

zip_archive = Downloads.download("https://www.unicode.org/Public/UCD/latest/ucdxml/ucd.all.flat.zip")
r = ZipFile.Reader(zip_archive)
open("ucd.all.flat.xml", "w") do io
    write(io, read(r.files[1], String))
end
println(pwd())
close(r)
