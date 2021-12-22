library(shiny)
library(shinydashboard)
library(tidyverse)
library(devtools)
library(urbnmapr)
library(sf)

counties_sf <- get_urbn_map("counties", sf=TRUE)
counties_sf %>%
  ggplot(aes()) +
  geom_sf(fill="grey", color="#ffffff")

counties_sf %>%
  filter(state_name == "California") %>%
  ggplot() +
    geom_sf(mapping = aes(fill = "grey"),
              color = "#ffffff", size = 0.05)+
  coord_sf(datum = NA)

counties_sf %>%
  filter(state_name == "California") %>%
  ggplot()+
  geom_sf(mapping = aes(fill="grey"), color="#ffffff", size=0.2)

hospitals = read.csv("hospitals.csv")

NY = counties_sf %>%
  filter(state_abbv == "NY") %>%
  ggplot()+
  geom_sf(mapping = aes(fill="grey"), color="#ffffff", size=0.2)+
  geom_point(data = points)

ggplot(hospitals %>% filter(STATE == "NY"), aes(x=LONGITUDE, y=LATITUDE)) +
  geom_point()+
  scale_x_reverse()

hospitals <- st_as_sf(hospitals, coords = c("LATITUDE", "LONGITUDE"), crs = 3347)

ggplot() + 
  geom_sf(data = counties_sf %>% filter(state_abbv == "NY"))+
  geom_sf(data = points %>% filter(STATE == "NY"))+
  coord_sf(crs = st_crs(4326))



ggplot() + 
  geom_sf(data = counties_sf %>% filter(state_abbv == "NY")) + 
  coord_sf(crs = st_crs(4326))


points <- st_as_sf(hospitals %>% filter(STATE == "NY"), coords = c("LONGITUDE", "LATITUDE"), crs=4326)

ggplot() + 
  geom_sf(data = counties_sf %>% filter(state_abbv == "NY")) + 
  geom_sf(data = points, size = 0.005) +
  coord_sf(crs = st_crs(3347))

install.packages('ggvoronoi')
library(ggvoronoi)

install.packages('spData')
library(spData)

install.packages('tmap')
library(tmap)

us_states %>% view()

NY = us_states %>% filter(NAME == "New York") %>%
  st_as_sf(crs = 4326)

NYhospitals = hospitals %>% filter(STATE == "NY")

ggplot() +
  geom_sf(data = NY)+
  geom_sf(data = points, size = 0.01) + 
  coord_sf(crs = st_crs(3347))+
  stat_voronoi(x=x,y=y)
  
ggplot(data = points) +
  geom_voronoi(outline = NY)


ggplot(hospitals %>% filter(STATE == "NY"), aes(x=LONGITUDE,y=LATITUDE)) +
  stat_voronoi(geom="path", 
               outline = map_data("state") %>% filter(region=="new york"))+
  geom_point(size = 1, stroke = 3, alpha=.2, color="green", fill="blue", shape=21)


ggplot(hospitals %>% filter(STATE == "MA"), aes(x=LONGITUDE,y=LATITUDE)) +
  stat_voronoi(geom = "path", outline = map_data("state") %>% filter(region=="massachusetts")) +
  geom_point(size = 0.05)

circle <- data.frame(x = 100*(1+cos(seq(0, 2*pi, length.out = 2500))),
                     y = 100*(1+sin(seq(0, 2*pi, length.out = 2500))),
                     group = rep(1,2500))

test <- voronoi_polygon(NYhospitals,x="LONGITUDE",y="LATITUDE",
                        outline= map_data("state") %>% filter(region=="new york"))


install.packages('deldir')
library(deldir)

tesselation = NYhospitals %>% deldir(LONGITUDE,LATITUDE)
tiles = tile.list(tesselation)

list = map_data("state") %>% 
  filter(region=="new york") %>% 
  select(long,lat) %>%
  rename(x = long,
         y = lat) %>%
  as.list()

plot(tiles, pch=5, clipp = list)

ggplot(data=NYhospitals, aes(x=LONGITUDE,y=LATITUDE))+
  geom_segment(aes(x=x1,y=y1,xend=x2,yend=y2),
               size=.5,
               data=tesselation$dirsgs,
               linetype=1,
               color="#FFB958")+
  geom_point(size=.5, pch=21)


install.packages('ggforce')
library(ggforce)

testList = map_data("state") %>% filter(region=="new york") %>% select(long, lat) %>% as.matrix()
triangle <- cbind(c(3, 9, 6), c(1, 1, 6))

ggplot(data=NYhospitals, aes(x=LONGITUDE,y=LATITUDE, group=-1L))+
  geom_point()+
  geom_voronoi_tile(aes(fill=OBJECTID)) +
  geom_voronoi_segment()


triangle <- cbind(c(3, 9, 6), c(1, 1, 6))
ggplot(iris, aes(Sepal.Length, Sepal.Width, group = -1L)) +
  geom_voronoi_tile(aes(fill = Species), colour = 'black')
  
list = map_data("state") %>% 
  filter(region=="new york") %>% 
  select(long,lat) %>%
  mutate(group = 1)

vor_spdf <- voronoi_polygon(data=hospitals %>% filter(STATE == "NY"),x="LONGITUDE",y="LATITUDE")
vor_df <- fortify_voronoi(vor_spdf)

ggplot(vor_df) +
  geom_polygon(aes(x=LONGITUDE,y=LATITUDE))


set.seed(45056)
rx <- sample(1:200,100)
ry <- sample(1:200,100)
rpoints <- data.frame(rx, ry,
                     rdistance = sqrt((rx-100)^2 + (ry-100)^2))
rcircle <- data.frame(rx = 100*(1+cos(seq(0, 2*pi, length.out = 2500))),
                     ry = 100*(1+sin(seq(0, 2*pi, length.out = 2500))),
                     group = rep(1,2500))
ggplot(rpoints) +
  stat_voronoi(aes(x=rx,y=ry,fill=rdistance))
ggplot(rpoints) +
  stat_voronoi(aes(x=rx,y=ry),geom="path")
ggplot(rpoints) +
  stat_voronoi(aes(x=rx,y=ry,fill=rdistance),outline=rcircle)




#SWITCHES 
ggplot() + 
  geom_polygon(data=map_data("county"), 
               aes(x=long, y=lat, group=group), 
               color="black", 
               fill="#fcbfbb")+
  theme(
    panel.background = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )

ggplot(hospitals, aes(x=LONGITUDE,y=LATITUDE,)) +
  stat_voronoi(geom="path", 
               outline = map_data("usa"))+
  theme(
    panel.background = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )


#area of each voronoi polygon
library(maps)
library(maptools)
library(spatstat)
library(rgeos)
library(sf)
library(tigris)
library(geosphere)

lng <- c(-51.74768, -51.74768, -51.74735, -51.74735)
lat <- c(-0.1838690, -0.1840993, -0.1840984, -0.1838682)
d <- cbind(lng, lat)
geosphere::areaPolygon(d)

x <- sample(1:200,100)
y <- sample(1:200,100)
points <- data.frame(x, y,
                     distance = sqrt((x-100)^2 + (y-100)^2))
circle <- data.frame(x = 100*(1+cos(seq(0, 2*pi, length.out = 2500))),
                     y = 100*(1+sin(seq(0, 2*pi, length.out = 2500))),
                     group = rep(1,2500))
vor_spdf <- voronoi_polygon(data=points,x="x",y="y",outline=circle)
vor_df <- fortify_voronoi(vor_spdf)
ggplot(vor_df) +
  geom_polygon(aes(x=x,y=y,fill=distance,group=group))

points2 = hospitals %>% filter(STATE == "NY") %>% select(LONGITUDE, LATITUDE)

list = map_data("state") %>% 
  filter(region=="new york") %>% 
  select(long,lat)

vor_spdf2 <- voronoi_polygon(data=points2,x="LONGITUDE",y="LATITUDE",outline=list)
vor_df2 <- fortify_voronoi(vor_spdf2)
ggplot(vor_df2) +
  geom_polygon(aes(x=x,y=y))







