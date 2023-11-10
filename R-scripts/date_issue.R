library(tidyverse)
library(gt)
sp500_opens <- gt::sp500 |> 
  select(date, open)
sp500_opens
 sp500_opens |> 
  mutate(day=day(date),
         month=month(date),
         year=year(date))

sp500_opens |> 
  timetk::tk_augment_timeseries_signature(date) 

library(tidyverse)
library(gt)
sp500 |> 
  timetk::tk_augment_timeseries_signature() |> glimpse()
