library(knitr)
knitr::purl(input="ch4.rmd", output = "ch4.R", documentation = 0)


library(tidyverse)
library(gapminder)
library(gt)

gapminder |> 
  filter(year==2007, country %in% c( "Bangladesh","India",
                                      "Pakistan",
                                    "Sri Lanka",
                                    "Nepal"
                                    
                                    )) |>
  mutate(countries=c("BD", "IN", "NP", "PK", "SL")) |> 
  select(country, countries,lifeExp,pop) |> 
  gt() |> 
  tab_header(title = md("**Sample Countries Grouped by Life Expectancy & Population**"),
             subtitle=md("*South Asian Countries*")) |> 
  fmt_flag(countries) |> 
  cols_label(country="Country",
             countries="Country Flag",
             lifeExp="Life Expectancy",
             pop="Population") |> 
  cols_align(align = "center") |> 
  opt_stylize(style = 6, color="green" ) |> 
  opt_table_font(font=google_font("IBM Plex Sans")) |> 
  opt_align_table_header(align="left") |> 
  data_color(columns = pop, method = "numeric", palette = "Set3") |> 
  tab_stubhead(label="Country") |> 
  tab_source_note(
    source_note = "Source: Gapminder Dataset.") |> 
  tab_source_note(source_note = "The Population Data in year 2007"
  )



countrypops |> arrange(-population)
countrypops |>
  dplyr::filter(year == 2021,population>120000000)|> 
  #dplyr::filter(grepl("^S", country_name))|>
  dplyr::arrange(-population) |>
  dplyr::select(-country_code_3, -year) |>
  dplyr::slice_head(n = 10) |>
  gt() |>
  cols_move_to_start(columns = country_code_2) |>
  fmt_integer() |>
  fmt_flag(columns = country_code_2) |>
  cols_label(
    country_code_2 = "",
    country_name = "Country",
    population = "Population (2021)"
  ) |> 
  cols_align(align = "center") |> 
  opt_stylize(style = 6, color="green" ) |> 
  opt_table_font(font=google_font("IBM Plex Sans")) |> 
  opt_align_table_header(align="left") |> 
  data_color(columns = population, method = "numeric", palette = "Set3") |> 
  tab_stubhead(label="Country") |> 
  tab_source_note(
    source_note = "Source: yearly country population WDI") |> 
  tab_source_note(source_note = "The Population Data in year 2021"
  )
??countrypops
