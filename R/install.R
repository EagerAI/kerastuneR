#' @title Install Keras Tuner
#' 
#' @description This function is used to install the Keras Tuner python module

#' @param version for specific version of Keras tuneR, e.g. "1.0.1"
#' @param ... other arguments passed to [reticulate::py_install()].
#' @param restart_session Restart R session after installing (note this will only occur within RStudio).
#' @return a python module kerastuner
#' @export
install_kerastuner <- function(version = NULL, ..., restart_session = TRUE) {
  
  if (is.null(version))
    module_string <- paste0("keras-tuner==", '1.0.1')
  else
    module_string <- paste0("keras-tuner==", version)
  
  reticulate::py_install(packages = paste(module_string), pip = TRUE, ...)
  reticulate::py_install(packages = c('pydot'))
  
  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()
}