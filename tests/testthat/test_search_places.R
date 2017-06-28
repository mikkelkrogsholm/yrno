library(norweather)

context("Testing the search_places() function")

cph <- search_places(place = "Copenhagen")
ny <- search_places(place = "New York")
lnd <- search_places(place = "London")

# Run tests
test_that("cph dims and class", {
  expect_equal(ncol(cph), 8)
  expect_true(nrow(cph) > 0)
  expect_equal(class(cph), "data.frame")
})

test_that("ny dims and class", {
  expect_equal(ncol(ny), 8)
  expect_true(nrow(ny) > 0)
  expect_equal(class(ny), "data.frame")
})

test_that("lnd dims and class", {
  expect_equal(ncol(lnd), 8)
  expect_true(nrow(lnd) > 0)
  expect_equal(class(lnd), "data.frame")
})
