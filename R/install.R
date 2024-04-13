#' @title Install Keras Tuner
#' 
#' @description This function is used to install the Keras Tuner python module

#' @param version for specific version of Keras Tuner, e.g. "1.0.1"
#' @param ... other arguments passed to [reticulate::py_install()].
#' @param restart_session Restart R session after installing (note this will only occur within RStudio).
#' @param from_git install the recent GitHub version of Keras Tuner
#' @param bayesian install bayesian module
#' @return a python module kerastuner
#' @importFrom reticulate py_config py_install use_python
#' @importFrom crayon red black
#' @export
install_kerastuner <- function(version = NULL, ..., bayesian = TRUE, restart_session = TRUE, from_git = FALSE) {
  
  kerastuner_py_install = function(pkgs) {
    system(paste(reticulate::py_discover_config()[['python']],'-m pip install',
                 paste(pkgs,collapse = ' ')
    ))
  }
  
  
  if (is.null(version) & !from_git) {
    module_string <- paste0("keras-tuner==", '1.4.7')
  } else if (!is.null(version)) {
    module_string <- paste0("keras-tuner==", version)
  } else if (isTRUE(from_git)) {
    module_string <- paste0("git+https://github.com/keras-team/keras-tuner.git")
  }
  
  invisible(py_config())
  py_path = Sys.which('python') %>% as.character()
  
  #py_install(packages = paste(module_string, 'pydot'), pip = TRUE, ...)
  
  if(bayesian)
    all_ = paste(module_string, 'pydot', 'keras-tuner[bayesian]')
  else
    all_ = paste(module_string, 'pydot')
  
  kerastuner_py_install(all_)
  
  invisible(use_python(py_path, required = TRUE))
  py_install('pydot')
  
  fun <- function() {
    py_path = gsub(py_path, replacement = '/',pattern = '\\', fixed=TRUE)
    error <- red $ bold
    error2 <- red $ bold
    cat(error2("Keras Tuner is installed here:"), paste('"',error(py_path),'"',sep = ''))
  }
  
  fun()
  
  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()

}
