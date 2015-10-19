context("API")

test_that("Dummy table is created.", {
  expect_true(is.null(new_module_table()), TRUE)
  new_tbl <- new_module_table("potato")
  expect_true(is.data.frame(new_tbl), TRUE)
  expect_true(nrow(new_tbl) == 3, TRUE)
})

test_that("Dummy table is retrieved.", {
  expect_true(is.null(get_module_table()), TRUE)
  get_tbl <- get_module_table("potato")
  expect_true(is.data.frame(get_tbl), TRUE)
  expect_true(nrow(get_tbl) >= 1, TRUE)
})

test_that("Dummy table is stored.", {
  crop = "potato"
  get_tbl <- get_module_table(crop)
  n = nrow(get_tbl)
  vars = letters[1:n]
  get_tbl[, "variables"] <- vars
  expect_true(post_module_table(get_tbl, crop), TRUE)
})
