library(gapminder)
library(ggthemes )
library(tidyverse)
library(knitr)
gapminder_2007 <- gapminder %>% filter(year == 2007)
ggplot(data = gapminder_2007) +
  geom_point(mapping = aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  scale_x_log10()

library(plotly)
g <- crosstalk::SharedData$new(gapminder, ~continent)
gg <- ggplot(g, aes(gdpPercap, lifeExp, color = continent, frame = year)) +
  geom_point(aes(size = pop, ids = country)) +
  geom_smooth(se = FALSE, method = "lm") +
  scale_x_log10()+labs(title = "Relationship between GDP per capita and life_expectancy 1952-2007",
                       subtitle="Bubble size is population of the country and color represents continent",
                       caption="Source: Gapminder, Zahid Asghar")
ggplotly(gg) %>% 
  highlight("plotly_hover")
