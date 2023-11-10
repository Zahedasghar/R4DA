#install.packages("tidymodels")
library(tidymodels)
library(tidyverse)
library(gt)
library(here)

tbl_one <- linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") |> 
  fit(displ~year+hwy+cyl,data=mpg) |> 
  tidy()

# Creating table function 
gt_table_function <- function(regression_table,r_square, adj_rsquare,prob_f,
                              text=""){
  tbl <- gt(regression_table,id="two")

gt_table <- tbl |> 
  tab_header(
    title = md("**Linear Regression Analysis**"),
    subtitle = md("**Model: displ~year+hwy+cyl**")) |>
  cols_label(term="variable",
             estimate="Estimate",
             std.error="Standard Error",
             statistic="T-value",
             p.value="P Value") |> 
  fmt_number(
    columns =everything(),
    rows=everything(),
    decimals = 2
  ) |> 
  fmt_auto(columns = "term") |> 
  opt_stylize(style = 6, color = "cyan") |> 
  opt_table_font(stack = "rounded-sans") |> 
  tab_footnote(footnote = paste("R-Squared:", r_square)) |> 
  tab_footnote(footnote = paste("Adj-r-squared:", adj_rsquare)) |> 
  tab_footnote(footnote = paste("Prob(F-statistic:", prob_f)) |> 
  tab_source_note(paste("Source:",text)) |> 
  tab_options(table.width = pct(70)) |> 
  opt_css(
    css="#two gt_footnote{
    color: black;
    top: 310px;}"
  )
return(gt_table)
}
gt_table_function(tbl_one,0.883,0.881, 000, "mpg")
  
