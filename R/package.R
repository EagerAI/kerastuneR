# keras tuner
kerastuner <- NULL

.onLoad <- function(libname, pkgname) {
  
    kerastuner <<- reticulate::import("kerastuner", delay_load = list(
      priority = 4,
      environment = "r-tensorflow"
    ))
  
}
