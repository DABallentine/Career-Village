# Variable    Computed:   pros_loc_div
# Variable  Definition:   Location of the professional binned into region divisions of the US as listed below
# Research   Objective:   Explore User Profiles
# Research    Question:   What clusters exist within professionals


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

# Create a tibble of the 9 division names
divisions = tibble(division = c("New England", "Mid-Atlantic", "East North Central", 
                                  "West North Central", "South Atlantic", "East South Central",
                                  "West South Central", "Mountain", "Pacific"))

# Starting count: 2,583 unique locations
length(unique(professionals$professionals_location))

# Replace all NA values with "Not Specified"
professionals <- professionals %>% replace(is.na(.), "Not Specified")

# Remove generalizing terms, e.g. "Greater Chicago Area" becomes simply "Chicago"
professionals$professionals_location <- str_replace_all(professionals$professionals_location, "Greater ", "")
professionals$professionals_location <- str_replace_all(professionals$professionals_location, " Area", "")
professionals$professionals_location <- str_replace_all(professionals$professionals_location, " area", "")
professionals$professionals_location <- str_replace_all(professionals$professionals_location, " Region", "")

# Standardize several major cities listed without states, e.g. "Chicago" now becomes "Chicago, Illinois", as well as numerous error categories such as "none"
professionals$professionals_location <- case_when(professionals$professionals_location == "Atlanta" ~ "Atlanta, Georgia",
                                                  professionals$professionals_location == "Birmingham" ~ "Birmingham, Alabama",
                                                  professionals$professionals_location == "Boca Raton" ~ "Boca Raton, Florida",
                                                  professionals$professionals_location == "Boston" ~ "Boston, Massachusetts",
                                                  professionals$professionals_location == "Chicago" ~ "Chicago, Illinois",
                                                  professionals$professionals_location == "Chicago; New York" ~ "Chicago, Illinois",
                                                  professionals$professionals_location == "Dallas/Fort Worth" ~ "Dallas/Fort Worth, Texas",
                                                  professionals$professionals_location == "Denver" ~ "Denver, Colorado",
                                                  professionals$professionals_location == "Detroit" ~ "Detroit, Michigan",
                                                  professionals$professionals_location == "Dublin, County Dublin" ~ "Dublin, Ireland",
                                                  professionals$professionals_location == "empty" ~ "Not Specified",
                                                  professionals$professionals_location == "fill in" ~ "Not Specified",
                                                  professionals$professionals_location == "Hawaiian Islands" ~ "Hawaii, Hawaii",
                                                  professionals$professionals_location == "Howell" ~ "Howell, New Jersey",
                                                  professionals$professionals_location == "Kennewick" ~ "Kennewick, Washington",
                                                  professionals$professionals_location == "Lancaster" ~ "Lancaster, Pennsylvania",
                                                  professionals$professionals_location == "Lancaster PA" ~ "Lancaster, Pennsylvania",
                                                  professionals$professionals_location == "Lincoln Park" ~ "Lincoln Park, Illinois",
                                                  professionals$professionals_location == "Los Angeles" ~ "Los Angeles, California",
                                                  professionals$professionals_location == "Memphis" ~ "Memphis, Tennessee", 
                                                  professionals$professionals_location == "Miami/Fort Lauderdale" ~ "Miami, Florida",
                                                  professionals$professionals_location == "Milwaukee" ~ "Milwaukee, Wisconsin", 
                                                  professionals$professionals_location == "Minneapolis-St. Paul" ~ "Minneapolis-St. Paul, Minnesota",
                                                  professionals$professionals_location == "na" ~ "Not Specified",
                                                  professionals$professionals_location == "Nashville" ~ "Nashville, Tennessee",
                                                  professionals$professionals_location == "Nashville, TN" ~ "Nashville, Tennessee",
                                                  professionals$professionals_location == "New Orleans" ~ "New Orleans, Louisiana",
                                                  professionals$professionals_location == "New York City" ~ "New York, New York",
                                                  professionals$professionals_location == "Newark" ~ "Newark, New Jersey",
                                                  professionals$professionals_location == "no location provided" ~ "Not Specified",
                                                  professionals$professionals_location == "none" ~ "Not Specified",
                                                  professionals$professionals_location == "Other" ~ "Not Specified",
                                                  professionals$professionals_location == "Philadelphia" ~ "Philadelphia, Pennsylvania",
                                                  professionals$professionals_location == "Pittsburg" ~ "Pittsburg, Pennsylvania",
                                                  professionals$professionals_location == "Pittsburgh" ~ "Pittsburg, Pennsylvania",                                                  
                                                  professionals$professionals_location == "Salt Lake City" ~ "Salt Lake City, Utah",
                                                  professionals$professionals_location == "San Diego" ~ "San Diego, California",
                                                  professionals$professionals_location == "San Francisco Bay" ~ "San Francisco, California",
                                                  professionals$professionals_location == "Seattle" ~ "Seattle, Washington",
                                                  professionals$professionals_location == "St. Louis" ~ "St. Louis, Missouri",
                                                  professionals$professionals_location == "TEST" ~ "Not Specified",
                                                  professionals$professionals_location == "Washington" ~ "Washington, Washington",
                                                  professionals$professionals_location == "Washington DC Metro" ~ "Washington, D.C.",
                                                  professionals$professionals_location == "Washington D.C. Metro" ~ "Washington, D.C.",
                                                  TRUE ~ professionals$professionals_location
                                                  )

# Ending count: 2,395 unique locations, reduced by 188 duplicates or errors
length(unique(professionals$professionals_location))

# Encode the new variable
professionals <- professionals %>% 
  mutate(professionals_loc_div = case_when(
           sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div1 ~ divisions$division[1]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div2 ~ divisions$division[2]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div3 ~ divisions$division[3]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div4 ~ divisions$division[4]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div5 ~ divisions$division[5]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div6 ~ divisions$division[6]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div7 ~ divisions$division[7]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div8 ~ divisions$division[8]
           ,sub(pattern = ".*, ", replacement = "", x = professionals_location) %in% div9 ~ divisions$division[9]
           ,professionals_location == "Not Specified" ~ "Not Specified"
           ,str_sub(professionals_location, start=-13) == 'United States' ~ 'Not Specified'
           ,TRUE ~ 'International'
            )
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
professionals <- professionals %>%
  mutate(professionals_country = case_when(
    professionals_loc_div == 'International' ~ countryname(word(professionals_location, -1, sep=", "), warn=FALSE)
    ,professionals_loc_div == 'Not Specified' ~ 'Not Specified'
    ,TRUE ~ 'United States')
  )

# Encode the 42 records remaining with NA country (due to incomplete location information) as "Other"
replace_na(professionals$professionals_country, "Other")
           
# Convert date_joined to datetime
professionals$professionals_date_joined <- as.Date(professionals$professionals_date_joined,'%Y-%m-%d')

# Convert new columns to factors
professionals$professionals_loc_div <- factor(professionals$professionals_loc_div)
professionals$professionals_country <- factor(professionals$professionals_country)
print(str(professionals))

### Plots ###

# Observe professionals' locations for other countries
library(ggplot2)
library(forcats)
top_countries <- slice_min(.data=professionals[professionals$professionals_loc_div=='International',], 
                           order_by = fct_infreq(professionals_country), 
                           n=2076) # Order by countries with largest # of professionals and then select all 2076 records from the top 7 countries
levels=c('India', 'Canada', 'China', 'UK', 'Brazil', 'Ireland', 'Germany')
top_countries$professionals_country <- factor(top_countries$professionals_country, levels=levels) # order the countries descending

## Plot
plot1 <- top_countries %>% 
  ggplot(mapping=aes(professionals_country, label='Country')) + 
  geom_bar(aes(fill=professionals_country)) + 
  labs(title = "Professionals' Top 7 Countries of Origin Outside the U.S.",
       x = "Country",
       y = "Number of professionals") +
  theme(plot.title = element_text(hjust = 0.5))

print(plot1)
dev.off()

# Observe professionals' locations within the U.S. and compared to international

## Plot
plot2 <- professionals %>% 
  ggplot(mapping=aes(x=reorder(professionals_loc_div, professionals_loc_div, function(x)-length(x)))) + 
  geom_bar(fill = c("#3182bd", "#c74e4e", "#3182bd", "#3182bd", "#3182bd", "#595959", "#3182bd", "#3182bd", "#3182bd", "#3182bd", "#3182bd"), alpha = 0.7) + 
  labs(title = "Professionals' Distribution Within the U.S.",
       x = "Division",
       y = "Number of professionals") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1)) +
  scale_y_continuous(breaks = seq(0,5500,1000),
                     minor_breaks = seq(0,5500,500))

print(plot2)
