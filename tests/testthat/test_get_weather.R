library(norweather)

context("Testing the get_weather() function")

# Get weather for days and for hours
weather_days <- suppressMessages(
  get_weather("https://www.yr.no/place/Denmark/Capital/Copenhagen/",
              forecast = "days")
)
weather_hours <- suppressMessages(
  get_weather("https://www.yr.no/place/Denmark/Capital/Copenhagen/",
              forecast = "hours")
)

# Run tests
test_that("weather_days dims and class", {
  expect_equal(ncol(weather_days), 20)
  expect_true(nrow(weather_days) > 0)
  expect_equal(class(weather_days), "data.frame")
})

test_that("weather_hours dims and class", {
  expect_equal(ncol(weather_hours), 19)
  expect_true(nrow(weather_hours) > 0)
  expect_equal(class(weather_hours), "data.frame")
})
