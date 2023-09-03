#' @title RandomSearch
#'
#' @description Random search tuner.
#'
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
#' @param max_retries_per_trial Integer. Defaults to 0. The maximum number of times to retry a `Trial` if the trial crashed or the results are invalid.
#' @param max_consecutive_failed_trials Integer. Defaults to 3. The maximum number of consecutive failed `Trial`s. When this number is reached, the search will be stopped. A `Trial` is marked as failed when none of the retries succeeded. **kwargs: Keyword arguments relevant to all `Tuner` subclasses. Please see the docstring for `Tuner`.
#' @param ... Some additional arguments
#' @return a hyperparameter tuner object RandomSearch
#' @examples
#'
#' \dontrun{
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
#'  tuner = RandomSearch(hypermodel = build_model,
#'                        objective = 'val_accuracy',
#'                        max_trials = 2,
#'                        executions_per_trial = 1)
#' }
#' 
#' @export
RandomSearch = function(hypermodel, objective, max_trials, seed = NULL, 
                        hyperparameters = NULL, tune_new_entries = TRUE,
                        allow_new_entries = TRUE,
                        max_retries_per_trial = 0, max_consecutive_failed_trials = 3,
                        ...) {
  
  args = list(
    hypermodel = hypermodel,
    objective = objective,
    max_trials = as.integer(max_trials),
    seed = seed,
    hyperparameters = hyperparameters,
    tune_new_entries = tune_new_entries,
    allow_new_entries = allow_new_entries,
    max_retries_per_trial = as.integer(max_retries_per_trial),
    max_consecutive_failed_trials = as.integer(max_consecutive_failed_trials),
    ...)
  
  if(is.null(seed))
    args$seed <- NULL
  else
    args$seed <- as.integer(args$seed)
  
  if(is.null(hyperparameters))
    args$hyperparameters <- NULL
  
  
  
  do.call(kerastuner$tuners$RandomSearch, args)
  
}

