library(caret)
library(ggplot2)
library(dplyr)
library(tidyverse)

df_answer_scores <- read.csv('answer_scores.csv')
df_answers <- read.csv('answers.csv')
df_comments <- read.csv('comments.csv')
df_emails <- read.csv('emails.csv')
df_group_memberships <- read.csv('group_memberships.csv')
df_matches <- read.csv('matches.csv')
df_prof <- read.csv('professionals.csv')
df_question_scores <- read.csv('question_Scores.csv')
df_questions <- read.csv('questions.csv')
df_school_memberships <- read.csv('school_memberships.csv')
df_students <- read.csv('students.csv')
df_tag_questions <- read.csv('tag_questions.csv')
df_tag_users <- read.csv('tag_users.csv')
df_tags <- read.csv('tags.csv')

str(df_prof)
str(df_questions)
str(df_question_scores)
str(df_answers)


df_prof_na <- read.csv('professionals.csv',na.strings=c('NA',''))
str(df_prof_na)
####################
# Combining industry by variation in spelling
#"Consulting"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Consulting"), "Consulting", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "CONSULTING"), "Consulting", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "consulting"), "Consulting", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Consultant"), "Consulting", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "CONSULTANT"), "Consulting", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "consultant"), "Consulting", df_prof_na$professionals_industry)

#"Doctor"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Doctor"), "Doctor", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "DOCTOR"), "Doctor", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "doctor"), "Doctor", df_prof_na$professionals_industry)

#"Electrical and Electronic Manufacturing"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Electrical and Electronic Manufacturing"), "Electrical and Electronic Manufacturing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "ELECTRICAL AND ELECTRONIC MANUFACTURING"), "Electrical and Electronic Manufacturing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "electrical and electronic manufacturing"), "Electrical and Electronic Manufacturing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Electrical/Electronic Manufacturing"), "Electrical and Electronic Manufacturing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "ELECTRICAL/ELECTRONIC MANUFACTURING"), "Electrical and Electronic Manufacturing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "electrical/electronic manufacturing"), "Electrical and Electronic Manufacturing", df_prof_na$professionals_industry)

#"Engineering"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Engineering"), "Engineering", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "ENGINEERING"), "Engineering", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "engineering"), "Engineering", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Engineer"), "Engineering", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "ENGINEER"), "Engineering", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "engineer"), "Engineering", df_prof_na$professionals_industry)

#"Entertainment"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Entertainment"), "Entertainment", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "ENTERTAINMNET"), "Entertainment", df_prof_na$professionals_industry)

#"Finance"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Financial"), "Finance", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "financial"), "Finance", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Finance"), "Finance", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "finance"), "Finance", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "FINANCE"), "Finance", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "FINANCIAL"), "Finance", df_prof_na$professionals_industry)

#"Fitness"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Fitness"), "Fitness", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "FITNESS"), "Fitness", df_prof_na$professionals_industry)

#"Food and Beverage"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Food and Beverage"), "Food and Beverage", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "FOOD AND BEVERAGE"), "Food and Beverage", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "food and beverage"), "Food and Beverage", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Food & Beverage"), "Food and Beverage", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "FOOD & BEVERAGE"), "Food and Beverage", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "food & beverage"), "Food and Beverage", df_prof_na$professionals_industry)

#"Healthcare"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Healthcare"), "Healthcare", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "HEALTHCARE"), "Healthcare", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Health Care"), "Healthcare", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Health care"), "Healthcare", df_prof_na$professionals_industry)

#Higher Education
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Higher Education"), "Higher Education", df_prof_na$professionals_industry)



#"Human Resources"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Human Resources"), "Human Resources", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Human Resource"), "Human Resources", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "HUMAN RESOURCES"), "Human Resources", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "HUMAN_RESOURCES"), "Human Resources", df_prof_na$professionals_industry)

#Hospitality
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Hospitality"), "Hospitality", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Hospitality "), "Hospitality", df_prof_na$professionals_industry)

#"Individual and Family Services"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Individual and Family Services"), "Individual and Family Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "INDIVIDUAL AND FAMILY SERVICES"), "Individual and Family Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "individual and family services"), "Individual and Family Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Individual & Family Services"), "Individual and Family Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "INDIVIDUAL & FAMILY SERVICES"), "Individual and Family Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "individual & family services"), "Individual and Family Services", df_prof_na$professionals_industry)


#Information Technology and Services
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Information Technology and Services"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "INFORMATION TECHNOLOGY AND SERVICES"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "information technology and services"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Information Services"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "INFORMATION SERVICES"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "information services"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "INFORMATION TECHNOLOGY"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "information technology"), "Information Technology and Services", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Information Technology"), "Information Technology and Services", df_prof_na$professionals_industry)

#Insurance
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Insurance"), "Insurance", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "insurance "), "Insurance", df_prof_na$professionals_industry)

#"Nurse"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Nurse"), "Nursing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "NURSE"), "Nursing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "nurse"), "Nursing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Nursing"), "Nursing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "NURSING"), "Nursing", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "nursing"), "Nursing", df_prof_na$professionals_industry)

df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Oil and Energy"), "Oil and Energy", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "OIL AND ENERGY"), "Oil and Energy", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Oil and Energy"), "Oil and Energy", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Oil & Energy"), "Oil and Energy", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "OIL & ENERGY"), "Oil and Energy", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Oil & Energy"), "Oil and Energy", df_prof_na$professionals_industry)

#"Pharmaceuticals"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Pharmaceuticals"), "Pharmaceuticals", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "PHARMACEUTICALS"), "Pharmaceuticals", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "pharmaceuticals"), "Pharmaceuticals", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Pharmacy"), "Pharmaceuticals", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "PHARMACY"), "Pharmaceuticals", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "pharmacy"), "Pharmaceuticals", df_prof_na$professionals_industry)

#"Real Estate"
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Real Estate"), "Real Estate", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Real estate"), "Real Estate", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "REAL ESTATE"), "Real Estate", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "real estate"), "Real Estate", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "Realtor"), "Real Estate", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "realtor"), "Real Estate", df_prof_na$professionals_industry)
df_prof_na$professionals_industry <- ifelse(str_detect(df_prof_na$professionals_industry, pattern = "REALTOR"), "Real Estate", df_prof_na$professionals_industry)


#rename all profession INDUSTRIES with count fewer than 'x' "other"
df_prof_na$professionals_industry <- with(df_prof_na, ave(professionals_industry, professionals_industry, FUN = function(i) replace(i, length(i) < 15, 'other')))

#count of profession industries
table(df_prof_na$professionals_industry)

#create variable for count of professions for plotting
prof_ind <- table(df_prof_na$professionals_industry)

#bar plot of professions
barplot(prof_ind, main="industry distribution", 
        xlab="Industry")


#convert to data frame
df_prof_ind <- as.data.frame(prof_ind)

#industries by proportion
prop_prof_ind <- prop.table(table(df_prof_na$professionals_industry))
view(prop_prof_ind)


str(df_prof_ind)


##########################

#df_prof_answer creates new df merging professionals with answers they've provided.
df_prof_answer <- merge(df_prof_na, df_answers, by.x="professionals_id", by.y="answers_author_id")
str(df_prof_answer)

#Answers provided by professional industry
table(df_prof_answer$professionals_industry)
prof_answer_ind <- table(df_prof_answer$professionals_industry)

#bar plot of answers
barplot(prof_answer_ind, main="Answer Distribution", 
        xlab="Industry")

#convert to data frame
df_prof_answer_ind <- as.data.frame(prof_answer_ind)

#answers by proportion
prop_prof_answer_ind <- prop.table(table(df_prof_answer$professionals_industry))
View(prop_prof_answer_ind)

#proportion of answers per industry
df_ind_answer_prop <- df_prof_answer_ind$Freq / df_prof_ind$Freq
View(df_ind_answer_prop)
str(df_ind_answer_prop)

#Dataframe now include industry, number of answers per industry, and ratio of profs/answers
df_prof_answer_ind$answer_proportion <- df_ind_answer_prop

str(df_prof_answer_ind)
View(df_prof_answer_ind)
############################################################