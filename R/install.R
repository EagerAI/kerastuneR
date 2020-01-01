#' Install Keras Tuner
#' This function is used to install the Keras Tuner python module on Mac OS and Linux (Windows will be added later)
#' @param python_path python_path specifies the python path for installation via terminal
#' @param version for specific version of Keras tuneR, e.g. "0.9.1"
#' @param upgrade is helpful if one wants to upgrade a version of Keras TuneR
#' @export
install_kerastuner <- function(python_path = NULL, upgrade = FALSE, version = NULL) {
  os = switch(Sys.info()[['sysname']],
         Windows= {paste("win")},
         Linux  = {paste("lin")},
         Darwin = {paste("mac")})
  if (!is.null(python_path) && is.null(version) && isFALSE(upgrade) && !os == 'win') {
    rstudioapi::terminalExecute(command = paste(python_path, ' -m pip install keras-tuner'))
  } else if (!is.null(python_path) && upgrade && !os == 'win') {
    rstudioapi::terminalExecute(command = paste(python_path, '-m pip install keras-tuner --upgrade'))
  } else if (!is.null(version) && !is.null(python_path) && !os == 'win') {
    rstudioapi::terminalExecute(command = paste(python_path, ' -m pip install keras-tuner==',version,sep = ''))
  } else if (!is.null(python_path) && os == 'win') {
    warning('Please install "pip install keras-tuner==1.0.0" from python')
  }
  else {
    warning('Python location is not provided')
  }
}


