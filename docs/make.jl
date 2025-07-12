using HyperdimensionalComputing
using Documenter

DocMeta.setdocmeta!(HyperdimensionalComputing, :DocTestSetup, :(using HyperdimensionalComputing); recursive=true)

# Get repository information dynamically for fork support
repo_url = get(ENV, "GITHUB_REPOSITORY", "michielstock/HyperdimensionalComputing.jl")
repo_name = split(repo_url, "/")[end]
repo_owner = split(repo_url, "/")[1]

makedocs(;
    modules=[HyperdimensionalComputing],
    authors="Steff Taelman, Dimi Boeckaerts",
    repo="https://github.com/$repo_url/blob/{commit}{path}#{line}",
    sitename="HyperdimensionalComputing.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://$repo_owner.github.io/$repo_name",
        assets=String[],
        edit_link="main",
    ),
    pages=[
        "Home" => "index.md",
        "API Reference" => "api.md",
        "Examples" => "examples.md",
    ],
    checkdocs=:exports,
)

deploydocs(;
    repo="github.com/$repo_url",
    devbranch=begin
		current_branch = get(ENV, "GITHUB_REF", "refs/heads/main")
		dev_branch = if occursin("develop", current_branch)
			"develop"
		else
			"main"
		end
	end,
)
