library("tidyverse") # my friend and yours
library("gapminder") # for dataset

gapminder <- gapminder # explicitly save data as a dataframe

gapminder %>% 
  glimpse()

# type your code below in this chunk
gapminder |> select( year, lifeExp, country)

# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# # type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


gapminder %>%
  group_by(continent) %>%
  summarize(avg_gdppc = mean(gdpPercap))

# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk
majors <- read_csv('https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv')

majors %>% # or whatever you named your tibble with the data
  glimpse()

# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


# type your code below in this chunk


stem_categories <- c("Biology & Life Science",
                     "Computers & Mathematics",
                     "Engineering",
                     "Physical Sciences")

# type your code below in this chunk


# type your code below in this chunk

