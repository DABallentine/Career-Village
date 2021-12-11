#set to the appropriate working directory
setwd('/Users/Kristie/Documents/R/careervillage')

#JOIN tags and tag questions
summary(tags)
summary(tag_questions)

library(dplyr)
tags <- tags %>% rename(tag_questions_tag_id = tags_tag_id)

tag_full <- merge(tag_questions[, c("tag_questions_tag_id", "tag_questions_question_id")], tags, by="tag_questions_tag_id")

#note there are duplicate questions_id values since 1 question may have more than 1 tag
tag_full <- tag_full %>% rename(questions_id = tag_questions_question_id)
tag_full <- tag_full %>% rename(tagname = tags_tag_name)
tag_full <- merge(tag_full[, c("tag_questions_tag_id", "questions_id", "tagname")], questions, by="questions_id")
question_scores <- question_scores %>% rename(questions_id=id)
tag_full <- merge(tag_full, question_scores, by="questions_id")
#now we have a full table of questions, their tags, and their scores

#TAGS - MOST FREQUENT
###
#see most frequent tags
toptags <- data.frame(table(tag_full$tagname))
toptags <- toptags %>% arrange(desc(Freq))
toptags <- head(toptags,15)

library("ggplot2")
ggplot(toptags, aes(x=Var1, y=Freq)) + 
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Most Popular Tags in Questions") +
  xlab("Tag Name") + ylab("Frequency")

#QUESTION SCORES
###
#arrange tag_full by question scores
tag_full <- tag_full %>% arrange(desc(score))

#majority of questions have 1 like
#shows scores 0-10
table(lit$score)
lit <- filter(tag_full,score<11)
ggplot(lit, aes(x=score)) + 
  geom_histogram(binwidth=1)

#higher question scores breakdown
big <- filter(tag_full,score>10)
ggplot(big, aes(x=score)) + 
  geom_histogram(bins=20)

#TAGS OF HIGHEST SCORED QUESTIONS
###
huge <- filter(big, score>100)
huge_tags <- data.frame(table(huge$tagname))

###TEXT MINING
#Corpus of Question Bodies
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(quanteda.textmodels)
library(stopwords)
modelData <- merge(questions, question_scores, by="questions_id")

myCorpus <- corpus(modelData$questions_body)
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
modelData <- modelData %>% select(score)
modelData <-cbind(modelData,as.data.frame(modelSvd$docs))
head(modelData)

library("caret")
trainIndex <- createDataPartition(modelData$score,
                                  p=0.7,
                                  list=FALSE,
                                  times=1)
MD.train <- modelData[trainIndex,]
MD.valid <- modelData[-trainIndex,]

# Build a linear regression model based on the training dataset
regModel <- glm(formula=score~.,
                family="gaussian",
                data=MD.train)

summary(regModel)

#evaluate regression model w/ MSE
pred <- predict(regModel, MD.train)    #running regression on the train dataset
mean((MD.train$score - pred)^2)       #calculating MSE on train set 

pred <- predict(regModel, MD.valid)    #running regression on the test dataset
mean((MD.valid$score - pred)^2)    #calculating MSE on test set

#tail
q_test <- filter(MD.valid,score>10)
q_test <- tail(q_test,1)
predq <- predict(reg, q_test)    #running regression on the test dataset
predq
q_test

#try regression again
reg <- lm(formula = score ~ V1 + V2 + V3 + V4 + V5 + V6 + V7 + V8 + V9 + V10, data = MD.train)    #dropped ZN variable
summary(reg)
pred <- predict(reg, MD.valid)    #running regression on the train dataset
mean((MD.train$score - pred)^2)       #calculating MSE on train set 
