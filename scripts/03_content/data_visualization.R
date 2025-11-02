##Load packages
library(tidyverse)
library(cowplot)
library(forcats)
library(EVR628tools)
theme_set(theme_minimal())
##Load Data

summary_smhw<-read.csv(file="data/processed/summary_mhw.csv")


##Visualization (Initial/basic)
ggplot(data = summary_smhw,
       mapping = aes(x = Species, fill = Species)) +
  geom_bar() +
  coord_flip() +
  labs(x = "Species",
       y = "N",
       title = "Species Group Weight")

#Sample #n faceted by species
ggplot(data = summary_smhw,
       mapping = aes(x = year, y = total_length,fill=Species)) +
  geom_col() +
  facet_grid(~ Species) +
  labs(x = "Year", y = "Number Samples")


ggplot(data = summary_smhw,
       mapping = aes(x = year, y = total_length, color = Species)) +
  geom_point() +
  facet_grid(~Species)+
  labs(x = "Year",
       y = "Total Length",
       color = "Species",)
#Comparison Visuals 1/cowplot

p1<-ggplot(data = summary_smhw,
       mapping = aes(x = year, y = total_length, color = Species)) +
  geom_linerange(mapping = aes(ymin = 0,
                               ymax = total_length))+
  theme_light()+
  scale_color_manual(values=c("red","magenta","blue"))+
  labs(x = "Year",
       y = " Max Total Length (in)",
       color = "Species",)


p2<-ggplot(data = summary_smhw,
             mapping = aes(x = year, y = intensity_cumulative,
                           color = intensity_max)) +
  theme_light()+
  geom_linerange(mapping = aes(ymin = 0,
                               ymax = intensity_max),
                 linewidth = 1) +
  geom_point(size = 2) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(x = "Date Peak",
       y = "MHW Intensity (°C)",
       color = "MHW Intensity (°C days)",
       caption= "Data from RSM Analysis of Biological Data and EVR 628 Data Package.") +
  theme(legend.position = "right",
        legend.title.position = "top",
        legend.key.width = unit(1, "cm"))

Comparison_1<-plot_grid(p1, p2, ncol = 1, rel_heights = c(1, 1))


##next visualization
ggplot(data = summary_smhw,
       mapping = aes(x = Condition, fill = Condition)) +
  geom_bar() +
  coord_flip() +
  labs(x = "Condition",
       y = "N",
       title = "Condition Count")
##Visualization 2 Length/Condition/Year
cumlengthyr<-ggplot(data = summary_smhw,
       mapping = aes(x = year, y= total_length, fill=Condition)) +
  geom_col() +
  facet_grid(~factor(Condition,levels=c("D","P","F","G","E"))) + scale_fill_discrete(breaks=c("D","P","F","G","E"))+
  labs(x = "Year", y = "Cumulative Sample Lengths (in)",
       title="Total Cumulative Lengths per Year by Condition", caption= "Data from RSM Analysis of Biological Data.")



##Export img
ggsave("results/img/comparison_1.png", plot = Comparison_1)
ggsave("results/img/cum_length_year.png",plot=cumlengthyr)

