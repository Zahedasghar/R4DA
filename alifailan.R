## Always start with a project
## getwd()
## setwd()


## Lesson Plan

## Reading Data
## Using Required package
## data frame
## glimpse (to have an overview of data, rows, variables, variables nature)
## structure of data with `str` command , similar as glimpse from base R
## head
## tail
## View



## Select 
## Summarise  (mean, min, max, median, sd,q1, q3)
## filter
## arrange
## mutate
## rename (dont use names with gap  or starting with letters)
## 10 most powerful tools





library(tidyverse) 

library(readr)  # To read csv file 

alif <- read_csv("Alifailan.csv", col_names = TRUE)



alif  |> glimpse()


str(alif)

head(alif)
tail(alif)
#View(alif)


library(janitor)

alif <- alif |> clean_names() 
alif |> colnames()

## Select only few variables

alif |> select(rank_2016,district, province, infrastructure_score, electricity,
               drinking_water)

## Select data for 4 main provinces (two ways either filter or select)
alif |> filter(province!="AJK",province!="GB",province!="ICT",province!="FATA")

## Or just dont select few variables

alif |> select(!c(toilet,boundary_wall))


## Slice
alif |> slice(1:5, )

alif |> select(district, province, infrastructure_score) |> slice(25:30)
## Count total number of districts in each province

alif |> summarise(count = n(), .by = province)

## Arrange ascending or descending order

alif |> summarise(count=n(),.by=province)|>arrange(count)

## Descending

alif |> summarise(count = n(), .by = province) |> arrange(desc(count))

## Filter 
alif |> summarise(count = n(), .by = province) |> arrange(desc(count)) |>
  filter(count > 10)


alif |> summarise(count = n(), .by = province) |> arrange(desc(count)) |>
  filter(count > 10) |>
  na.omit()

## Summarise continued

alif |> summarise(avg_iscr=mean(infrastructure_score),min=min(infrastructure_score),
                  max=max(infrastructure_score),median=median(infrastructure_score),
                  sd=sd(infrastructure_score),
                  .by = province)




## Summarisaton for percentiles
alif |>
  group_by(province) |>
  summarise(quants = list(quantile(electricity, probs = c(.01, .1, .25, .5, .75, .90,.99)))) |>
  unnest_wider(quants)


















## Lets build scatter plot between drinking water and toilet facilty

p<-ggplot(alif,aes(x=drinking_water,y=toilet,color=province))+geom_point() ## Name plot as p
p
## Make comment on plot by observing where does each province districts lie
p+facet_wrap(~province,ncol = 4)+
  labs(x="Drinking Water",y="Toilet Facility",title = "Toilet facility and Drinking Water Facility situation province wise",
       caption = "Alif Ailan Data 2016")

