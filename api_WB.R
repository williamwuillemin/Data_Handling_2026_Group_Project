# Own API wrapper for the World Bank REST API (v2)
# Returns one row per country and year for the chosen indicator

library(httr2)

get_wbdata <- function(indicator = "NY.GDP.PCAP.KD", country = "all",
                       year_from = 1960, year_to = 2025) {
  
  # Several countries can be requested at once: the World Bank joins codes with ";"
  country_key <- paste(country, collapse = ";")
  
  # Base URL + path parameters (country, indicator) + query parameters
  final_url <- paste0(
    "https://api.worldbank.org/v2/country/", country_key,
    "/indicator/", indicator,
    "?format=json",
    "&date=", year_from, ":", year_to,
    "&per_page=20000"
  )
  
  # Send the request; switch off httr2's automatic error so ours is shown
  resp <- request(final_url) |>
    req_error(is_error = function(resp) FALSE) |>
    req_perform()
  
  # Stop with a clear message if the request did not come through
  if (resp_status(resp) != 200) {
    stop("World Bank request failed (HTTP ", resp_status(resp), "). URL: ", final_url)
  }
  
  # Turn the JSON body into an R list
  body <- resp_body_json(resp)
  
  # An invalid indicator still returns status 200, with a message instead of data
  if (!is.null(body[[1]]$message)) {
    stop("World Bank API error: ", body[[1]]$message[[1]]$value)
  }
  
  # First element: metadata (number of pages and of observations)
  meta <- body[[1]]
  
  # Second element: the observations (NULL if there are none)
  obs <- body[[2]]
  if (is.null(obs)) {
    stop("No data returned. URL: ", final_url)
  }
  
  # One row per observation; missing values (NULL) become NA
  df <- data.frame(
    country   = sapply(obs, function(x) x$country$value),
    iso3c     = sapply(obs, function(x) x$countryiso3code),
    year      = as.integer(sapply(obs, function(x) x$date)),
    indicator = sapply(obs, function(x) x$indicator$id),
    value     = sapply(obs, function(x) if (is.null(x$value)) NA else x$value)
  )
  
  # Check that we received all observations the API says exist
  if (nrow(df) != meta$total) {
    warning("Received ", nrow(df), " of ", meta$total,
            " observations. Increase per_page.")
  }
  
  df
}

