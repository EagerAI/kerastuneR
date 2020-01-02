#' A residual neural network is an artificial neural network of a kind that builds on constructs known from 
#' pyramidal cells in the cerebral cortex. 
#'
#' These are ready-to-use hypermodels for computer vision.
#' 
#' Note: They come pre-compiled with loss="categorical_crossentropy" and metrics=["accuracy"].
#' @param input_shape optional shape list, only to be specified if include_top is FALSE 
#' (otherwise the input shape has to be (224, 224, 3). It should have exactly 3 inputs channels, 
#' and width and height should be no smaller than 32. E.g. (200, 200, 3) would be one valid value.
#' @param num_classes optional number of classes to classify images into, only to be specified if include_top is True, 
#' and if no weights argument is specified.
#' @param ... Some additional arguments
#' @export
HyperResNet <- function(input_shape = NULL, num_classes = NULL, ...) {
  kerastuner$applications$HyperResNet(input_shape = input_shape, num_classes = num_classes, ...)
}

#' Xception is a convolutional neural network that is trained on more than a million images from the ImageNet 
#' database. The network is 71 layers deep and can classify images into 1000 object categories, such as keyboard,
#' mouse, pencil, and many animals.
#'
#' These are ready-to-use hypermodels for computer vision.
#' 
#' Note: They come pre-compiled with loss="categorical_crossentropy" and metrics=["accuracy"].
#' @param input_shape optional shape list, only to be specified if include_top is FALSE 
#' (otherwise the input shape has to be (224, 224, 3). It should have exactly 3 inputs channels, 
#' and width and height should be no smaller than 32. E.g. (200, 200, 3) would be one valid value.
#' @param num_classes optional number of classes to classify images into, only to be specified if include_top is True, 
#' and if no weights argument is specified.
#' @param ... Some additional arguments
#' @export
HyperXception <- function(input_shape = NULL, num_classes = NULL, ...) {
  kerastuner$applications$HyperXception(input_shape = input_shape, num_classes = num_classes, ...)
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
#' but that were not specified in hyperparameters should be added to the search space, or not. If not, 
#' then the default value for these parameters will be used.
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
                      tune_new_entries = NULL,
                      distribution_strategy = NULL,
                      directory = NULL, project_name = NULL,
                      ...) {
  kerastuner$tuners$Hyperband(hypermodel = hypermodel, 
                              optimizer = optimizer,
                              loss = loss,
                              metrics = metrics,
                              hyperparameters = hyperparameters,
                              objective = objective, 
                              max_epochs = max_epochs, 
                              factor = as.integer(factor),
                              hyperband_iterations = as.integer(hyperband_iterations),
                              seed = as.integer(seed),
                              tune_new_entries = tune_new_entries,
                              distribution_strategy = distribution_strategy,
                              directory = directory, 
                              project_name = project_name,
                              ...)
}

