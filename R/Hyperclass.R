#' @title HyperModel
#'
#' @description Defines a searchable space of Models and builds Models from this space.
#'
#' @details # Attributes: name: The name of this HyperModel. tunable: Whether the hyperparameters defined in this hypermodel 
#' should be added to search space. If `FALSE`, either the search space for these parameters must be defined in advance, 
#' or the default values will be used.
#' @return None
#' @export
HyperModel_class <- function() {
  return(invisible(kerastuner$engine$hypermodel$HyperModel))
}

#' @title Tuner
#'
#' @description Tuner class for Keras models.
#'
#' @details May be subclassed to create new tuners. # Arguments: oracle: Instance of Oracle class. hypermodel: Instance of HyperModel class (or callable that takes hyperparameters and returns a Model instance). max_model_size: Int. Maximum size of weights (in floating point coefficients) for a valid models. Models larger than this are rejected. optimizer: Optional. Optimizer instance. May be used to override the `optimizer` argument in the `compile` step for the models. If the hypermodel does not compile the models it generates, then this argument must be specified. loss: Optional. May be used to override the `loss` argument in the `compile` step for the models. If the hypermodel does not compile the models it generates, then this argument must be specified. metrics: Optional. May be used to override the `metrics` argument in the `compile` step for the models. If the hypermodel does not compile the models it generates, then this argument must be specified. distribution_strategy: Optional. A TensorFlow `tf.distribute` DistributionStrategy instance. If specified, each trial will run under this scope. For example, `tf.distribute.MirroredStrategy(['/gpu:0, /'gpu:1])` will run each trial on two GPUs. Currently only single-worker strategies are supported. directory: String. Path to the working directory (relative). project_name: Name to use as prefix for files saved by this Tuner. logger: Optional. Instance of Logger class, used for streaming data to Cloud Service for monitoring. overwrite: Bool, default `FALSE`. If `FALSE`, reloads an existing project of the same name if one is found. Otherwise, overwrites the project.
#'
#' @return None
#' @export
Tuner_class <- function(){
  object = kerastuner$Tuner
  return(invisible(object))
}

#' @title Objective
#'
#' @description Objective(name, direction) includes strings, the direction of the optimization (min or max) will be inferred.
#'
#' @param name name
#' @param direction direction
#' @param ... Some additional arguments
#' @return None
#' @export
Objective <- function(name, direction, ...) {
  
  args <- c(
    name = name,
    direction = direction,
    ...
  )
  do.call(kerastuner$Objective, args)
}



