#read in  csv file into data frames
setwd('/Users/Kristie/Documents/R/careervillage')
professionals <- read.csv('professionals.csv',na.strings=c('NA',''))

#look at the structure of the un-processed data
str(professionals)
summary(professionals)
table(professionals$professionals_location)
sum(is.na(professionals$professionals_location))

library(dplyr)
library(tidyverse)
library(ggmap)
library(ggplot2)

#make a dataframe to hold professionals_location
prof_loc <- data.frame(professionals$professionals_location,stringsAsFactors = FALSE)
prof_loc
is.data.frame(prof_loc)
summary(prof_loc)

#remove NA values
prof_loc <- na.omit(prof_loc)
sum(is.na(prof_loc))

#geocode
register_google(key = "AIzaSyCnEFT7ep33wiUzhLyL8oIslmfiiioiFIA")
prof_loc_geo <- mutate_geocode(data=prof_loc,
                               location=professionals.professionals_location)

#save geocodes to a csv
write.csv(prof_loc_geo,"prof_geo.csv", row.names = TRUE)

#check there are no NAs
sum(is.na(prof_loc_geo$professionals.professionals_location))

#map the geocodes
map<-get_googlemap(location='united states', zoom=4, maptype = "terrain",
             color='color')

us <- c(left = -125, bottom = 25.75, right = -67, top = 49)
map <- get_stamenmap(us, zoom = 5, maptype = "toner-lite") %>% ggmap() 
map <- map + geom_point(data=prof_loc_geo,aes(x=lon,y=lat))
map
