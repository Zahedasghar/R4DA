library(tidyverse)

mpg_2008 <- mpg |> 
  filter(
    year == 2008,
    !(class %in% c('2seater', 'minivan'))
  ) |>  
  mutate(
    class = case_when(
      class %in% c('compact', 'subcompact') ~ '(Sub-)Compact',
      class %in% c('pickup', 'suv') ~ 'Pickup/SUV',
      TRUE ~ str_to_title(class)
    ),
    manufacturer = str_to_title(manufacturer),
    manufacturer = fct_infreq(manufacturer) |>  fct_rev()
  )

mpg_2008

colors <- thematic::okabe_ito(4)
split_plot <- mpg_2008 |> 
  ggplot(aes(y = manufacturer, fill = class)) +
  geom_bar() +
  geom_vline(xintercept = 0) +
  theme_minimal(base_size = 20, base_family = 'Source Sans Pro') +
  scale_fill_manual(values = colors[1:3]) +
  facet_wrap(vars(class)) +
  labs(x = element_blank(), y = element_blank()) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = 'none'
  )
split_plot
total_plot <- mpg_2008 |> 
  ggplot(aes(y = manufacturer)) +
  geom_bar(fill = colors[4]) +
  geom_vline(xintercept = 0) +
  theme_minimal(base_size = 20, base_family = 'Source Sans Pro') +
  scale_fill_manual(values = colors[1:3]) +
  scale_y_discrete(labels = element_blank()) +
  facet_wrap(vars('Total')) +
  labs(x = element_blank(), y = element_blank()) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = 'none'
  )


library(patchwork)
split_plot + total_plot +
  plot_layout(widths = c(3.1, 1)) +
  plot_annotation(
    title = 'Cars in the data set by manufacturer and class',
    theme = theme(
      title = element_text(size = 20, family = 'Merriweather')
    )
  )

