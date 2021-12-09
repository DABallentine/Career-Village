#set to the appropriate working directory
setwd('/Users/Kristie/Documents/R/careervillage')

#WordClouds
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(quanteda.textmodels)
library(stopwords)

#QUESTIONS TITLE
summary(questions)
sum(is.na(questions$questions_title))

myCorpus <- corpus(questions$questions_title)
summary(myCorpus)
myDfm <- dfm(tokens(myCorpus))

# Simple frequency analyses
tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

# Remove stop words and perform stemming
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) )
myDfm <- dfm_remove(myDfm, stopwords('english'))
myDfm <- dfm_wordstem(myDfm)
dim(myDfm)
topfeatures(myDfm,60)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

#QUESTIONS BODY
summary(questions)
sum(is.na(questions$questions_body))

myCorpus <- corpus(questions$questions_body)
summary(myCorpus)
myDfm <- dfm(tokens(myCorpus))

# Simple frequency analyses
tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

# Remove stop words and perform stemming
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) )
myDfm <- dfm_remove(myDfm, stopwords('english'))
myDfm <- dfm_wordstem(myDfm)
dim(myDfm)
topfeatures(myDfm,60)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

# Add more user-defined stop words
stopwords1 <-c('#colleg','go','get','can','also')
myDfm <- dfm_remove(myDfm, stopwords1) 
dim(myDfm)
topfeatures(myDfm,30)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

#ANSWERS BODY
summary(answers)
sum(is.na(answers$answers_body))

myCorpus <- corpus(answers$answers_body)
summary(myCorpus)
myDfm <- dfm(tokens(myCorpus))

# Simple frequency analyses
tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

# Remove stop words and perform stemming
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) )
myDfm <- dfm_remove(myDfm, stopwords('english'))
myDfm <- dfm_wordstem(myDfm)
dim(myDfm)
topfeatures(myDfm,60)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

# Add more user-defined stop words
stopwords1 <-c('<','>','p','can','get','br','li')
myDfm <- dfm_remove(myDfm, stopwords1) 
dim(myDfm)
topfeatures(myDfm,30)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)


#JOIN questions and question scores
library(dplyr)
summary(questions)
summary(question_scores)

question_scores <- question_scores %>% rename(questions_id = id)

questions_full <- left_join(questions,question_scores)
summary(questions_full)

#range of score values
max(questions_full$score, na.rm=TRUE) - min(questions_full$score, na.rm=TRUE)
table(questions_full$score)

#WordCloud for question TITLE that get more likes
questions_liked <- questions_full %>% filter(score > 5)

myCorpus <- corpus(questions_liked$questions_title)
summary(myCorpus)
myDfm <- dfm(tokens(myCorpus))
# Simple frequency analyses
tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)
# Remove stop words and perform stemming
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) )
myDfm <- dfm_remove(myDfm, stopwords('english'))
myDfm <- dfm_wordstem(myDfm)
dim(myDfm)
topfeatures(myDfm,60)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

#WordCloud for question BODY that get more likes
myCorpus <- corpus(questions_liked$questions_body)
summary(myCorpus)
myDfm <- dfm(tokens(myCorpus))
# Simple frequency analyses
tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)
# Remove stop words and perform stemming
myDfm <- dfm(tokens(myCorpus,
                    remove_punc = T) )
myDfm <- dfm_remove(myDfm, stopwords('english'))
myDfm <- dfm_wordstem(myDfm)
stopwords1 <-c('<','>','p','can','get','br','li')
myDfm <- dfm_remove(myDfm, stopwords1) 
dim(myDfm)
topfeatures(myDfm,60)

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

#most liked questions
questions_most_liked <- questions_full %>% filter(score > 27)



#JOIN answers and answer scores
summary(answers)
summary(answer_scores)

answer_scores <- answer_scores %>% rename(answers_id = id)

answers_full <- left_join(answers,answer_scores)
summary(answers_full)

#range of score values
table(answers_full$score)

