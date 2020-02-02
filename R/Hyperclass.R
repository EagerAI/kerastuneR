#' You can use a HyperModel subclass instead of a model-building function
#' This makes it easy to share and reuse hypermodels.
#' A HyperModel subclass only needs to implement a build(self, hp) method.
#' @export 
HyperModel_class <- function(){
  object = kerastuner$engine$hypermodel$HyperModel
  return(invisible(object))
}

#' Tuner class for Keras models.
#' May be subclassed to create new tuners.
#' @export
Tuner_class <- function(){
  object = kerastuner$Tuner
  return(invisible(object))
}

#' @title Objective
#' @description Objective(name, direction)
#' @param name name
#' @param direction direction
#' @param ... Some additional arguments
#'
#' @export
Objective <- function(name = NULL, direction = NULL, ...) {
  
  args <- c(
    name = name,
    direction = direction,
    ...
  )
  do.call(kerastuner$Objective, args)
}



