# ---------------------------------------------------------------------------------------------
# Title: Text Mining Student Questions
# Description: This script analyzzes the text of student questions
# Date: 12/09/2021
# ---------------------------------------------------------------------------------------------

# Set working directory
  getwd()
  setwd("C:/Users/tferg/OneDrive - University of North Carolina at Charlotte/Classwork/DSBA 6211/Group Project/data-science-for-good-careervillage")

# Install Packages
  install.packages(c("dplyr", "ggplot2", "stringr", "tidygeocoder", "data.table", "SentimentAnalysis", "vader",
                     "syuzhet", "topicmodels", "quanteda", "wordcloud", "BTM", "udpipe", "stopwords", "textplot",
                     "ggraph", "concaveman", "tidytext", "quanteda.textplots"))
  Packages <- c("dplyr", "ggplot2", "stringr", "tidygeocoder", "data.table", "SentimentAnalysis", "vader",
                "syuzhet", "topicmodels", "quanteda", "wordcloud", "BTM", "udpipe", "stopwords", "textplot",
                "ggraph", "concaveman", "tidytext", "quanteda.textplots", "scales")
  lapply(Packages, library, character.only = TRUE)

# Import relevant data file
  questions <- read.csv("questions.csv", na.strings = c("NA", ""), stringsAsFactors = FALSE)

# __________________________________
# Create Topics
# __________________________________

# Initial text cleaning
  unclean_text <- tolower(questions$questions_body)
  
  clean_text = gsub("&amp", "", unclean_text)
  clean_text = gsub("@\\w+", "", clean_text)
  clean_text = gsub("http\\w+", "", clean_text)
  clean_text = gsub("[ \t]{2,}", "", clean_text)
  clean_text = gsub("^\\s+|\\s+$", "", clean_text) 
  clean_text = gsub("Ã¢","",clean_text)
  clean_text = gsub("???","",clean_text)
  clean_text = gsub("T","",clean_text)
  
  questions$text_cleaned = clean_text


# Pre-processing
  tokensAll = tokens(questions$text_cleaned, remove_punct = TRUE)
  tokensNoStopwords = tokens_remove(tokensAll, c(stopwords("english"),"T","???","get","???","s","t","uf","???","T","???_T","im"))
  tokensNgramsNoStopwords = tokens_ngrams(tokensNoStopwords, c(1,2))
  myDFM = dfm(tokensNgramsNoStopwords)
  myDFM = dfm_remove(myDFM, c('€','™',"€_™")) # Remove frequent words
  myDFM <- dfm_wordstem(myDFM) # Perform Stemming
  myDFM = dfm_remove(myDFM, c('p', "<_p","p_>", "<", ">", "iâ", "iâ_€", "thing", "also",
                              "m")) # Remove frequent words
  myDFM = dfm_trim(myDFM ,  min_termfreq = 2, min_docfreq = 2)
  topfeatures(myDFM, 20)

# Topic Modeling  
  f <- convert(myDFM, to="topicmodels")

  K <- 9 # Number of topics
  lda.model <- LDA(f, k = K, method = "Gibbs", control = list(verbose=25L, seed = 123, burnin = 100, iter = 500))
  terms(lda.model,10) ## top 10 terms in each topic

# Plot top 10 terms for each topic
  topic_lda <- tidy(lda.model,matrix = "beta")
  top_terms <- topic_lda %>%
    group_by(topic) %>%
    top_n(10,beta) %>% 
    ungroup() %>%
    arrange(topic,-beta)
  plot_topic <- top_terms %>%
    mutate(term = reorder_within(term, beta, topic)) %>%
    ggplot(aes(term, beta, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scales = "free") +
    coord_flip() +
    scale_x_reordered()
  plot_topic

# Add topics to original data
  topics = as.data.frame(topics(lda.model))
  names(topics)[1] = "topic_lda"
  topics$text_id = row.names(topics)
  row.names(topics) = NULL
  topics = topics[,c(2,1)]
  questions$text_id = paste("text",seq(1,nrow(questions),1),sep="")
  questions = merge(questions,topics,by="text_id",sort=F,all=T)
  
  questions$topic_lda <- as.factor(questions$topic_lda)

  write.csv(questions, 'questions_withTopics.csv') # Export new table


# __________________________________
# Visualizations
# __________________________________

summary(questions$topic_lda)

# Create relevant subset
  TimeSeries <- questions %>% select(c(text_id, questions_date_added, topic_lda)) %>% 
    filter(is.na(topic_lda)==FALSE)
  TimeSeries$questions_date_added <- as.POSIXct(TimeSeries$questions_date_added, format = "%Y-%m-%d %H")
  TimeSeries$Year <- substr(TimeSeries$questions_date_added,1,4) 
  
  TimeSeries$topic_lda <- as.integer(TimeSeries$topic_lda)
  TimeSeries$Year <- as.integer(TimeSeries$Year)
  
  # Make Pivot Table
  TimeSeries <- TimeSeries %>%
    group_by(Year, topic_lda) %>% 
    summarize(Topic_Sum =  sum(topic_lda))
  
# Bar graph of topics by year
  TimeSeries$topic_lda <- as.factor(TimeSeries$topic_lda)
  TimeSeries$Year <- as.factor(TimeSeries$Year)
  TimeSeries = na.omit(TimeSeries)

  ggplot(TimeSeries, aes(x = Year, y = Topic_Sum, fill = topic_lda)) + 
    geom_bar(stat = "identity", position="dodge") +
    scale_fill_discrete(name = "Topics", 
                        labels = c("Internship/Career Search", "High School Students", "People-Oriented Careers", 
                                   "Coping with College", "Paying for College", "STEM", 
                                   "Medical Field", "Business", "Art/Design")) +
    labs(title = "Question Topics Over Time", x = "Year", y = "Sum of Questions") +
    theme(legend.position = "bottom")
  
# Overall Topic Frequency 
 summary(questions$topic_lda)
  
  topicFreq <- questions %>% count(topic_lda)
  topicFreq <- na.omit(topicFreq) # Remove 86 missing values
  topicFreq$Title <- c("Internship/Career Search", "High School Students", "People-Oriented Careers", 
                       "Coping with College", "Paying for College", "STEM", 
                       "Medical Field", "Business", "Art/Design")
  
  ggplot(topicFreq, aes(x = reorder(Title, -n), y = n, fill = topic_lda)) + 
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    geom_text(aes(label=n), position=position_dodge(width=0.9), vjust=-0.25) +
    labs(title = "Frequency of Question Topics", x = "Topics", y = "Sum of Questions")+
    scale_y_continuous(limit = c(0, 3500)) +
    theme(legend.position = "none")
  
