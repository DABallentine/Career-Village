# This script engineers and aggregates features for the questions data frame: 

# - quest_age: How long has the question been posted
# - num_tags: Total number of tags the question has
# - num_words: Total word count
# - stud_loc_div: The location division of the student who submitted the question
# - stud_school_mem: Whether the student submitting the question is a member of a school
# - num_emails: Total number of emails sent regarding a question
# - topic_lda: 9 topical categories modeled by Latent Dirichlet Allocation

## Target Variable:
# Answered: 1/0 for Y/N


library(dplyr)
library(tidyr)
library(stringr)
library(quanteda)

### Question Age ###
questions <- read.csv('~/GitHub/Career-Village/questions.csv', header=T, na.strings=c('NA',''), encoding="UTF-8")
# Since the data cuts off at 2019-01-31, we'll use 02-01 as the anchor
questions <- questions %>%
  mutate(quest_age = as.numeric(as.Date('2019-02-01') - as.Date(questions$questions_date_added)))



### Number of Tags ###

num_tags <- tag_questions %>%
  group_by(tag_questions_question_id) %>%
  summarise(num_tags = n())

questions <- left_join(questions,
                       num_tags,
                       by=c('questions_id' = 'tag_questions_question_id'))

questions[is.na(questions)] <- 0



### Number of Words ###

questCorp <- corpus(questions$questions_body,
                    docnames = questions$questions_id)
questToks <- tokens(questCorp,
                    remove_punc = TRUE)
questions$num_words <- ntoken(questToks)



### Student's Location & School Membership ###

questions <- questions %>%
  left_join(students[,c(1,4,8)], by=c('questions_author_id' = 'students_id'))

  # 130 questions likely from former members no longer in the students table, now NA, will be dropped at the end of this script



### Number of emails sent ###

num_emails <- matches %>%
  group_by(matches_question_id) %>%
  summarise(num_emails = n())

questions <- questions %>%
  left_join(num_emails, by=c('questions_id' = 'matches_question_id'))

questions$num_emails[is.na(questions$num_emails)] <- 0



### Topic Categories ###  -  computed in 'questions_text analysis.R'
questtops <- read.csv('~/GitHub/Career-Village/questions_withTopics.csv')
questions$topic_lda <- questtops$topic_lda



### Target Variable ###
# Answered: 1/0 for Y/N

questions$answered <- ifelse(questions$questions_id %in% answers$answers_question_id, 1, 0)


# Drop remaining 215 records with missing topic or student location
questions <- questions[rowSums(is.na(questions))==0, ]
check <- questions[rowSums(is.na(questions))>0, ] # =0. NAs successfully dropped.

# Write to csv
write.csv(questions, 'questions_prepped.csv') # Export new table
