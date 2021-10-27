# Variable    Computed:   stud_loc_div
# Variable  Definition:   Location of the student binned into region divisions of the US as listed below
# Research   Objective:   Explore User Profiles
# Research    Question:   What clusters exist within students


library(dplyr)
library(tibble)

# U.S. Census Bureau Regions and Divisions
div1 <- c('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 'Vermont')
div2 <- c('New Jersey', 'New York', 'Pennsylvania')
div3 <- c('Illinois', 'Indiana','Michigan', 'Ohio', 'Wisconsin')
div4 <- c('Iowa', 'Kansas', 'Minnesota', 'Missouri', 'Nebraska', 'North Dakota', 'South Dakota')
div5 <- c('Delaware', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 
          'Virginia', 'Washington, D.C.', 'West Virginia')
div6 <- c('Alabama', 'Kentucky', 'Mississippi', 'Tennessee')
div7 <- c('Arkansas', 'Louisiana', 'Oklahoma', 'Texas')
div8 <- c('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming')
div9 <- c('Alaska', 'California', 'Hawaii', 'Oregon', 'Washington')

# Create a tibble of division names
divisions = tibble(division = c("New England", "Mid-Atlantic", "East North Central", 
                                "West North Central", "South Atlantic", "East South Central",
                                "West South Central", "Mountain", "Pacific"))

# Drop NA records from students
print(sapply(students, function(x) sum(is.na(x)))) # counts of missing values by column
dim(students)[1] # 30971
students <- na.omit(students) # drops 2033 records (6.6%)
students <- students[students$students_location != 'United States',] # drops 71 records with generic "US" value
dim(students)[1] # 28867

# Encode the new variable
students <- students %>% 
  mutate(stud_loc_div = case_when(
    sub(pattern = ".*, ", replacement = "", x = students_location) %in% div1 ~ divisions$division[1]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div2 ~ divisions$division[2]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div3 ~ divisions$division[3]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div4 ~ divisions$division[4]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div5 ~ divisions$division[5]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div6 ~ divisions$division[6]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div7 ~ divisions$division[7]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div8 ~ divisions$division[8]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div9 ~ divisions$division[9]
    ,TRUE ~ 'International'
  )
  )
 
View(students)
