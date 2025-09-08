# Developer guide

## Formatting

We use [Runic.jl](https://github.com/fredrikekre/Runic.jl) to format the
`HyperdimensionalComputing.jl` codebase. We recommend installing
[pre-commit](https://pre-commit.com/) to automatically set up pre-commit hooks that check code
formatting. To install the pre-commit hooks, run `pre-commit install` in the root directory.
After installation, the hooks will run automatically on each commit.

Since implementing comprehensive development tooling can be challenging, pull requests that
don't follow Runic.jl formatting will be automatically revised with review comments indicating
the required changes. We strongly encourage contributors to format their code before submitting
pull requests, as large unformatted PRs can be difficult to review and may cause significant
delays in the review process.
