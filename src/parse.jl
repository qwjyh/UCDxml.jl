# parse xml file

function parse_xml(location = "deps/ucd.all.flat.xml")
    # use flat version, which doesn't use group mechanism
    ucd = readxml(location)
    repertoire = elements(elements(ucd.root)[2])

    ucd_repertoire = map(
        get_repertoire_info,
        repertoire
    )
end
