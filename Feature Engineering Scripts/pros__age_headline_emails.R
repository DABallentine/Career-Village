# This script transforms and engineers features for the professionals data frame: 

# - acct_age
# - headline_topic (not completed as discussed below)
# - emails: email_notification_immediate, _daily, and _weekly total emails received
# - tags followed

library(dplyr)
library(tibble)
library(tidyr)
library(stringr)



### Account Age ###
# Since the data cuts off at 2019-01-31, we'll use 02-01 as the anchor
professionals <- professionals %>%
  mutate(professionals_acct_age = as.numeric(as.Date('2019-02-01') - professionals$professionals_date_joined))

### headline_topic ###

# Here we conduct simple topic modeling of the professionals headlines and group them into a reasonable number of topical groups
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(quanteda.textmodels)

# Create the corpus object
myCorpus <- corpus(professionals$professionals_headline)
summary(myCorpus)

# Remove stop words and perform stemming
library(stopwords)
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) ) # remove punctuation
myDfm <- dfm_remove(myDfm, stopwords('english')) # remove stopwords
myDfm <- dfm_wordstem(myDfm) # stem the words

dim(myDfm) # 12301 features
topfeatures(myDfm,100)
myDfm <- dfm_remove(myDfm, c('|', 'manag')) # remove additional common mark and term

# Observe term frequency
tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

# Print a word cloud for professionals headlines
print(textplot_wordcloud(myDfm, max_words = 500, min_size = 1.5, max_size=8))


## We need to check for rows with no words recognized in the headline, which disallows topic modeling with LDA
rowTotals <- apply(myDfm, 1, sum)

# Impute 'nonstandard' for all headlines containing no words
professionals[rowTotals==0,'professionals_headline'] <- 'unspecified'

# Rebuild the corpus and recheck
myCorpus <- corpus(professionals$professionals_headline)
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) ) # remove punctuation
myDfm <- dfm_remove(myDfm, stopwords('english')) # remove stopwords
myDfm <- dfm_wordstem(myDfm) # stem the words
myDfm <- dfm_remove(myDfm, c('|', 'manag')) # remove additional common mark and term
rowTotals <- apply(myDfm, 1, sum) # recheck for 0-word headlines
zeroRows <- rowTotals == 0
sum(zeroRows) # Sums to 0: there are no more 0-word headlines and we can proceed

library(topicmodels)
library(tidytext)

# Explore the option with 10 topics using Latent Dirichlet Allocation
docvars(myCorpus,"ID") <- professionals$professionals_id
myLda <- LDA(myDfm,
             k=5,
             control=list(seed=161))

# Term-topic probabilities: let's look at the top terms for each topic
myLda_td <- tidy(myLda)

### Visualize most common terms in each topic
library(ggplot2)

## First extract the top terms
top_terms <- myLda_td %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)
## Then plot
top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

# Finally, we can view the topic probabilities for each headline
headline_probs <- as.data.frame(myLda@gamma)
head(headline_probs, 15)

## Unfortunately for any values of k from 5 to 20, we don't see enough difference in the probability of a
## headline belonging to one topic over another, so we can't include a headline variable for predictive modeling




### Emails ###

library(reshape2)

# Convert frequency feature to a factor
emails$emails_frequency_level <- as.factor(emails$emails_frequency_level)

# Group by recipient and frequency level, sum, then dcast frequency level out as columns
email_vols <- emails %>%
  group_by(emails_recipient_id, emails_frequency_level) %>%
  summarise(n = n()) %>%
  dcast(emails_recipient_id ~ emails_frequency_level)

email_vols[is.na(email_vols)] <- 0 # replace NA with 0

# Join professionals with new email columns
professionals <- left_join(professionals, 
                           email_vols, 
                           by=c('professionals_id' = 'emails_recipient_id'))

professionals[is.na(professionals)] <- 0




### Tags followed ###

tags_followed <- tag_users %>%
  group_by(tag_users_user_id) %>%
  summarise(n = n()) %>% 
  rename(tags_followed = n)

professionals <- left_join(professionals, 
                           tags_followed, 
                           by=c('professionals_id' = 'tag_users_user_id'))

professionals[is.na(professionals)] <- 0




###### Target Variables ######

## The following 4 features are possible definitions of "participation" to be used as targets for predictive modeling
# •	Activity = Total answers given (QTY / already computed in answers_by_industry.R)
# •	Activity = Total words written (QTY / already computed in answers_by_industry.R)
# •	Activity = Heart Scores (Quality)
# •	Activity = Num Comments (Quality)


### Heart Scores ###

total_hearts <- answer_scores %>% 
  left_join(answers, by=c('id' = 'answers_id')) %>%
  group_by(answers_author_id) %>%
  summarise(total_hearts = sum(score))

professionals <- left_join(professionals,
                           total_hearts,
                           by=c('professionals_id' = 'answers_author_id'))

professionals[is.na(professionals)] <- 0


### Number of Comments ###

total_comments <- answers %>%
  left_join(comments, by=c('answers_id' = 'comments_parent_content_id')) %>%
  group_by(answers_author_id) %>%
  summarise(total_comments = n())

professionals <- left_join(professionals,
                           total_comments,
                           by=c('professionals_id' = 'answers_author_id'))

professionals[is.na(professionals)] <- 0





