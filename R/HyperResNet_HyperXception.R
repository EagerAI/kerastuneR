#' @title HyperResNet
#'
#' @description A ResNet HyperModel.
#'
#' @param include_top whether to include the fully-connected layer at the top of the network.
#' @param input_shape Optional shape list, e.g. `(256, 256, 3)`. One of `input_shape` or 
#' `input_tensor` must be specified.
#' @param input_tensor Optional Keras tensor (i.e. output of `layers.Input()`) to use as image 
#' input for the model. One of `input_shape` or `input_tensor` must be specified.
#' @param classes optional number of classes to classify images into, only to be specified if 
#' `include_top` is TRUE, and if no `weights` argument is specified. **kwargs: Additional keyword 
#' arguments that apply to all HyperModels. See `kerastuner.HyperModel`.
#' @param ... Additional keyword arguments that apply to all HyperModels.
#' @return a pre-trained ResNet model
#' @examples
#' 
#' \dontrun{
#' 
#' 
#' cifar <- dataset_cifar10()
#' 
#' hypermodel = HyperResNet(input_shape = list(32L, 32L, 3L), classes = 10L)
#' hypermodel2 = HyperXception(input_shape = list(32L, 32L, 3L), classes = 10L)
#' 
#' 
#' tuner = Hyperband(
#'   hypermodel = hypermodel,
#'   objective = 'accuracy',
#'   loss = 'sparse_categorical_crossentropy',
#'   max_epochs = 1,
#'   directory = 'my_dir',
#'   project_name='helloworld')
#' 
#' 
#' train_data = cifar$train$x[1:30,1:32,1:32,1:3]
#' test_data = cifar$train$y[1:30,1] %>% as.matrix()
#' 
#' 
#' tuner %>% fit_tuner(train_data,test_data, epochs = 1)
#' }
#' @export
HyperResNet <- function(include_top = TRUE, input_shape = NULL, input_tensor = NULL, classes = NULL,...) {
  
  kerastuner$applications$HyperResNet(
    include_top = include_top,
    input_shape = input_shape,
    input_tensor = input_tensor,
    classes = classes,
    ...
  )
  
}

#' @title HyperXception
#'
#' @description An Xception HyperModel.
#'
#' @param include_top whether to include the fully-connected layer at the top of the network.
#' @param input_shape Optional shape list, e.g. `(256, 256, 3)`. One of `input_shape` or 
#' `input_tensor` must be specified.
#' @param input_tensor Optional Keras tensor (i.e. output of `layers.Input()`) to use as 
#' image input for the model. One of `input_shape` or `input_tensor` must be specified.
#' @param classes optional number of classes to classify images into, only to be specified 
#' if `include_top` is TRUE, and if no `weights` argument is specified. **kwargs: Additional 
#' keyword arguments that apply to all HyperModels. See `kerastuner.HyperModel`.
#' @param ... Additional keyword arguments that apply to all HyperModels.
#' @return a pre-trained Xception model
#' @export
HyperXception <- function(include_top = TRUE, input_shape = NULL, input_tensor = NULL, classes = NULL,...) {
  
  kerastuner$applications$HyperXception(
    include_top = include_top,
    input_shape = input_shape,
    input_tensor = input_tensor,
    classes = classes,
    ...
  )
  
}

#' @title Hyperband
#'
#' @description Variation of HyperBand algorithm.
#'
#' @details Reference: Li, Lisha, and Kevin Jamieson. ["Hyperband: A Novel Bandit-Based Approach to Hyperparameter Optimization." Journal of Machine Learning Research 18 (2018): 1-52]( http://jmlr.org/papers/v18/16-558.html).
#'
#' @param hypermodel Instance of `HyperModel` class (or callable that takes hyperparameters and returns a `Model` instance). It is optional when `Tuner.run_trial()` is overriden and does not use `self.hypermodel`.
#' @param objective A string, `keras_tuner.Objective` instance, or a list of `keras_tuner.Objective`s and strings. If a string, the direction of the optimization (min or max) will be inferred. If a list of `keras_tuner.Objective`, we will minimize the sum of all the objectives to minimize subtracting the sum of all the objectives to maximize. The `objective` argument is optional when `Tuner.run_trial()` or `HyperModel.fit()` returns a single float as the objective to minimize.
#' @param max_epochs Integer, the maximum number of epochs to train one model. It is recommended to set this to a value slightly higher than the expected epochs to convergence for your largest Model, and to use early stopping during training (for example, via `tf.keras.callbacks.EarlyStopping`). Defaults to 100.
#' @param factor Integer, the reduction factor for the number of epochs and number of models for each bracket. Defaults to 3.
#' @param hyperband_iterations Integer, at least 1, the number of times to iterate over the full Hyperband algorithm. One iteration will run approximately `max_epochs * (math.log(max_epochs, factor) ** 2)` cumulative epochs across all trials. It is recommended to set this to as high a value as is within your resource budget. Defaults to 1.
#' @param seed Optional integer, the random seed.
#' @param hyperparameters Optional HyperParameters instance. Can be used to override (or register in advance) hyperparameters in the search space.
#' @param tune_new_entries Boolean, whether hyperparameter entries that are requested by the hypermodel but that were not specified in `hyperparameters` should be added to the search space, or not. If not, then the default value for these parameters will be used. Defaults to TRUE.
#' @param allow_new_entries Boolean, whether the hypermodel is allowed to request hyperparameter entries not listed in `hyperparameters`. Defaults to TRUE.
#' @param max_retries_per_trial Integer. Defaults to 0. The maximum number of times to retry a `Trial` if the trial crashed or the results are invalid.
#' @param max_consecutive_failed_trials Integer. Defaults to 3. The maximum number of consecutive failed `Trial`s. When this number is reached, the search will be stopped. A `Trial` is marked as failed when none of the retries succeeded. **kwargs: Keyword arguments relevant to all `Tuner` subclasses. Please see the docstring for `Tuner`.
#'
#' @section Reference:
#' Li, Lisha, and Kevin Jamieson. ["Hyperband: A Novel Bandit-Based Approach to Hyperparameter Optimization." Journal of Machine Learning Research 18 (2018): 1-52]( http://jmlr.org/papers/v18/16-558.html).
#'
#' @param ... Some additional arguments
#' @return a hyperparameter tuner object Hyperband
#' @export
Hyperband <- function(hypermodel = NULL, objective = NULL, 
                      max_epochs = 100, factor = 3, hyperband_iterations = 1, 
                      seed = NULL, hyperparameters = NULL, tune_new_entries = TRUE, 
                      allow_new_entries = TRUE, max_retries_per_trial = 0, 
                      max_consecutive_failed_trials = 3,
                      
                      ...) {
  

  if(missing(hypermodel)) {
    kerastuner$tuners$Hyperband
  } else {
    args = list(hypermodel = hypermodel, objective = objective, 
                max_epochs = as.integer(max_epochs), 
                factor = as.factor(factor), 
                hyperband_iterations = as.integer(hyperband_iterations), 
                seed = seed, 
                hyperparameters = hyperparameters, tune_new_entries = tune_new_entries, 
                allow_new_entries = allow_new_entries, 
                max_retries_per_trial = as.integer(max_retries_per_trial), 
                max_consecutive_failed_trials = as.integer(max_consecutive_failed_trials),
                ...)
    
    if(is.null(hypermodel))
      args$hypermodel <- NULL
    
    if(is.null(objective))
      args$objective <- NULL
    
    if(is.null(hyperparameters))
      args$hyperparameters <- NULL
    
    if(is.null(seed))
      args$seed <- NULL
    else
      args$seed <- as.integer(args$seed)
    
    do.call(kerastuner$tuners$Hyperband, args)
  }
}


#' @title HyperParameters
#' 
#' @description The HyperParameters class serves as a hyperparameter container. A HyperParameters instance contains information about both the search space and the current values of each hyperparameter.
#' Hyperparameters can be defined inline with the model-building code that uses them. This saves you from having to write boilerplate code and helps to make the code more maintainable.
#' @return container for both a hyperparameter space, and current values
#' @param ... Pass hyperparameter arguments to the tuner constructor
#' @export
HyperParameters = function(...){
  args = list(...)
  do.call(kerastuner$HyperParameters,args = args)
}
