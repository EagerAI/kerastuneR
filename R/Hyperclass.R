#' @title HyperModel
#'
#' @description Defines a searchable space of Models and builds Models from this space.
#'
#' @param name The name of this HyperModel.
#' @param tunable Whether the hyperparameters defined in this hypermodel should 
#' be added to search space. If `FALSE`, either the search space for these parameters 
#' must be defined in advance, or the default values will be used.
#' @return None
#' @export
HyperModel_class <- function(name = NULL, tunable = TRUE) {
  
  invisible(
    kerastuner$engine$hypermodel$HyperModel(
      name = name,
      tunable = tunable
    )
  )
  
  
}

#' @title Tuner
#'
#' @description Tuner class for Keras models.
#'
#' @details May be subclassed to create new tuners. 
#' 
#' @param oracle Instance of Oracle class.
#' @param hypermodel Instance of HyperModel class (or 
#' callable that takes hyperparameters and returns a 
#' Model instance).
#' @param max_model_size Int. Maximum size of weights 
#' (in floating point coefficients) for a valid models. 
#' Models larger than this are rejected.
#' @param optimizer Optional. Optimizer instance. May be 
#' used to override the `optimizer` argument in the `compile` 
#' step for the models. If the hypermodel does not compile 
#' the models it generates, then this argument must be specified.
#' @param loss Optional. May be used to override the `loss` 
#' argument in the `compile` step for the models. If the 
#' hypermodel does not compile the models it generates, 
#' then this argument must be specified.
#' @param metrics Optional. May be used to override the `metrics` 
#' argument in the `compile` step for the models. If the hypermodel 
#' does not compile the models it generates, then this argument 
#' must be specified.
#' @param distribution_strategy Optional. A TensorFlow `tf$distribute` 
#' DistributionStrategy instance. If specified, each trial will run 
#' under this scope. For example, `tf$distribute.MirroredStrategy(['/gpu:0, /'gpu:1])` 
#' will run each trial on two GPUs. Currently only single-worker strategies are supported.
#' @param directory String. Path to the working directory (relative).
#' @param project_name Name to use as prefix for files saved by this Tuner.
#' @param logger Optional. Instance of Logger class, used for 
#' streaming data to Cloud Service for monitoring.
#' @param tuner_id tuner_id
#' @param overwrite Bool, default `FALSE`. If `FALSE`, reloads an 
#' existing project of the same name if one is found. Otherwise, overwrites the project.
#' @return a tuner object
#' @export
Tuner_class <- function(oracle, hypermodel, max_model_size = NULL, 
                        optimizer = NULL, loss = NULL, metrics = NULL, 
                        distribution_strategy = NULL, directory = NULL, 
                        project_name = NULL, logger = NULL, tuner_id = NULL, overwrite = FALSE) {
  
  if(missing(oracle) & missing(hypermodel))
    invisible(kerastuner$Tuner)
  else
    kerastuner$Tuner(
      oracle = oracle,
      hypermodel = hypermodel,
      max_model_size = max_model_size,
      optimizer = optimizer,
      loss = loss,
      metrics = metrics,
      distribution_strategy = distribution_strategy,
      directory = directory,
      project_name = project_name,
      logger = logger,
      tuner_id = tuner_id,
      overwrite = overwrite
    )
}

#' @title Objective
#'
#' @description Objective(name, direction) includes strings, 
#' the direction of the optimization (min or max) will be inferred.
#'
#' @param name name
#' @param direction direction
#' @param ... Some additional arguments
#' @return None
#' @export
Objective <- function(name, direction, ...) {
  
  args <- list(
    name = name,
    direction = direction,
    ...
  )
  do.call(kerastuner$Objective, args)
}



