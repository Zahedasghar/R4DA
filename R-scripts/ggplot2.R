library(tidyverse)

library(ggthemes)


?mpg

ggplot(mpg) +
  aes(x=displ,y=hwy, color=class) + geom_point()



ggplot(mpg)+
  aes(x=displ,y=hwy)+geom_point()

ggplot(data=mpg)+
  aes(x=displ,y=hwy,
      color=class )+
  geom_point()


ggplot(data=mpg)+aes(x=displ,y=hwy)+
  geom_point(aes(color=class))


ggplot(mpg)+aes(x=displ,y=hwy)+
  geom_point(aes(color=class))+
  geom_smooth(method=lm)

ggplot(mpg)+aes(x=displ,y=hwy)+
  geom_point(aes(color=class))+
  geom_smooth()


ggplot(data=mpg)+
  aes(x=class,y=hwy)+
  geom_boxplot()

ggplot(data=mpg)+
  aes(x=class)+
  geom_bar()

ggplot(data=mpg)+
  aes(x=class,fill=drv)+
  geom_bar()

#View(mpg)

ggplot(data=mpg)+
  aes(x=class,fill=drv)+
  geom_bar(positin="dodge")

p <- ggplot(data=mpg)+
  aes(x=displ,
      y=hwy)+
  geom_point(aes(color=class))+
  geom_smooth()
p ## to show plot |> 

p+facet_wrap(~year)

p+facet_grid(cyl~year)


 
#OR

(p <- p+facet_wrap(~year)+
    labs(x="Engine Displacement (Liters)",
  y="Highway MPG",
  title="Care mileage and displacement",
  subtitle="More displacement lowers highway mpg",
  caption="Source: EPA",
  color="Vehicle Class")
)

p+ facet_wrap(~year)+
  labs(x="Engine Displacement",
       y="Highway MPG",
       title="Care mileage and displacement",
       subtitle="More displacement lowers highway mpg",
       caption="Source: EPA",
       color="Vehicle Class")

p+scale_x_continuous(breaks=seq(0,10,2),
                     limits=c(0,7.5),
                     expand=c(0,0))

p+scale_x_continuous(breaks=seq(0,10,2),
                     limits=c(0,7.5),
                     expand=c(0,0))+
  scale_color_viridis_d()


ggplot(data=mpg)+
  aes(x=displ,
      y=hwy)+
  geom_point(aes(color=class))+
  geom_smooth()+
  facet_wrap(~year)+
  labs(x="Engine Displacement (Liters)",
       y="Highway MPG",
       title="Care Mileage and Displacement",
       subtitle = "More Displacement Lowers Highway MPG",
       caption="Source: EPA",
       color="Vehicle Class")+
  scale_color_viridis_d()+
  theme_minimal()+
  theme(text = element_text(family = "Fira Sans"),
        legend.position = "bottom")

library(ggthemes)
ggplot(data=mpg)+
  aes(x=displ,
      y=hwy)+
  geom_point(aes(color=class))+
  facet_wrap(~year)+
  labs(x="Engine Displament (Liters)",
y="Highway mpg",
title="Care mileage and displament",
subtitle="More displament lowers highway mpg",
caption="Source:EPA",
color="Vehicle Class")+
  scale_color_viridis_d()+
  theme_fivethirtyeight()+
  theme( text=element_text(family = "Fira Sans"),
         legend.position = "bottom")



