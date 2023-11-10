library(tidyverse)
library(readxl)
library(janitor)
basic_survey <- read_excel("D:/RepTemplates/PIDE/basic_survey.xlsx", 
                           sheet = "Sheet6")
pide <- basic_survey |> pivot_longer(cols=3:8,names_to = "category", values_to = "values")
# basic_survey
pide <- pide |> clean_names()
pide <- pide |>  mutate(
  category = case_when(
    category %in% c('unhappy', 'very unhappy') ~ 'Unhappy',
    category %in% c('very happy', 'somewhat happy') ~ 'Happy',
    TRUE ~ str_to_title(category)
  ),
  category = fct_infreq(category) |>  fct_rev()) 
library(ggthemes)
pide <- pide |> summarise(values=sum(values),.by=c(gender,age, category))
View(pide)
colors <- thematic::okabe_ito(4)
 pide |> #fct_rev(age, '15-24','25-34','35-44','45-59','>=60','All') |> 
  ggplot(aes(x=category, y=values, fill=gender)) +
  geom_bar(stat="identity") +coord_flip()+ facet_grid(gender~age)+
  geom_vline(xintercept = 0) +
  theme_minimal()+
   labs(x = element_blank(), y = element_blank()) +
   theme(
     panel.grid.minor = element_blank(),
     panel.grid.major.y = element_blank(),
     legend.position = 'none',
     axis.text.x=element_blank(), #remove x axis labels
     axis.ticks.x=element_blank(), #remove x axis ticks
     axis.text.y=element_blank(), #remove y axis labels
     axis.ticks.y=element_blank(), #remove y axis ticks
   ) +
  scale_fill_manual(values = colors[1:5]) +
   scale_y_discrete(labels = element_blank())+geom_text(aes(label=values),size=4, hjust=0.2) +
   labs(title = "Access to playground by age and sex ", caption = "PIDE Basic Notes") +theme_economist()

   ggsave("pide.png", width = 15, height = 9,units="cm",dpi=300)
 