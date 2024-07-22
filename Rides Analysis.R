# Set working directory and load required libraries
setwd("/home/conde/Programing/R/Projects/Uber Data Analysis/")
library(ggplot2)
library(ggthemes)
library(lubridate)
library(dplyr)
library(tidyr)
library(scales)
library(DT)

# ===== LOADING AND CLEANING DATA =====

# vector with the colors used in plotting functions
colors = c("#CC1011", "#665555", "#05a399", "#cfcaca", "#f5e840", "#0683c9", "#e075b0")

# load data sets and combine them into a single data frame
may_data <- read.csv("uber-raw-data-may14.csv")
apr_data <- read.csv("uber-raw-data-apr14.csv")
jun_data <- read.csv("uber-raw-data-jun14.csv")
jul_data <- read.csv("uber-raw-data-jul14.csv")
aug_data <- read.csv("uber-raw-data-aug14.csv")
sep_data <- read.csv("uber-raw-data-sep14.csv")
data_2014 <- rbind(may_data, apr_data, jun_data, jul_data, aug_data, sep_data)

# format date and create a time column
data_2014$Date.Time <- as.POSIXct(data_2014$Date.Time, format = "%m/%d/%Y %H:%M:%S")
data_2014$Time <- format(as.POSIXct(data_2014$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format = "%H:%M:%S")

# factor time and date into separate columns
data_2014$Day <- format(data_2014$Date.Time, "%d") # days
data_2014$Month <- format(data_2014$Date.Time, "%b") # months
data_2014$Year <- format(data_2014$Date.Time, "%Y") # years
data_2014$Day_of_week <- format(data_2014$Date.Time, "%A") # week days
data_2014$Hour <- factor(hour(hms(data_2014$Time))) # hours
data_2014$Minute <- factor(minute(hms(data_2014$Time))) # minutes
data_2014$Second <- factor(second(hms(data_2014$Time))) # seconds



# ===== TRIPS BY DATES ====
## total of trips by hours
hour_data <- data_2014 %>%
  group_by(Hour) %>%
  dplyr::summarize(Total = n()) 
# bar graph - number of trips by hours
ggplot(data = hour_data, aes(x = Hour, y = Total)) +
  geom_bar(stat = "identity", fill = "lightblue", color = "red") +
  ggtitle("Trips By Hour") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma)

# total trips by hours in a day
month_hour <- data_2014 %>%
  group_by(Month, Hour) %>%
  dplyr::summarize(Total = n())
# bar graph - number of trips by hour and month
ggplot(data = month_hour, aes( x = Hour, y = Total, fill = Month)) +
  geom_bar(stat = "identity") +
  ggtitle("Trips by Hour and Month") +
  scale_y_continuous(labels = comma)


## total trips by day
day_group <- data_2014 %>% # day of month
  group_by(Day) %>%
  dplyr::summarize(Total = n())
# bar graph - trips by day
ggplot(data = day_group, aes(x = Day, y = Total)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  ggtitle("Trips by Day") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma)

# trips by day of week
day_week_group <- data_2014 %>%  
  group_by(Day_of_week) %>%
  dplyr::summarize(Total = n())
# bar graph - trips by day of week
ggplot(data = day_week_group, aes(x = Day_of_week, y = Total)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  ggtitle("Trips by Day of Week") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma)
  

## total trips by month
month_group <- data_2014 %>%
  group_by(Month) %>%
  dplyr::summarize(Total = n())
# bar graph - trips by month
ggplot(data = month_group, aes(x = Month, y = Total)) +
  geom_bar(stat = "identity") +
  ggtitle("Trips by Month") +
  theme(legend.position = "none")

# trips by month and day of week
day_month_group <- data_2014 %>%
  group_by(Month, Day_of_week) %>%
  dplyr::summarize(Total = n())
# bar graph - trips by month and day of week
ggplot(data = day_month_group, aes(Month, Total, fill = Day_of_week)) +
  geom_bar(stat = "identity", position = "dodge") +
  ggtitle("Trips by Day and Month") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = colors)



# ===== TRIPS BY BASE ===== 
# bar graph - trips by base
ggplot(data = data_2014, aes(x = Base)) +
  geom_bar(fill = "darkblue") +
  scale_y_continuous(labels = comma) +
  ggtitle("Trips by Base")

# bar graph - trips by base per month
ggplot(data = data_2014, aes(x = Base, fill = Month)) +
  geom_bar(position = "dodge") +
  scale_y_continuous(labels = comma) +
  ggtitle("Trips by Base and Month") +
  scale_fill_manual(values = colors)

# bar graph - trips by base per day of week
ggplot(data = data_2014, aes(x = Base, fill = Day_of_week)) +
  geom_bar(position = "dodge") +
  ggtitle("Trips by Base and Day of Week") +
  scale_fill_manual(values = colors)



# ===== HEAT MAPS =====
# by day of month and hour
day_and_hour <- data_2014 %>%
  group_by(Day, Hour) %>%
  dplyr::summarize(Total = n())
ggplot(data = day_and_hour, aes(Day, Hour, fill = Total)) +
  geom_tile(color = "white") +
  ggtitle("Heat Map by Hour and Day")

# by month and day of month
month_and_day <- data_2014 %>%
  group_by(Month, Day) %>%
  dplyr::summarize(Total = n())
ggplot(data = month_and_day, aes(x = Day, y = Month, fill = Total)) +
  ggtitle("Heat Map by Month and Day") +
  geom_tile(color = "white")

# by month and day of week
month_and_day_week <- data_2014 %>%
  group_by(Month, Day_of_week) %>%
  dplyr::summarize(Total = n())
ggplot(data = month_and_day_week, aes(x = Day_of_week, y = Month, fill = Total)) +
  ggtitle("Heat Map by Month and Day of Week") +
  geom_tile(color = "white")

# by month and bases
month_bases <- data_2014 %>%
  group_by(Month, Base) %>%
  dplyr::summarize(Total = n())
ggplot(data = month_bases, aes(x = Base, y = Month, fill = Total)) +
  ggtitle("Heat Map by Month and Base") +
  geom_tile(color = "white")

# by day of week and bases
day_of_week_and_bases <- data_2014 %>%
  group_by(Day_of_week, Base) %>%
  dplyr::summarize(Total = n())
ggplot(data = day_of_week_and_bases, aes(x = Base, y = Day_of_week, fill = Total)) +
  ggtitle("Heat Map by Day of Week and Base") +
  geom_tile(color = "white")



# ===== MAP VISUALIZATION IN NEW YORK =====
# define NY city boundaries
min_lat <- 40.5774
max_lat <- 40.9176
min_long <- -74.15
max_long <- -73.7004

# plot map of Uber rides
ggplot(data = data_2014, aes(x = Lon, y = Lat)) +
  geom_point(size = 1, color = "blue") +
  scale_x_continuous(limits = c(min_long, max_long)) +
  scale_y_continuous(limits = c(min_lat, max_lat)) +
  theme_map() +
  ggtitle("NYC Map Based on Uber Rides During Apr-2014 to Sep-2014")
  
# plot map of Uber rides by Base
ggplot(data = data_2014, aes(x = Lon, y = Lat, color = Base)) +
  geom_point(size = 1) +
  scale_x_continuous(limits = c(min_long, max_long)) +
  scale_y_continuous(limits = c(min_lat, max_lat)) +
  theme_map() +
  ggtitle("NYC Map Base on Uber Rised During Apr-2014 to Sep-2014 by Base")
