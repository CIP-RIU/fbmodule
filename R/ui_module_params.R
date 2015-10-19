#' UI material list paramters
#'
#' An interface to parameters
#'
#' @param name character
#' @author Reinhard Simon
#' @export
ui_module_params <- function(name = "resource_modules"){
  shiny::conditionalPanel(
    paste0("input.menu == '",name,"'"),
    shiny::uiOutput("module_crop", inline = TRUE),

    shiny::HTML("<center>"),
    shinyBS::bsAlert("saveModuleAlert"),
    shiny::uiOutput("module_butSave", inline = TRUE),
    #shiny::actionButton("butNewModule", "New", inline = TRUE),
    shinyFiles::shinyFilesButton('module_files', 'Import',
                                 'Please select a file', FALSE ),
    shiny::uiOutput("module_butExport", inline = TRUE),
    shiny::HTML("</center>")
  )
}
