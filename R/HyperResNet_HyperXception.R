#' @title HyperResNet
#'
#' @description A ResNet HyperModel.
#'
#' @details # Arguments: include_top: whether to include the fully-connected layer at the top of the network. input_shape: Optional shape list, e.g. `(256, 256, 3)`. One of `input_shape` or `input_tensor` must be specified. input_tensor: Optional Keras tensor (i.e. output of `layers.Input()`) to use as image input for the model. One of `input_shape` or `input_tensor` must be specified. classes: optional number of classes to classify images into, only to be specified if `include_top` is TRUE, and if no `weights` argument is specified. **kwargs: Additional keyword arguments that apply to all HyperModels. See `kerastuner.HyperModel`.
#'
#' @param include_top whether to include the fully-connected layer at the top of the network.
#' @param input_shape Optional shape list, e.g. `(256, 256, 3)`. One of `input_shape` or `input_tensor` must be specified.
#' @param input_tensor Optional Keras tensor (i.e. output of `layers.Input()`) to use as image input for the model. One of `input_shape` or `input_tensor` must be specified.
#' @param classes optional number of classes to classify images into, only to be specified if `include_top` is TRUE, and if no `weights` argument is specified. **kwargs: Additional keyword arguments that apply to all HyperModels. See `kerastuner.HyperModel`.
#'
#' @examples
#'
#' \dontrun{
#'
#' library(keras)
#' library(dplyr)
#' library(kerastuneR)
#' 
#' use_python('C:/Users/turgut.abdullayev/AppData/Local/Continuum/anaconda3/python.exe',required = TRUE)
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
#'
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
#' @details Arguments: include_top: whether to include the fully-connected layer at the top of the network. input_shape: Optional shape list, e.g. `(256, 256, 3)`. One of `input_shape` or `input_tensor` must be specified. input_tensor: Optional Keras tensor (i.e. output of `layers.Input()`) to use as image input for the model. One of `input_shape` or `input_tensor` must be specified. classes: optional number of classes to classify images into, only to be specified if `include_top` is TRUE, and if no `weights` argument is specified. **kwargs: Additional keyword arguments that apply to all HyperModels. See `kerastuner.HyperModel`.
#'
#' @param include_top whether to include the fully-connected layer at the top of the network.
#' @param input_shape Optional shape list, e.g. `(256, 256, 3)`. One of `input_shape` or `input_tensor` must be specified.
#' @param input_tensor Optional Keras tensor (i.e. output of `layers.Input()`) to use as image input for the model. One of `input_shape` or `input_tensor` must be specified.
#' @param classes optional number of classes to classify images into, only to be specified if `include_top` is TRUE, and if no `weights` argument is specified. **kwargs: Additional keyword arguments that apply to all HyperModels. See `kerastuner.HyperModel`.
#'
#' @export
HyperXception <- function(include_top = TRUE, input_shape = NULL, input_tensor = NULL, classes = NULL) {
  
  python_function_result <- kerastuner$applications$HyperXception(
    include_top = include_top,
    input_shape = input_shape,
    input_tensor = input_tensor,
    classes = classes
  )
  
}

#' Tool for searching the best hyperparameters for computer vision.
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
#' @export
Hyperband <- function(hypermodel = NULL, optimizer = NULL, loss = NULL,
                      metrics = NULL,
                      hyperparameters = NULL, 
                      objective = NULL, max_epochs = NULL, factor = NULL,
                      hyperband_iterations = NULL,
                      seed = NULL,
                      tune_new_entries = TRUE,
                      distribution_strategy = NULL,
                      directory = NULL, project_name = NULL,
                      ...) {
  
  args = c(hypermodel = hypermodel, 
              objective = objective, 
              loss = loss,
              optimizer = optimizer,
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
  do.call(kerastuner$tuners$Hyperband, args)
}


#'
#' The search space may contain conditional hyperparameters
#' 
#' @param ... Pass hyperparameter arguments to the tuner constructor
#' @export
HyperParameters = function(...){
  args = list(...)
  do.call(kerastuner$HyperParameters,args = args)
}
