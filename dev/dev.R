
library(norweather)

places <- search_places("Roskilde Festival")

place_url <- places$place_url[1]

weather_data_days <-  get_weather(place_url)
weather_data_hours <-  get_weather(place_url, "hours")
