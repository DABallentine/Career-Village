# This script transforms and engineers features for the students data frame: 

# - acct_age
# - tags followed
# - school_member

## The following 4 features are possible definitions of "participation" to be used as targets for predictive modeling
# •	Activity = Total questions asked (QTY)
# •	Activity = Total words written (QTY)
# •	Activity = Heart Scores (Quality)
# •	Activity = Num Comments (Quality)

library(dplyr)
library(tibble)
library(tidyr)
library(stringr)



### Account Age ###

# Since the data cuts off at 2019-01-31, we'll use 02-01 as the anchor
students <- students %>%
  mutate(students_acct_age = as.numeric(as.Date('2019-02-01') - students$students_date_joined))



### Tags followed ###

tags_followed <- tag_users %>%
  group_by(tag_users_user_id) %>%
  summarise(tags_followed = n())

students <- left_join(students,
                      tags_followed,
                      by=c('students_id' = 'tag_users_user_id'))

students[is.na(students)] <- 0



### School member? ###

school_members <- school_memberships %>%
  left_join(students, by=c('school_memberships_user_id' = 'students_id')) %>%
  group_by(school_memberships_user_id) %>%
  summarize(school_mem_status = n())

# Set to 2 for any membership >= 2 schools
school_members$school_mem_status <- ifelse(school_members$school_mem_status > 1, 2, 1)

students <- left_join(students,
                      school_members,
                      by=c('students_id' = 'school_memberships_user_id'))

students[is.na(students)] <- 0
students$school_mem_status <- as.factor(students$school_mem_status) # factorize since this variable is categorical




###### Target Variables ######

## The following 4 features are possible definitions of "participation" to be used as targets for predictive modeling
# •	Activity = Total questions asked (QTY)
# •	Activity = Total words written (QTY)
# •	Activity = Heart Scores (Quality)
# •	Activity = Num Comments (Quality)


### Total Questions Asked ###

# Create a new df by merging students with questions they've asked.
stud_quest <- merge(students, questions, by.x="students_id", by.y="questions_author_id")

### Compute aggregate statistics ###

## Total questions asked by a student
total_questions <- aggregate.data.frame(stud_quest$students_id, by = list(stud_quest$students_id), FUN = length)
students <- merge(students, total_questions, by.x="students_id", by.y="Group.1", all.x = TRUE)
names(students)[names(students) == 'x'] <- 'total_questions'

## Average answer length & total words written
library(quanteda)
library(quanteda.textstats)
library(stopwords)
myCorpus <- corpus(stud_quest$questions_body,
                   docnames = stud_quest$questions_id)
myCorpus_stats <- summary(myCorpus, n = Inf) # The summary contains word, token, and sentence count for each answer
stud_quest <- merge(stud_quest, myCorpus_stats, by.x="questions_id", by.y="Text", all.x = TRUE) # Add those columns to the merged working data set

# Compute total words written
tot_quest_word_count <- aggregate.data.frame(stud_quest$Types, by = list(stud_quest$students_id), FUN = sum)

# Merge the new columns into students data frame
students <- merge(students, tot_quest_word_count, by.x="students_id", by.y="Group.1", all.x = TRUE) 
names(students)[names(students) == 'x'] <- 'tot_words_written' # Rename the newly merged column

# Replace NA values with 0
students <- students %>% replace(is.na(.), 0)


### Heart Scores ###

total_hearts <- question_scores %>% 
  left_join(questions, by=c('id' = 'questions_id')) %>%
  group_by(questions_author_id) %>%
  summarise(total_hearts = sum(score))

students <- left_join(students,
                      total_hearts,
                      by=c('students_id' = 'questions_author_id'))

students[is.na(students)] <- 0


### Number of Comments ###

total_comments <- questions %>%
  left_join(comments, by=c('questions_id' = 'comments_parent_content_id')) %>%
  group_by(questions_author_id) %>%
  summarise(total_comments = n())

students <- left_join(students,
                      total_comments,
                      by=c('students_id' = 'questions_author_id'))

students[is.na(students)] <- 0






