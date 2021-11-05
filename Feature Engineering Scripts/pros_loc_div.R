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
  'Virginia', 'Washington, D.C.', 'West Virginia')
div6 <- c('Alabama', 'Kentucky', 'Mississippi', 'Tennessee')
div7 <- c('Arkansas', 'Louisiana', 'Oklahoma', 'Texas')
div8 <- c('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming')
div9 <- c('Alaska', 'California', 'Hawaii', 'Oregon', 'Washington')

# Create a tibble of division names
divisions = tibble(division = c("New England", "Mid-Atlantic", "East North Central", 
                                  "West North Central", "South Atlantic", "East South Central",
                                  "West South Central", "Mountain", "Pacific"))

# Replace all NA values with "Not Specified"
professionals <- professionals %>% replace(is.na(.), "Not Specified")

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

# Convert date_joined to datetime
professionals$professionals_date_joined <- as.Date(professionals$professionals_date_joined,'%Y-%m-%d')

# Convert new columns to factors
professionals$professionals_loc_div <- factor(professionals$professionals_loc_div)
professionals$professionals_country <- factor(professionals$professionals_country)
print(str(professionals))

### Plots ###

# Now observe professionals' locations for other countries
library(ggplot2)
library(forcats)
top_countries <- slice_min(.data=professionals[professionals$professionals_loc_div=='International',], 
                           order_by = fct_infreq(professionals_country), 
                           n=2193) # Select the top 2193 professionals as ordered by countries with largest # of professionals
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