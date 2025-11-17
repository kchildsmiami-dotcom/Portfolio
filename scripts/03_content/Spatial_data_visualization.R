##Load packages
library(ggspatial)
library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(cowplot)


##Load data, filter to probable habitat locations ((It has to be like this with reading the data in 2x. I don't know why.God doesn't know why. Buddha Doesn't know why.Everything breaks if it's not. Attempt to fix at your own risk.))
nurse <- read.csv("data/raw/nurseshark.csv")
nurse <- read.csv("data/raw/nurseshark.csv")|>filter(nurse$Overall.Probability>0.6)
creef<- read.csv("data/raw/creefshark.csv")
creef<- read.csv("data/raw/creefshark.csv")|>filter(creef$Overall.Probability>0.6)


str(nurse)
names(nurse)

##csv to sf and check plotting
nurse_sf<-st_as_sf(nurse,coords=c("Center.Long","Center.Lat"),crs=4326)
plot(st_geometry(nurse_sf), pch=16,col="navy")
creef_sf<-st_as_sf(creef,coords=c("Center.Long","Center.Lat"),crs=4326)
plot(st_geometry(nurse_sf), pch=16, col="pink")
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)


p1<-ggplot(data = world) +
  geom_sf(fill="white")+
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.3, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering)+
  theme(panel.background =element_rect( "lightblue"))+
  geom_sf(data=creef_sf,aes(color=Overall.Probability))+labs(color="C. Reef Shark Probability")

p2<-ggplot(data = world) +
  geom_sf(fill="white")+
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.3, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering)+
  theme(panel.background =element_rect( "lightblue"))+
  geom_sf(data=nurse_sf,aes(color=Overall.Probability))+labs(color="Nurse Shark Probability",caption = "Habitat Probabilities of Caribbean Reef & Nurse Sharks, From GBIF Sightings. Sourced From AquaMaps.") +theme(plot.caption = element_text(size=5))

final_map<-plot_grid(p1, p2, ncol = 1, rel_heights = c(.9, 1))


ggsave("results/img/final_map.png", plot = final_map)


