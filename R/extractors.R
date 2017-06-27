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
