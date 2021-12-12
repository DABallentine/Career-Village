#set to the appropriate working directory
setwd('/Users/Kristie/Documents/R/careervillage')
library(dplyr)

#JOIN tags and tag questions
summary(answers)
summary(answer_scores)
dim(answers)
dim(answer_scores)
dim(tag_full)

answer_scores <- answer_scores %>% rename(answers_id = id)
answers_full <- merge(answers,answer_scores,by="answers_id")
summary(answers_full)
answers_full <- answers_full %>% arrange(desc(score))

#QUESTION SCORES
###
#arrange tag_full by question scores
tag_full <- tag_full %>% arrange(desc(score))

#look at answer score data - histograms
table(answers_full$score)
ggplot(answers_full, aes(x=score)) + 
  geom_histogram(binwidth=1)
low <- filter(answers_full,score<10)
low <- filter(low,score>1)
ggplot(low, aes(x=score)) + 
  geom_histogram(binwidth=1)
big <- filter(answers_full,score>9)
ggplot(big, aes(x=score)) + 
  geom_histogram(binwidth=1)

#merge answers (full) table with the tag/question full table
answers_full <- answers_full %>% rename(questions_id = answers_question_id)
answers_full <- answers_full %>% rename(a_score = score)
ques_full <- merge(questions,question_scores,by="questions_id")
dim(questions)
dim(question_scores)
dim(ques_full)

ques_full <- ques_full %>% rename(q_score = score)

full <- merge(answers_full,ques_full, by="questions_id")
dim(answers_full)
dim(full)

#do question scores and answer scores positively correlate?
#train and validation dataset split
library("caret")
trainIndex <- createDataPartition(full$a_score,
                                  p=0.7,
                                  list=FALSE,
                                  times=1)
f.train <- full[trainIndex,]
f.valid <- full[-trainIndex,]

#regression model
regModel <- glm(formula=a_score~q_score,
                family="gaussian",
                data=f.train)

summary(regModel)

#evaluate regression model w/ MSE
pred <- predict(regModel, f.train)    #running regression on the train dataset
mean((f.train$a_score - pred)^2)       #calculating MSE on train set 

pred <- predict(regModel, f.valid)    #running regression on the test dataset
mean((f.valid$a_score - pred)^2)    #calculating MSE on test set

###TEXT MINING
#Corpus of Answer Bodies
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(quanteda.textmodels)
library(stopwords)

myCorpus <- corpus(answers_full$answers_body)
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

stopwords1 <-c('>','<','p','can','get',
               'br','li','may')

myDfm <- dfm_remove(myDfm, stopwords1) 

tstat_freq <- textstat_frequency(myDfm)
head(tstat_freq, 20)

textplot_wordcloud(myDfm,max_words=200)

# Control sparse terms: to further remove some very infrequency words
modelDfm<- dfm_trim(myDfm,min_termfreq=4, min_docfreq=2)
dim(modelDfm)

# We will first generate SVD columns based on the entire corpus
# Weight the predictiv DFM by tf-idf
modelDfm_tfidf <- dfm_tfidf(modelDfm)
dim(modelDfm_tfidf)

# Perform SVD for dimension reduction
# Choose the number of reduced dimensions as 10
modelSvd <- textmodel_lsa(modelDfm_tfidf, nd=10)
head(modelSvd$docs)

#set up model to be able to do predictive modelling
modelData <- answers_full %>% select(a_score)
modelData <-cbind(modelData,as.data.frame(modelSvd$docs))
head(modelData)

trainIndex <- createDataPartition(modelData$a_score,
                                  p=0.7,
                                  list=FALSE,
                                  times=1)
a.train <- modelData[trainIndex,]
a.valid <- modelData[-trainIndex,]

# Build a linear regression model based on the training dataset
regModelAns <- glm(formula=a_score~.,
                family="gaussian",
                data=a.train)

summary(regModelAns)

#evaluate regression model w/ MSE
pred <- predict(regModelAns, a.train)    #running regression on the train dataset
mean((a.train$a_score - pred)^2)       #calculating MSE on train set 

pred <- predict(regModelAns, a.valid)    #running regression on the test dataset
mean((a.valid$a_score - pred)^2)    #calculating MSE on test set


