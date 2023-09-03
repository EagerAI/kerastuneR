#' @title Oracle
#'
#' @description Implements a hyperparameter optimization algorithm.
#'
#' @details In a parallel tuning setting, there is only one `Oracle` instance. The
#' workers would communicate with the centralized `Oracle` instance with gPRC
#' calls to the `Oracle` methods. `Trial` objects are often used as the communication packet through the gPRC
#' calls to pass information between the worker `Tuner` instances and the
#' `Oracle`. For example, `Oracle.create_trial()` returns a `Trial` object, and
#' `Oracle.end_trial()` accepts a `Trial` in its arguments. New copies of the same `Trial` instance are reconstructed as it going
#' through the gRPC calls. The changes to the `Trial` objects in the worker
#' `Tuner`s are synced to the original copy in the `Oracle` when they are
#' passed back to the `Oracle` by calling `Oracle.end_trial()`.
#'
#' @param objective A string, `keras_tuner.Objective` instance, or a list of `keras_tuner.Objective`s and strings. If a string, the direction of the optimization (min or max) will be inferred. If a list of `keras_tuner.Objective`, we will minimize the sum of all the objectives to minimize subtracting the sum of all the objectives to maximize. The `objective` argument is optional when `Tuner.run_trial()` or `HyperModel.fit()` returns a single float as the objective to minimize.
#' @param max_trials Integer, the total number of trials (model configurations) to test at most. Note that the oracle may interrupt the search before `max_trial` models have been tested if the search space has been exhausted.
#' @param hyperparameters Optional `HyperParameters` instance. Can be used to override (or register in advance) hyperparameters in the search space.
#' @param allow_new_entries Boolean, whether the hypermodel is allowed to request hyperparameter entries not listed in `hyperparameters`. Defaults to TRUE.
#' @param tune_new_entries Boolean, whether hyperparameter entries that are requested by the hypermodel but that were not specified in `hyperparameters` should be added to the search space, or not. If not, then the default value for these parameters will be used. Defaults to TRUE.
#' @param seed Int. Random seed.
#' @param max_retries_per_trial Integer. Defaults to 0. The maximum number of times to retry a `Trial` if the trial crashed or the results are invalid.
#' @param max_consecutive_failed_trials Integer. Defaults to 3. The maximum number of consecutive failed `Trial`s. When this number is reached, the search will be stopped. A `Trial` is marked as failed when none of the retries succeeded.
#'
#' @return None
#' @export
Oracle <- function(objective = NULL, max_trials = NULL, 
                   hyperparameters = NULL, allow_new_entries = TRUE, 
                   tune_new_entries = TRUE, seed = NULL, 
                   max_retries_per_trial = 0, 
                   max_consecutive_failed_trials = 3) {
  
  args <- list(
    objective = objective,
    max_trials = max_trials,
    hyperparameters = hyperparameters,
    allow_new_entries = allow_new_entries,
    tune_new_entries = tune_new_entries,
    max_retries_per_trial = as.integer(max_retries_per_trial), 
    max_consecutive_failed_trials = as.integer(max_consecutive_failed_trials)
  )
  if(is.null(objective))
    args$objective <- as.integer(args$objective)  
  
  if(is.null(hyperparameters))
    args$hyperparameters <- as.integer(args$hyperparameters) 
  
  if(is.null(seed))
    args$seed <- NULL
  else
    args$seed <- as.integer(args$seed)
  
  if(!is.null(max_trials))
    args$max_trials <- as.integer(max_trials)
  
  do.call(kerastuner$Oracle, args)
  
}