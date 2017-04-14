# This file is used to define necessary import and importFrom statements in the package's
# NAMESPACE file using roxygen2. Since those imports are global to the entire package (unlike
# for example, Python's module local import staements), for purposes of DRY they may as well be
# all together here in none file.

# We're following Hadley Wickham's advice:
#   If you are using just a few functions from another package, the recommended option is to note the
#   package name in the Imports: field of the DESCRIPTION file and call the function(s) explicitly
#   using ::, e.g., pkg::fun().
# But these are imports for some commonly used functions:
#
#' @importFrom grDevices dev.off png replayPlot
#' @importFrom jsonlite fromJSON toJSON
#' @import methods
#' @import stringr
#' @import tools
#' @importFrom utils capture.output read.csv write.csv
NULL

# Get the version
version <- tryCatch(toString(packageVersion("stencila")), error = '0.0.0')

# Hooks for namespace events
# See https://stat.ethz.ch/R-manual/R-devel/library/base/html/ns-hooks.html

# Called when namespace is loaded
.onLoad <- function (libname, pkgname) {
  # This appears to be better than instantiating 'globally'
  # which causes issues with bindings
  host <<- Host$new()
}