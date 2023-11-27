temp_df <- read_excel('data/lahore_temp.xlsx')

temp_df |> dim()

temp_df |> colnames()

temp_df |> clean_names()->temp_df
temp_df |> pivot_longer(cols=c(!year), names_to="month",values_to="value")


library(tidyr)

temp_df <- pivot_longer(temp_df, cols = -year, names_to = "month", values_to = "value")


library(forcats)
temp_df |> distinct(month)

temp_df$month <- factor(temp_df$month, levels = c("jan","feb","mar","apr",'may','jun','jul',
                                                  'aug','sep','oct','nov','dec'))


 p <- ggplot(data = temp_df, aes(month,value,color=year))+
  geom_line(aes(group = year),linewidth=0.2) + theme_minimal()

 library(plotly)
ggplotly(p) 


p1 <- ggplot(data = temp_df, aes(month,value, color=month))+
  geom_boxplot(aes(group = month)) + theme_minimal()
ggplotly(p1)
