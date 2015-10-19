#' Creates an empty module table
#'
#' With dummy data
#'
#' @author Reinhard Simon
#' @param crop character
#' @export
#' @return dataframe
new_module_table <- function(crop = NULL){
  if (is.null(crop)) return(NULL)
  n = 3
  id <- 1:n
  crop = rep(crop, n)
  module = paste0("module_",id)
  variable = paste0("variable_",id)
  res <- as.data.frame(cbind(
    id, crop, module, variable),
    stringsAsFactors = FALSE)
  res
}

#' Gets a site table.
#'
#' If not yet present creates a dummy one.
#'
#' @author Reinhard Simon
#' @param crop character
#' @export
#' @return dataframe
get_module_table <- function(crop = NULL){
  if (is.null(crop)) return(crop)
  fns <- fbglobal::fname_module(crop)

  if(!file.exists(fns)) {
    base_dir <-  dirname(fns)
    if(!dir.exists(base_dir)) dir.create(base_dir, recursive = TRUE)
    table_module <- new_module_table(crop)
    saveRDS(table_module, file = fns)
  }
  readRDS(fns)
}

#' Posts a module table locally.
#'
#' Posts a data.frame containing location data.
#'
#' @author Reinhard Simon
#' @param table_module data.frame
#' @param crop character
#' @export
post_module_table <- function(table_module, crop){
  res = FALSE
  try({
    saveRDS(table_module, file = fbglobal::fname_module(crop))
    res = TRUE
  })
  res
}

