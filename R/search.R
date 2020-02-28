#' Start the search for the best hyperparameter configuration. 
#' The call to search has the same signature as ```model.fit()```.
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
#' 
#' @examples
#'
#' \dontrun{
#'
#' x_data <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5) 
#' y_data <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
#' x_data2 <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
#' y_data2 <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
#' 
#' 
#' HyperModel <- kerastuneR::PyClass(
#'   'HyperModel',
#'   inherit = kerastuneR::HyperModel_class(),
#'   list(
#'     
#'     `__init__` = function(self, num_classes) {
#'       
#'       self$num_classes = num_classes
#'       NULL
#'     },
#'     build = function(self,hp) {
#'       model = keras_model_sequential() 
#'       model %>% layer_dense(units = hp$Int('units',
#'                                            min_value = 32,
#'                                            max_value = 512,
#'                                            step = 32),
#'                             input_shape = ncol(x_data),
#'                             activation = 'relu') %>% 
#'         layer_dense(as.integer(self$num_classes), activation = 'softmax') %>% 
#'         compile(
#'           optimizer = tf$keras$optimizers$Adam(
#'             hp$Choice('learning_rate',
#'                       values = c(1e-2, 1e-3, 1e-4))),
#'           loss = 'sparse_categorical_crossentropy',
#'           metrics = 'accuracy')
#'     }
#'   )
#' )
#' 
#' hypermodel = HyperModel(num_classes=10L)
#' 
#' 
#' tuner = RandomSearch(hypermodel = hypermodel,
#'                      objective = 'val_accuracy',
#'                      max_trials = 2,
#'                     executions_per_trial = 1,
#'                      directory = 'my_dir5',
#'                      project_name = 'helloworld')
#'                      
#' tuner2 %>% fit_tuner(x_data, y_data, epochs = 5, validation_data = list(x_data2,y_data2)) 
#' }                    
#' @importFrom stats setNames
#' @export
fit_tuner = function(tuner = NULL, x = NULL, y = NULL, steps_per_epoch = NULL, epochs = NULL, 
                        validation_data = NULL, validation_steps = NULL, ...) {
  tuner = tuner
  
  if(class(tuner)[1]=='python.builtin.Tuner') {
    args = c(x = x, y = y, steps_per_epoch = steps_per_epoch,
             epochs = as.integer(epochs),
             validation_data = setNames(validation_data, NULL),
             validation_steps = validation_steps, ...)
    do.call(tuner$search, args)
    
  } else {
    tuner$search(x = x, y = y, steps_per_epoch = steps_per_epoch,
                 epochs = as.integer(epochs),
                 validation_data = setNames(validation_data, NULL),
                 validation_steps = validation_steps, ...)
  }
  
  
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

