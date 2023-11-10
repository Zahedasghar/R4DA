library(tidyverse)
library(ggforce)
library(ggtext)

# Assumed data
df1 <- 
  data.frame(
    start = c(2014, 2017, 2018, 2021)
    , qual = c("BSc", "MRes", "Phd", "DS" )
    , loc = paste("Uni", LETTERS[1:4])
  ) %>%  
  mutate(
    qual = factor(qual, levels = qual, ordered = TRUE)
    , lab  = paste0("**", qual, "**<br>", loc)
    , dur = paste0(start, "\n-\n", lead(start))
    , dur = stringr::str_replace(dur, "NA", "now")
  )


Plot1 <-
  ggplot(data = df1) +
  geom_segment(aes(x = -Inf, xend = Inf, y = 0, yend = 0)) +
  geom_segment(aes(x = qual, xend = qual, y = 0, yend = rep(c(0.75, -0.75), 2))) +
  geom_point(aes(x = qual, y = 0), size = 3)+
  geom_circle(aes(x0 = 1:4, y0 = rep(c(1, -1), 2), r = 0.35),
              fill = "aquamarine4",
              colour = NA)+
  geom_richtext(aes(x = qual, y = rep(c(-0.5, 0.5), 2), label = lab),
                size = 6,
                family = "serif",
                colour = "aquamarine4",
                label.colour = NA)+
  geom_text(aes(x = qual, y = rep(c(1, -1), 2), label = dur),
            colour = "white",
            size = 6,
            family = "serif") +
  ylim(-1.5, 1.5) +
  theme_void() +
  coord_fixed()

Plot1

