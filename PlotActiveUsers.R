setwd("C:/Users/Administrator/OneDrive - Goldsmiths College/PyASMR/")

# K-means -----------------------------------------------------------------


## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
library(ggstatsplot)
library(ggpubr)
library(dplyr)
library(Rmisc)
library(lubridate)
library(plotly)
library(tidyverse)
library(htmlwidgets)
library(grid)
library(reshape2)


dataset = read.csv('ActiveUsersSummary.csv')

dataset <- na.omit(dataset)

# Convert DateTime column into a DateTime category R can recognise + collate multiple formats into one

dataset$DateTime = parse_date_time(x = dataset$DateTime,
                orders = c("d/m/Y H:M", "Y-m-d H:M"),
                tz = "GMT",
                locale = "eng")

dataset$Date = parse_date_time(x = dataset$Date,
                                   orders = c("d/m/Y", "Y-m-d"),
                                   tz = "GMT",
                                   locale = "eng")

# find out IQR and remove outliers based off of this
boxplot(dataset$ActiveUsers, plot=TRUE)$out
Q <- quantile(dataset$ActiveUsers, probs=c(.25, .75), na.rm = FALSE)
iqr <- IQR(dataset$ActiveUsers)
up <-  Q[2]+2.5*iqr # Upper Range  
low<- Q[1]-2.5*iqr # Lower Range
cleandataset<- subset(dataset, dataset$ActiveUsers > (Q[1] - 2.5*iqr) & dataset$ActiveUsers < (Q[2]+2.5*iqr))
# boxplot(cleandataset$ActiveUsers)


# Convert DateTime column into a DateTime category R can recognise
# cleandataset$DateTime <- as.POSIXct(cleandataset$DateTime)#, format = "%d/%m/%Y %H:%M")
# cleandataset$Date <- as.POSIXct(cleandataset$Date, format = "%d/%m/%Y")

# cleandataset$DateTime = str_sub(cleandataset$DateTime, start = 3)


cleandataset$Weekday <- wday(cleandataset$DateTime, label = TRUE, abbr = TRUE)

weekdayview <-cleandataset %>%
  group_by(Time, Weekday) %>% 
  summarise(across(ActiveUsers, mean))
# weekdayview$DayTime <- paste(weekdayview$Weekday, "-", weekdayview$Time)
# 
# weekdayview$DayTime <- as.POSIXct(weekdayview$DayTime, tz = "", format = "%a - %H:%M")

dayLabs<-c("Mon","Tue","Wed","Thu","Fri","Sat","Sun") 
weekdayview$Weekday <- factor(weekdayview$Weekday, levels= dayLabs)
weekdayview<-weekdayview[order(weekdayview$Weekday), ]


# calculate mean for dashed line
ASMRmean <- mean(cleandataset$ActiveUsers, trim = 0, na.rm = FALSE)

# save plot object with various settings
# interactiveASMR <- ggplot(data = cleandataset, aes(x = c(DateTime, Time) y = ActiveUsers)) +
#   labs(x = "Date & Time (GMT+1)", 
#        y = "Active Users",
#        title = "Number of reddit users browsing the /r/ASMR subreddit (dashed line = mean)",
#        caption = "dashed line = mean") +
#   geom_point(alpha=0.7, colour = "#f55f02") + #orange
#   # geom_point(alpha=0.7, colour = "#51A0D5") + #blue
#   geom_line() +
#   geom_hline(yintercept=ASMRmean, linetype="dashed", color = "#2C528C", size=0.5) +
#   theme_classic()

# save plot object with various settings
interactiveASMR <- ggplot(data = weekdayview, aes(x = Time, y = ActiveUsers, group = Weekday)) +
  labs(x = "Time (GMT)", 
       y = "Active Users",
       title = paste0("Number of reddit users browsing the /r/ASMR subreddit from ", cleandataset$Date[1], " to " ,cleandataset$Date[length(cleandataset$Date)],"\n (dashed line = mean)"),
       caption = "dashed line = mean") +
  geom_point(alpha=0.7, colour = "#f55f02") + #orange
  # geom_point(alpha=0.7, colour = "#51A0D5") + #blue
  geom_line(aes(color=Weekday)) +
  geom_hline(yintercept=ASMRmean, linetype="dashed", color = "#2C528C", size=0.5) +
  theme_classic() +
  scale_x_discrete(breaks=c("00:00", "04:00", "08:00", "12:00", "16:00", "20:00"))#,
                    #labels=c("00:00", "04:00", "08:00", "12:00", "16:00", "20:00"))

# plot interactively
ggplotly(interactiveASMR)

