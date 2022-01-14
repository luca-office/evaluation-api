# =========================================================================
# Import of all functions implemented in Python and R

# Paths to the runtime functions in R and python
PATH_R_FUNCTIONS <- "runtime_functions/r/"
PATH_PYTHON_FUNTIONS <- "runtime_functions/python/"

# Import all functions implemented in R
file_names <- list.files(PATH_R_FUNCTIONS)
file_names <- file_names[grepl(".R$", file_names)]
for (file_name in file_names) {
  source(paste0(PATH_R_FUNCTIONS, file_name))
}

# Import all functions implemented in Python
library(reticulate)
file_names <- list.files(PATH_PYTHON_FUNTIONS)
file_names <- file_names[grepl(".py$", file_names)]
for (file_name in file_names) {
  py_run_file(paste0(PATH_PYTHON_FUNTIONS, file_name), convert=FALSE)
}


# =========================================================================
#' Set an endpoint for the functions to evaluate the participant performance
#' 
#' The endpoint provides access to different functions implemented in Python or R.
#' Each function returns a score for the participant on a specific task. Further,
#' it might also return an id vor a specific answer variant, and in case of
#' probabilistic approaches like results from machine learning models, it also returns
#' a probability estimate for the correctness of the score.
#' 
#' @param functionId The function ID
#' @param invitationId The invitation ID
#' @param scenarioId The scenario ID
#' @param surveyID The survey ID
#' @return A list including the elements score, variant, and num
#' 
#* @get /evaluate
evaluate <- function(functionId=NULL, invitationId=NULL, scenarioId=NULL, surveyID=NULL){
  if (is.null(functionId)) {
    stop("No function Id provided!")
  }
  if (is.null(invitationId)) {
    stop("No invitation Id provided!")
  }
  if (is.null(scenarioId)) {
    stop("No scenario Id provided!")
  }
  if (is.null(surveyID)) {
    stop("No survey Id provided!")
  }

    
  # Checking whether the function is implemented in Python
  if (substr(functionId, 1, 1)=="p") {
    
    # TODO Check whether the function exists before moving on
    
    #  Calling the function with the text of the mail answer as input argument
    if (substr(functionId, 2, 9)=="_answer_") {
      py_eval(paste0(functionId, "('", getAnswerEmail(invitationId, scenarioId, surveyID), "')"))
    }
  }
  # Checking whether the function is implemented in R
  else if (substr(functionId, 1, 1)=="r") {
    
    # TODO Check whether the function exists before moving on
    
    #  Calling the function with the text of the mail answer as input argument
    if (substr(functionId, 2, 9)=="_answer_") {
      
      # TODO Implement an examplary function call for R
      
    }
  }
}

