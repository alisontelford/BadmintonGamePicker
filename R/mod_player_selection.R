#' player_selection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_player_selection_ui <- function(id) {
  tagList(
    fluidRow(
      column(
        width=4, align="center",
        div(
          shinydashboard::box(
            title = "Add/Remove Players",
            solidHeader = FALSE,
            collapsible = TRUE,
            collapsed = FALSE,
            width = 12,
            background = NULL,
            fluidRow(
              htmlOutput(NS(id, "add_player_ui")),
              actionButton(NS(id, "add_player_button"), label="Add Player")
            ),
            fluidRow(
              htmlOutput(NS(id, "remove_player_ui")),
              actionButton(NS(id, "remove_player_button"), label="Remove Player")
            )
          )
        ),
        div(
          shinydashboard::box(
            title = NULL,
            solidHeader = FALSE,
            collapsible = TRUE,
            collapsed = FALSE,
            width = 12,
            background = NULL
          )
        )
      ),
      column(
        width=8, align="center",
        div(
          shinydashboard::box(
            title = NULL,
            solidHeader = FALSE,
            collapsible = TRUE,
            collapsed = FALSE,
            width = 12,
            background = NULL,
            DTOutput(NS(id, "active_players"))
          )
        )
      )
    )
  )
}
    
#' player_selection Server Functions
#'
#' @noRd 
mod_player_selection_server <- function(id, sv, rv){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    PlayerNames=reactive({
      out=read.csv("data/PlayerNames.csv")
      return(out)
    })
    output$add_player_ui = renderUI({
      selectInput(NS(id, "add_player"), "Add player", PlayerNames()$PlayerName, multiple=T, selectize=T)
    })
    observeEvent(input$add_player_button, {
      rv$ActivePlayers=rv$ActivePlayers |> 
        bind_rows(
          data.frame(
            Name=input$add_player, 
            Status=sapply(seq(1:4), function(x) {paste0("In Queue Position ", x)})
          )
        )
    })
    output$active_players=renderDT(
      rv$ActivePlayers
    )
  })
}
    
## To be copied in the UI
# mod_player_selection_ui("player_selection_1")
    
## To be copied in the server
# mod_player_selection_server("player_selection_1")
