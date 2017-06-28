## Mimic the internal workings of the get_weather() function ----
place_url <- "https://www.yr.no/place/Denmark/Capital/Copenhagen/"
xml_url <- paste0(place_url, "forecast.xml")

# Get xml data
yr_request <- httr::GET(url = xml_url)

# Extract content
yr_content <- httr::content(yr_request, as = "text", encoding = "UTF-8")

# Read it in as html
yr_content <- xml2::read_html(yr_content)

## Test extract_content() ----
context("Testing the extract_content() helper function")

# Extract
extracted_content <- norweather:::extract_content(yr_content)

# Run tests
test_that("extracted_content dims and class", {
  expect_equal(ncol(extracted_content), 20)
  expect_true(nrow(extracted_content) > 0)
  expect_equal(class(extracted_content), "data.frame")
})

# Save exact dims to compare later agains prettify
extracted_content_dims <- dim(extracted_content)

## Test prettify_data() ----
context("Testing the prettify_data() helper function")

# Prettify columns
extracted_content <- norweather:::prettify_data(extracted_content)

# Run tests
test_that("extracted_content dims and class", {
  expect_equal(ncol(extracted_content), 20)
  expect_true(nrow(extracted_content) > 0)
  expect_equal(class(extracted_content), "data.frame")
  expect_equal(dim(extracted_content), extracted_content_dims)
})

## Test extract_creditation() ----
context("Testing the extract_creditation() helper function")

creditation <- norweather:::extract_creditation(yr_content)

# Run tests
test_that("creditation dims and class", {
  expect_equal(length(creditation), 1)
  expect_true(nchar(creditation) > 0)
  expect_equal(class(creditation), "character")
})

