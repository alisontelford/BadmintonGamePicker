#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  # Logo at top-right
  title_content <- {
    tags$div(
      tags$img(
        src = "www/favicon.png", "",
        height = "50px", style = "vertical-align: middle;"
      )
    )
  }
  # Main text on home page
  title_text_main_cond <- {
    tags$div(
      h2("Welcome to the Badminton Game Picker!")
    )
  }
  
  # Secondary text on home page
  title_text_secondary_cond <- {
    tags$div(
      h4("This application will randomly select a new badminton game based upon those who are waiting in the queue.")
    )
  }
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(
      # Set up the dashboard header.
      dashboardHeader(
        title=title_content
      ),
      # Set up the dashboard sidebar.
      dashboardSidebar(
        sidebarMenu(
          id="sidebarID",
          menuItem("Home", tabName="home", icon=icon("home")),
          menuItem("Player Selection", tabName="playerselection", icon=icon("user-plus")),
          menuItem("Game Picker", tabName="gamepicker", icon=icon("people-group"))
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(
            tabName="home",
            tags$div(
              style = "vertical-align: middle; text-align: center;",
              tags$img(src="www/favicon.png", height="200px")
            ),
            title_text_main_cond,
            title_text_secondary_cond,
            div(style = "height: 30px"),
            div(
              shinydashboard::box(
                title = "Game Picker Logic",
                solidHeader = FALSE,
                collapsible = TRUE,
                collapsed = FALSE,
                width = 12,
                background = NULL,
                HTML("
                <h4>
                  <ul>
                      <li>The player at the front of the queue will be the `Game Leader`.</li>
                      <li>The Game Leader creates a new game in the Game Picker tab.</li>
                      <li>The additional three players are randomly chosen from the next 6 players in the queue.</li>
                      <li>The Game Leader initiates the game and on completion of the game records the winners and losers.</li>
                  </ul>
                </h4>
                     ")
              )
            )
          ),
          tabItem(
            tabName="playerselection",
            mod_player_selection_ui("player_selection1")
          ),
          tabItem(
            tabName="gamepicker",
            mod_game_picker_ui("game_picker1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "BadmintonGamePicker"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
