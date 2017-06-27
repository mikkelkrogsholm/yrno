

places <- search_places("Skanderborg")

place_url <- places$place_url[1]

get_weather <- function(place_url, forecast = "days"){

  ## GET DATA ----

  # Set url for daily forecasts
  if(forecast == "days"){
    xml_url <- paste0(place_url, "forecast.xml")
  }

  # Set url for hourly forecasts
  if(forecast == "hours"){
    xml_url <- paste0(place_url, "forecast_hour_by_hour.xml")
  }

  # Get xml data
  yr_request <- httr::GET(url = xml_url)

  # Make sure the data returned is good
  if(httr::http_type(yr_request) != "text/xml"){
    stop("API did not return XML", call. = FALSE)
  }

  if(httr::http_error(yr_request) | httr::status_code(yr_request) != 200){
    stop(paste0("API request failed with status code .",
                httr::status_code(yr_request),
                ". ",
                httr::warn_for_status(yr_request)),
         call. = FALSE)
  }

  ## PARSE DATA ----

  # Extract content
  yr_content <- httr::content(yr_request, as = "text", encoding = "UTF-8")

  # Read it in as html
  yr_content <- xml2::read_html(yr_content)

  # Extract
  extracted_content <- extract_content(yr_content)

  return(extracted_content)
}


test <-  get_weather(place_url)
