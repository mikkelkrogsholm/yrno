
<!-- README.md is generated from README.Rmd. Please edit that file -->
norweather
==========

The goal of `norweather` is to high quality weather data from the Norwegian Meteorological Institute and the NRK easily into R.

Installation
------------

You can install norweather from github with:

``` r
# install.packages("devtools")
devtools::install_github("mikkelkrogsholm/yrno")
```

This Readme shows you how to use the `norweather` package.

`norweather` is a wrapper for the weather forecasts from Yr, delivered by the Norwegian Meteorological Institute and the NRK.

Please read more about the conditions and guidelines at <http://om.yr.no/verdata/>
English explanation at <http://om.yr.no/verdata/free-weather-data/>

There are two steps to follow when you want to get the weather data:

-   Find the place to get weather data for
-   Get the weather data

Find the place
--------------

In order for us to get the data from the Yr service we need to have the appropriate place url. There are several ways of doing this.

**Manual lookup**
You can do a manual lookup on [yr.no](https://www.yr.no/). Here you can search for a location and navigate to the site with the weather forecast for that place. For instance, if you go to the webpage and search for *Copenhagen* and then navigate to the capital of Denmark you should end up on the following url: <https://www.yr.no/place/Denmark/Capital/Copenhagen/>

There you can se the weather forecast for Copenhagen, Denmark. You can also use the url to get data systematically into R.

**Automatic lookup**
You can also use the `search_places()` function in the `norweather` package.

``` r
cph <- norweather::search_places(place = "Copenhagen")
```

This function searches for *Copenhagen* and then returns possible matches in a data frame.

``` r
head(cph)
#>   no.                   place elevation                    type
#> 1   1              Copenhagen        14                 Capital
#> 2   2 Copenhagen municipality         3 Administrative division
#> 3   3              Copenhagen        65         Populated place
#> 4   4              Copenhagen       355         Populated place
#> 5   5         Central Station         7        Railroad station
#> 6   6              Copenhagen       216         Populated place
#>   municipality    region       country
#> 1           NA   Capital       Denmark
#> 2           NA   Capital       Denmark
#> 3           NA Louisiana United States
#> 4           NA  New York United States
#> 5           NA   Capital       Denmark
#> 6           NA   Ontario        Canada
#>                                                          place_url
#> 1              https://www.yr.no/place/Denmark/Capital/Copenhagen/
#> 2 https://www.yr.no/place/Denmark/Capital/Copenhagen_municipality/
#> 3      https://www.yr.no/place/United_States/Louisiana/Copenhagen/
#> 4       https://www.yr.no/place/United_States/New_York/Copenhagen/
#> 5         https://www.yr.no/place/Denmark/Capital/Central_Station/
#> 6               https://www.yr.no/place/Canada/Ontario/Copenhagen/
```

The first row looks about right, and indeed it is the same url as the one we identified above manually.

Now we can use the url to fetch weather data for Copenhagen automatically into R.

Get the weather data
--------------------

First we set our place url. This is the basis of all the different forecasts we want to get.

``` r
place_url <- "https://www.yr.no/place/Denmark/Capital/Copenhagen/"
```

We can then use the `get_weather()` function to get forecasts for Copenhagen.

``` r
forecast_days <- norweather::get_weather(place_url, forecast = "days")
#> In order to use the free weather data from yr no, you HAVE to display the following text clearly visible on your web page. The text should be a
#> link to the specified URL.
#> 
#> TEXT: Weather forecast from Yr, delivered by the Norwegian Meteorological Institute and the NRK
#> URL: http://www.yr.no/place/Denmark/Capital/Copenhagen/
#> 
#> Please read more about the conditions and guidelines at http://om.yr.no/verdata/
#> English explanation at http://om.yr.no/verdata/free-weather-data/
```

As you can see there are some conditions to using the data from Yr. Whenever you call to get data, the function will make you aware of how to credit the data correctly.

Above we set the `forecast` parameter to *"days"*. This means that the `get_weather()` function will get a forecast for the next week our so, where every day is split in to 6 hour intervals - so each day has four different intervals.

Lets have a look:

``` r
dplyr::glimpse(forecast_days)
#> Observations: 37
#> Variables: 20
#> $ time_from              <dttm> 2017-07-19 20:00:00, 2017-07-20 00:00:...
#> $ time_period            <dbl> 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, ...
#> $ time_to                <dttm> 2017-07-20 00:00:00, 2017-07-20 06:00:...
#> $ symbol_name            <chr> "Partly cloudy", "Partly cloudy", "Part...
#> $ symbol_number          <dbl> 3, 3, 3, 9, 10, 10, 3, 3, 3, 4, 2, 3, 9...
#> $ symbol_numberex        <dbl> 3, 3, 3, 46, 10, 10, 3, 3, 3, 4, 2, 3, ...
#> $ symbol_var             <chr> "03n", "03n", "03d", "46", "10", "10", ...
#> $ precipitation_value    <dbl> 0.0, 0.0, 0.0, 0.8, 7.6, 5.2, 0.0, 0.0,...
#> $ precipitation_maxvalue <dbl> NA, NA, NA, 2.2, 12.2, 9.6, 1.4, 1.0, N...
#> $ precipitation_minvalue <dbl> NA, NA, NA, 0.0, 4.3, 1.1, 0.0, 0.0, NA...
#> $ winddirection_code     <chr> "SSE", "ESE", "E", "SE", "ESE", "ESE", ...
#> $ winddirection_deg      <dbl> 156.6, 117.1, 94.4, 128.1, 103.6, 104.1...
#> $ winddirection_name     <chr> "South-southeast", "East-southeast", "E...
#> $ windspeed_mps          <dbl> 2.4, 2.3, 3.0, 4.9, 3.7, 3.0, 1.9, 2.7,...
#> $ windspeed_name         <chr> "Light breeze", "Light breeze", "Light ...
#> $ temperature_unit       <chr> "celsius", "celsius", "celsius", "celsi...
#> $ temperature_value      <dbl> 19, 16, 14, 21, 19, 17, 17, 21, 20, 16,...
#> $ pressure_unit          <chr> "hPa", "hPa", "hPa", "hPa", "hPa", "hPa...
#> $ pressure_value         <dbl> 1015.7, 1014.7, 1012.6, 1011.0, 1008.4,...
#> $ tz                     <chr> "Europe/Copenhagen", "Europe/Copenhagen...
```

We can also get a more detailed forecast: the hourly forecast. Here we set the `forecast` parameter to *"hours"*.

``` r
forecast_hours <- norweather::get_weather(place_url, forecast = "hours")
#> In order to use the free weather data from yr no, you HAVE to display the following text clearly visible on your web page. The text should be a
#> link to the specified URL.
#> 
#> TEXT: Weather forecast from Yr, delivered by the Norwegian Meteorological Institute and the NRK
#> URL: http://www.yr.no/place/Denmark/Capital/Copenhagen/
#> 
#> Please read more about the conditions and guidelines at http://om.yr.no/verdata/
#> English explanation at http://om.yr.no/verdata/free-weather-data/
```

This forecast has predictions for each hour for the next 48 hours.

Lets have a look:

``` r
dplyr::glimpse(forecast_hours)
#> Observations: 48
#> Variables: 19
#> $ time_from              <dttm> 2017-07-19 20:00:00, 2017-07-19 21:00:...
#> $ time_to                <dttm> 2017-07-19 21:00:00, 2017-07-19 22:00:...
#> $ symbol_name            <chr> "Fair", "Partly cloudy", "Partly cloudy...
#> $ symbol_number          <dbl> 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 3, ...
#> $ symbol_numberex        <dbl> 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 3, ...
#> $ symbol_var             <chr> "02d", "03d", "03n", "03n", "03n", "03n...
#> $ precipitation_value    <dbl> 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
#> $ precipitation_maxvalue <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
#> $ precipitation_minvalue <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
#> $ winddirection_code     <chr> "SSE", "SSE", "SSE", "SE", "ESE", "ESE"...
#> $ winddirection_deg      <dbl> 156.6, 161.7, 151.2, 127.8, 117.1, 119....
#> $ winddirection_name     <chr> "South-southeast", "South-southeast", "...
#> $ windspeed_mps          <dbl> 2.4, 2.7, 2.5, 2.2, 2.3, 2.1, 2.4, 2.5,...
#> $ windspeed_name         <chr> "Light breeze", "Light breeze", "Light ...
#> $ temperature_unit       <chr> "celsius", "celsius", "celsius", "celsi...
#> $ temperature_value      <dbl> 19, 18, 17, 16, 16, 15, 15, 14, 14, 14,...
#> $ pressure_unit          <chr> "hPa", "hPa", "hPa", "hPa", "hPa", "hPa...
#> $ pressure_value         <dbl> 1015.7, 1016.0, 1015.8, 1015.2, 1014.7,...
#> $ tz                     <chr> "Europe/Copenhagen", "Europe/Copenhagen...
```

And that is how you use the `norweather` package.
