#' @title Search summary
#' @description  Print a summary of the search space
#'
#' @param tuner Requires a tuner object
#' @return the summary of search space of the tuner object
#' @export
search_summary = function(tuner = NULL) {

    tuner$search_space_summary()

}

#' @title Results summary
#' @description Print a summary of the search results (best models)
#' 
#' @param tuner Requires a tuner object
#' @param num_trials Shows the top best models
#' @return the list of results summary of the tuner object
#' @export
results_summary = function(tuner = NULL, num_trials = NULL) {
  
    tuner$results_summary(num_trials = as.integer(num_trials))
  
}
