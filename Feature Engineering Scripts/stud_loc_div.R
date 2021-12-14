# This script transforms and engineers features for the students data frame: 

# - loc_div
# - country


library(dplyr)
library(tibble)
library(tidyr)
library(stringr)

# U.S. Census Bureau Regions and Divisions
div1 <- c('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 'Vermont')
div2 <- c('New Jersey', 'New York', 'Pennsylvania')
div3 <- c('Illinois', 'Indiana','Michigan', 'Ohio', 'Wisconsin')
div4 <- c('Iowa', 'Kansas', 'Minnesota', 'Missouri', 'Nebraska', 'North Dakota', 'South Dakota')
div5 <- c('Delaware', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 
          'Virginia', 'D.C.', 'West Virginia')
div6 <- c('Alabama', 'Kentucky', 'Mississippi', 'Tennessee')
div7 <- c('Arkansas', 'Louisiana', 'Oklahoma', 'Texas')
div8 <- c('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming')
div9 <- c('Alaska', 'California', 'Hawaii', 'Oregon', 'Washington')

# Create a tibble of division names
divisions = tibble(division = c("New England", "Mid-Atlantic", "East North Central", 
                                "West North Central", "South Atlantic", "East South Central",
                                "West South Central", "Mountain", "Pacific"))

# Starting count: 5,481 unique locations
length(unique(students$students_location))

# Replace all NA values with "Not Specified"
students <- students %>% replace(is.na(.), "Not Specified")

# Remove generalizing terms, e.g. "Greater Chicago Area" becomes simply "Chicago"
students$students_location <- str_replace_all(students$students_location, "Greater ", "")
students$students_location <- str_replace_all(students$students_location, " Area", "")
students$students_location <- str_replace_all(students$students_location, " area", "")
students$students_location <- str_replace_all(students$students_location, " Region", "")

# Standardize several major cities listed without states, e.g. "Chicago" now becomes "Chicago, Illinois", as well as numerous error categories such as "none"
students$students_location <- case_when(students$students_location == "Atlanta" ~ "Atlanta, Georgia",
                                                  students$students_location == "Birmingham" ~ "Birmingham, Alabama",
                                                  students$students_location == "Boca Raton" ~ "Boca Raton, Florida",
                                                  students$students_location == "Boston" ~ "Boston, Massachusetts",
                                                  students$students_location == "Chicago" ~ "Chicago, Illinois",
                                                  students$students_location == "Chicago; New York" ~ "Chicago, Illinois",
                                                  students$students_location == "Dallas/Fort Worth" ~ "Dallas/Fort Worth, Texas",
                                                  students$students_location == "Denver" ~ "Denver, Colorado",
                                                  students$students_location == "Detroit" ~ "Detroit, Michigan",
                                                  students$students_location == "Dublin, County Dublin" ~ "Dublin, Ireland",
                                                  students$students_location == "empty" ~ "Not Specified",
                                                  students$students_location == "fill in" ~ "Not Specified",
                                                  students$students_location == "Hawaiian Islands" ~ "Hawaii, Hawaii",
                                                  students$students_location == "Howell" ~ "Howell, New Jersey",
                                                  students$students_location == "Kennewick" ~ "Kennewick, Washington",
                                                  students$students_location == "Lancaster" ~ "Lancaster, Pennsylvania",
                                                  students$students_location == "Lancaster PA" ~ "Lancaster, Pennsylvania",
                                                  students$students_location == "Lincoln Park" ~ "Lincoln Park, Illinois",
                                                  students$students_location == "Los Angeles" ~ "Los Angeles, California",
                                                  students$students_location == "Memphis" ~ "Memphis, Tennessee", 
                                                  students$students_location == "Miami/Fort Lauderdale" ~ "Miami, Florida",
                                                  students$students_location == "Milwaukee" ~ "Milwaukee, Wisconsin", 
                                                  students$students_location == "Minneapolis-St. Paul" ~ "Minneapolis-St. Paul, Minnesota",
                                                  students$students_location == "na" ~ "Not Specified",
                                                  students$students_location == "Nashville" ~ "Nashville, Tennessee",
                                                  students$students_location == "Nashville, TN" ~ "Nashville, Tennessee",
                                                  students$students_location == "New Orleans" ~ "New Orleans, Louisiana",
                                                  students$students_location == "New York City" ~ "New York, New York",
                                                  students$students_location == "Newark" ~ "Newark, New Jersey",
                                                  students$students_location == "no location provided" ~ "Not Specified",
                                                  students$students_location == "No location provided" ~ "Not Specified",
                                                  students$students_location == "none" ~ "Not Specified",
                                                  students$students_location == "Other" ~ "Not Specified",
                                                  students$students_location == "Philadelphia" ~ "Philadelphia, Pennsylvania",
                                                  students$students_location == "Pittsburg" ~ "Pittsburg, Pennsylvania",
                                                  students$students_location == "Pittsburgh" ~ "Pittsburg, Pennsylvania",                                                  
                                                  students$students_location == "Salt Lake City" ~ "Salt Lake City, Utah",
                                                  students$students_location == "San Diego" ~ "San Diego, California",
                                                  students$students_location == "San Francisco Bay" ~ "San Francisco, California",
                                                  students$students_location == "Seattle" ~ "Seattle, Washington",
                                                  students$students_location == "St. Louis" ~ "St. Louis, Missouri",
                                                  students$students_location == "TEST" ~ "Not Specified",
                                                  students$students_location == "Washington" ~ "Washington, Washington",
                                                  students$students_location == "Washington DC Metro" ~ "Washington, D.C.",
                                                  students$students_location == "Washington D.C. Metro" ~ "Washington, D.C.",
                                                  TRUE ~ students$students_location
)

# Ending count: 5,472 unique locations, reduced by 9 duplicates or errors
length(unique(students$students_location))

# Encode the new variable for student location division
students <- students %>% 
  mutate(students_loc_div = case_when(
    sub(pattern = ".*, ", replacement = "", x = students_location) %in% div1 ~ divisions$division[1]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div2 ~ divisions$division[2]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div3 ~ divisions$division[3]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div4 ~ divisions$division[4]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div5 ~ divisions$division[5]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div6 ~ divisions$division[6]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div7 ~ divisions$division[7]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div8 ~ divisions$division[8]
    ,sub(pattern = ".*, ", replacement = "", x = students_location) %in% div9 ~ divisions$division[9]
    ,is.na(students_location) ~ "Not Specified"
    ,str_sub(students_location, start=-13) == 'United States' ~ 'Not Specified'
    ,students_location == 'Not Specified' ~ 'Not Specified'
    ,TRUE ~ 'International')
  )

# install.packages('countrycode') ## to account for misspellings and non-countries in location field, which will return 'NA'

# # Run this code block for an example of the countryname() function
# test = c("Deutschland", "China", "Mexica", "SOMEWHERE EXPENSIVE")
# for (i in 1:length(test)) {
#   print(countryname(test[i], warn = FALSE))
# }
# # output = Germany, China, Mexico, NA


# Encode a new variable for country
library(countrycode)
students <- students %>%
  mutate(students_country = case_when(
  students_loc_div == 'International' ~ countryname(word(students_location, -1, sep=", "), warn=FALSE)
  ,students_loc_div == 'Not Specified' ~ 'Not Specified'
  ,TRUE ~ 'United States')
  )

# Replace NA countries with "Not Specified"
students$students_country <- as.character(students$students_country)
students[is.na(students$students_country),"students_country"] <- "Other"
students$students_country <- as.factor(students$students_country)

# Convert date_joined to datetime
students$students_date_joined <- as.Date(students$students_date_joined,'%Y-%m-%d')

# Convert new columns to factors
students$students_loc_div <- factor(students$students_loc_div)
students$students_country <- factor(students$students_country)
print(str(students))

### Plots ###

# Now observe students' locations for other countries
library(ggplot2)
library(forcats)
top_countries <- slice_min(.data=students[students$students_loc_div=='International',], 
                           order_by = fct_infreq(students_country), 
                           n=3600) # Select the top 3600 students as ordered by countries with largest # of students
levels=c('India', 'Canada', 'UK', 'Egypt', 'Nigeria', 'South Africa', 'Pakistan')
top_countries$students_country <- factor(top_countries$students_country, levels=levels) # order the countries descending

## Plot
plot1 <- top_countries %>% 
  ggplot(mapping=aes(students_country, label='Country')) + 
  geom_bar(aes(fill=students_country)) + 
  labs(title = "Students' Top 7 Countries of Origin Outside the U.S.",
       x = "Country",
       y = "Number of Students") +
  theme(plot.title = element_text(hjust = 0.5))

print(plot1)
dev.off()

# Observe students' locations within the U.S. and compared to international

## Plot
plot2 <- students %>% 
  ggplot(mapping=aes(x=reorder(students_loc_div, students_loc_div, function(x)-length(x)))) + 
  geom_bar(fill = c("#3182bd", "#c74e4e", "#3182bd", "#3182bd", "#3182bd", "#3182bd", "#595959", "#3182bd", "#3182bd", "#3182bd", "#3182bd"), alpha = 0.7) + 
  labs(title = "Students' Distribution Within the U.S.",
       x = "Division",
       y = "Number of Students") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1)) +
  scale_y_continuous(breaks = seq(0,5500,1000),
                     minor_breaks = seq(0,5500,500))

print(plot2)