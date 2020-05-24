#' @title Base Tuner
#'
#' @description Tuner base class.
#'
#' @details May be subclassed to create new tuners, including for non-Keras models. 
#' 
#' @param oracle Instance of Oracle class.
#' @param hypermodel Instance of HyperModel class (or callable that takes 
#' hyperparameters and returns a Model instance).
#' @param directory String. Path to the working directory (relative).
#' @param project_name Name to use as prefix for files saved by this Tuner.
#' @param logger Optional. Instance of Logger class, used for streaming 
#' data to Cloud Service for monitoring.
#' @param overwrite Bool, default `FALSE`. If `FALSE`, reloads an existing 
#' project of the same name if one is found. Otherwise, overwrites the project.
#'
#' @export
BaseTuner <- function(oracle, hypermodel, directory = NULL, project_name = NULL, logger = NULL, overwrite = FALSE) {

  if(missing(oracle) & missing(hypermodel)) {
    kerastuner$engine$base_tuner$BaseTuner
  } else {
    kerastuner$engine$base_tuner$BaseTuner(
      oracle = oracle,
      hypermodel = hypermodel,
      directory = directory,
      project_name = project_name,
      logger = logger,
      overwrite = overwrite
    )
  }
  
}
