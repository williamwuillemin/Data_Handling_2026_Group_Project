# Question 1.2 - GDP per capita (World Bank)
library(WDI)

# Indicator chosen: NY.GDP.PCAP.KD (GDP per capita, constant 2015 US$)
# Why: (write 2-3 sentences: same currency, adjusted for inflation,
#       longest series; say why you rejected the other candidates)

gdp_raw <- WDI(
  country   = "all",
  indicator = "NY.GDP.PCAP.KD",
  start     = 1960,
  end       = 2025
)

# Oldest date available (only rows with a real value)
min(gdp_raw$year[!is.na(gdp_raw$NY.GDP.PCAP.KD)])

# Checks
nrow(gdp_raw)
head(gdp_raw, 5)

# Store the data
dir.create("data", showWarnings = FALSE)
saveRDS(gdp_raw, "data/df_WorldBank_gdp_capita.RDS")