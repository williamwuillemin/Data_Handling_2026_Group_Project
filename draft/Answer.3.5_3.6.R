## 3.5 - Goldin's U-Shape theory


### 3.5.1 - Theoretical considerations


#### 3.5.1.1 - As shown in Figure 1, Claudia Goldin shows a U-shaped correlation between GDP per capita and female labour force participation. Comment on the graph and the expected correlation.

The graph shows a U-shaped relationship between log GDP per capita and female labor force participation, captured by a quadratic fit with a minimum at middle-income levels. The expected correlation is therefore non-linear and depends on the stage of development: negative at low income levels, approximately zero at the turning point, and positive at higher income levels.


#### 3.5.1.2 - Do you expect this relationship to have changed over time, for example between 1990 and 2020? 

We'd expect the U-shaped relationship to have flattened between 1990 and 2020. Social and economic changes have raised the returns to women's work and lower the cost of combining work and family, which encourages more women to work. Consequently, female labour force participation increases in both middle-income and high-income countries, which makes the trough of the curve shallower.


#### 3.5.1.3 - Would you expect female labour force participation in Switzerland to be higher or lower than in its neighbours (Germany, France, Italy, Austria)? Why?

We would expect female labour force participation in Switzerland to be higher than in its neighbours. Goldin's U-shaped hypothesis places advanced economies on the rising branch of the curve, where higher GDP per capita goes with higher female participation. Since Switzerland's GDP per capita exceeds that of Germany, France, Austria, and Italy, the model predicts a higher Swiss female participation rate.


### 3.5.2 - Reproducing Goldin's graph


#### 3.5.2.1 - Explore the correlation with your data by reproducing Goldin's graph (Figure 1) with our data.

# Keep only rows with both values (the full join leaves NAs)
# We use 1985 for both indicators: Goldin's combination (participation 1980,
# GDP 1985) leaves only 20 countries with both values, versus about 40 for 1985 alone.

library(tidyverse)
df_plot <- df_merged |>
  drop_na(flfp, gdp_pc)
df_plot |>
  filter(year == 1985) |>
  ggplot(aes(x = log_gdp_pc, y = flfp)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), se = FALSE) +
  labs(
    x = "Log GDP per capita (constant 2015 US$)",
    y = "Female labour force participation, ages 45–54 (%)",
    title = "Female labour force participation and GDP per capita, 1985",
    caption = paste0("n = ", nrow(df_plot), " countries")
  ) +
  theme_minimal()


#### 3.5.2.2 - Compare your graph with Goldin's: what differs between our data and hers? Give a final statement about your results.

Our graph differs from Goldin's in four ways:

- We used 1985 for both indicators instead of 1980 for female labour force participation and 1985 for gdp per capita.
- We used gdp per capita in constant 2015 US dollar instead of 1985 US dollar.
- Our sample covers women aged from 45-54 instead of women aged from 45-59 years old.
- As stated in the notes Goldin excluded some countries(middle eastern countries and countries with inconsistent labour force data), we made no such exclusion.

Consequently, our U-shape is shallower and more scattered than hers. It is consistent with her theory but is only weak evidence for it, given the difference of our sample.


#### 3.5.2.3 - Like Goldin, we will use log of GDP as the main variable. Explain why.

Gdp per capita is strongly right-skewed so most poor countries would be squeezed into one corner of the plot. We use log of gdp because it spreads the points out and makes the relationship closer to a smooth quadratic.


### 3.5.3 - Change over time: look at the same correlation over time using a graph. Briefly comment.

```{r}
# We look at the correlation over the years 1970, 1990, 2010 and 2020. 
df_plot |>
  filter(year %in% c(1970, 1990, 2010, 2020)) |>
  ggplot(aes(x = log_gdp_pc, y = flfp)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), se = FALSE) +
  facet_wrap(~ year) +
  labs(x = "Log GDP per capita (constant 2015 US Dollars)", y = "Female labour force participation (%)") +
  theme_minimal()
```

The U-shaped curve seems to appear after 1970. We need to check the comparability between each year. 

```{r}
#Number of countries per year
years <- c(1970, 1990, 2010, 2020)

df_years <- df_merged |>
  filter(year %in% years) |>
  drop_na(flfp, log_gdp_pc)

df_years |>
  count(year, name = "n_countries")

# Countries with both values in all four years
balanced <- df_years |>
  group_by(iso3c) |>
  filter(n_distinct(year) == length(years)) |>
  ungroup()

n_distinct(balanced$iso3c)

# Compare matching countries visually
plot_u <- function(data, title) {
  ggplot(data, aes(x = log_gdp_pc, y = flfp)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", formula = y ~ x + I(x^2), se = FALSE) +
    facet_wrap(~ year) +
    labs(
      x = "Log GDP per capita (constant 2015 US$)",
      y = "Female labour force participation (%)",
      title = title
    ) +
    theme_minimal()
}

plot_u(df_years, "All available countries")
plot_u(balanced, "Same countries in every year")

```
After further analysis, we can conclude that the U-shape does not emerge over time. The countries in the data change between years, so the apparent shift in the curve mainly reflects the changing sample, not a real change in the relationship.


### 3.5.4 - Female labour force participation in Switzerland


#### 3.5.4.1 - Look at female labour force participation in Switzerland over time and compare it to its neighbour countries. What do you notice? Se baser sur 3.4.1

```{r}
neighbours <- c("CHE", "DEU", "FRA", "ITA")

df_nb <- df_plot |>
  filter(iso3c %in% neighbours) |>
  arrange(iso3c, year)

# Participation over time
ggplot(df_nb, aes(x = year, y = flfp, colour = iso3c)) +
  geom_line() +
  labs(x = NULL, y = "Female labour force participation (%)", colour = "Country") +
  theme_minimal()
```
Switzerland started below France but caught up to France and Germany, ending among the highest, while Italy stayed clearly below the others throughout.


#### 3.5.4.2 - Look at the correlation between GDP and female labour force participation for Switzerland and its neighbouring countries. Can you conclude that they followed a U-Shape historical path?

```{r}
# Path against GDP: do they follow a U?
ggplot(df_nb, aes(x = log_gdp_pc, y = flfp, colour = iso3c)) +
  geom_path() +
  labs(
    x = "Log GDP per capita (constant 2015 US$)",
    y = "Female labour force participation (%)",
    colour = "Country"
  ) +
  theme_minimal()

```
In all four countries participation rises almost continuously with GDP, which matches the rising right arm of the U. However, our data only start once these countries were already wealthy, so we do not observe the falling left part, and we therefore cannot conclude that they followed a U-shaped path. 


## 3.6 - Wrap up


### 3.6.1 - Your data story (bonus reflection, not graded)

```{r}
library(patchwork)

# Ploting the two graphs 
p_all      <- plot_u(df_years, "All available countries")
p_balanced <- plot_u(balanced, "Same countries in every year")

p_all / p_balanced
```

Do data lie? Not exactly, but depending on how we select and treat them, they can tell the story we expect. In a recent group project on Goldin's U-shape work, it looked as if the U-shape of female participation appeared after 1970. Yet, after further analysis, the pattern came from the changing country sample, not from history. Keep the same countries in every year, and the U was already there. Before drawing conclusions, ask who is in your data and always question your initial conclusions.

### 3.6.2 - Further steps

We propose conducting panel regressions with country fixed effects to test the U within countries over time. Since researchers find that results depend on the GDP source, we should check robustness using Penn World Table GDP. Finally, focusing on specific sectors like agriculture could test the structural change mechanism.






