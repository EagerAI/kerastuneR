#' Install Keras Tuner
#' This function is used to install the Keras Tuner python module on Mac OS and Linux (Windows will be added later)
#' @param python_path python_path specifies the python path for installation via terminal
#' @param version for specific version of Keras tuneR, e.g. "0.9.1"
#' @param upgrade is helpful if one wants to upgrade a version of Keras TuneR
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

