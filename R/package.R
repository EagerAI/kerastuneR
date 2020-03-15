#' Handle to the `kerastuner` module
#'
#'
#' @return Module(kerastuner)
#' @export
kerastuner <- NULL

.onLoad <- function(libname, pkgname) {
  
    kerastuner <<- reticulate::import("kerastuner", delay_load = list(
      priority = 10,
      environment = "r-tensorflow"
    ))
  
}
