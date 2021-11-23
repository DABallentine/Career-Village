# ---------------------------------------------------------------------------------------------
# Mapping of Student & Professional locations
#
# Description: This code extracts location data from the students.csv and professionals.csv
#              files for the purposes of aggregation and mapping.
# ---------------------------------------------------------------------------------------------

# Set working directory
  getwd()
  setwd("C:/Users/tferg/OneDrive - University of North Carolina at Charlotte/Classwork/DSBA 6211/Group Project/data-science-for-good-careervillage")

# Install & Load Packages
  install.packages(c("dplyr", "ggplot2", "stringr", "tidygeocoder"))
  Packages <- c("dplyr", "ggplot2", "stringr", "tidygeocoder", "tidyverse")
  lapply(Packages, library, character.only = TRUE)

###----------------------------
# Aggregating Student Locations
###----------------------------
  
# Import Students data frame
  students <- read.csv("students.csv", na.strings = c("NA", ""), stringsAsFactors = FALSE)
  
# Remove Missing Values
  summary(is.na(students$students_location))
  students <- subset(students, is.na(students$students_location) == FALSE)

# Add columns for city, state, and country
  students['City'] <- NA
  students$City <- as.character(students$City)

  students['State'] <- NA
  students$State <- as.character(students$State)

  students['Country'] <- NA
  students$Country <- as.character(students$Country)

# Create For Loop to parse city, state, and country for United States
  n <- nrow(students)
  
  for (i in 1:n) {
    if (length(str_subset(students$students_location[i],state.name)) > 0) {
      
      students$City[i] = (unlist(strsplit(students$students_location[i],",")))[1]
      students$State[i] = (unlist(strsplit(students$students_location[i],",")))[2]
      students$Country[i] = "United States"
      
    }else if (students$students_location[i] == "United States"){
      students$Country[i] = "United States"
    }
  }
  
# Create loop to extract city and country for rest of the world
  
  for (i in 1:n) {
    if (is.na(students$Country[i]) ==TRUE) {
      
      if (str_count(students$students_location[i], ',') == 2){
        students$City[i] = (unlist(strsplit(students$students_location[i],",")))[1]
        students$State[i] = (unlist(strsplit(students$students_location[i],",")))[2]
        students$Country[i] = (unlist(strsplit(students$students_location[i],",")))[3]
        }
      
      if (str_count(students$students_location[i], ',') == 1){
        students$City[i] = (unlist(strsplit(students$students_location[i],",")))[1]
        students$Country[i] = (unlist(strsplit(students$students_location[i],",")))[2]
        }
      
      if (str_count(students$students_location[i], ',') == 0){
        students$Country[i] = students$students_location[i]
        }
      }
  }

# Create aggregate table to get counts in each location
  studentsAggregate <- students %>% filter(is.na(Country)==FALSE) %>% count(City, State, Country, sort = TRUE)
  studentsAggregate$City <- as.factor(studentsAggregate$City)
  studentsAggregate$State <- as.factor(studentsAggregate$State)
  studentsAggregate$Country <- as.factor(studentsAggregate$Country)

# Match Latitude and Longitude for all locations
  
  # Match locations with city, state, and country information
  studentsAggregate_mapping <- studentsAggregate %>% geocode(city = City, state = State, country = Country)
  missing <- studentsAggregate_mapping %>% filter(is.na(lat)==TRUE) %>% select(-c(lat, long)) # Capture Missing values
  
  # Geocode again with city and country information
  missing <- missing %>% geocode(city = City, country = Country)
  missingStill <- missing %>% filter(is.na(lat)==TRUE) %>% select(-c(lat, long)) # Capture Missing values
  missing <- missing %>% filter(is.na(lat)==FALSE)
  
  # Geocode again with country and manually input a few locations
  missingStill <- missingStill %>% geocode(country = Country)
  missingStill$lat[1] <- 51.2538
  missingStill$long[1] <- 85.3232
  missingStill$lat[4] <- 40.6331
  missingStill$long[4] <-89.3985
  missingStill$lat[5] <- 22.3193
  missingStill$long[5] <-114.1694
  missingStill$lat[6] <- 35.7596
  missingStill$long[6] <-79.0193
  missingStill$lat[13] <- 37.9643
  missingStill$long[13] <-91.8318
  missingStill$lat[15] <- 18.2208
  missingStill$long[15] <-66.5901
  missingStill$lat[16] <- 42.4072
  missingStill$long[16] <-71.3824
  missingStill <- missingStill %>% filter(is.na(lat)==FALSE)
  
  # Combine all non-missing geocoded locations
  missing <- rbind(missing, missingStill)
  studentsAggregate_mapping <- studentsAggregate_mapping %>% filter(is.na(lat)==FALSE)  
  studentsAggregate_mapping <- rbind(studentsAggregate_mapping,missing)
  
  # Write Aggregate file into CSV
  write.csv(studentsAggregate_mapping, 'students_AggregateLocations.csv')
  
  
###---------------------------------
# Aggregating Professional Locations
###---------------------------------
  
  # Import Students data frame
  professionals <- read.csv("professionals.csv", na.strings = c("NA", ""), stringsAsFactors = FALSE)
  
  # Remove Missing Values
  summary(is.na(professionals$professionals_location))
  professionals <- subset(professionals, is.na(professionals$professionals_location) == FALSE)
  
  # Add columns for city, state, and country
  professionals['City'] <- NA
  professionals$City <- as.character(professionals$City)
  
  professionals['State'] <- NA
  professionals$State <- as.character(professionals$State)
  
  professionals['Country'] <- NA
  professionals$Country <- as.character(professionals$Country)
  
  # Create For Loop to parse city, state, and country for United States
  n <- nrow(professionals)
  
  for (i in 1:n) {
    if (length(str_subset(professionals$professionals_location[i],state.name)) > 0) {
      
      professionals$City[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[1]
      professionals$State[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[2]
      professionals$Country[i] = "United States"
      
    }else if (professionals$professionals_location[i] == "United States"){
      professionals$Country[i] = "United States"
    }
  }
  
  # Create loop to extract city and country for rest of the world
  
  for (i in 1:n) {
    if (is.na(professionals$Country[i]) ==TRUE) {
      
      if (str_count(professionals$professionals_location[i], ',') == 2){
        professionals$City[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[1]
        professionals$State[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[2]
        professionals$Country[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[3]
      }
      
      if (str_count(professionals$professionals_location[i], ',') == 1){
        professionals$City[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[1]
        professionals$Country[i] = (unlist(strsplit(professionals$professionals_location[i],",")))[2]
      }
      
      if (str_count(professionals$professionals_location[i], ',') == 0){
        professionals$Country[i] = professionals$professionals_location[i]
      }
    }
  }
  
  # Create aggregate table to get counts in each location
  professionalsAggregate <- professionals %>% filter(is.na(Country)==FALSE) %>% count(City, State, Country, sort = TRUE)
  
  # Match Latitude and Longitude for all locations
  
  # Match locations with city, state, and country information
  professionalsAggregate_mapping <- professionalsAggregate %>% geocode(city = City, state = State, country = Country)
  missing <- professionalsAggregate_mapping %>% filter(is.na(lat)==TRUE) %>% select(-c(lat, long)) # Capture Missing values
  
  # Geocode again with city and country information
  missing <- missing %>% geocode(city = City, country = Country)
  missingStill <- missing %>% filter(is.na(lat)==TRUE) %>% select(-c(lat, long)) # Capture Missing values
  missing <- missing %>% filter(is.na(lat)==FALSE)
  
  # Geocode again with country and manually input a few locations
  missingStill <- missingStill %>% geocode(country = Country)
  missingStill$lat[1] <- 40.712728
  missingStill$long[1] <- -74.0060152
  missingStill$lat[2] <- 37.773972
  missingStill$long[2] <--122.431297
  missingStill$lat[3] <- 33.7490
  missingStill$long[3] <--84.386330
  missingStill$lat[4] <- 32.7767
  missingStill$long[4] <--96.808891
  missingStill$lat[5] <- 34.0522
  missingStill$long[5] <--118.243683
  missingStill$lat[6] <- 41.8781
  missingStill$long[6] <--87.623177
  missingStill$lat[7] <- 42.3601
  missingStill$long[7] <--71.057083
  missingStill$lat[8] <- 38.9072
  missingStill$long[8] <--77.050636
  missingStill$lat[9] <- 47.6062
  missingStill$long[9] <--122.335167
  missingStill$lat[10] <- 39.9526
  missingStill$long[10] <--75.165222
  missingStill$lat[11] <- 27.9506
  missingStill$long[11] <--82.452606
  missingStill$lat[12] <- 42.3314
  missingStill$long[12] <--83.045753
  missingStill$lat[13] <- 40.440624
  missingStill$long[13] <--79.995888
  missingStill$lat[15] <- 50.000000
  missingStill$long[15] <--85.000000
  missingStill$lat[16] <- 33.787914
  missingStill$long[16] <--117.853104
  missingStill$lat[20] <- 39.742043
  missingStill$long[20] <--104.991531
  missingStill$lat[22] <- 32.715736
  missingStill$long[22] <--117.161087
  missingStill$lat[23] <- 25.761681
  missingStill$long[23] <--80.191788
  missingStill$lat[24] <- 43.651070
  missingStill$long[24] <--79.347015
  missingStill$lat[27] <- 44.986656
  missingStill$long[27] <--93.258133
  missingStill$lat[30] <- 41.505493
  missingStill$long[30] <--81.681290
  missingStill$lat[33] <- 35.782169
  missingStill$long[33] <--80.793457
  missingStill$lat[37] <- 36.174465
  missingStill$long[37] <--86.767960
  missingStill$lat[39] <- 35.787743
  missingStill$long[39] <--78.644257
  missingStill$lat[44] <- 38.573936
  missingStill$long[44] <--92.603760
  missingStill$lat[48] <- 22.302711
  missingStill$long[48] <-114.177216
  missingStill$lat[50] <- 40.000000
  missingStill$long[50] <--89.000000
  
  missingStill <- missingStill %>% filter(is.na(lat)==FALSE)
  
  # Combine all non-missing geocoded locations
  missing <- rbind(missing, missingStill)
  professionalsAggregate_mapping <- professionalsAggregate_mapping %>% filter(is.na(lat)==FALSE)  
  professionalsAggregate_mapping <- rbind(professionalsAggregate_mapping,missing)
  
  # Write Aggregate file into CSV
  write.csv(professionalsAggregate_mapping, 'professionals_AggregateLocations.csv')
  
###---------------------------------
# Mapping Locations
###---------------------------------  
  
# Map Student Locations
  
  world <- map_data("world")
  
  ggplot() +
    geom_map(
      data = world, map = world,
      aes(long, lat, map_id = region),
      color = "white", fill = "lightgray", size = 0.1
    ) +
    geom_point(
      data = studentsAggregate_mapping,
      aes(long, lat, color = Country),
      alpha = 0.5
    ) +
    theme_void() +
    theme(legend.position = "none")+
    labs(title="Student Locations")
  
# Map Professional Locations

  ggplot() +
    geom_map(
      data = world, map = world,
      aes(long, lat, map_id = region),
      color = "white", fill = "lightgray", size = 0.1
    ) +
    geom_point(
      data = professionalsAggregate_mapping,
      aes(long, lat, color = Country),
      alpha = 0.5
    ) +
    theme_void() +
    theme(legend.position = "none")+
    labs(title="Professional Locations")
