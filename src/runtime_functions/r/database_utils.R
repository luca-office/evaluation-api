#' Set up the database connection to the postgres database via the connection data provided in config.yml
#' of r-tensorflow-api from the LUCA project .
#'
#' In order to use the function locally you typically want to get a data dump from a LUCA instance first,
#' install postgres locally, initiate an empty database in it, and restore the database provided in the data
#' dump. Easiest is to to use the defult values during the installation, which correspond to ones provided in
#' the yaml file. During the installation process you will be asked to provided a password for your local
#' postgres instance. Choose here "admin" as password to use the one already set in the yaml file otherwise
#' simply change the settings there as needed.
#' 
#' After the installation you can setup an empty database using the following command:
#' \code{createdb -U postgres -T template0 newdb}
#' \code{newdb} will in this case be the name of your local database (however, you can choose any other name),
#' that is, this is the name you will provide as value for the argument \code{db}.
#' To restore the data dump from LUCA you finally run the following command:
#' \code{pg_restore -U postgres -d newdb data_dump}
#' Where \code{data_dump} is the name of the file including the data dump.
#'
#' @return An S4 object that inherits from DBIConnection
#' @export
#'
#' @examples
#' db <- 'newdb'
#' db_password <- 'admin'
#' getDatabaseConnection(db=db, db_password=admin)
#' 
getDatabaseConnection <- function () {
  config <- config::get()
  return(RPostgres::dbConnect(RPostgres::Postgres(), dbname = config$db, host=config$db_host, port=config$db_port, user=config$db_user, password=config$db_password))
}



#' Get the text of a sent answer email
#' 
#' Gets the answer email for a specific participant and a specific scenario.
#' For performance reasons the survey ID has to be provided additionally.
#' 
#' The function \code{getDatabaseConnection()} is part of this function and must have
#' access to the database given in the function definition.
#'
#' @param invitationId The ID of the participant in hash code format
#' @param scenarioId The scenario ID in hash code format
#' @param surveyId The survey (or project) ID in hash code format
#'
#' @return A string including the text of the sent answer mail or NULL if no answer mail was encountered
#' @export
#'
#' @examples
#' # Define the needed arguments
#' invitationId <- '08eb2f57-e100-40fb-a132-08c1b98f754e'
#' scenarioId <- '61b65b57-f5d1-4127-8cf2-e611160e9734'
#' surveyId <- '4eca83df-7e4f-4a0e-b6a5-975bf76f62b4'
#' 
#' # Call the Function
#' getAnswerEmail (invitationId, scenarioId, surveyId)
#' 
getAnswerEmail <- function (invitationId, scenarioId, surveyId) {
  # Connect to a LUCA database
  con <- getDatabaseConnection()
  
  # Select all survey events for sent emails for the given person and survey (i.e. project)
  mail_events <- RPostgres::dbGetQuery(con, paste0("SELECT * FROM survey_event WHERE event_type='SendEmail' AND invitation_id='", invitationId, "' AND survey_id='", surveyId, "';"))

  # Check the data fields of all selected events to find the one with the provided id, which includes the completed answer email
  payload_list <- lapply(mail_events$data, jsonlite::fromJSON)
  answer_mail <- NULL
  for (payload in payload_list) {
    if (payload$scenarioId==scenarioId & payload$isCompletionEmail==TRUE){
      answer_mail <- payload$text
      break;
    }
  }


  #answer_mail <- "Lieber Herr Morgenschön, ich konnte die Aufgabe leider nicht lösen. Viele Grüße!"
  #answer_mail <- NULL
  print(paste0("The following answer mail will be evaluated:\n", answer_mail, "\n"))
  
  return(answer_mail)
}
