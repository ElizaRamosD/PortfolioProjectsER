# Setting the working directory
getwd()
setwd("C:\\Users\\eliza\\OneDrive\\Desktop\\Cyclistic Project")

# Install the required packages
# tidyverse for data import and wrangling
# janitor for format data frame
# lubridate for date functions
# ggplot for data visualization

install.packages("janitor")
library(tidyverse)
library(janitor)
library(skimr)
library (lubridate)
library (ggplot2)
getwd()

# Step 1: Collect the Data
# New to add 1
# data found "here
# https://divvy-tripdata.s3.amazonaws.com/index.html

# There are several files but I will go with the 
# 12 files of most recent data
# From July 2020 to July 2021

jul_20<- read.csv("202007-divvy-tripdata.csv")
aug_20<- read.csv("202008-divvy-tripdata.csv")
sep_20<- read.csv("202009-divvy-tripdata.csv")
oct_20<- read.csv("202010-divvy-tripdata.csv")
nov_20<- read.csv("202011-divvy-tripdata.csv")
dec_20<- read.csv("202012-divvy-tripdata.csv")
jan_21<- read.csv("202101-divvy-tripdata.csv")
feb_21<- read.csv("202102-divvy-tripdata.csv")
mar_21<- read.csv("202103-divvy-tripdata.csv")
apr_21<- read.csv("202104-divvy-tripdata.csv")
may_21<- read.csv("202105-divvy-tripdata.csv")
jun_21<- read.csv("202106-divvy-tripdata.csv")

# Step 2: Wrangle data and combine into a single file
# Compare colunm names of the files
colnames(jul_20)
colnames(aug_20)
colnames(sep_20)
colnames(oct_20)
colnames(nov_20)
colnames(dec_20)
colnames(jan_21)
colnames(feb_21)
colnames(mar_21)
colnames(apr_21)
colnames(may_21)
colnames(jun_21)

# Compare the data types across all columns

compare_df_cols(jul_20, aug_20, sep_20, oct_20,
                nov_20, dec_20, jan_21, feb_21,
                mar_21, apr_21, may_21, jun_21,
                return = "mismatch")

# start_station_id and end_station_id 
# data type need to be changed to character
# for the following data frames:
# jul_20, aug_20, sep_20, oct_20, nov_20
# Convert to character to stack them correctly
 

jul_20 <- mutate(jul_20, start_station_id = as.character(start_station_id)
                 ,end_station_id = as.character(end_station_id))
aug_20 <- mutate(aug_20, start_station_id = as.character(start_station_id)
                 ,end_station_id = as.character(end_station_id))
sep_20 <- mutate(sep_20, start_station_id = as.character(start_station_id)
                 ,end_station_id = as.character(end_station_id))
oct_20 <- mutate(oct_20, start_station_id = as.character(start_station_id)
                 ,end_station_id = as.character(end_station_id))
nov_20 <- mutate(nov_20, start_station_id = as.character(start_station_id)
                 ,end_station_id = as.character(end_station_id))

# We compare the data types again

compare_df_cols(jul_20, aug_20, sep_20, oct_20,
                nov_20, dec_20, jan_21, feb_21,
                mar_21, apr_21, may_21, jun_21,
                return = "mismatch")

# Now, we can proceed to stack individual data frames into one
all_trips <- bind_rows(jul_20, aug_20, sep_20, oct_20,
                       nov_20, dec_20, jan_21, feb_21,
                       mar_21, apr_21, may_21, jun_21)

str(all_trips)
# Changing started_at and ended_at from chr to Posixct
all_trips <- mutate(all_trips, started_at = as.POSIXct(started_at)
                 ,ended_at = as.POSIXct(ended_at))
str(all_trips)

#--------- NEW No removed for Tableau -_____
# Removing start_lat, start_lng, end_lat, end_lng
all_trips <- all_trips %>% 
  select(-c(start_lat,start_lng,end_lat,end_lng))
#------------------
# Removing duplicates with the same ride_id
all_trips_v2 <- all_trips[!duplicated(all_trips$ride_id),]
print(paste(nrow(all_trips)-nrow(all_trips_v2), "duplicated rows were removed"))
str(all_trips_v2)

# Renaming column member_casual to usertype
all_trips_v2 <- rename(all_trips_v2, usertype = member_casual)

colnames(all_trips_v2)

# Lets inspect the data in each column to see it's accurate
unique(all_trips_v2$rideable_type)
unique (all_trips_v2$usertype)
unique(all_trips_v2$start_station_name)


#-----
# Step 3: Clean up and add Data to prepare for analysis
# Inspect the data frame
colnames(all_trips_v2)
nrow(all_trips_v2)
dim(all_trips_v2)
head(all_trips_v2)
str(all_trips_v2)
summary(all_trips_v2)
skim(all_trips_v2)
# Aggregate new column for date, year, month, day, hour for each ride
# to perform further operations aggregating data
all_trips_v2$date <- as.Date(all_trips_v2$started_at)
all_trips_v2$year <- format(as.Date(all_trips_v2$date), "%Y")
all_trips_v2$month <- format(as.Date(all_trips_v2$date), "%m")
all_trips_v2$day <- format(as.Date(all_trips_v2$date), "%d")
all_trips_v2$day_of_week <- format(as.Date(all_trips_v2$date), "%A")
all_trips_v2$start_hour <- strftime(all_trips_v2$started_at, "%H")


# Add a ride length calculation to all trips (in seconds)
all_trips_v2$ride_length <- difftime(all_trips_v2$ended_at,all_trips_v2$started_at)
str(all_trips_v2)

# Convert ride length from factor to numeric
is.factor(all_trips_v2$ride_length)
all_trips_v2$ride_length <- as.numeric(as.character(all_trips_v2$ride_length))
is.numeric(all_trips_v2$ride_length)

# Check the ride length > 0
skim(all_trips_v2$ride_length)
all_trips_v3 <- all_trips_v2[!(all_trips_v2$ride_length<0),]
skim(all_trips_v3)
head(all_trips_v3)

# Converting the name of the month
unique(all_trips_v3$month)
all_trips_v3$month[all_trips_v3$month=="01"] <- "Jan"
all_trips_v3$month[all_trips_v3$month=="02"] <- "Feb"
all_trips_v3$month[all_trips_v3$month=="03"] <- "Mar"
all_trips_v3$month[all_trips_v3$month=="04"] <- "Apr"
all_trips_v3$month[all_trips_v3$month=="05"] <- "May"
all_trips_v3$month[all_trips_v3$month=="06"] <- "Jun"
all_trips_v3$month[all_trips_v3$month=="07"] <- "Jul"
all_trips_v3$month[all_trips_v3$month=="08"] <- "Aug"
all_trips_v3$month[all_trips_v3$month=="09"] <- "Sep"
all_trips_v3$month[all_trips_v3$month=="10"] <- "Oct"
all_trips_v3$month[all_trips_v3$month=="11"] <- "Nov"
all_trips_v3$month[all_trips_v3$month=="12"] <- "Dec"

# Step 4: Conduct Descriptive Analysis
# How to find how casual riders differ from members
# Lets eavaluate the ride_length

summary(all_trips_v3$ride_length)
#------- 
#Compare casual and members 
ggplot(all_trips_v3)+
  geom_bar(mapping = aes(x = usertype, fill = usertype )) +
  labs(title = "Total Rides by User Type",
       x= "User Type", y= "Quantity") +
  scale_fill_manual("User Type", values = c("member" = "darkblue",
                                            "casual" = "lightblue"))
 
#------
 all_trips_v3 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(usertype, weekday) %>%
  summarise(number_rides = n(),
            avg_duration = mean(ride_length)/60) %>%
  arrange(usertype, weekday) %>%
  ggplot(aes(x= weekday, y= number_rides,
             fill = usertype)) +
  geom_col(position = "dodge") +
  labs(x = "User Type", title = "Number of Rides by User")+
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual("User Type", values = c("member" = "darkblue",
                                        "casual" = "lightblue"))

# Compare number of rides by user type
 all_trips_v3 %>%
  group_by(usertype) %>%
  summarise(ride_mean = mean(ride_length)/60,
            ride_median = median(ride_length)/60,
            ride_max = max(ride_length)/60,
            ride_min = min(ride_length)/60)
 
# Compare summary for user type and weekday,
# number of rides, and average duration
all_trips_v3$day_of_week <- ordered( all_trips_v3$day_of_week,
                                     levels = c("Sunday", "Monday",
                                                "Tuesday", "Wednesday",
                                                "Thursday", "Friday",
                                                "Saturday"))

all_trips_v3 %>%
  group_by(usertype, day_of_week) %>%
  summarise(number_rides = n(),
            avg_duration = mean(ride_length)/60) %>%
  ggplot(aes(x=day_of_week, y= avg_duration,
            fill = usertype)) +
  geom_col(position = "dodge") +
  labs(x = "Weekday", title = "Avg Ride Duration by Weekday")+
  theme(axis.text.x=element_text(angle= 25), 
        plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual("User Type", values = c("member" = "darkblue",
                                            "casual" = "lightblue"))

#-----
# Top 15 stations with more casual riders
top_15_stations <- all_trips_v3 %>%
  group_by(start_station_name, usertype) %>%
  summarise(number_of_ride = n(), .groups = 'drop') %>%
  filter(start_station_name != "", usertype != 'member') %>%
  arrange(-number_of_ride) %>%
  head(n=15) %>%
  select(-usertype)
top_15_stations  
#-----
# Distribution of riders by Type of bike
all_trips_v3 %>% 
  group_by(rideable_type, usertype) %>%
  summarise(number_of_ride = n()) %>%
  ggplot(aes(x= rideable_type, y= number_of_ride, fill= usertype)) +
  labs(x= "Type of Bike", title= "Users by Type of Bike") +
  geom_col(position = "dodge") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual("User Type", values = c("member" = "darkblue",
                                       "casual" = "lightblue"))
#-----
# Distribution by Type of User per hour 
all_trips_v3 %>% 
  ggplot(aes(x= start_hour, fill= usertype)) +
  labs(x= " Start Hour", 
       title= "Distribution by User Type per Hour") +
  geom_bar() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x=element_text(angle= 90), 
      plot.title = element_text(hjust = 0.5))+
  scale_fill_manual("legend", values = c("member" = "darkblue",
                                         "casual" = "lightblue"))


#----
# Distribution by Type of User per hour for each day
all_trips_v3 %>% 
  ggplot(aes(x= start_hour, fill= usertype)) +
  labs(x= " Start Hour", 
       title= "Distribution by User/hour per Day") +
  geom_bar() +
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~day_of_week) +
  theme(axis.text.x=element_text(angle= 90), 
        plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual("User Type", values = c("member" = "darkblue",
                                         "casual" = "lightblue"))

getwd()

write.csv(all_trips_v3, file = "all_trips_v3.csv")
