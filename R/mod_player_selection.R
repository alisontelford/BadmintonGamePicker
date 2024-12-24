#' player_selection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @import DT
#' @import dplyr
#' @import shinyWidgets
#' @import stringr
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_player_selection_ui <- function(id) {
  tagList(
    fluidRow(
      column(
        width=5, align="center",
        shinydashboard::box(
          title = "Add/Remove Existing Players",
          solidHeader = FALSE,
          collapsible = TRUE,
          collapsed = FALSE,
          width = 12,
          background = NULL,
          fluidRow(
            column(
              width=7,
              uiOutput(NS(id, "add_player_ui"))
            ),
            column(
              width=4,
              div(style="height: 25px"),
              actionButton(NS(id, "add_player_button"), label="Add Player")
            )
          ),
          fluidRow(
            column(
              width=7,
              uiOutput(NS(id, "remove_player_ui"))
            ),
            column(
              width=4,
              div(style="height: 25px"),
              actionButton(NS(id, "remove_player_button"), label="Remove Player")
            )
          )
        ),
        shinydashboard::box(
          title = "Add New Player",
          solidHeader = FALSE,
          collapsible = TRUE,
          collapsed = FALSE,
          width = 12,
          background = NULL,
          HTML("<h4>Please enter your first and last name below.</h4>"),
          fluidRow(
            column(
              width=6,
              textInput(NS(id, "first_name"), label="First Name")
            ),
            column(
              width=6,
              textInput(NS(id, "last_name"), label="Last Name")
            )
          ),
          actionButton(NS(id, "new_player"), label="Add New Player")
        )
      ),
      column(
        width=7, align="center",
        div(
          shinydashboard::box(
            title = NULL,
            solidHeader = FALSE,
            collapsible = TRUE,
            collapsed = FALSE,
            width = 12,
            background = NULL,
            DT::DTOutput(NS(id, "active_players"))
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
    output$add_player_ui = renderUI({
      shinyWidgets::pickerInput(session$ns("add_player"), label="Add player", choices=sort(rv$PlayerNames_tmp$PlayerName), multiple=TRUE)
    })
    output$remove_player_ui=renderUI({
      shinyWidgets::pickerInput(session$ns("remove_player"), label="Remove Player", choices=sort(rv$ActivePlayers$PlayerName), multiple=TRUE)
    })
    observeEvent(input$add_player_button, {
      req(input$add_player)
      rv$ActivePlayers=rv$ActivePlayers |> 
        dplyr::bind_rows(
          data.frame(
            PlayerName=as.factor(input$add_player), 
            Status=as.factor(sapply(seq(rv$QueuePos,(rv$QueuePos+length(input$add_player)-1)), function(x) {paste0("In Queue Position ", x)}))
          )
        )
      rv$UnactivePlayers=rv$PlayerNames_tmp |> 
        filter(!(PlayerName %in% rv$ActivePlayers$PlayerName))
      updatePickerInput(session, "add_player", choices=sort(rv$UnactivePlayers$PlayerName))
      updatePickerInput(session, "remove_player", choices=sort(rv$ActivePlayers$PlayerName))
      rv$QueuePos=rv$QueuePos+length(input$add_player)
    })
    observeEvent(input$remove_player_button, {
      req(input$remove_player)
      Condition = any(
        !str_starts(
          rv$ActivePlayers |> 
            filter(PlayerName %in% input$remove_player) |> 
            pull(Status),
          "In Queue"
        )
      )
      if (Condition){
        showModal(
          modalDialog(
            HTML("<h4>One or more of those players are still in active games, please complete the games before removing the players.</h4>"),
            easyClose=TRUE,
            title="Error",
          )
        )
      }else{
        rv$ActivePlayers=rv$ActivePlayers |> 
          dplyr::filter(
            !(PlayerName %in% input$remove_player)
          ) |> 
          dplyr::mutate(
            Status=ifelse(
              str_starts(Status, "In Queue"),
              paste0("In Queue Position ", order(as.numeric(str_sub(Status, 19, str_length(Status))))),
              Status
            )
          )
        rv$UnactivePlayers=rv$PlayerNames_tmp |> 
          filter(!(PlayerName %in% rv$ActivePlayers$PlayerName))
        updatePickerInput(session, "add_player", choices=sort(rv$UnactivePlayers$PlayerName))
        updatePickerInput(session, "remove_player", choices=sort(rv$ActivePlayers$PlayerName))
        rv$QueuePos={rv$ActivePlayers |> filter(str_starts(Status, "In Queue")) |> nrow()} + 1
      }
    })
    output$active_players=DT::renderDT(
      DT::datatable(rv$ActivePlayers, filter="top")
    )
    observeEvent(input$new_player, {
      browser()
      if (input$first_name=="" | input$last_name==""){
        showModal(
          modalDialog(
            HTML("<h4>Please provide both a first and last name.</h4>"),
            easyClose=TRUE,
            title="Error",
          )
        )
      }else{
        new_names=sapply(seq(1,nchar(input$last_name)), function(x) {paste0(input$first_name, substr(input$last_name, 1, x))})
        if (any(new_names %in% rv$PlayerNames_tmp$PlayerName)){
          showModal(
            modalDialog(
              easyClose=FALSE,
              title="Note",
              HTML(
                paste0("<h4> The name(s) ", new_names[which(new_names %in% rv$PlayerNames_tmp$PlayerName)], 
                " already exists. If any of these/this is you, please press cancel. 
                If you are none of these, please press 'Add New Player', your name will be displayed as: ", 
                new_names[min(which(!(new_names %in% rv$PlayerNames_tmp$PlayerName)))],
                ".</h4>")
              ),
              footer=tagList(
                modalButton("Cancel"),
                actionButton(session$ns("new_player_ok"), "Add New Player")
              )
            )
          )
        }else{
          rv$PlayerNames_tmp=rv$PlayerNames_tmp |> 
            dplyr::bind_rows(
              data.frame(PlayerName=new_names[1])
            )
        }
      }
    })
    observeEvent(input$new_player_ok, {
      new_names=sapply(seq(1,nchar(input$last_name)), function(x) {paste0(input$first_name, substr(input$last_name, 1, x))})
      rv$PlayerNames_tmp=rv$PlayerNames_tmp |> 
        dplyr::bind_rows(
          data.frame(PlayerName=new_names[min(which(!(new_names %in% rv$PlayerNames_tmp$PlayerName)))])
        )
      removeModal()
    })
  })
}
    
## To be copied in the UI
# mod_player_selection_ui("player_selection_1")
    
## To be copied in the server
# mod_player_selection_server("player_selection_1")
