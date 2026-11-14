# Data Handling Group Project (HSG, Fall 2026)

# Main.R: main script of the project

# Authors: Batteau Elias, Collet Stanislav, Lewis Oliver, Von Muralt Noé & Wuillemin William 

# 1. Start of the Code :

# Data Handling Group Project (HSG, Fall 2026)

# Main.R: main script of the project

# Authors: Batteau Elias, Collet Stanislav, Lewis Oliver, Von Muralt Noé & Wuillemin William 

# 1. Start of the Code :

setwd("C:/GitHub/Data_Handling_2026_Group_Project")

#install the package
# install.packages("dplyr")
# install.packages("httr2")

# Packages (install once in the console with install.packages() if missing)
library(dplyr)
library(httr2)

# Load our own API functions from the R/ folder
source("api_ILO.R")  # creates get_ilodata()
source("api_WB.R")   # creates get_wbdata()

# 2. Quick test: does each function work for one country? --------------------
get_ilodata("CHE", year_from = 2020, year_to = 2023)
get_wbdata("NY.GDP.PCAP.KD", "CHE", year_from = 2020, year_to = 2023)


# 3. Test for Switzerland, USA and Germany in 2023 ----------------------------

countries <- c("CHE", "USA", "DEU")

# ILO: female labour force participation rate, women aged 45-54
ilo_test <- lapply(countries, get_ilodata, year_from = 2023, year_to = 2023) |>
  bind_rows()
ilo_test

# World Bank: GDP per capita (constant 2015 US$)
wb_test <- lapply(
  countries,
  function(cty) get_wbdata("NY.GDP.PCAP.KD", cty, 2023, 2023)
) |>
  bind_rows()
wb_test


# 4. Full download: all countries, all years ----------------------------------

ilo_all <- get_ilodata()  # all countries, 1950-2025
wb_all <- get_wbdata()    # all countries, 1960-2025

nrow(ilo_all)  # the ILO explorer showed 4130 data points for these filters
nrow(wb_all)

