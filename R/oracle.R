#' @title Oracle
#'
#' @description Implements a hyperparameter optimization algorithm.
#' 
#' @param objective String. Name of model metric to minimize or maximize, e.g. "val_accuracy".
#' @param max_trials The maximum number of hyperparameter combinations to try.
#' @param hyperparameters HyperParameters class instance. Can be used to override (or register in 
#' advance) hyperparamters in the search space.
#' @param allow_new_entries Whether the hypermodel is allowed to request hyperparameter entries 
#' not listed in `hyperparameters`.
#' @param tune_new_entries Whether hyperparameter entries that are requested by the hypermodel 
#' but that were not specified in `hyperparameters` should be added to the search space, or not. 
#' If not, then the default value for these parameters will be used.
#' @return None
#' @export
Oracle <- function(objective, max_trials = NULL, 
                   hyperparameters = NULL, 
                   allow_new_entries = TRUE, 
                   tune_new_entries = TRUE) {
  
  args <- list(
    objective = objective,
    max_trials = max_trials,
    hyperparameters = hyperparameters,
    allow_new_entries = allow_new_entries,
    tune_new_entries = tune_new_entries
  )
  
  do.call(kerastuner$Oracle, args)
  
}