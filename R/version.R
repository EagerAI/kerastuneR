#' @title Version of Keras Tuner
#' @description Get the current version of Keras Tuner
#' @return prints the version.
#' @export
keras_tuner_version = function() {
  kerastuner$`__version__`
}