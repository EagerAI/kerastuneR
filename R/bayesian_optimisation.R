#' @title Bayesian Optimization
#'
#' @description Bayesian optimization oracle.
#'
#' @details It uses Bayesian optimization with a underlying Gaussian process model.
#' The acquisition function used is upper confidence bound (UCB), which can
#' be found [here](
#' https://www.cse.wustl.edu/~garnett/cse515t/spring_2015/files/lecture_notes/12.pdf).
#'
#' @param objective A string, `keras_tuner.Objective` instance, or a list of `keras_tuner.Objective`s and strings. If a string, the direction of the optimization (min or max) will be inferred. If a list of `keras_tuner.Objective`, we will minimize the sum of all the objectives to minimize subtracting the sum of all the objectives to maximize. The `objective` argument is optional when `Tuner.run_trial()` or `HyperModel.fit()` returns a single float as the objective to minimize.
#' @param max_trials Integer, the total number of trials (model configurations) to test at most. Note that the oracle may interrupt the search before `max_trial` models have been tested if the search space has been exhausted. Defaults to 10.
#' @param num_initial_points Optional number of randomly generated samples as initial training data for Bayesian optimization. If left unspecified, a value of 3 times the dimensionality of the hyperparameter space is used.
#' @param alpha Float, the value added to the diagonal of the kernel matrix during fitting. It represents the expected amount of noise in the observed performances in Bayesian optimization. Defaults to 1e-4.
#' @param beta Float, the balancing factor of exploration and exploitation. The larger it is, the more explorative it is. Defaults to 2.6.
#' @param seed Optional integer, the random seed.
#' @param hyperparameters Optional `HyperParameters` instance. Can be used to override (or register in advance) hyperparameters in the search space.
#' @param allow_new_entries Boolean, whether the hypermodel is allowed to request hyperparameter entries not listed in `hyperparameters`. Defaults to TRUE.
#' @param tune_new_entries Boolean, whether hyperparameter entries that are requested by the hypermodel but that were not specified in `hyperparameters` should be added to the search space, or not. If not, then the default value for these parameters will be used. Defaults to TRUE.
#' @param max_retries_per_trial Integer. Defaults to 0. The maximum number of times to retry a `Trial` if the trial crashed or the results are invalid.
#' @param max_consecutive_failed_trials Integer. Defaults to 3. The maximum number of consecutive failed `Trial`s. When this number is reached, the search will be stopped. A `Trial` is marked as failed when none of the retries succeeded.
#' @return BayesianOptimization tuning with Gaussian process
#' @examples
#' 
#' \dontrun{
#' # The usage of 'tf$keras'
#' library(tensorflow)
#' tf$keras$Input(shape=list(28L, 28L, 1L))
#' }
#' @export
BayesianOptimization <- function(objective = NULL, max_trials = 10, 
                                 num_initial_points = NULL, alpha = 0.0001, 
                                 beta = 2.6, seed = NULL, hyperparameters = NULL, 
                                 allow_new_entries = TRUE, tune_new_entries = TRUE, 
                                 max_retries_per_trial = 0, 
                                 max_consecutive_failed_trials = 3) {

  if(missing(objective)) {
    invisible(kerastuner$oracles$BayesianOptimizationOracle)
  } else {
    args = list(
      objective = objective,
      max_trials = as.integer(max_trials),
      num_initial_points = num_initial_points,
      alpha = alpha,
      beta = beta,
      seed = seed,
      hyperparameters = hyperparameters,
      allow_new_entries = allow_new_entries,
      tune_new_entries = tune_new_entries,
      max_retries_per_trial = max_retries_per_trial, 
      max_consecutive_failed_trials = max_consecutive_failed_trials
    )
    
    if (is.null(num_initial_points))
      args$num_initial_points <- NULL
    else
      args$num_initial_points <- as.integer(args$num_initial_points)
    
    if(is.null(seed))
      args$seed <- NULL
    else
      args$seed <- as.integer(args$seed)
    
    if(is.null(max_retries_per_trial))
      args$max_retries_per_trial <- NULL
    else
      args$max_retries_per_trial <- as.integer(args$max_retries_per_trial)
    
    if(is.null(max_consecutive_failed_trials))
      args$max_consecutive_failed_trials <- NULL
    else
      args$max_consecutive_failed_trials <- as.integer(args$max_consecutive_failed_trials)
    
    if(is.null(hyperparameters))
      args$hyperparameters <- NULL
    
    do.call(kerastuner$oracles$BayesianOptimizationOracle,args)
  }
}
