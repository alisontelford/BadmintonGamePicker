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
    
  )
  
  ### Reactive values -------------------
  rv <-
    reactiveValues(
      ActivePlayers=NULL
    )
  
  ### Player Selection Tab
  mod_player_selection_server("player_selection1", sv, rv)
}
