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
#' @param objective A loss metrics function for tracking the model performance e.g. "val_precision". The name of 
#' the objective to optimize (whether to minimize or maximize is automatically inferred for built-in metrics)
#' @param max_epochs to train the model. Note that in conjunction with initial_epoch, 
#' epochs is to be understood as "final epoch". The model is not trained for a number of iterations
#'  given by epochs, but merely until the epoch of index epochs is reached.
#' @param directory The dir where training logs are stored
#' @param project_name Detailed logs, checkpoints, etc, in the folder my_dir/helloworld, i.e. 
#' directory/project_name.
#' @param ... Some additional arguments
#' @export
Hyperband <- function(hypermodel = NULL, objective = NULL, max_epochs = NULL, directory = NULL, project_name = NULL,
                      ...) {
  kerastuner$tuners$Hyperband(hypermodel = hypermodel, 
                              objective = objective, 
                              max_epochs = max_epochs, 
                              directory = directory, 
                              project_name = project_name,
                              ...)
}

