library(tidyverse) ## A set of package to be used
library(gapminder) ## gapminder package for gapminder.org
## data
gapminder

## To have an overview
gapminder |> glimpse()



# keep country and all variables containing "per"
gapminder |> 
  select(country, contains("per"))

gapminder |> 
  filter(year == 2002)  ## Only for 2002 year data


gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp)    ## All variables other than lifeExp

gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp) |> 
rename(gdp_per_cap = gdpPercap)

gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp) |> 
  rename(gdp_per_cap = gdpPercap) |> 
  mutate(gdp = gdp_per_cap * pop)

gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp) |> 
  rename(gdp_per_cap = gdpPercap) |> 
  mutate(gdp = gdp_per_cap * pop) |> 
  mutate(europe = continent == "Europe")


gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp) |> 
  rename(gdp_per_cap = gdpPercap) |> 
  mutate(gdp = gdp_per_cap * pop) |> 
  mutate(europe = continent == "Europe") |> 
  select(country, year, gdp, europe, pop)  |> 
  mutate(europe_category =
           case_when(europe == T ~ "Europe",
                     europe == F ~ "Not Europe"))

gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp) |> 
  rename(gdp_per_cap = gdpPercap) |> 
  mutate(gdp = gdp_per_cap * pop) |> 
  mutate(europe = continent == "Europe") |> 
  select(country, year, gdp, europe, pop)  |> 
  mutate(europe_category =
           case_when(europe == T ~ "Europe",
                     europe == F ~ "Not Europe")) |> 
    arrange(-gdp) 



gapminder |> 
  filter(year == 2002) |> 
  select(-lifeExp) |> 
  rename(gdp_per_cap = gdpPercap) |> 
  mutate(gdp = gdp_per_cap * pop) |> 
  mutate(europe = continent == "Europe") |> 
  select(country, year, gdp, europe, pop)  |> 
  mutate(europe_category =
           case_when(europe == T ~ "Europe",
                     europe == F ~ "Not Europe")) |> 
  arrange(-gdp) |>  
    mutate(gdp_billions = gdp/1000000000) |> 
  slice(1:8) ->
  europe_or_not_2002
# plot 

ggplot(data = europe_or_not_2002) +
  aes(x = reorder(country, gdp_billions)) +
  aes(y = gdp_billions) +
  geom_col()


ggplot(data = europe_or_not_2002) +
  aes(x = reorder(country, gdp_billions)) +
  aes(y = gdp_billions) +
  geom_col()+
  aes(fill = europe_category)


ggplot(data = europe_or_not_2002) +
  aes(x = reorder(country, gdp_billions)) +
  aes(y = gdp_billions) +
  geom_col()+
  aes(fill = europe_category)+
  scale_y_log10()

ggplot(data = europe_or_not_2002) +
  aes(x = reorder(country, gdp_billions)) +
  aes(y = gdp_billions) +
  geom_col()+
  aes(fill = europe_category)+
  scale_y_log10()+
    coord_flip() +
  labs(title = "Eight largest economies, 2002")

