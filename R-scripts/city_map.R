#install.packages("osmdata")
library(osmdata)
library(tidyverse)
library(sf)
library(ggmap)
available_features()
available_tags("amenity")

islamabad_bb <- getbb("islamabad")
islamabad_bb

islamabad_bb |> 
  opq()


islamabad_librarys <- islamabad_bb %>%
  opq() %>%
  add_osm_feature(key = "amenity", value = "library") %>%
  osmdata_sf()

islamabad_librarys$bbox

islamabad_librarys$meta

# osm_points
islamabad_librarys$osm_points


# osm_polyogns
islamabad_librarys$osm_polygons

ggplot() +
  geom_sf(data = islamabad_librarys$osm_polygons)

#install.packages("ggmap")
library(ggmap)
islamabad_map <- get_map(location = getbb("Islam
                         abad"), zoom = 6, source = "stamen")


islamabad_map
#rbinom(10,1,1/2)
#?register_google

ggmap(islamabad_map) +
  geom_sf(
    data = islamabad_librarys$osm_polygons,
    inherit.aes = FALSE,
    colour = "#08519c",
    fill = "#08306b",
    alpha = .5,
    size = 1
  ) +
  labs(x = "", y = "")



# install.packages(c("osmdata", "ggplot2", "ggmap"))
library(osmdata)
library(ggplot2)
library(ggmap)
#pacman::p_load(ggmap, osmdata)
#get_map(location = getbb("islamabad"), zoom = 6, source = "stamen")

# creating bounding box for islamabad
islamabad_bb <- getbb("islamabad")

islamabad_bb
# retrieving data of librarys in islamabad
islamabad_librarys <- islamabad_bb %>%
  opq() %>%
  add_osm_feature(key = "amenity", value = "library") %>%
  osmdata_sf()

# retrieving map of islamabad
islamabad_map <- get_map(islamabad_bb, maptype = "roadmap")
islamabad_map
ggmap::register_google("AIzaSyCA3ssTmIgdNd21jk4b7IjAQCEiNNilu-Q")

# visualising map of islamabad overlayed by librarys in islamabad
ggmap(islamabad_map) +
  geom_sf(
    data = islamabad_librarys$osm_polygons,
    inherit.aes = FALSE,
    colour = "#08519c",
    fill = "#08306b",
    alpha = .5,
    size = 1
  ) +
  labs(
    title = "librarys in islamabad(Pakistan)",
    x = "Latitude",
    y = "Longitude"
  )

#library(devtools)
#devtools::install_github("dkahle/ggmap")

library(sf)
q <- getbb("Lahore") %>%
  opq() %>%
  add_osm_feature("amenity", "fire_station")

str(q) #query structure

library <- osmdata_sf(q)

#our background map
lah_map <- get_map(getbb("Lahore"), maptype = "toner-background")

#final map
ggmap(lah_map)+
  geom_sf(data = fire_station$osm_points,
          inherit.aes = FALSE,
          colour = "#238443",
          fill = "#004529",
          alpha = .5,
          size = 4,
          shape = 21)+
  labs(x = "", y = "")


q <- getbb("Islamabad") %>%
  opq() %>%
  add_osm_feature("amenity", "fire_station")


library <- osmdata_sf(q)


#our background map
lah_map <- get_map(getbb("Islamabad"), maptype = "toner-background")
lah_map
#final map
ggmap(lah_map)+
  geom_sf(data = fire_station$osm_points,
          inherit.aes = FALSE,
          colour = "#238443",
          fill = "#004529",
          alpha = .5,
          size = 4,
          shape = 21)+
  labs(x = "", y = "")

























#bounding box for the Iberian Peninsula
m <- c(-10, 30, 5, 46)

#building the query
q <- m %>% 
  opq (timeout = 25*100) %>%
  add_osm_feature("name", "Mercadona") %>%
  add_osm_feature("shop", "supermarket")

#query
mercadona <- osmdata_sf(q)

#final map
ggplot(mercadona$osm_points)+
  geom_sf(colour = "#08519c",
          fill = "#08306b",
          alpha = .5,
          size = 1,
          shape = 21)+
  theme_void()