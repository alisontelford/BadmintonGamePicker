#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  ### Load Data -------------------------

  
  ### Static values ---------------------
  sv <- list(
    PlayerNamesCSV=read.csv("data/PlayerNames.csv")
  )
  
  ### Reactive values -------------------
  rv <-
    reactiveValues(
      PlayerNames_tmp=sv$PlayerNamesCSV,
      ActivePlayers=NULL,
      UnactivePlayers=NULL,
      QueuePos=1
    )
  
  ### Player Selection Tab
  mod_player_selection_server("player_selection1", sv, rv)
}
