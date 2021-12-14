library(caret)
library(ggplot2)
library(dplyr)
library(tidyverse)

# industries' starting length is 2471 different industries for professionals
length(unique(professionals$professionals_industry))

####################
# Combining industry by variation in spelling
#"Consulting"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Consulting"), "Consulting", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "CONSULTING"), "Consulting", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "consulting"), "Consulting", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Consultant"), "Consulting", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "CONSULTANT"), "Consulting", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "consultant"), "Consulting", professionals$professionals_industry)

#"Doctor"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Doctor"), "Doctor", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "DOCTOR"), "Doctor", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "doctor"), "Doctor", professionals$professionals_industry)

#"Electrical and Electronic Manufacturing"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Electrical and Electronic Manufacturing"), "Electrical and Electronic Manufacturing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "ELECTRICAL AND ELECTRONIC MANUFACTURING"), "Electrical and Electronic Manufacturing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "electrical and electronic manufacturing"), "Electrical and Electronic Manufacturing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Electrical/Electronic Manufacturing"), "Electrical and Electronic Manufacturing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "ELECTRICAL/ELECTRONIC MANUFACTURING"), "Electrical and Electronic Manufacturing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "electrical/electronic manufacturing"), "Electrical and Electronic Manufacturing", professionals$professionals_industry)

#"Engineering"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Engineering"), "Engineering", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "ENGINEERING"), "Engineering", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "engineering"), "Engineering", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Engineer"), "Engineering", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "ENGINEER"), "Engineering", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "engineer"), "Engineering", professionals$professionals_industry)

#"Entertainment"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Entertainment"), "Entertainment", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "ENTERTAINMNET"), "Entertainment", professionals$professionals_industry)

#"Finance"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Financial"), "Finance", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "financial"), "Finance", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Finance"), "Finance", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "finance"), "Finance", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "FINANCE"), "Finance", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "FINANCIAL"), "Finance", professionals$professionals_industry)

#"Fitness"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Fitness"), "Fitness", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "FITNESS"), "Fitness", professionals$professionals_industry)

#"Food and Beverage"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Food and Beverage"), "Food and Beverage", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "FOOD AND BEVERAGE"), "Food and Beverage", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "food and beverage"), "Food and Beverage", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Food & Beverage"), "Food and Beverage", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "FOOD & BEVERAGE"), "Food and Beverage", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "food & beverage"), "Food and Beverage", professionals$professionals_industry)

#"Healthcare"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Healthcare"), "Healthcare", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "HEALTHCARE"), "Healthcare", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Health Care"), "Healthcare", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Health care"), "Healthcare", professionals$professionals_industry)

#Higher Education
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Higher Education"), "Higher Education", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Primary/Secondary"), "Primary/Secondary Education", professionals$professionals_industry)

#"Human Resources"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Human Resources"), "Human Resources", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Human Resource"), "Human Resources", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "HUMAN RESOURCES"), "Human Resources", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "HUMAN_RESOURCES"), "Human Resources", professionals$professionals_industry)

#Hospitality
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Hospitality"), "Hospitality", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Hospitality "), "Hospitality", professionals$professionals_industry)

#"Individual and Family Services"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Individual and Family Services"), "Individual and Family Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "INDIVIDUAL AND FAMILY SERVICES"), "Individual and Family Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "individual and family services"), "Individual and Family Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Individual & Family Services"), "Individual and Family Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "INDIVIDUAL & FAMILY SERVICES"), "Individual and Family Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "individual & family services"), "Individual and Family Services", professionals$professionals_industry)

#Information Technology and Services
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Information Technology and Services"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "INFORMATION TECHNOLOGY AND SERVICES"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "information technology and services"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Information Services"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "INFORMATION SERVICES"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "information services"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "INFORMATION TECHNOLOGY"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "information technology"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Information Technology"), "Information Technology and Services", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "IT"), "Information Technology and Services", professionals$professionals_industry)

#Insurance
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Insurance"), "Insurance", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "insurance "), "Insurance", professionals$professionals_industry)

#"Non-Profit"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Nonprofit Organization Management"), "Non-profit Organization Management", professionals$professionals_industry)

#"Nurse"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Nurse"), "Nursing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "NURSE"), "Nursing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "nurse"), "Nursing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Nursing"), "Nursing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "NURSING"), "Nursing", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "nursing"), "Nursing", professionals$professionals_industry)

#Oil and Energy
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Oil and Energy"), "Oil and Energy", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "OIL AND ENERGY"), "Oil and Energy", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Oil and Energy"), "Oil and Energy", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Oil & Energy"), "Oil and Energy", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "OIL & ENERGY"), "Oil and Energy", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Oil & Energy"), "Oil and Energy", professionals$professionals_industry)

#"Pharmaceuticals"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Pharmaceuticals"), "Pharmaceuticals", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "PHARMACEUTICALS"), "Pharmaceuticals", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "pharmaceuticals"), "Pharmaceuticals", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Pharmacy"), "Pharmaceuticals", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "PHARMACY"), "Pharmaceuticals", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "pharmacy"), "Pharmaceuticals", professionals$professionals_industry)

# Professional Training
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Professional Training & Coaching"), "Professional Training", professionals$professionals_industry)

#Public Relations
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Public Relations and Communications"), "Public Relations", professionals$professionals_industry)

#"Real Estate"
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Real Estate"), "Real Estate", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Real estate"), "Real Estate", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "REAL ESTATE"), "Real Estate", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "real estate"), "Real Estate", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "Realtor"), "Real Estate", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "realtor"), "Real Estate", professionals$professionals_industry)
professionals$professionals_industry <- ifelse(str_detect(professionals$professionals_industry, pattern = "REALTOR"), "Real Estate", professionals$professionals_industry)

#Technology
professionals$professionals_industry <- ifelse(professionals$professionals_industry == "Tech", "Technology", professionals$professionals_industry)
####################


# Length after combinations is 1905 different industries, which is 566 fewer than at start.
length(unique(professionals$professionals_industry))

# Rename all profession INDUSTRIES with a count fewer than 'x' "Other"
professionals$professionals_industry <- with(professionals, ave(professionals_industry, professionals_industry, FUN = function(i) replace(i, length(i) < 15, 'Other')))

# Length after "Other" imputation is 120 different industries, a further reduction of 1779 low-density industries.
length(unique(professionals$professionals_industry))

# Count of profession industries
table(professionals$professionals_industry)

# Create data frame with count and proportion of professions
prof_ind <- table(professionals$professionals_industry) %>%
  as.data.frame() %>% 
  arrange(desc(Freq)) # Order descending by frequency


# Bar plot of top 30 professions
library(scales)
dev.off()
top30 <- head(prof_ind,30)
top30 <- top30 %>% mutate(to_highlight = ifelse(Var1 == 'Not Specified', "yes", "no")) # Allows for highlighting the 'Not Specified' bar

plot1 <- top30 %>% 
  ggplot(mapping=aes(x = reorder(Var1, Freq), y = Freq, fill = to_highlight)) + 
  geom_bar(stat = 'identity', alpha = 0.7) + 
  geom_text(aes(label = percent(Freq/dim(professionals)[1],0.1)),
            size = 3,
            vjust = 1.5) +
  labs(title = "Professionals' Industries",
       x = "Industry",
       y = "Number of Professionals") +
  scale_fill_manual(values = c("yes"="#595959", "no"="#2ca25f"), guide = "none" ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))
                     
print(plot1)


############## Merging Data ############## - Professionals & Answers

# Create a new df by merging professionals with answers they've provided.
df_prof_answer <- merge(professionals, answers, by.x="professionals_id", by.y="answers_author_id")

### Compute aggregate statistics ###

## Total answers given by a professional
total_answers <- aggregate.data.frame(df_prof_answer$professionals_id, by = list(df_prof_answer$professionals_id), FUN = length)
professionals <- merge(professionals, total_answers, by.x="professionals_id", by.y="Group.1", all.x = TRUE)
names(professionals)[names(professionals) == 'x'] <- 'total_answers'

## Average answer length & total words written
library(quanteda)
library(quanteda.textstats)
library(stopwords)
myCorpus <- corpus(df_prof_answer$answers_body,
                   docnames = df_prof_answer$answers_id)
myCorpus_stats <- summary(myCorpus, n = Inf) # The summary contains word, token, and sentence count for each answer
myCorpus_stats$sent_length <- myCorpus_stats$Types / myCorpus_stats$Sentences # Divide number of words by # sentences to compute average sentence length
df_prof_answer <- merge(df_prof_answer, myCorpus_stats, by.x="answers_id", by.y="Text", all.x = TRUE) # Add those columns to the merged working data set

# Compute aggregate statistics by professional
avg_ans_word_count <- aggregate.data.frame(df_prof_answer$Types, by = list(df_prof_answer$professionals_id), FUN = mean)
avg_ans_num_sents <- aggregate.data.frame(df_prof_answer$Sentences, by = list(df_prof_answer$professionals_id), FUN = mean)
avg_ans_sent_length <- aggregate.data.frame(df_prof_answer$sent_length, by = list(df_prof_answer$professionals_id), FUN = mean)
tot_ans_word_count <- aggregate.data.frame(df_prof_answer$Types, by = list(df_prof_answer$professionals_id), FUN = sum)

# Merge the new columns into professionals data frame
professionals <- merge(professionals, avg_ans_word_count, by.x="professionals_id", by.y="Group.1", all.x = TRUE) 
names(professionals)[names(professionals) == 'x'] <- 'avg_ans_word_count' # Rename the newly merged column
professionals <- merge(professionals, avg_ans_num_sents, by.x="professionals_id", by.y="Group.1", all.x = TRUE) 
names(professionals)[names(professionals) == 'x'] <- 'avg_ans_num_sents' # Rename the newly merged column
professionals <- merge(professionals, avg_ans_sent_length, by.x="professionals_id", by.y="Group.1", all.x = TRUE) 
names(professionals)[names(professionals) == 'x'] <- 'avg_ans_sent_length' # Rename the newly merged column
professionals <- merge(professionals, tot_ans_word_count, by.x="professionals_id", by.y="Group.1", all.x = TRUE) 
names(professionals)[names(professionals) == 'x'] <- 'tot_words_written' # Rename the newly merged column

# Replace NA values with 0
professionals <- professionals %>% replace(is.na(.), 0)


# Total number of answers provided by each industry
prof_answer_ind <- table(df_prof_answer$professionals_industry) %>%
  as.data.frame() %>% 
  arrange(desc(Freq)) # Order descending by frequency
prof_answer_ind

#bar plot of answers
dev.off()
top30 <- head(prof_answer_ind,30)
top30 <- top30 %>% mutate(to_highlight = ifelse(Var1 == 'Not Specified', "yes", "no")) # Allows for highlighting the 'Not Specified' bar

plot2 <- top30 %>% 
  ggplot(mapping=aes(x = reorder(Var1, Freq), y = Freq, fill = to_highlight)) + 
  geom_bar(stat = 'identity', alpha = 0.7) + 
  geom_text(aes(label = percent(Freq/dim(professionals)[1],0.1)),
            size = 3,
            vjust = 1.5) +
  labs(title = "Industries Providing Answers",
       x = "Industry",
       y = "Number of Answers") +
  scale_fill_manual(values = c("yes"="#595959", "no"="#8588e6"), guide = "none" ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))

print(plot2)


# #answers by proportion
# prop_prof_answer_ind <- prop.table(table(df_prof_answer$professionals_industry))
# View(prop_prof_answer_ind)
# 
# #proportion of answers per industry
# df_ind_answer_prop <- prof_answer_ind$Freq / df_prof_ind$Freq
# View(df_ind_answer_prop)
# str(df_ind_answer_prop)
# 
# #Dataframe now include industry, number of answers per industry, and ratio of profs/answers
# prof_answer_ind$answer_proportion <- df_ind_answer_prop
# 
# str(prof_answer_ind)
# View(prof_answer_ind)
############################################################