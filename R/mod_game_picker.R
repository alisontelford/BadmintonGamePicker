#' game_picker UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_game_picker_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' game_picker Server Functions
#'
#' @noRd 
mod_game_picker_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_game_picker_ui("game_picker_1")
    
## To be copied in the server
# mod_game_picker_server("game_picker_1")
