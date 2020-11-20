#' @title BayesianOptimization
#'
#' @description Bayesian optimization tuner.
#'
#' @details It uses Bayesian optimization with a underlying Gaussian process model.
#' The acquisition function used is upper confidence bound (UCB), which can
#' be found in the following link:
#' https://www.cse.wustl.edu/~garnett/cse515t/spring_2015/files/lecture_notes/12.pdf 
#' 
#' @param hypermodel Define a model-building function. It takes an argument "hp" from which 
#' you can sample hyperparameters.
#' @param objective String or `kerastuner.Objective`. If a string, the direction of the 
#' optimization (min or max) will be inferred.
#' @param max_trials Int. Total number of trials (model configurations) to test at most. 
#' Note that the oracle may interrupt the search before `max_trial` models have been tested 
#' if the search space has been exhausted.
#' @param num_initial_points (Optional) Int. The number of randomly generated samples as 
#' initial training data for Bayesian optimization. If not specified, a value of 3 times 
#' the dimensionality of the hyperparameter space is used.
#' @param alpha Float. Value added to the diagonal of the kernel matrix during fitting. 
#' It represents the expected amount of noise in the observed performances in 
#' Bayesian optimization.
#' @param beta Float. The balancing factor of exploration and exploitation. The 
#' larger it is, the more explorative it is.
#' @param seed Int. Random seed.
#' @param hyperparameters HyperParameters class instance. Can be used to override 
#' (or register in advance) hyperparamters in the search space.
#' @param allow_new_entries Whether the hypermodel is allowed to request hyperparameter 
#' entries not listed in `hyperparameters`.
#' @param tune_new_entries Whether hyperparameter entries that are requested by the 
#' hypermodel but that were not specified in `hyperparameters` should be added to the search space, or not. If not, then the default value for these parameters will be used.
#' @param executions_per_trial the number of models that should be built and fit for each trial 
#' (executions_per_trial). Note: the purpose of having multiple executions per trial is to reduce results 
#' variance and therefore be able to more accurately assess the performance of a model. If you want to get 
#' results faster, you could set executions_per_trial=1 (single round of training for each model configuration)
#' @return BayesianOptimization tuning with Gaussian process
#' @section be found in the following link:
#' https://www.cse.wustl.edu/~garnett/cse515t/spring_2015/files/lecture_notes/12.pdf
#' 
#' @examples
#' 
#' \dontrun{
#' # The usage of 'tf$keras'
#' library(tensorflow)
#' tf$keras$Input(shape=list(28L, 28L, 1L))
#' }
#' @export
BayesianOptimization <- function(hypermodel, objective, max_trials, num_initial_points = NULL, 
                                 hyperparameters = NULL,
                                 seed = NULL, allow_new_entries = TRUE, 
                                 tune_new_entries = TRUE, executions_per_trial = NULL,
                                 directory = NULL, project_name = NULL, ...) {
  
  if(missing(objective)) {
    invisible(kerastuner$tuners$BayesianOptimization)
  }
  
  args = list(
    hypermodel = hypermodel,
    objective = objective,
    max_trials = as.integer(max_trials),
    num_initial_points = num_initial_points,
    seed = as.integer(seed),
    hyperparameters = hyperparameters,
    allow_new_entries = allow_new_entries,
    tune_new_entries = tune_new_entries,
    directory = directory,
    project_name = project_name,
    ...)
  
  if(is.null(seed))
    args$seed <- NULL
  else
    args$seed <- as.integer(args$seed)
  
  if(is.null(hyperparameters))
    args$hyperparameters <- NULL
  
  if(is.null(directory))
    args$directory <- NULL
  
  if(is.null(executions_per_trial))
    args$executions_per_trial <- NULL
  else
    args$executions_per_trial <- as.integer(executions_per_trial)
  
  
  if (is.null(num_initial_points))
    args$num_initial_points <- NULL
  else
    args$num_initial_points <- as.integer(args$num_initial_points)
  
  
  if(is.null(project_name))
    args$project_name <- NULL
  
  do.call(kerastuner$tuners$BayesianOptimization,args)
}

