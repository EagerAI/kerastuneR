#' To see the summary of search criteria
#'
#' Print a summary of the search space:
#' @param tuner Requires a tuner object
#' @export
search_summary = function(tuner = NULL) {
  if (is.null(tuner)) {
    warning('Tuner object does not exist')
  } else {
    tuner$search_space_summary()
  }
}

#' Print a summary of the search results/best models
#' 
#' @param tuner Requires a tuner object
#' @param num_trials Shows the top best models
#' @export
results_summary = function(tuner = NULL, num_trials = NULL){
  if (is.null(tuner)) {
    warning('Tuner object does not exist')
  } else {
    tuner$results_summary(num_trials = as.integer(num_trials))
  }
}
