#' shiny UI element
#'
#' returns a re-usable user interface element
#'
#' @author Reinhard Simon
#' @param type of ui Element; default is a tab in a shiny dashboard
#' @param title display title
#' @param name a reference name
#' @param output name of output element
#' @export
ui_module <- function(type = "tab", title = "Module configuration",
                      name = "resource_modules",
                    output = "hot_modules"){
  # just only one type
  shinydashboard::tabItem(tabName = name,
    shiny::fluidRow(
      shinydashboard::box(width = 12,
          title = title,
          rhandsontable::rHandsontableOutput(output, height = 600)
      )
    )
  )
}
