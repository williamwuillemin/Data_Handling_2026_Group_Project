# Question 1.2 - GDP per capita (World Bank)
library(WDI)

# **1**
# Indicator chosen: NY.GDP.PCAP.KD (GDP per capita, constant 2015 US$)i.e. a country's GDP divided by its midyear population, expressed in 2015 US dollars.
# We have chosen this indicator because : 
#         1) It expresses all countries' GDP in the same currency; US dollars.
#         2) It adjusts for inflation; constant 2015 US dollars
#         3) It has the most amount of data; up to 1960 
# We also considered the NY.GDP.PCAP.KN and the NY.GDP.PCAP.CD but they were ,respectively, not in the same currency or not adjusted for inflation.

gdp_raw <- WDI(
  country   = "all",
  indicator = "NY.GDP.PCAP.KD",
  start     = 1960,
  end       = 2025
)

# Oldest date available (only rows with a real value)
min(gdp_raw$year[!is.na(gdp_raw$NY.GDP.PCAP.KD)])
# **2**
# The oldest year available is 1960

# Checks
nrow(gdp_raw)
head(gdp_raw, 5)

# Store the data
dir.create("data", showWarnings = FALSE)
saveRDS(gdp_raw, "data/df_WorldBank_gdp_capita.RDS")