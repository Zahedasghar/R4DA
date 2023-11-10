library(tidyverse)
library(readr)
library(janitor)


alif <- read_csv("https://raw.githubusercontent.com/Zahedasghar/AER/main/data/alif_aser.csv")


alif |> clean_names() ->gdf


## Lets take year, province and city as first three and
## rename city as city

gdf |> select(year, province, city, everything())

## Lets assign this data as 
gdf |> select(year, province, city, everything()) |> rename(city=city) -> edu_gdf

## Use select to have variables containing percent 

View(edu_gdf)

edu_gdf |> select(contains("percent"))

edu_gdf |> select(ends_with("score")) 

## Lets assing this data as scores


## Distinct years

edu_gdf |> distinct(year)

edu_gdf |>filter(year==2013) |>  distinct(city) |> count()

edu_gdf |> group_by(province) |> distinct(city) |> count()

edu_gdf |> group_by(province) |> distinct(city) |> count() |> 
  arrange(-n)

## Count year and city province wise

gdf |> count(year,province)


gdf |> count(year,province) |> 
  summarise(n=n())


## Filter only for year 2014 
edu_gdf |> filter(year==2014) |> head(4)

edu_gdf |> filter(year==2014) |> slice(103:108)

## Minimum rention score city wise
edu_gdf |> select(year, province, city, retention_score, everything()) |> 
  filter(year==2013) |> filter(retention_score==min(retention_score), .by=province)


edu_gdf |> select(year, province, city, education_score, everything()) |>
  filter(year==2013, province %in% c("Punjab", "Sindh",
"KP","Balochistan", "Sindh")) |> filter(education_score==min(education_score), .by=province)



gdf_short <- edu_sc |> select(year, province, city, contains("score"))

gdf_short |> glimpse()




## plots

library(ggplot2)

gdf1 <- gdf |> filter(year==2014)

ggplot(gdf1) 

ggplot(gdf1)+aes(x=drinking_water,y=electricity) 

ggplot(gdf1)+aes(x=drinking_water,y=electricity) +
  geom_point()


ggplot(gdf1)+aes(x=drinking_water,y=electricity) +
  geom_point() +
  aes(color=c(province))


ggplot(gdf1)+aes(x=drinking_water,y=electricity) +
  geom_point() +
  aes(color=province)+
  facet_wrap(~province)


ggplot(gdf1) + aes(x = drinking_water, y = electricity) +
  geom_jitter(width = .25,
              height = .25) +
  aes(col = province)+
  labs(title="Relationship between drinking water and electricity among citys")

ggplot(gdf1) + aes(x = drinking_water, y = electricity) +
  geom_jitter(width = .25,
              height = .25) +
  aes(col = province)+scale_color_discrete(guide = F)+
  labs(title="Relationship between drinking water and electricity among citys")+
  labs(caption = "Data source: gdf1 Ailan")




## Only for Punjab

gdf1 |> filter(province=="Punjab")

gdf1 |> filter(province=="Punjab") |> 
  ggplot()+aes(x=drinking_water,y=electricity)+
  geom_point()



gdf1 |> filter(province=="Punjab") |> 
  ggplot()+aes(x=drinking_water,y=electricity)+
  geom_point()+geom_text(aes(label=city),hjust=0, vjust=0)

gdf1 |> filter(province=="Punjab") -> gdf1_punjab
ggplot(gdf1_punjab)+aes(x=drinking_water,y=electricity)+
  geom_point()+geom_label(data=gdf1_punjab |> filter(electricity<70),
                          aes(label=city),hjust=0, vjust=0)

ggplot(gdf1)+
  aes(x=drinking_water,y=electricity)+
  geom_point()+geom_label(data=gdf1 |> filter(province=="Balochistan"&electricity<20),
                          aes(label=city),col='red',size=2, hjust=0,vjust=0)





## Concept of ecological correlations

gdf1 |> filter(province=="Punjab") |> 
  ggplot()+aes(x=drinking_water,y=electricity)+
  geom_point()





## Lets build scatter plot between drinking water and toilet facilty

p<-ggplot(gdf1,aes(x=drinking_water,y=toilet,color=province))+geom_point() ## Name plot as p
p
## Make comment on plot by observing where does each province citys lie
p+facet_wrap(~province,ncol = 4)+
  labs(x="Drinking Water",y="Toilet Facility",title = "Toilet facility and Drinking Water Facility situation province wise",
       caption = "gdf1 Ailan Data 2016")

gdf1 |> glimpse()
ggplot(gdf1)+aes(x=province,y=drinking_water, fill=province)+geom_boxplot(method="restyle")


gdf1 |> filter(province=="Punjab") |> 
  ggplot()+aes(x=reorder(city,toilet),y=toilet)+geom_bar(stat="identity")+
  coord_flip()+geom_col(fill = 'dodgerblue4') +
  theme_minimal() 
gdf1$drinking_water

gdf1 |> filter(province=="Balochistan") |> 
  ggplot()+aes(x=reorder(city,drinking_water),y=drinking_water)+geom_bar(stat="identity")+
  coord_flip()+geom_col(fill = 'dodgerblue4') +
  theme_minimal() 

