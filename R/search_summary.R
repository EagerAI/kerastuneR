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