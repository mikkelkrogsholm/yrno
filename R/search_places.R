#' Search yr.no for a place.
#'
#' @param place The place you want to search for. Keep the search as simple as
#'     possible. This function will only return the first page of the search
#'     result from yr.no
#' @param country Two letter country code. Ex: DK, US, DE.
#' @export
#' @examples
#'
#' library(norweather)
#'
#' search_places(place = "Copenhagen")
#' search_places(place = "Copenhagen", country = "US")
#' search_places(place = "New York")
#' search_places(place = "London")

search_places <- function(place = "", country = ""){

  # Opens an english language session with yr.no
  s <- rvest::html_session("https://www.yr.no/_/settspr.aspx?spr=eng&redir=%2f")

  # Build query
  url_parts <- list(
    scheme = "https",
    hostname = "www.yr.no",
    path = "soek/soek.aspx",
    query = list(
      sted = place,
      land = country
    )
  )

  # Supply correct class
  class(url_parts) <- "url"

  # Build URL from parts
  place_url <- httr::build_url(url_parts)

  # Get data
  place_search <- rvest::jump_to(s, place_url)

  # Extract tables
  places_tables <- rvest::html_table(rvest::html_nodes(place_search, "table"))

  # Abort function if there are no results
  if(length(places_tables) == 1){
    message("No results. Specify your search.")
    return(NULL)
  }

  # Rowbind all results from front page
  places_df <- dplyr::bind_rows(
    places_tables[[2]],
    places_tables[[3]]
  )

  # Get url for places
  place_url <- rvest::html_nodes(place_search, "table.yr-table.yr-table-search-results")
  place_url <- rvest::html_nodes(place_url, "td:nth-child(2) a")
  place_url <- rvest::html_attr(place_url, "href")
  place_url <- paste0("https://www.yr.no", place_url)
  places_df$place_url <- place_url

  # Return the possible places
  return(places_df)
}
