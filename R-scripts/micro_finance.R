library(readxl)
library(tidyverse)
micro<-read_excel("microfinance.xlsx")
micro<-as_tibble(micro)
glimpse(micro)

View(micro)



## Name the province as region and `Indicator - primary`as Ind_prim,`Indicator - Values` as ind_values

micro<-micro |> rename("Region"="Province","ind_primary"="Indicator - primary", "ind_val"="Indicator - Values")

#summary(micro)


#Basic Data Summary



## Other useful commands
micro |> tally()
micro |> group_by(Region) |> tally()

micro |> filter(Depositors>0) |> group_by(Region) |> tally()


## Selecting particular rows

micro |> slice(25:27)

micro |> slice(c(2,6,29)) 




micro |> filter(Borrowers>0) |> 
  ggplot()+aes(x=Borrowers, fill=Region)+geom_histogram()

micro |> filter(Borrowers>10) |> 
  ggplot()+aes(x=Borrowers, fill=Region)+geom_density()

micro |> filter(Borrowers>10) |> 
  ggplot()+aes(x=Borrowers, color=Region)+geom_density()

## Number of observations by region
micro |> group_by(Region) |> count(Region)

micro |> group_by(Region) |> count(MFI)

## List top 10 MFI  by number of borrowers
micro |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10)

## List top 10 borrowers in asceding and descending order

micro |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(sum)

## Descending order

micro |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(desc(sum))

## Large Borrowers by Province

# If Balochistan

micro |> filter(Region=="Balochistan") |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10)

micro |> filter(Region=="Balochistan") |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(sum)

micro |> filter(Region=="Balochistan") |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(desc(sum))

## If Punjab
micro |> filter(Region=="Punjab") |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(desc(sum))

## If Sindh
micro |> filter(Region=="Sindh") |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(desc(sum))

## If KP
## If Punjab
micro |> filter(Region=="KP") |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(desc(sum))

## If KP or Sindh

micro |> filter(Region %in% c("KP", "Sindh")) |> group_by(MFI) |> summarise(sum=sum(Borrowers)) |> top_n(10) |> 
  arrange(desc(sum))

## Number of MFI where borrowers are not zero
micro |> filter(Borrowers!=0) |> summarise(total=n(), avg_borrowers=mean(Borrowers), avg_dep=mean(Depositors))

micro |> filter(Depositors!=0) |> group_by(Region) |>  summarise(total=n(), avg_borrowers=mean(Borrowers), avg_dep=mean(Depositors))


## Awesome summary
library(gtsummary)

micro |> filter(Depositors!=0) |> group_by(Region) |> 
  summarise(total=n(), avg_borrowers=mean(Borrowers), avg_dep=mean(Depositors)) |> 
  gt(caption = "Microfinance Institutions in Pakistan 2013") |> 
  gt_theme_538() |> tab_header("Province-wise summary of borrowers and depositors")

## Round digits to 1 decimal point

micro |> filter(Depositors!=0) |> 
  group_by(Region) |> 
  summarise(total=n(), avg_borrowers=round(mean(Borrowers),0), 
            avg_dep=round(mean(Depositors),0)) |> 
  gt(caption = "Microfinance Institutions in Pakistan 2013") |>
  gt_theme_538() |> tab_header("Province-wise summary of borrowers and depositors")
