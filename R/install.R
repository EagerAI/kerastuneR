#' @title Install Keras Tuner
#' 
#' @description This function is used to install the Keras Tuner python module

#' @param version for specific version of Keras tuneR, e.g. "1.0.1"
#' @param ... other arguments passed to [reticulate::py_install()].
#' @param restart_session Restart R session after installing (note this will only occur within RStudio).
#' @return a python module kerastuner
#' @importFrom reticulate py_config py_install use_python
#' @export
install_kerastuner <- function(version = NULL, ..., restart_session = TRUE) {
  
  if (is.null(version))
    module_string <- paste0("keras-tuner==", '1.0.1')
  else
    module_string <- paste0("keras-tuner==", version)
  invisible(py_config())
  py_path = Sys.which('python') %>% as.character()
  py_install(packages = paste(module_string, 'pydot'), pip = TRUE, ...)
  
  invisible(use_python(py_path, required = TRUE))
  py_install('pydot')
  
  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()
}