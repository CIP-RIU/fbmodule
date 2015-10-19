#' server_module
#'
#' Constructs table
#'
#' @param input shinyserver input
#' @param output shinyserver output
#' @param session shinyserver session
#' @param dom target dom element name
#' @param values reactive values
#' @author Reinhard Simon
#' @export
server_module <- function(input, output, session, dom="hot_modules", values){
  setHot_modules = function(x) values[[dom]] = x
  roots = shinyFiles::getVolumes("Page File (F:)")
  #print(roots)
  shinyFiles::shinyFileChoose(input, 'module_files', session = session,
                              #roots=roots,
                              roots = c(roots),
                              filetypes = c('xlsx', 'csv'))

  shiny::observeEvent(input$module_files, {
    #fn = fbglobal::fname_module(input$module_crop)
    fn <- as.character(
      shinyFiles::parseFilePaths(roots, input$module_files)$datapath[1]
    )
    #print(paste0("Importing ... ", fn))
    tbl <- fbmodule::import_module_table(fn, input$module_crop)
    #print(tbl)
    setHot_modules(tbl)
    #print("ok")
  }
  )


  output$module_crop <- shiny::renderUI({
    if (is.null(values[["hot_module_crops"]])) {
      values[["hot_module_crops"]] <- fbcrops::get_crop_table()
    }
    crops <- values[["hot_module_crops"]]$crop_name
    shiny::selectInput("module_crop", NULL, choices = crops, width = '50%')
  })


  output$module_butSave <- shiny::renderUI({
    shiny::actionButton("saveModuleButton", "Save", inline = TRUE)
  })

  output$module_butExport <- shiny::renderUI({
    shiny::downloadButton("downloadModuleData", "Export")
  })



  shiny::observeEvent(input$saveModuleButton, ({
    if (!is.null(input[[dom]])) {
      table_modules = rhandsontable::hot_to_r(input[[dom]])
      #print(table_modules)
      #print(input$module_crop)
      fbmodule::post_module_table(table_modules,
                          input$module_crop)
      #print("saved!")
    }
  })
  )


  output$hot_modules = rhandsontable::renderRHandsontable({
    shiny::withProgress(message = 'Loading table', {
      #list_name <- input$module_name
      #print(input$module_crop)
      DF_module <- fbmodule::get_module_table(input$module_crop)
      #print(DF_module)
      if(!is.null(DF_module)){
        setHot_modules(DF_module)
        rh <- rhandsontable::rhandsontable(DF_module,   stretchH = "all")
        rhandsontable::hot_table(rh, highlightCol = TRUE, highlightRow = TRUE)
      } else {
        NULL
      }
    })
  })

  output$downloadModuleData <- shiny::downloadHandler(
    filename = function() {
      paste(input$module_crop,"_module_",
            Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv( values[["hot_modules"]], con, row.names = FALSE)
    }
  )

}
