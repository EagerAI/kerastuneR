#' @title BaseTuner
#'
#' @description Tuner base class.
#'
#' @details `BaseTuner` is the super class of all `Tuner` classes. It defines the APIs
#' for the `Tuner` classes and serves as a wrapper class for the internal
#' logics. `BaseTuner` supports parallel tuning. In parallel tuning, the communication
#' between `BaseTuner` and `Oracle` are all going through gRPC. There are
#' multiple running instances of `BaseTuner` but only one `Oracle`. This design
#' allows the user to run the same script on multiple machines to launch the
#' parallel tuning. The `Oracle` instance should manage the life cycles of all the `Trial`s,
#' while a `BaseTuner` is a worker for running the `Trial`s. `BaseTuner`s
#' requests `Trial`s from the `Oracle`, run them, and report the results back
#' to the `Oracle`. A `BaseTuner` also handles events happening during running
#' the `Trial`, like saving the model, logging, error handling. Other than
#' these responsibilities, a `BaseTuner` should avoid managing a `Trial` since
#' the relevant contexts for a `Trial` are in the `Oracle`, which only
#' accessible from gRPC. The `BaseTuner` should be a general tuner for all types of models and avoid
#' any logic directly related to Keras. The Keras related logics should be
#' handled by the `Tuner` class, which is a subclass of `BaseTuner`.
#'
#' @param oracle Instance of Oracle class.
#' @param hypermodel Instance of `HyperModel` class (or callable that takes hyperparameters and returns a `Model` instance). It is optional when `Tuner.run_trial()` is overriden and does not use `self.hypermodel`.
#' @param directory A string, the relative path to the working directory.
#' @param project_name A string, the name to use as prefix for files saved by this Tuner.
#' @param overwrite Boolean, defaults to `FALSE`. If `FALSE`, reloads an existing project of the same name if one is found. Otherwise, overwrites the project. **kwargs: Arguments for backward compatibility.
#'
#' @section Attributes:
#' remaining_trials: Number of trials remaining, `NULL` if `max_trials` is not set. This is useful when resuming a previously stopped search.
#'
#' @return base tuner object
#' @export
BaseTuner <- function(oracle, hypermodel, directory = NULL, project_name = NULL, overwrite = FALSE) {

  if(missing(oracle) & missing(hypermodel)) {
    kerastuner$engine$base_tuner$BaseTuner
  } else {
    kerastuner$engine$base_tuner$BaseTuner(
      oracle = oracle,
      hypermodel = hypermodel,
      directory = directory,
      project_name = project_name,
      overwrite = overwrite
    )
  }
  
}
