#' @title Plot Keras model
#'
#' @description Converts a Keras model to dot format and save to a file.
#'
#'
#' @param model A Keras model instance
#' @param to_file File name of the plot image.
#' @param show_shapes whether to display shape information.
#' @param show_layer_names whether to display layer names.
#' @param rankdir `rankdir` argument passed to PyDot, a string specifying the format of the plot: 
#' 'TB' creates a vertical plot; 'LR' creates a horizontal plot.
#' @param expand_nested Whether to expand nested models into clusters.
#' @param dpi Dots per inch.
#'
#' @return a png image.
#'
#' @export
plot_keras_model <- function(model, to_file = "model.png", show_shapes = FALSE, show_layer_names = TRUE, 
                       rankdir = "TB", expand_nested = FALSE, dpi = 96) {
  
  python_function_result <- tf$keras$utils$plot_model(
    model = model,
    to_file = to_file,
    show_shapes = show_shapes,
    show_layer_names = show_layer_names,
    rankdir = rankdir,
    expand_nested = expand_nested,
    dpi = as.integer(dpi)
  )
  
}


