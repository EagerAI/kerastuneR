

kerastuner <- NULL

.onLoad <- function(libname, pkgname) {
  
    kerastuner <<- reticulate::import("kerastuner", delay_load = list(
      priority = 10,
      environment = "r-tensorflow"
    ))
  
}
