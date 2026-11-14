# Part 1: Importing data with R packages

# Question 1.1 - Female labour force participation (ILO)
library(Rilostat)
library(dplyr)

#**1**
# Indicator chosen: EAP_DWAP_SEX_AGE_RT, "Labour force participation rate by sex and age (%)",
#annual data, women aged 45-54, i.e. the share of women aged 45 to 54 who are economically active
# (employed, or unemployed and looking for a job) among all women of that age in the country.
# We have chosen this indicator because :
#         1) it is highly effective for measuring long-term female economic development. Women in this age bracket have generally completed their formal education and are past the primary years of raising young children. This isolates their labor market attachment from the temporary economic inactivity often associated with early-childhood child-rearing, providing a more standardized measure
#         2) It is available by country and year with annual frequency.
#         3) It has the most amount of data; up to 1946
# We also considered the other "participation rate by sex and age" series of the ILOSTAT table of
# contents, but they start later in 1948 and have a different frequency.


toc <- get_ilostat_toc(
  search = "Labour force participation", 
  quiet = TRUE
  )
toc %>%
  select(
    id,
    indicator,
    indicator.label,
    freq,
    freq.label,
    data.start,
    data.end
  )%>%
  arrange(data.start)


# Question 2: Import annual female labour force participation rate (1950-2025

# 1. Download data for women aged 45-54, all countries, 1950-2025
flfp_raw <- get_ilostat(
  id = id_flfp,
  segment = "indicator",
  time_format = "num",
  filters = list(
    sex = "SEX_F",
    classif1 = "AGE_10YRBANDS_Y45-54",
    timefrom = 1950,
    timeto = 2025
  ),
  quiet = TRUE
)

# 2. Clean and organise the dataset
flfp <- flfp_raw %>%
  transmute(
    iso3 = ref_area,
    year = as.integer(time),
    flfp = obs_value
  ) %>%
  filter(between(year, 1950, 2025), !is.na(flfp)) %>%
  arrange(iso3, year)

# 3. Check the resulting dataset
range(flfp$year)
n_distinct(flfp$iso3)
glimpse(flfp)

# 4. Save the dataset
dir.create("data", showWarnings = FALSE)
saveRDS(flfp, "data/flfp_ilo.rds")
