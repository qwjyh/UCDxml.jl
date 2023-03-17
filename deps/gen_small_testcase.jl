# make small xml for light test
using EzXML

xml = readxml("ucd.all.flat.xml")
repertoire = elements(elements(xml.root)[2])

len_repertoire = length(repertoire)

filter(x -> rand() > 0.05, repertoire) .|> EzXML.unlink!

write("small.xml", xml)
