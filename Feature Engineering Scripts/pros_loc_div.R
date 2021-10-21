# Variable    Computed:   pros_loc_div
# Variable  Definition:   Location of the professional binned into region divisions of the US as listed below
# Research   Objective:   Explore User Profiles
# Research    Question:   What clusters exist within professionals

# Strictly speaking, the following are the only extant variables relating to user profiles:

  # Professionals_{location, industry, headline, date_joined}
  # Students_{location, date_joined}
  # School_memberships
  # Group_memberships

# Therefore, for clustering users to explore profiles, we will begin with these, and 
# compute the most closely-related characteristic variables before moving further
# into variables that are associated more with the users' behavior and actions

library(tidyverse)

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

# Combine the divisions' lists of member states into a tibble with each labeled by division name
divisions = tibble(division = c("New England", "Mid-Atlantic", "East North Central", 
                                  "West North Central", "South Atlantic", "East South Central",
                                  "West South Central", "Mountain", "Pacific"),
                  states = I(list(div1,div2,div3,div4,div5,div6,div7,div8,div9))) # I() function is required to insert each list as a singular object, i.e. "as Is"


professionals %>% 
  mutate_at(professionals_location, pros_loc_div = case_when(
    . %in% divisions$states[1] ~ divisions$division[1]
    . %in% divisions$states[2] ~ divisions$division[2]
    . %in% divisions$states[3] ~ divisions$division[3]
    . %in% divisions$states[4] ~ divisions$division[4]
    . %in% divisions$states[5] ~ divisions$division[5]
    . %in% divisions$states[6] ~ divisions$division[6]
    . %in% divisions$states[7] ~ divisions$division[7]
    . %in% divisions$states[8] ~ divisions$division[8]
    . %in% divisions$states[9] ~ divisions$division[9]
    )
  )


professionals %>% 
  mutate(pros_loc_div = case_when(
    contains(divisions$states[i], 'subset:professionals_location', ignore.case = TRUE) ~ divisions$division[i]
  ))


# Search each entry in the state column for expr
library(rlist)
list.search(divisions$states[i], )


head(div_names)
summary(professionals)
str(professionals)
head(professionals$professionals_location,20)
