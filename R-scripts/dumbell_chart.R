library(tidyverse)
library(janitor)
#install.packages("ggtext")
library(ggtext)

gapminder_2007_1952 <- gapminder::gapminder |> janitor::clean_names() |> 
  filter(year %in% c(1952,2007)) |> 
  mutate(year=factor(year))

selected_countries <- gapminder_2007_1952 |> filter(country %in% c("Pakistan","India",
                                                        "Bangladesh","Sri Lanka","Nepal","Bhutan"))

color_palette <- c("#E69F00","#009E73")
names(color_palette) <- c(1952,2007)

selected_countries
selected_countries |> 
  ggplot(aes(x=life_exp,y=country,col=year))+
  geom_point(size=4)+
  scale_color_manual(values = color_palette)+
  theme_minimal(base_size = 16,base_family = "Merriweather")+
  theme(legend.position = "none")

title_text <- glue::glue(
  "Comparison of life expectancies between <span style=
  'color:{color_palette['1952']}'>2007</span>"
)

selected_countries |> 
  ggplot(aes(x=life_exp,y=country,col=year))+
  geom_point(size=4)+
  scale_color_manual(values = color_palette)+
  theme_minimal(
    base_size = 16, base_family = 'Merriweather'
  )+
  theme(legend.position = 'none')


segment_helper <- selected_countries |>
  select(country, year, life_exp) |>
  pivot_wider(names_from = year,
              values_from = life_exp,
              names_prefix = 'year_') |>
  mutate(change = year_2007 - year_1952,
         country = fct_reorder(country,
                               year_2007 * if_else(change < 0, -1, 1)))

selected_countries |> 
  ggplot(aes(x=life_exp,y=country,col=year))+
  geom_segment(data=segment_helper,
               aes(x=year_1952, xend=year_2007,
                   y=country, yend=country),
               col='grey60',
               linewidth=1.25)+
  geom_point(size=4)+
  
  scale_color_manual(values = color_palette)+
  labs(x='Life Expectancy',y=element_blank(),
       title = title_text)+
  theme_minimal(
    base_size = 16, base_family = 'Merriweather'
  )+
  theme(legend.position = 'none',
        plot.title = ggtext::element_markdown(),
        plot.title.position = 'plot')


df %>% 
  ggplot(aes(x= lifeExp, y= reorder(country,lifeExp), fill=year)) +
  geom_col(position="dodge")+
  labs(y="Country")

library(gapminder)

df <- gapminder %>%
  filter(year %in% c(1952,2007)) %>%
  filter(continent=="Asia")

df <- df %>%
  mutate(paired = rep(1:(n()/2),each=2),
         year=factor(year))



df %>% 
  ggplot(aes(x= lifeExp, y= reorder(country,lifeExp))) +
  geom_line(aes(group = paired),color="grey")+
  geom_point(aes(color=year), size=6) +
  labs(y="country")+
  theme_classic(24)+
  theme(legend.position="top") +
  scale_color_brewer(palette="Accent", direction=-1)

df %>% 
  ggplot(aes(x= lifeExp, y= reorder(country,lifeExp))) +
  geom_line(aes(group = paired))+
  geom_point(aes(color=year), size=4) +
  labs(y="country")






df %>% 
  ggplot(aes(x= lifeExp, y= country)) +
  geom_line(aes(group = paired))+
  geom_point(aes(color=year), size=4) +
  theme(legend.position="top")




census <- tribble(
 ~City_div,~census_17,~census_23,
 "Karachi",	16024000,	19124000,
 "Hyderabad",	10596000,	12896000,
 "Larkana",	6190926,	8190926,
 "Mir Pur Khas"	,4224945,	5172132,
 "Shaheed Benazir Abad",	5275400,	6299600,
 "Sukhur",	5542270,	6736027
 
)
library(ggplot2)
library(ggalt)
census %>% arrange(census_17) %>%  mutate(div_label = factor(City_div, unique(City_div))) %>%
  mutate(census_17=census_17/1000000,census_23=census_23/1000000) |> 
  ggplot(aes(x=census_17, xend=census_23, y=City_div, group=City_div)) + 
  #create a thick line between x and xend instead of using defaut 
  #provided by geom_dubbell
  geom_segment(aes(x=census_17, 
                   xend=census_23, 
                   y=City_div, 
                   yend=City_div), 
               color="#b2b2b2", size=1.5)+
  geom_dumbbell(color="light blue", 
                size_x=3.5, 
                size_xend = 3.5,
                #Note: there is no US:'color' for UK:'colour' 
                # in geom_dumbbel unlike standard geoms in ggplot()
                colour_x="forestgreen", # green = 2010
                colour_xend = "red")+ # red = 2018
  labs(x=NULL, y=NULL, 
       title="Population 2023 for Sind (Millions)", 
       subtitle="Population of Sind 2017 vs 2022")+
  geom_text(color="black", size=3, hjust=-0.5,
            aes(x=census_23, label=census_23))+
  geom_text(aes(x=census_17, label=census_17), 
            color="black", size=3, hjust=1.5)+scale_x_continuous(labels = comma)



df <- census |> pivot_longer( cols=c(2:3), names_to = "Div",values_to = "population")



df <- df %>%
  mutate(paired = rep(1:(n()/2),each=2),
         Div=factor(Div))



df %>% 
  ggplot(aes(x= population, y= reorder(City_div,population))) +
  geom_line(aes(group = paired),color="grey")+
  geom_point(aes(color=Div), size=6) +
  labs(y="Division")+
  theme_classic(24)+
  theme(legend.position="top") +
  scale_color_brewer(palette="Accent", direction=-1)
library(scales)

df %>% 
  ggplot(aes(x= population, y= reorder(City_div,population))) +
  geom_line(aes(group = paired))+
  geom_point(aes(color=Div), size=4) +
  labs(y="Division")+
  theme(legend.position="top")+scale_x_continuous(labels = comma)






df %>% 
  ggplot(aes(x= lifeExp, y= country)) +
  geom_line(aes(group = paired))+
  geom_point(aes(color=Div), size=4) +
  theme(legend.position="top")




library(ggplot2)
library(ggalt)
 census %>% arrange(census_17) %>%  mutate(div_label = factor(City_div, unique(City_div))) %>%
   mutate(census_17=census_17/1000000,census_23=census_23/1000000) |> 
  ggplot(aes(x=census_17, xend=census_23, y=City_div, group=City_div)) + 
  #create a thick line between x and xend instead of using defaut 
  #provided by geom_dubbell
  geom_segment(aes(x=census_17, 
                   xend=census_23, 
                   y=City_div, 
                   yend=City_div), 
               color="#b2b2b2", size=1.5)+
  geom_dumbbell(color="light blue", 
                size_x=3.5, 
                size_xend = 3.5,
                #Note: there is no US:'color' for UK:'colour' 
                # in geom_dumbbel unlike standard geoms in ggplot()
                colour_x="forestgreen", # green = 2010
                colour_xend = "red")+ # red = 2018
  labs(x=NULL, y=NULL, 
       title="Population (Millions)", 
       subtitle="Population of Sind 2017 vs 2022")+
  geom_text(color="black", size=3, hjust=-0.5,
            aes(x=census_23, label=census_23))+
  geom_text(aes(x=census_17, label=census_17), 
            color="black", size=3, hjust=1.5)+scale_x_continuous(labels = comma)

 p1 <- census %>% arrange(census_17) %>%  mutate(div_label = factor(City_div, unique(City_div))) %>%
   mutate(census_17=census_17/1000000,census_23=census_23/1000000) |> 
   ggplot(aes(x=census_17, xend=census_23, y=City_div, group=City_div)) + 
   #create a thick line between x and xend instead of using defaut 
   #provided by geom_dubbell
   geom_segment(aes(x=census_17, 
                    xend=census_23, 
                    y=City_div, 
                    yend=City_div), 
                color="#b2b2b2", size=1.5)+
   geom_dumbbell(color="light blue", 
                 size_x=3.5, 
                 size_xend = 3.5,
                 #Note: there is no US:'color' for UK:'colour' 
                 # in geom_dumbbel unlike standard geoms in ggplot()
                 colour_x="forestgreen", # green = 2010
                 colour_xend = "red")+ # red = 2018
   labs(x=NULL, y=NULL, 
        title="Population (Millions)", 
        subtitle="Population of Sind 2017 vs 2022")+
   geom_text(color="black", size=3, hjust=-0.20,
             aes(x=census_23, label=census_23))+
   geom_text(aes(x=census_17, label=census_17), 
             color="black", size=3, hjust=1.5)+scale_x_continuous(labels = comma)
 
 
 
 
 
 
 
 p1
 
 
 
 
 
 
 
 
 
 df |>  
   ggplot(aes(x = City_div, y = population, fill = Div)) + 
   geom_bar(stat = "identity", position = "dodge", width = 0.5)+scale_y_continuous(labels = comma)
 
 census
 
 census |> mutate(growth=(((census_23/census_17)^(1/6)-1)*100)) |> mutate(growth=round(growth,2)) |> 
   ggplot(aes(x=City_div,y=growth, fill=City_div))+
   geom_bar(stat="identity")+geom_text(aes(label=growth),vjust=-0.5)+
   labs(
     x = element_blank(),
     y = element_blank(), 
     title = 'Population growth rate for Sind divisions between 2017 and 2023',
     subtitle = "Karachi population growth rate is lower than other parts of the Sind despite there is migration \n to Karachi from inland Sind and Pakistan.If population of Karachi is counted at place of domiciles,\n then will it not be the case that Karachi has to feed and share more burden than resources it get"
   )+ theme(legend.position = "none")+labs(caption="Source: PBS, by Zahid Asghar")

 p2 <-  census |> mutate(growth=(((census_23/census_17)^(1/6)-1)*100)) |> mutate(growth=round(growth,2)) |> 
   ggplot(aes(x=City_div,y=growth, fill=City_div))+
   geom_bar(stat="identity")+geom_text(aes(label=growth),vjust=-0.5)+
   labs(
     x = element_blank(),
     y = element_blank(), 
     title = 'Population growth rate for Sind divisions between 2017 and 2023',
     subtitle = "Karachi population growth rate is lower than other parts of the Sind despite there is migration \n to Karachi from inland Sind and Pakistan.If population of Karachi is counted at place of domiciles,\n then will it not be the case that Karachi has to feed and share more burden than resources it get"
   )+ theme(legend.position = "none")+labs(caption="Source: PBS, by Zahid Asghar")

 library(patchwork) 
p1+p2 
