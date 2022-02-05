# Pasteee.jl - Julia API for Paste.ee

[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/cossio/Pasteee.jl/blob/master/LICENSE.md)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://cossio.github.io/Pasteee.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://cossio.github.io/Pasteee.jl/dev)
![](https://github.com/cossio/Pasteee.jl/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/cossio/Pasteee.jl/branch/master/graph/badge.svg?token=a9gw7jz3c7)](https://codecov.io/gh/cossio/Pasteee.jl)

[Paste.ee](https://paste.ee/) is a free version of [Pastebin](https://pastebin.com/) with SSL, IPv6, and an easy to use API.
This package provides a Julia wrapper around the Paste.ee API (see <https://pastee.github.io/docs/>).

## Installation

This package is registered.
Install with:

```Julia
using Pkg
Pkg.add("Pasteee")
```

## Related

[Pastebin](https://pastebin.com/) Julia wrapper: <https://github.com/cossio/Pastebin.jl>.
Note that Pastebin has some limitations, such as 10 pastes / day for guest accounts (see <https://pastebin.com/faq#11a>).
Paste.ee does not have these limitations.
