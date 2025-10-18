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
mhw_data<-rename(mhw_data,Date=date_peak)
#date formatting & re classing from character to numeric. Also Creating a New column with Just year for comparison with MHW data.
shark_filtered<-shark_data%>%
  filter(sex %in% c("M","F"))  %>%
  mutate(Date=as.Date(Date,format="%m/%d/%Y"),
         year=year(Date),
         Condition=factor(Condition,levels=c("D","P","F","G","E")),
         sex=factor(sex),
         Species=factor(Species),
         fork_length=as.numeric(fork_length),
         total_length=as.numeric(total_length),
         standard_length=as.numeric(standard_length)) %>%
  filter(!is.na(year),!is.na(Condition))

mhw_data<-mhw_data %>% mutate(Date=as.Date(Date,format="%m/%d/%Y"),
                              year=year(Date))
#create a function and use it, to remove any rows with more than 2 NA values
delete.na <- function(DF, n=0) {
  DF[rowSums(is.na(DF)) <= n,]
}
tidy_shark<-delete.na(shark_filtered, 2)

##join to create dataset with common years/dates. Clean up rows with many NA values.
common_data<-full_join(tidy_shark,mhw_data, by ="year")
common_data<-delete.na(common_data, 2)

