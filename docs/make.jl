import Documenter
import Literate
import Pasteee

ENV["JULIA_DEBUG"] = "Documenter,Literate,Pasteee"

#=
We place Literate.jl source .jl files and the generated .md files inside docs/src/literate.
=#
const literate_dir = joinpath(@__DIR__, "src/literate")

#=
Helper function to remove all "*.md" files from a directory.
=#
function clear_md_files(dir::String)
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".md")
                rm(joinpath(root, file))
            end
        end
    end
end

#=
Remove previously Literate.jl generated files. This removes all "*.md" files inside
`literate_dir`. This is a precaution: if we build docs locally and something fails,
and then change the name of a source file (".jl"), we will be left with a lingering
".md" file which will be included in the current docs build. The following line makes
sure this doesn't happen.
=#
clear_md_files(literate_dir)

#=
Run Literate.jl on the .jl source files within docs/src/literate (recursively).
For each .jl file, this creates a markdown .md file at the same location as
and with the same name as the corresponding .jl file, but with the extension
changed (.jl -> .md).
=#
for (root, dirs, files) in walkdir(literate_dir)
    for file in files
        if endswith(file, ".jl")
            Literate.markdown(joinpath(root, file), root; documenter=true)
        end
    end
end

#=
Build docs.
=#
Documenter.makedocs(
    modules = [Pasteee],
    sitename = "Pasteee.jl",
    pages = [
        "Home" => "index.md",
        "Examples" => "literate/examples.md",
        "Reference" => "reference.md"
    ],
    strict = true
)

#=
After the docs have been compiled, we can remove the *.md files generated by Literate.
=#
clear_md_files(literate_dir)

#=
Deploy docs to Github pages.
=#
Documenter.deploydocs(
    repo = "github.com/cossio/Pasteee.jl.git",
    devbranch = "master"
)
