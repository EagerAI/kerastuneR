

kerastuner <- NULL

.onLoad <- function(libname, pkgname) {
  
    kerastuner <<- reticulate::import("keras_tuner", delay_load = list(
      priority = 10,
      environment = "r-tensorflow"
    ))
  
}
