#' @title Install Keras Tuner
#' 
#' @description This function is used to install the Keras Tuner python module

#' @param version for specific version of Keras tuneR, e.g. "0.9.1"
#' @param restart_session Restart R session after installing (note this will only occur within RStudio).
#' @export
install_kerastuner <- function(version = NULL, ..., restart_session = TRUE) {
  
  if (is.null(version))
    module_string <- paste0("keras-tuner==", '1.0.0')
  else
    module_string <- paste0("keras-tuner==", version)
  
  reticulate::py_install(packages = module_string, pip = TRUE, ...)
  
  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()
}

