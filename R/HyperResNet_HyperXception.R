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
#' @return a pre-trained ResNet model
#' @examples
#' 
#' \donttest{
#' library(keras)
#' library(dplyr)
#' library(kerastuneR)
#' 
#' kerastuneR::install_kerastuner()
#' 
#' cifar <- dataset_cifar10()
#' 
#' hypermodel = kerastuneR::HyperResNet(input_shape = list(32L, 32L, 3L), classes = 10L)
#' hypermodel2 = kerastuneR::HyperXception(input_shape = list(32L, 32L, 3L), classes = 10L)
#' 
#' 
#' tuner = kerastuneR::Hyperband(
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
HyperResNet <- function(include_top = TRUE, input_shape = NULL, input_tensor = NULL, classes = NULL) {
  
  python_function_result <- kerastuner$applications$HyperResNet(
    include_top = include_top,
    input_shape = input_shape,
    input_tensor = input_tensor,
    classes = classes
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
#' @return a pre-trained Xception model
#' @export
HyperXception <- function(include_top = TRUE, input_shape = NULL, input_tensor = NULL, classes = NULL) {
  
  python_function_result <- kerastuner$applications$HyperXception(
    include_top = include_top,
    input_shape = input_shape,
    input_tensor = input_tensor,
    classes = classes
  )
  
}

#' @title Hyperband
#'
#' @description Variation of HyperBand algorithm.
#'
#' @details Reference: Li, Lisha, and Kevin Jamieson. ["Hyperband: A Novel Bandit-Based Approach to Hyperparameter Optimization." Journal of Machine Learning Research 18 (2018): 1-52]( http://jmlr.org/papers/v18/16-558.html). # Arguments hypermodel: Instance of HyperModel class (or callable that takes hyperparameters and returns a Model instance). objective: String. Name of model metric to minimize or maximize, e.g. "val_accuracy". max_epochs: Int. The maximum number of epochs to train one model. It is recommended to set this to a value slightly higher than the expected time to convergence for your largest Model, and to use early stopping during training (for example, via `tf.keras.callbacks.EarlyStopping`). factor: Int. Reduction factor for the number of epochs and number of models for each bracket. hyperband_iterations: Int >= 1. The number of times to iterate over the full Hyperband algorithm. One iteration will run approximately `max_epochs * (math.log(max_epochs, factor) ** 2)` cumulative epochs across all trials. It is recommended to set this to as high a value as is within your resource budget. seed: Int. Random seed. hyperparameters: HyperParameters class instance. Can be used to override (or register in advance) hyperparamters in the search space. tune_new_entries: Whether hyperparameter entries that are requested by the hypermodel but that were not specified in `hyperparameters` should be added to the search space, or not. If not, then the default value for these parameters will be used. allow_new_entries: Whether the hypermodel is allowed to request hyperparameter entries not listed in `hyperparameters`. **kwargs: Keyword arguments relevant to all `Tuner` subclasses. Please see the docstring for `Tuner`.
#'
#' 
#' @param hypermodel Define a model-building function. It takes an argument "hp" from which 
#' you can sample hyperparameters.
#' @param optimizer An optimizer is one of the arguments required for compiling a Keras model
#' @param loss A loss function (or objective function, or optimization score function) is one of
#' the parameters required to compile a model
#' @param metrics A metric is a function that is used to judge the performance of your model
#' @param hyperparameters HyperParameters class instance. Can be used to override (or register in advance) 
#' hyperparamters in the search space.
#' @param objective A loss metrics function for tracking the model performance e.g. "val_precision". The name of 
#' the objective to optimize (whether to minimize or maximize is automatically inferred for built-in metrics)
#' @param max_epochs to train the model. Note that in conjunction with initial_epoch, 
#' epochs is to be understood as "final epoch". The model is not trained for a number of iterations
#' given by epochs, but merely until the epoch of index epochs is reached.
#' @param factor Int. Reduction factor for the number of epochs and number of models for each bracket.
#' @param hyperband_iterations Int >= 1. The number of times to iterate over the full Hyperband algorithm.
#' One iteration will run approximately ```max_epochs * (math.log(max_epochs, factor) ** 2)``` cumulative epochs
#' across all trials. It is recommended to set this to as high a value as is within your resource budget.
#' @param seed Int. Random seed.
#' @param tune_new_entries Whether hyperparameter entries that are requested by the hypermodel 
#' but that were not specified in hyperparameters should be added to the search space, or not. 
#' If not, then the default value for these parameters will be used.
#' @param allow_new_entries Whether the hypermodel is allowed to request hyperparameter entries not listed in 
#' `hyperparameters`. **kwargs: Keyword arguments relevant to all `Tuner` subclasses. Please see the docstring for `Tuner`.
#' @param distribution_strategy Scale up from running single-threaded locally to running on dozens or 
#' hundreds of workers in parallel. Distributed Keras Tuner uses a chief-worker model. The chief runs a 
#' service to which the workers report results and query for the hyperparameters to try next. The chief 
#' should be run on a single-threaded CPU instance (or alternatively as a separate process on 
#' one of the workers). Keras Tuner also supports data parallelism via tf.distribute. 
#' Data parallelism and distributed tuning can be combined. For example, if you have 10 workers 
#' with 4 GPUs on each worker, you can run 10 parallel trials with each trial training on 4 GPUs 
#' by using tf.distribute.MirroredStrategy. You can also run each trial on TPUs 
#' via tf.distribute.experimental.TPUStrategy. Currently tf.distribute.MultiWorkerMirroredStrategy 
#' is not supported, but support for this is on the roadmap.
#' @param directory The dir where training logs are stored
#' @param project_name Detailed logs, checkpoints, etc, in the folder my_dir/helloworld, i.e. 
#' directory/project_name.
#' @param ... Some additional arguments
#' @return a hyperparameter tuner object Hyperband
#' @section Reference:
#' Li, Lisha, and Kevin Jamieson. ["Hyperband: A Novel Bandit-Based Approach to Hyperparameter Optimization." Journal of Machine Learning Research 18 (2018): 1-52]( http://jmlr.org/papers/v18/16-558.html).
#'
#' @export
Hyperband <- function(hypermodel, optimizer = NULL, loss = NULL,
                      metrics = NULL,
                      hyperparameters = NULL, 
                      objective, max_epochs, factor = 3,
                      hyperband_iterations = 1,
                      seed = NULL,
                      tune_new_entries = TRUE,
                      allow_new_entries = TRUE,
                      distribution_strategy = NULL,
                      directory = NULL, project_name = NULL,
                      ...) {
  
  args = list(hypermodel = hypermodel, 
              optimizer = optimizer,
              objective = objective, 
              loss = loss,
              metrics = metrics,
              hyperparameters = hyperparameters,
              max_epochs = as.integer(max_epochs), 
              factor = as.integer(factor),
              hyperband_iterations = as.integer(hyperband_iterations),
              seed = as.integer(seed),
              tune_new_entries = tune_new_entries,
              distribution_strategy = distribution_strategy,
              directory = directory, 
              project_name = project_name,
              ...)
  
  if(is.null(optimizer))
    args$optimizer <- NULL
  
  if(is.null(loss))
    args$loss <- NULL
  
  if(is.null(metrics))
    args$metrics <- NULL
  
  if(is.null(hyperparameters))
    args$hyperparameters <- NULL
  
  if(is.null(seed))
    args$seed <- NULL
  else
    args$seed <- as.integer(args$seed)
  
  if(is.null(distribution_strategy))
    args$distribution_strategy <- NULL
  
  if(is.null(directory))
    args$directory <- NULL
  
  if(is.null(project_name))
    args$project_name <- NULL
  
  do.call(kerastuner$tuners$Hyperband, args)
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
