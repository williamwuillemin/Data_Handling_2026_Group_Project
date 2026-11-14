# Own API wrapper for the ILO SDMX REST API
# Female labour force participation rate, women aged 45-54, annual data
# Dataset: Labour force participation rate by sex and age (DF_EAP_DWAP_SEX_AGE_RT)

library(httr2)

get_ilodata <- function(country = "", year_from = 1950, year_to = 2025) {
  
  # Several countries can be requested at once: SDMX joins codes with "+"
  country_key <- paste(country, collapse = "+")
  
  # Base URL + dataflow (agency, dataset ID, version)
  base_url <- "https://sdmx.ilo.org/rest/data/ILO,DF_EAP_DWAP_SEX_AGE_RT,1.0/"
  
  # Key: country . frequency . (all) . sex . age -- empty slot = all values
  key <- paste0(country_key, ".A..SEX_F.AGE_10YRBANDS_Y45-54")
  
  # Query parameters: period and output format
  final_url <- paste0(
    base_url, key,
    "?startPeriod=", year_from,
    "&endPeriod=", year_to,
    "&dimensionAtObservation=AllDimensions",
    "&format=csvfilewithlabels"
  )
  
  # Send the request; switch off httr2's automatic error so ours is shown
  resp <- request(final_url) |>
    req_error(is_error = function(resp) FALSE) |>
    req_perform()
  
  # Stop with a clear message if the request did not come through
  if (resp_status(resp) != 200) {
    stop("ILO request failed (HTTP ", resp_status(resp), "). URL: ", final_url)
  }
  
  # Turn the CSV body into a data frame
  df <- read.csv(text = resp_body_string(resp))
  
  # Keep only the columns we need, with short names (same as Rilostat)
  data.frame(
    ref_area  = df$REF_AREA,        # country code, e.g. "CHE"
    country   = df$Reference.area,  # country name, e.g. "Switzerland"
    time      = df$TIME_PERIOD,     # year
    obs_value = df$OBS_VALUE        # participation rate in %
  )
}

