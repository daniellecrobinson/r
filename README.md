## `stencila/r` : Stencila for R

[![Build status](https://travis-ci.org/stencila/r.svg?branch=master)](https://travis-ci.org/stencila/r)
[![Code coverage](https://codecov.io/gh/stencila/r/branch/master/graph/badge.svg)](https://codecov.io/gh/stencila/r)
[![Chat](https://badges.gitter.im/stencila/stencila.svg)](https://gitter.im/stencila/stencila)

### Status

![](http://blog.stenci.la/wip.png)

This is very much a work in progress. See our [main repo](https://github.com/stencila/stencila) for more details.

### Install

Right now this package isn't on CRAN, but you can install it from this repo using the [`devtools`](https://github.com/hadley/devtools) package,

```r
devtools::install_github("stencila/r")
```

### Use

The various [Stencila packages](https://github.com/stencila/stencila#packages) can act as a network of diverse peers, each providing diffing capabilities. At the moment, the capabilities of this R package are relatively limited, so it will be most useful when used in conjunction with the Stencila [`node`](https://github.com/stencila/node) package. Start up a `node` host and then in R,

```r
library(stencila)

# Start up the host so that it can serve up 
# components and find peers
host$startup()

# Open an example document and view it in the browser
path <- system.file('examples/mtcars.md', package='stencila')
doc <- host$open(path)
doc$view()
```

More documentation is available at https://stencila.github.io/r

### Discuss

We love feedback. Create a [new issue](https://github.com/stencila/r/issues/new), add to [existing issues](https://github.com/stencila/r/issues) or [chat](https://gitter.im/stencila/stencila) with members of the community.

### Develop

Want to help out with development? Great, there's a lot to do! To get started, read our contributor [code of conduct](CONDUCT.md), then [get in touch](https://gitter.im/stencila/stencila) or checkout the [platform-wide, cross-repository kanban board](https://github.com/orgs/stencila/projects/1).

Most development tasks can be run using `make` or RStudio keyboard shortcuts.

Task                                                    | `make`                | RStudio         |
------------------------------------------------------- |-----------------------|-----------------|
Install dependencies                                    | `make setup`          | 
Run tests                                               | `make test`           | `Ctrl+Shift+T`
Run tests with coverage                                 | `make cover`          |
Build documentation                                     | `make docs`           | `packagedocs::build_vignettes()`
Check the package                                       | `make check`          | `Ctrl+Shift+E`
Build                                                   | `make build`          | `Ctrl+Shift+B`
Clean                                                   | `make clean`          |

Unit tests live in the `tests` folder and are mostly written using the [`testthat`](https://github.com/hadley/testthat) test harness. Documentation is written using `roxygen2` and `vignettes/*.Rmd` files and generated using [`packagedocs`](http://hafen.github.io/packagedocs/).
