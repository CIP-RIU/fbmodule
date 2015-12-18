library(shiny)
library(shinydashboard)
library(rhandsontable)
library(fbglobal)
library(fbmodule)
library(shinyBS)
library(shinyFiles)

tabNameS <- "resource_module"


server <- function(input, output, session) {
  values = shiny::reactiveValues()
  fbmodule::server_module(input, output, session, values = values)
}

ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title = "Demo Module"),
                    dashboardSidebar(width = 350,
                       menuItem("Resources",
                          sidebarMenu(id = "menu",
                                      menuSubItem("Module", icon = icon("book"),
                                                  tabName = tabNameS),
                                      fbmodule::ui_module_params()
                          )
                       )
                    ),
                    dashboardBody(
                      tabItems(
                        fbmodule::ui_module(name = tabNameS)
                      )
                    )
)

shinyApp(ui = ui, server = server)
