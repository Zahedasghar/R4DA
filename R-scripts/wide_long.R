library(readxl)
library(tidyverse)
wide<-read_excel("wide_data.xlsx")
View(wide)

long<-wide %>% 
  pivot_longer(c(`1960s`, `1970s`, `1980s` ,`1990s` ,`2000s`,`2007-08`,`2008-09` ,`2009-10`,`2010-11`),#Select column
               names_to = "year",# variable for column names
               values_to = "growth_rate")
long
View(long)


