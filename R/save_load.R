#' @title Save model
#'
#' @description Saves a Model for a given trial
#' @param tuner A tuner object
#' @param trial_id The ID of the `Trial` that corresponds to this Model.
#' @param model The trained model.
#' @param step For models that report intermediate results to the `Oracle`, the 
#' step that this saved file should correspond to. For example, for Keras models 
#' this is the number of epochs trained.
#' @return None
#' @export
save_model <- function(tuner, trial_id, model, step = 1) {
  
  tuner$save_model(
    trial_id = trial_id,
    model = model,
    step = as.integer(step)
  )
}

#' @title Load model
#'
#' @description Loads a Model from a given trial
#' @param tuner A tuner object
#' @param trial A `Trial` instance. For models that report intermediate results 
#' to the `Oracle`, generally `load_model` should load the best reported `step` 
#' by relying of `trial.best_step`
#' @return None
#' @export
load_model <- function(tuner, trial) {
  
  tuner$load_model(
    trial = trial
  )
}

