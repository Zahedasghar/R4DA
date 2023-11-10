
##  install.packages("tidyverse")

## ctrl+Enter

library(tidyverse)

## .dta , .sav, .xlsx, .csv

#library(readr)  # To read csv file

## alif1<-read.csv("docs/Alifailan.csv",header = TRUE) 

alif <- read_csv("Alifailan.csv")

# alif <- read_csv("Alifailan.csv", col_names = TRUE)

names(alif)

## Modify column names 
library(janitor)

alif <-    alif |> clean_names() 













colnames(alif) 

alif |> select(district, province, drinking_water)

alif |> select(-district, -rank_2016)



## select()

## filter()


## arrange()

## mutate()

## summarise()







alif |> glimpse()  


glimpse(alif)

str(alif)

head(alif)

tail(alif)

View(alif)

names(alif)


## Rename

library(janitor)
alif<-alif |> clean_names() |> glimpse()


# alif <-   alif |> rename(inf_scr = infrastructure.score,
#   drink_w = Drinking.water,    bound_w = Boundary.wall,
#    build_cond = Building.condition.satisfactory  )

#View(alif)
## Select data for 4 main provinces (two ways either filter or select)
alif |> filter(province != "AJK",
               province != "GB",
               province != "ICT",
               province != "FATA")


## Or use filter as

alif |> filter (province %in% c("Punjab","Sind","Balochistan", "KP"))


## How many districts in each Province

alif |>  count(province, name="district_count")

alif |> count(Province, name="dist_count") |> 
  arrange(dist_count)

library(gt)
library(gtExtras)

alif |> count(province, name="dist_count") |> 
  arrange(desc(dist_count)) |> gt() |>
  gt_theme_pff() 




## plots

library(ggplot2)

alif |> filter(province==Punjab) ## why an error

alif |> filter(province=="Punjab")

alif |> filter(province=="Punjab") |> 
  select(-c(rank_2016,province)) |> 
  slice(5:8)



alif |> filter( district %in% c("Vehari", "Faisalabad", "Chakwal"))



ggplot(data=alif) 

ggplot(alif)+
  aes(x=drinking_water,y=electricity) 

ggplot(alif)+
  aes(x=drinking_water,y=electricity) +
  geom_point()


ggplot(alif)+
  aes(x=drinking_water,y=electricity) +
  geom_point() +
  aes(color=province)


ggplot(alif)+
  aes(x=drinking_water,y=electricity) +
  geom_point() +
  aes(color=province)+
  facet_wrap(~province)


alif |> filter(province=="Punjab") |> 
  ggplot()+
  aes(x=drinking_water,y=electricity) +
  geom_point()



ggplot(alif) +
  aes(x = drinking_water, y = electricity) +
  geom_jitter(width = .25,
              height = .25) +
  aes(col = province)+
  labs(title="Relationship between drinking water and electricity among districts")

p <- ggplot(alif) + aes(x = drinking_water, y = electricity) +
  geom_jitter(width = .25,
              height = .25) +
  aes(col = province)+scale_color_discrete(guide = F)+
  labs(title="Relationship between drinking water and electricity among districts")+
  labs(caption = "Data source: Alif Ailan")

library(ggthemes)


p+theme_minimal()


## Only for Punjab

alif |> filter(province=="Punjab")

alif |> filter(province=="Punjab") |> 
  ggplot()+aes(x=drinking_water,y=electricity)




alif |> filter(province=="Punjab") |> 
  ggplot()+aes(x=drinking_water,y=electricity)+
  geom_point() 
## Concept of ecological correlations

alif |> filter(province=="Punjab") |> 
  ggplot()+aes(x=drinking_water,y=electricity)+
  geom_point()

















alif |> colnames()

## Lets build scatter plot between drinking water and toilet facilty

p<-ggplot(alif,aes(x=drinking_water,y=toilet,color=province))+geom_point() ## Name plot as p
p
## Make comment on plot by observing where does each province districts lie
p+facet_wrap(~province,ncol = 4)+
  labs(x="Drinking Water",y="Toilet Facility",title = "Toilet facility and Drinking Water Facility situation province wise",
       caption = "Alif Ailan Data 2016")

alif1 |> glimpse()
ggplot(alif1)+aes(x=Province,y=drink_w, fill=Province)+geom_boxplot(method="restyle")



library(dataxray)
alif |> make_xray() |>
  view_xray()
