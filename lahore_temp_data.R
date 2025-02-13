library(readxl)
library(tidyverse)
library(janitor)
temp_df <- read_excel('data/lahore_temp.xlsx')

temp_df |> dim()

temp_df |> colnames()

temp_df |> clean_names()->temp_df
temp_df |> pivot_longer(cols=c(!year), names_to="month",values_to="value")


library(tidyr)

temp_df <- pivot_longer(temp_df, cols = -year, names_to = "month", values_to = "value")

temp_df |> glimpse()
ggplot(data = temp_df, aes(month,value,color=year))+
  geom_line(aes(group = year),linewidth=0.2) + theme_minimal()



library(forcats)
temp_df |> distinct(month)

temp_df$month <- factor(temp_df$month, levels = c("jan","feb","mar","apr",'may','jun','jul',
                                                  'aug','sep','oct','nov','dec'))


 p <- ggplot(temp_df + aes(month,value,color=year))+
  geom_line(aes(group = year),linewidth=0.2) + theme_minimal()

 library(plotly)
ggplotly(p) 


p1 <- ggplot(data = temp_df, aes(month,value, color=month))+
  geom_boxplot(aes(group = month)) + theme_minimal()
ggplotly(p1)



library(openmeteo)
library(tidyverse)
library(xts)
library(tseries)
library(forecast)
lahore <- weather_history(
  location = "Islamabad"
  , start    = "1965-01-01"
  , end      = "2023-10-15"
  , daily    = c("temperature_2m_mean")
)

lahore <- as_tibble(lahore)

## Add year and month from date column
lahore$year <- year(lahore$date)
lahore$month <- month(lahore$date)

## Convert to monthly data
lahore <- lahore |> group_by(year, month) |> summarise(temperature_2m_mean = mean(daily_temperature_2m_mean))
lahore

## Convert 1 , 2, ...12 to month names
lahore$month <- month.abb[lahore$month]

lahore |> glimpse()

lahore$month <- factor(lahore$month, levels = c("Jan","Feb","Mar","Apr",'May','Jun','Jul',
                                                  'Aug','Sep','Oct','Nov','Dec'))


ggplot(lahore) + aes(month,temperature_2m_mean ,color=year)+
  geom_line(aes(group = year),linewidth=0.2) + theme_minimal()


## Change colors from blue to red shade
ggplot(lahore) + aes(month,temperature_2m_mean ,color=year)+
  geom_line(aes(group = year),linewidth=0.1) + theme_minimal() + scale_color_gradient(low = "steelblue", high = "red")


p11 <- ggplot(lahore) + aes(month,temperature_2m_mean ,color=year)+
  geom_line(aes(group = year),linewidth=0.1) + theme_minimal() + scale_color_gradient(low = "blue", high = "red")+
  labs(title = "Islamabad mean monthly temperature 1965 to date",
       caption = "By: zahedasghar, Source: https://openmeteodata.github.io")

library(plotly)
ggplotly(p11)

library(htmlwidgets)

#Export
saveWidget(ggplotly(p11), file = "Islamabad_mean_temp.html")

## Make it animated with respect to year using gganimate
library(gganimate)
p <- ggplot(lahore, aes(month, temperature_2m_mean, color = year)) +
  geom_line(aes(group = year),linewidth=0.1) + theme_minimal() + scale_color_gradient(low = "blue", high = "red") +
  transition_reveal(year) +
  labs(title = "Year: {frame_time}")
p


## Make it animated with respect to year using gganimate and save as gif

library(gganimate)
p <- ggplot(lahore, aes(month, temperature_2m_mean, color = year)) +
  geom_line(aes(group = year),linewidth=0.1) + theme_meanimal() + scale_color_gradient(low = "blue", high = "red") +
  transition_reveal(year) +
  labs(title = "Year: {frame_time}")


ggplot(lahore, aes(month, temperature_2m_mean, color = year)) +
  geom_line(aes(group = year), linewidth = 0.1) +
  theme_minimal() +
  scale_color_gradient(low = "blue", high = "red") +
  transition_reveal(year) +
  labs(title = "Year: {frame_time}")


library(ggplot2)
library(gganimate)

# Your existing code for creating the animated plot
animation <- ggplot(lahore, aes(month, temperature_2m_mean, color = year)) +
  geom_line(aes(group = year), linewidth = 0.1) +
  theme_minimal() +
  scale_color_gradient(low = "blue", high = "red") +
  transition_reveal(year) +
  labs(title = "Year: {frame_time}")

# Save the animation as a GIF
anim_save("lahore_animation.gif", animation)
