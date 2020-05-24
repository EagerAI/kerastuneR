#' @title Tuner Callback
#'
#' @description Abstract base class used to build new callbacks.
#'
#' @details Attributes: params: dict. Training parameters (eg. verbosity, 
#' batch size, number of epochs...). model: instance of `keras.models.Model`. 
#' Reference of the model being trained. validation_data: 
#' Deprecated. Do not use. The `logs` dictionary that callback methods
#' take as argument will contain keys for quantities relevant to
#' the current batch or epoch. Currently, the `.fit()` method of the `Model` class
#' will include the following quantities in the `logs` that
#' it passes to its callbacks: on_epoch_end: logs include `acc` and `loss`, 
#' and optionally include `val_loss` (if validation is enabled in `fit`), and 
#' `val_acc` (if validation and accuracy monitoring are enabled). on_batch_begin: 
#' logs include `size`, the number of samples in the current batch. on_batch_end: 
#' logs include `loss`, and optionally `acc` (if accuracy monitoring is enabled).
#'
#' @param tuner tuner object
#' @param trial trial ID
#'
#' @section Attributes:
#' params: dict. Training parameters (eg. verbosity, batch size, 
#' number of epochs...). model: instance of `keras.models.Model`. 
#' Reference of the model being trained. 
#' validation_data: Deprecated. Do not use.
#' @return None
#' @export
callback_tuner <- function(tuner, trial) {
  
  if(missing(tuner) & missing(trial))
    kerastuner$engine$tuner_utils$TunerCallback
  else
    kerastuner$engine$tuner_utils$TunerCallback(
      tuner = tuner,
      trial = trial
    )
  
}

