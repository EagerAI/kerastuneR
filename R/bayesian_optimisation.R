#' @title BayesianOptimization
#'
#' @description Bayesian optimization oracle.
#'
#' @details It uses Bayesian optimization with a underlying Gaussian process model.
#' The acquisition function used is upper confidence bound (UCB), which can
#' be found in the following link:
#' https://www.cse.wustl.edu/~garnett/cse515t/spring_2015/files/lecture_notes/12.pdf 
#' 
#' @param objective String or `kerastuner.Objective`. If a string, the direction of the optimization (min or max) will be inferred.
#' @param max_trials Int. Total number of trials (model configurations) to test at most. Note that the oracle may interrupt the search before `max_trial` models have been tested if the search space has been exhausted.
#' @param num_initial_points (Optional) Int. The number of randomly generated samples as initial training data for Bayesian optimization. If not specified, a value of 3 times the dimensionality of the hyperparameter space is used.
#' @param alpha Float. Value added to the diagonal of the kernel matrix during fitting. It represents the expected amount of noise in the observed performances in Bayesian optimization.
#' @param beta Float. The balancing factor of exploration and exploitation. The larger it is, the more explorative it is.
#' @param seed Int. Random seed.
#' @param hyperparameters HyperParameters class instance. Can be used to override (or register in advance) hyperparamters in the search space.
#' @param allow_new_entries Whether the hypermodel is allowed to request hyperparameter entries not listed in `hyperparameters`.
#' @param tune_new_entries Whether hyperparameter entries that are requested by the hypermodel but that were not specified in `hyperparameters` should be added to the search space, or not. If not, then the default value for these parameters will be used.
#' @return BayesianOptimization tuning with Gaussian process
#' @section be found in the following link:
#' https://www.cse.wustl.edu/~garnett/cse515t/spring_2015/files/lecture_notes/12.pdf
#' 
#' @examples
#' 
#' \donttest{
#' # The usage of 'tf$keras'
#' library(keras)
#' library(dplyr)
#' library(kerastuneR)
#' tf$keras$Input(shape=list(28L, 28L, 1L))
#' }
#' @export
BayesianOptimization <- function(objective, max_trials, num_initial_points = NULL, alpha = 0.0001, beta = 2.6, 
                                 seed = NULL, hyperparameters = NULL, allow_new_entries = TRUE, tune_new_entries = TRUE) {
  args = list(
    objective = objective,
    max_trials = as.integer(max_trials),
    num_initial_points = num_initial_points,
    alpha = alpha,
    beta = beta,
    seed = as.integer(seed),
    hyperparameters = hyperparameters,
    allow_new_entries = allow_new_entries,
    tune_new_entries = tune_new_entries
  )
  
  if (is.null(num_initial_points))
    args$num_initial_points <- NULL
  else
    args$num_initial_points <- as.integer(args$num_initial_points)
  
  if(is.null(seed))
    args$seed <- NULL
  else
    args$seed <- as.integer(args$seed)
  
  if(is.null(hyperparameters))
    args$hyperparameters <- NULL
  
  do.call(kerastuner$oracles$BayesianOptimization,args)
}
