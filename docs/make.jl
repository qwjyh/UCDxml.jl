using UCDxml
using Documenter

DocMeta.setdocmeta!(UCDxml, :DocTestSetup, :(using UCDxml); recursive=true)

makedocs(;
    modules=[UCDxml],
    authors="qwjyh <urataw421@gmail.com> and contributors",
    repo="https://github.com/qwjyh/UCDxml.jl/blob/{commit}{path}#{line}",
    sitename="UCDxml.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://qwjyh.github.io/UCDxml.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/qwjyh/UCDxml.jl",
    devbranch="master",
)
