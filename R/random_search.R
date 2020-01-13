#' Build model
#'
#' Usage: the basics
#'
#' Here's how to perform hyperparameter tuning for a single-layer dense neural network using random search.
#' First, we define a model-building function. It takes an argument hp from which you can sample hyperparameters,
#' such as hp$Int('units', min_value=32L, max_value=512L, step=32L) (an integer from a certain range) and hp$Choice
#' for choosing a range of values for learning rate.
#'
#' @param hypermodel Define a model-building function. It takes an argument "hp" from which 
#' you can sample hyperparameters.
#' @param objective A loss metrics function for tracking the model performance e.g. "val_precision". The name of 
#' the objective to optimize (whether to minimize or maximize is automatically inferred for built-in metrics)
#' @param max_trials the total number of trials (max_trials) to test
#' @param seed Int. Random seed
#' @param hyperparameters HyperParameters class instance. Can be used to override (or register in advance) hyperparamters 
#' in the search space
#' @param tune_new_entries Whether hyperparameter entries that are requested by the hypermodel 
#' but that were not specified in hyperparameters should be added to the search space, or not. 
#' If not, then the default value for these parameters will be used.
#' @param allow_new_entries Whether the hypermodel is allowed to request hyperparameter entries not listed in hyperparameters
#' @param executions_per_trial the number of models that should be built and fit for each trial 
#' (executions_per_trial). Note: the purpose of having multiple executions per trial is to reduce results 
#' variance and therefore be able to more accurately assess the performance of a model. If you want to get 
#' results faster, you could set executions_per_trial=1 (single round of training for each model configuration)
#' @param directory The dir where training logs are stored
#' @param project_name Detailed logs, checkpoints, etc, in the folder my_dir/helloworld, i.e. 
#' directory/project_name.
#' @param ... Some additional arguments
#'
#' @examples
#'
#' \dontrun{
#'
#' library(keras) 
#' library(tensorflow)
#' 
#' x_data <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5) 
#' y_data <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
#' x_data2 <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
#' y_data2 <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
#' 
#' build_model = function(hp) {
#'  model = keras_model_sequential()
#'   model %>% layer_dense(units=hp$Int('units',
#'                                     min_value=32L,
#'                                     max_value=512L,
#'                                     step=32L),
#'                                     input_shape = ncol(x_data),
#'                                     activation='relu') %>%
#'    layer_dense(units=1L, activation='softmax') %>%
#'    compile(
#'      optimizer= tf$keras$optimizers$Adam(
#'        hp$Choice('learning_rate',
#'                  values=c(1e-2, 1e-3, 1e-4))),
#'     loss='binary_crossentropy',
#'      metrics='accuracy')
#'      return(model)
#'  }
#' }
#' 
#' 
#' @export
RandomSearch = function(hypermodel = NULL, objective = NULL, max_trials = NULL, seed = NULL, 
                        hyperparameters = NULL, tune_new_entries = TRUE,
                        allow_new_entries = TRUE,
                        executions_per_trial = NULL, 
                        directory = NULL, project_name = NULL, ...) {
  if(dir.exists(directory)) {
    warning('The provided dir name already exists, please specify another name')
  } else {
    args = c(
      hypermodel = hypermodel,
      objective = objective,
      max_trials = as.integer(max_trials),
      seed = as.integer(seed),
      hyperparameters = hyperparameters,
      tune_new_entries = tune_new_entries,
      allow_new_entries = allow_new_entries,
      executions_per_trial = as.integer(executions_per_trial),
      directory = directory,
      project_name = project_name,
      ...)
    do.call(kerastuner$RandomSearch, args)
  }
}

