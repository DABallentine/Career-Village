# ---------------------------------------------------------------------------------------------
# Title: Time Series Analysis
# Description: This script predicts future volume of questions based on time series
# Date: 12/13/2021
# ---------------------------------------------------------------------------------------------

# Set working directory
getwd()
setwd("C:/Users/jaime/OneDrive/Documents")

# Install Packages
install.packages(c("dplyr", "ggplot2", "forecast", "zoo"))
Packages <- c("dplyr", "ggplot2", "forecast", "zoo")
lapply(Packages, library, character.only = TRUE)

# Import relevant data files
questions <- read.csv('R/questions_withTopics.csv', na.strings = c("NA", ""), stringsAsFactors = FALSE)

# __________________________________
# Aggregate Data
# __________________________________

# Create character format of Data
for (i in 1:nrow(questions)){
  FirstValue = "1/"
  Month = substr(questions$questions_date_added[i], 6,7)
  Seperator = "/"
  Year = substr(questions$questions_date_added[i], 1,4)
  questions$questions_date_added[i] = paste(FirstValue,Month,Seperator,Year, sep = "")
}

questions$questions_date_added <- as.factor(questions$questions_date_added)


# Create order summations by year

  # 2011
  Year2011 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2011)
  Year2011$Tally = 1
  Year2011 <- Year2011 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2012
  Year2012 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2012)
  Year2012$Tally = 1
  Year2012 <- Year2012 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2013
  Year2013 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2013)
  Year2013$Tally = 1
  Year2013 <- Year2013 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2014
  Year2014 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2014)
  Year2014$Tally = 1
  Year2014 <- Year2014 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2015
  Year2015 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2015)
  Year2015$Tally = 1
  Year2015 <- Year2015 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2016
  Year2016 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2016)
  Year2016$Tally = 1
  Year2016 <- Year2016 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2017
  Year2017 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2017)
  Year2017$Tally = 1
  Year2017 <- Year2017 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2018
  Year2018 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2018)
  Year2018$Tally = 1
  Year2018 <- Year2018 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

  # 2019
  Year2019 <- questions %>% select(questions_date_added) %>% filter((substr(questions$questions_date_added, 6,9)) == 2019)
  Year2019$Tally = 1
  Year2019 <- Year2019 %>% 
    group_by(questions_date_added) %>% 
    summarize(Question_Sum =  sum(Tally))

# Combine data with 12 months 
TimeSeries <- rbind(Year2012,Year2013, Year2014, Year2015, Year2016, Year2017, Year2018)


# __________________________________
# Linear Time Series Analysis
# __________________________________

# Define time Series
x <- ts(TimeSeries$Question_Sum,
        start = c(2012,1),
        frequency = 12)
x
plot(x)


############################################################################
# Model 1: Linear Trend Model
TimeSeries.lm <- tslm(x~trend)
summary(TimeSeries.lm)

# Data partition for time series data
# Use the last 36 months data as the training dataset
nValid <- 36
nTrain <- length(x)-nValid

train.ts <- window(x,start=c(2012,1),end=c(2012,nTrain))
valid.ts <- window(x,start=c(2012,nTrain+1),end=c(2012,nTrain+nValid))

train.lm <- tslm(train.ts~trend)
summary(train.lm)
train.lm.pred <- forecast(train.lm,h=nValid,level=0)

# Visualize the linear trend model
par(mfrow = c(1, 1))
plot(train.lm.pred, ylim = c(0, 5000),  ylab = "Question Volume", xlab = "Time", 
     bty = "l", xaxt = "n", xlim = c(2012,2018),main = "", flty = 2)
axis(1, at = seq(2012, 2018, 1), labels = format(seq(2012, 2018, 1)))
lines(train.lm.pred$fitted, lwd = 2, col = "blue")
lines(valid.ts)

# Evaluate model performance
accuracy(train.lm.pred,valid.ts)
# Polynomial Trend
train.lm.poly.trend <- tslm(train.ts ~ trend + I(trend^2))
summary(train.lm.poly.trend)
train.lm.poly.trend.pred <- forecast(train.lm.poly.trend, h = nValid, level = 0)
accuracy(train.lm.poly.trend.pred,valid.ts)

# A model with seasonality
# In R, function tslm() uses ts() which automatically creates the categorical 
# Season column (called season) and converts it into dummy variables.
train.lm.season <- tslm(train.ts ~ season)
summary(train.lm.season)
train.lm.season.pred <- forecast(train.lm.season, h = nValid, level = 0)
accuracy(train.lm.season.pred,valid.ts)

# A model with trend and seasonality
train.lm.trend.season <- tslm(train.ts ~ trend + I(trend^2) + season)
summary(train.lm.trend.season)
train.lm.trend.season.pred <- forecast(train.lm.trend.season, h = nValid, 
                                       level = 0)
accuracy(train.lm.trend.season.pred,valid.ts)

###########################################################################
# Model 2: Simple Moving Average
ma <- rollmean(x,k=12,align="right")
summary(ma)
# Observe the difference between forecasted ma vs original data x
ma
x
# Calculate MAPE
MAPE = mean(abs((ma-x)/x),na.rm=T)
MAPE

##########################################################################
# run simple exponential smoothing
# and alpha = 0.2 to fit simple exponential smoothing.
ses <- ses(train.ts, alpha = 0.2, h=36)
autoplot(ses)
accuracy(ses,valid.ts)
# Use ses function to estimate alpha
ses1 <- ses(train.ts, alpha = NULL, h=36)
summary(ses1)
accuracy(ses1,valid.ts)

# __________________________________
# ARIMA Model Time Series Analysis
# __________________________________

# start: the time of the first observation
# frequency: number of times per year
x <- ts(data[,2],start=c(2012,1),frequency=12)
x

# Observe the data: homscedasticity?
# Increasing variances over time
plot(x)

# log transformation to achieve homoscedasticity
z<- log10(x)
plot(z)

# Observe the data: stationary?
# Increasing mean over time
# The data has a trend, let's take the difference
y <- diff(z)
plot(y)

# Is the data random walk?
# Use Phillips-Perron Unit Root Test to check if the data is random walk
# If p-value is significant, reject the null hypothesis (i.e., data is not random walk)
PP.test(y)

# ACF test for White Noise
# ACF shows correlation between y_t and lagged terms y_(t-h)
# The figure suggests seasonal lagged autocorrelation
acf(y,main="Question Volume")


# Use auto.arima function in the package "forecast"
# Apply auto.arima to data without differencing
ARIMAfit <- auto.arima(z, approximation=FALSE,trace=TRUE)

summary(ARIMAfit)

# Use the best ARIMA model to forecast future scales
pred <- predict(ARIMAfit,n.ahead=36)
pred

# Plot the data
# Remember initial log-transformation?
par(mfrow = c(1,1))
plot(x,type='l',xlim=c(2012,2030),ylim=c(1,3000),xlab = 'Year',ylab = 'Question Volume')
lines(10^(pred$pred),col='blue') 
lines(10^(pred$pred+2*pred$se),col='orange')
lines(10^(pred$pred-2*pred$se),col='orange')


plot(train.lm.pred, ylim = c(0, 350),  ylab = "Question Volume", xlab = "Time", 
     bty = "l", xaxt = "n", xlim = c(2012,2020),main = "", flty = 2)
axis(1, at = seq(2012, 2020, 1), labels = format(seq(2012, 2020, 1)))

