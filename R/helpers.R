#' Extracts the xml data
#'
#' It is a non-exported helper function for get_weather().
#'
#' @param yr_content
#'
#' @return a data frame
#'
extract_content <- function(yr_content){

  xml_extractor <- function(yr_content, type){

    if(type == "time") {
      extracted_data <- rvest::html_nodes(yr_content, "time")
      extracted_data <- purrr::map(extracted_data, ~rvest::html_attrs(.))
      extracted_data <- purrr::map(extracted_data, ~data.frame(variable = names(.), value = ., row.names = NULL,
                                                     stringsAsFactors = FALSE))
      extracted_data <- purrr::map(extracted_data, ~tidyr::spread(., variable, value))
      extracted_data <- dplyr::bind_rows(extracted_data)

      names(extracted_data) <- paste0(type, "_", names(extracted_data))

    } else {

      extracted_data <- rvest::html_nodes(yr_content, "time")
      extracted_data <- purrr::map(extracted_data, ~rvest::html_nodes(., type))
      extracted_data <- purrr::map(extracted_data, ~rvest::html_attrs(.))
      extracted_data <- purrr::map(extracted_data, ~.[[1]])
      extracted_data <- purrr::map(extracted_data,
                                   ~data.frame(variable = names(.), value = .,
                                               row.names = NULL,
                                               stringsAsFactors = FALSE))
      extracted_data <- purrr::map(extracted_data,
                                   ~tidyr::spread(., variable, value))
      extracted_data <- dplyr::bind_rows(extracted_data)

      names(extracted_data) <- paste0(type, "_", names(extracted_data))
    }

    return(extracted_data)
  }

  data_list <- c("time", "symbol", "precipitation", "winddirection",
                 "windspeed", "temperature", "pressure")

  extracted_list <- purrr::map(data_list, ~ xml_extractor(yr_content, type = .))

  names(extracted_list) <- data_list

  extracted_df <- dplyr::bind_cols(extracted_list)

  extracted_df$tz <- rvest::html_attr(rvest::html_node(yr_content,
                                          "weatherdata location timezone"), "id")

  return(extracted_df)

}

#' Extracts the creditation
#'
#' It is a non-exported helper function for get_weather().
#'
#' @param yr_content
#'
#' @return a string
#'
extract_creditation <- function(yr_content){

  start_string <-  "In order to use the free weather data from yr no, you HAVE to display the following text clearly visible on your web page. The text should be a
link to the specified URL."

  credit_text <- rvest::html_attr(rvest::html_node(yr_content,
                                                   "weatherdata credit link"), "text")

  credit_url <- rvest::html_attr(rvest::html_node(yr_content,
                                                  "weatherdata credit link"), "url")

  read_more <- "Please read more about the conditions and guidelines at http://om.yr.no/verdata/\nEnglish explanation at http://om.yr.no/verdata/free-weather-data/"

  message_string <- paste0(start_string, "\n\nTEXT: ",credit_text, "\nURL: ", credit_url, "\n\n", read_more)

  return(message_string)
}


#' Makes the data frame pretty
#'
#' It is a non-exported helper function for get_weather().
#'
#' @param extracted_content
#'
#' @return a data frame
#'
prettify_data <- function(extracted_content){

  # Makes the numeric columns numeric
  num_vars <-  c("time_period", "symbol_number", "symbol_numberex",
                 "precipitation_value", "precipitation_maxvalue",
                 "precipitation_minvalue", "winddirection_deg",
                 "windspeed_mps", "temperature_value", "pressure_value")

  num_index <- which(names(extracted_content) %in% num_vars)

  extracted_content[, num_index] <- purrr::map(extracted_content[, num_index], as.numeric)

  # Turns the time columns into POSIXct
  extracted_content$time_from <- lubridate::ymd_hms(extracted_content$time_from,
                                               tz = extracted_content$tz[1])
  extracted_content$time_to <- lubridate::ymd_hms(extracted_content$time_to,
                                             tz = extracted_content$tz[1])

  # Return the pretty data
  return(extracted_content)

}
