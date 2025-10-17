#Packages
library(tidyverse)
library(EVR628tools)
#Data         
shark_data<-read.csv(file="~/EVR 628/Portfolio/data/raw/shark2014.csv")
mhw_data<-data_mhw_events

#Cleaning
## Rename columns
shark_data<-rename(shark_data,
       standard_length=Standard.Length,
       fork_length=Fork.Length,
      total_length= Total.Length)

