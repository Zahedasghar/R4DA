#  Load Libraries
library(tidyverse) ## tidyverse has 9 packages built in it


#' bar graph: single categorical variable
#' Histogram : for continuous variable
#' bar graph in ggplot2 
 

mtcars |> glimpse()

## cyl as factor variable, so make a bargraph

mpg |> glimpse() #cyl as integer so convert it into factor



#'1 Bar graph 

ggplot(mtcars) 

ggplot(mtcars) + aes(x = cyl) 


ggplot(mtcars) + aes(x = cyl) +
  geom_bar()   
  




# 2: uniform color. Color is for the border, fill is for the inside 



ggplot(mtcars) +
  aes(x=cyl) +
  geom_bar(fill="blue")  # Color is the border

ggplot(mtcars, aes(x = cyl)) +
  geom_bar(color = "blue", fill = rgb(0.1, 0.4, 0.5, 0.7)) ## Alternatively use as.factor whenever you specify cyl


ggplot(mtcars)+
  aes(x=cyl)+
  geom_bar(fill="blue")

ggplot(mtcars)+
  aes(x=cyl)+
  geom_bar(fill=rgb(0.1,0.3,0.5,0.9))



# 3: Using Hue
ggplot(mtcars, aes(x=cyl, fill=cyl )) + 
  geom_bar( )+
  scale_fill_hue(c = 40) +
  theme(legend.position="none")

# 4: Using RColorBrewer
ggplot(mtcars, aes(x=cyl, fill=cyl)) + 
  geom_bar( ) +
  scale_fill_brewer(palette = "Set3") +
  theme(legend.position="none")


# 5: Using greyscale:
ggplot(mtcars, aes(x=cyl, fill=cyl )) + 
  geom_bar( ) +
  scale_fill_grey(start = 0.25, end = 0.75) +
  theme(legend.position="none")


# 6: Set manually 

ggplot(mtcars, aes(x=cyl, fill=cyl )) +  
  geom_bar( ) +
  scale_fill_manual(values = c("lightgreen", "lightgreen", "red") ) +
  theme(legend.position="none") 



# Create data
data <- data.frame(
  name=c("A","B","C","D","E") ,  
  value=c(3,12,5,18,45)
)

# Barplot
ggplot(data, aes(x=name, y=value)) + 
  geom_bar(stat = "identity") +
  coord_flip()
#' Control bar width with width
#' The width argument of the geom_bar() function allows to control the bar width. 
#' It ranges between 0 and 1, 1 being full width.
#' See how this can be used to make bar charts with variable width.



# Load ggplot2
library(ggplot2)

# Create data
data <- data.frame(
  name=c("Karachi",
         "Hyderabad",
         "Larkana",
        " Mir Pur Khas",
         "Shaheed Benazir Abad",
         "Sukhur"
  ) ,  
  value=c(19124000,
          12896000,
          8190926,
          5172132,
          6299600,
          6736027
  )
)
data  <- data |> mutate(population=value/1000000) 
data
library(forcats)
# Barplot
ggplot(data, aes(x=name, y=population))+ 
  geom_bar(stat = "identity", width=0.9) +
  theme_minimal()+
  geom_text(aes(label=population), vjust=-.5)

ggplot(data, aes(x=name, y=population)) + 
  geom_bar(stat = "identity", width=0.9, fill="blue") +
  theme_minimal()+
  geom_text(aes(label=population), vjust=-.5)




ggplot(data, aes(x=name, y=population)) + 
  geom_bar(stat = "identity", width=0.9, fill="blue") +
  theme_minimal()+
  geom_text(aes(label=population), vjust=-.5)+
  labs(x = element_blank(),
       y = element_blank())

ggplot(data, aes(x = reorder(name, population), y = population)) + geom_bar(stat =
                                                                              "identity",
                                                                            fill = "blue",
                                                                            width = 0.8) +
  theme_minimal() +
  geom_text(
    aes(label = population),
    hjust = 1,
    col = "white",
    size = 5
  ) +
  labs(x = element_blank(),
       y = element_blank()) + coord_flip()

  
library(ggthemes)
  
  
  
ggplot(data, aes(x = reorder(name, population), y = population)) + geom_bar(stat =
                                                                              "identity",
                                                                            fill = "blue",
                                                                            width = 0.8) +
  theme_minimal() +
  geom_text(
    aes(label = population),
    hjust = 1,
    col = "white",
    size = 5
  ) +
  labs(x = element_blank(),
       y = element_blank()) + coord_flip() +
  labs(title = "Sind population (in millions) division wise:  2023 census",
       caption = "Source: Wikipedia") +
  theme_clean()

  
  
  
  
  
  
#'What’s next?
#'  This post was an overview of ggplot2 barplots, showing the basic options of geom_barplot().
#'   Visit the barplot section for more:
#'     how to reorder your barplot 
#'     how to use variable bar width what about error bars
#'     circular barplots RELATED CHART TYPES
#'     Barplot 
#'     Spider / Radar 
#'     Wordcloud 
#'     Parallel 
#'     Lollipop
#'     Circular Barplot



#' CONTACT
#' This document is a work by Yan Holtz. Any feedback is highly encouraged. 
#' You can fill an issue on Github, drop me a message on Twitter, or send an email pasting yan.holtz.data with gmail.com.

