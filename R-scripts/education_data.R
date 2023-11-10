
# install.packages("tidyverse")

library(tidyverse)


## .dta , .sav, .xlsx, .csv



library(janitor)   ## For data cleaning




edu_data <- read_csv("docs/data/edu_data_kaggle.csv")  #https://www.kaggle.com/datasets/mesumraza/pakistan-education-performance-dataset

#View(edu_data)

edu_data |> colnames()

edu_data |> clean_names() |> View()


edu_data |> clean_names() |> glimpse()


## So far not assigned 

edu_data |> clean_names() -> edf

edf <- edf |> select(year, province,city, everything()) |> rename(district=city)

View(edf)
edf |> glimpse()

edf |> select(year, province,district,contains("percent")) |> View()


edf |> select(year, province,district,contains("percent")) |> slice(25:30)


edf |> distinct(year)


edf |> distinct(year) |> count()

edf |> distinct(district ) |> count()

edf |> group_by(province) |> distinct(district) |> count()


edf |> group_by(province) |> distinct(district) |> count() |>
  arrange(-n)

edf |> group_by(province, year) |> distinct(district) |> count() |>
  arrange(-n)

edf |> distinct(province) 
edf |> filter(!province %in% c("AJK","ICT","FATA","GB" ))

## OR

edf |> filter(province %in% c("Punjab","KP", "Sindh","Balochistan"))


## Select variables ending with score by having year, province and district as first three variables

edf |> select(year, province, district, ends_with("score")) |> glimpse()

edf |> select(year, province, district, ends_with("score")) |> View()

## Assign this data as edf_score

edf_score <- edf |> select(year, province, district, ends_with("score"))


## So far so good

## View, Glimpse, Select, Filter, Arrange
#Let summarise

summary(edf_score) # Base R

edf_score |> summarise(mean_edu=mean(education_score),med_edu=median(education_score),
                       min=min(education_score), max=max(education_score),sd=sd(education_score))

## Lets find it by province wise 

edf_score |> summarise(mean_edu=mean(education_score),med_edu=median(education_score),
                       min=min(education_score), max=max(education_score),sd=sd(education_score),
                       .by=province)
## Lest find it by province wise as well year wise

edf_score |> summarise(mean_edu=mean(education_score),med_edu=median(education_score),
                       min=min(education_score), max=max(education_score),sd=sd(education_score),
                       .by=c(province,year))

## Lets do it for year 2014

edf_score |> filter(year==2014) |> 
  summarise(mean_edu=mean(education_score),med_edu=median(education_score),
            min=min(education_score), max=max(education_score),sd=sd(education_score),
            .by=province)

## Lets do it for only Balochistan for each year

edf_score |> filter(province=="Balochistan") |> 
  summarise(mean_edu=mean(education_score),med_edu=median(education_score),
            min=min(education_score), max=max(education_score),sd=sd(education_score),
            .by=year)
#install.packages("modelsummary")
library(modelsummary)

