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

is_module_table <- function(tbl, crop){
  stopifnot(is.data.frame(tbl))
  has_names <- all(names(tbl) %in% c("id", "crop", "module", "variable"))
  if (!has_names) return(FALSE)
  crop_table <- unique(tbl$crop)
  if (!length(crop_table) == 1) return(FALSE)
  if (crop != crop_table) return(FALSE)
  if (!is.numeric(tbl$id)) return(FALSE)
  TRUE
}

#' Imports a module table locally.
#'
#' Posts a data.frame containing location data and also returns the table or NULL.
#'
#' @author Reinhard Simon
#' @param file  a file path as string
#' @param crop character
#' @return dataframe
#' @export
import_module_table <- function(file, crop){
  if (stringr::str_detect(file, ".csv")) {
    tbl <- read.csv(file, stringsAsFactors = FALSE)
    if (!is_module_table(tbl, crop)) return(NULL)
  }
  if (stringr::str_detect(file, ".xlsx")) {
    tbl <- readxl::read_excel(file)
    if (!is_module_table(tbl, crop)) return(NULL)
  }
  tbl[, 1] <- as.integer(tbl[, 1])
  for(i in 2: 4) tbl[, i] <- as.character(tbl[, i])

  x <- post_module_table(table_module = tbl, crop = crop)
  tbl
}

