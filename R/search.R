#' Start the search for the best hyperparameter configuration. 
#' The call to search has the same signature as model.fit().
#'
#' Models are built iteratively by calling the model-building function, which populates the hyperparameter space 
#' (search space) tracked by the hp object. The tuner progressively explores the space, recording metrics for 
#' each configuration.
#' 
#' @param tuner A tuner object
#' @param x	Vector, matrix, or array of training data (or list if the model has multiple inputs). 
#' If all inputs in the model are named, you can also pass a list mapping input names to data. x can be NULL
#'  (default) if feeding from framework-native tensors (e.g. TensorFlow data tensors).
#' @param y Vector, matrix, or array of target (label) data (or list if the model has multiple outputs). 
#' If all outputs in the model are named, you can also pass a list mapping output names to data. y can be 
#' NULL (default) if feeding from framework-native tensors (e.g. TensorFlow data tensors).
#' @param steps_per_epoch Integer. Total number of steps (batches of samples) to yield from generator before 
#' declaring one epoch finished and starting the next epoch. It should typically be equal to 
#' ceil(num_samples / batch_size). Optional for Sequence: if unspecified, will use the len(generator) 
#' as a number of steps.
#' @param epochs to train the model. Note that in conjunction with initial_epoch, 
#' epochs is to be understood as "final epoch". The model is not trained for a number of iterations
#'  given by epochs, but merely until the epoch of index epochs is reached.
#' @param validation_data Data on which to evaluate the loss and any model metrics at the end of each epoch. 
#' The model will not be trained on this data. validation_data will override validation_split. 
#' validation_data could be: - tuple (x_val, y_val) of Numpy arrays or 
#' tensors - tuple (x_val, y_val, val_sample_weights) of Numpy arrays - dataset or a dataset iterator
#' @param validation_steps Only relevant if steps_per_epoch is specified. Total number of steps (batches of samples)
#'  to validate before stopping.
#' @param ... Some additional arguments
#' @export
fit_tuner = function(tuner = NULL, x = NULL, y = NULL, steps_per_epoch = NULL, epochs = NULL, 
                        validation_data = NULL, validation_steps = NULL, ...) {
  tuner = tuner
  tuner$search(x = x, y = y, steps_per_epoch = steps_per_epoch,
               epochs = as.integer(epochs),
               validation_data = setNames(validation_data, NULL),
               validation_steps = validation_steps)
}

#' The function for retrieving the top best models with hyperparameters
#' 
#' @param tuner A tuner object
#' @param num_models When search is over, one can retrieve the best model(s)
#' @export
get_best_models = function(tuner = NULL,num_models = NULL) {
  tuner = tuner
  tuner$get_best_models(num_models = as.integer(num_models))
}

#' Print a summary of the results
#' @param tuner A tuner object
#' @export
results_summary = function(tuner = NULL) {
  tuner = tuner
  tuner$results_summary()
}

