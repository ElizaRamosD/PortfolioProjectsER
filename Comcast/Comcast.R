# Comcast Telecom Consumer Complaints
# by Elizabeth Ramos
# June, 2021

# Analysis Tasks:
# 1.- Import data into R environment.
# Working Directory
getwd()
setwd("C:/Users/eliza/OneDrive/Desktop/Comcast Project")

# Import the necessary packages and libraries

# tidyverse for data import and wrangling
# janitor for format data frame
# lubridate for date functions
# kbl for Table Visualization
# ggplot for data visualization

install.packages("zipcodeR")
install.packages("kableExtra")
library(tidyverse)
library (stringi)
library(janitor)
library (lubridate)
library(kableExtra)
library (ggplot2)

# Load the file
complaints <- read.csv("Comcast Telecom Complaints data.csv")

# Cleaning and checking the data

# Lets take a look at the data
head(complaints)
str(complaints)
View(complaints)
# We found the following:
# - Date has different formats
# - Some column names has some dots

# Fixing the date format
complaints$Date <- dmy(complaints$Date)

# Fixing the column names
names(complaints) <- stri_replace_all(regex = "\\.", replacement = "",
                               str = names(complaints))

# Checking for any missing values in the data set
empty_values <- is.na(complaints)

# Check if any TRUE >=1 
length(empty_values[empty_values==TRUE])

# It returned 0, so there is not missing values in the data set
# Lets check for any value that is not correct
unique(complaints$Ticket) # 2224 records, unique values

unique(complaints$CustomerComplaint)

# The customer complaints column is not filled with standards words
# It will be analyzed later 

unique(complaints$ReceivedVia)

unique(complaints$City)
# We found few cities misspelled
complaints$City <-  str_replace(complaints$City,"Albuquerqur", "Albuquerque")
complaints$City <-  str_replace(complaints$City,"Colorado Spring", "Colorado Springs")

# Check the State
unique(complaints$State)
complaints$State <-  str_replace(complaints$State,"District Of Columbia", "District of Columbia")

#Check the Zip Code
unique(complaints$Zipcode)
# There are several zip codes with 4 numbers, lets filled with 0

complaints$Zipcode <- str_pad(complaints$Zipcode, 
                              pad = "0", width = 5)

#Check the Status
unique(complaints$Status)
# Nice: Closed, Open, Solved and Pending

# Check the Filling on behalf of someone 
unique(complaints$FilingonBehalfofSomeone)

# Data is clean, ready for Analysis

# 1.- Provide the trend chart for the number of complaints at 
# monthly and daily granularity levels.

# a) Monthly Level

monthly_c <- complaints %>%
  group_by(Month = as.integer(month(Date))) %>%
  summarise(Total_c = n())
 
# Ordering the month            
monthly_c <- arrange(monthly_c, Month)
monthly_c

# Now lets plot the monthly data
ggplot(data=monthly_c, aes(Month, Total_c, label= Total_c)) +
  geom_line(size = 1, color="red") +
  labs(title = "Number of Complaints per Month",
       x = "Month", y = "Number of Complaints") +
  scale_x_continuous(breaks = monthly_c$Month) + 
  theme(plot.title = element_text(hjust=0.5)) +
  geom_label(position = position_dodge(0.3))

# Analysis: 
# We clearly see that the month with more complaints is June
# with 1046 complaints
# and the month with lower complaints is November with 38


# Plotting Daily Complaints

# Lets group the complaints by date
daily_c <- complaints %>%
  group_by(Date) %>%
  summarise(n_comp = n())

# Lets visualize the data
ggplot(daily_c, aes(as.POSIXct(Date), n_comp)) +
  geom_line(color="red") +
  labs(title= "Number of Complaints per Day",
       x = "Days", y = " Number of Complaints") +
  scale_x_datetime(breaks = "1 weeks", date_labels ="%d/%m") +
  theme(plot.title = element_text(hjust=0.5),
        axis.text.x = element_text(angle=90))

# Analysis: The day with more complaints was 
# the 24/06/2015 with 218 complaints
# What happened in Comcast that day?

# 2.- Provide a table with the frequency of complaint types.
# Since, the column with "Type of Complaints" does not exists
# We need to create it based on the complaints's description

t_internet <- contains(complaints$CustomerComplaint, match="internet", ignore.case = "T")
t_payment <- contains(complaints$CustomerComplaint, match="payment", ignore.case = "T")
t_xfinity <- contains(complaints$CustomerComplaint, match="xfinity", ignore.case = "T")
t_billing <- contains(complaints$CustomerComplaint, match="billing", ignore.case = "T")
t_datacap <- contains(complaints$CustomerComplaint, match="data cap", ignore.case = "T")
t_fee <- contains(complaints$CustomerComplaint, match="fee", ignore.case = "T")
t_bcustomer <- contains(complaints$CustomerComplaint, match="customer", ignore.case = "T")
t_hbo <- contains(complaints$CustomerComplaint, match="hbo", ignore.case = "T")
t_price <- contains(complaints$CustomerComplaint, match="price", ignore.case = "T")
t_contract <- contains(complaints$CustomerComplaint, match="contract", ignore.case = "T")
t_bait <- contains(complaints$CustomerComplaint, match="bait", ignore.case = "T")
t_charges <- contains(complaints$CustomerComplaint, match="charges", ignore.case = "T")

#Lets create a new column in the data set with these values
complaints$Type[t_internet] <- "Internet"
complaints$Type[t_payment] <- "Payment"
complaints$Type[t_xfinity] <- "Xfinity"
complaints$Type[t_billing] <- "Billing"
complaints$Type[t_datacap] <- "Data Cap"
complaints$Type[t_fee] <- "Fee"
complaints$Type[t_bcustomer] <- "BadCustomerService"
complaints$Type[t_hbo] <- "HBO"
complaints$Type[t_price] <- "Price"
complaints$Type[t_contract] <- "Contract"
complaints$Type[t_bait] <- "Bait"
complaints$Type[t_charges] <- "Charges"

#There are a lot of complaints that not qualify for 
#the previous description, let fill with "Other" status
complaints$Type[-c(t_internet,t_payment,t_xfinity,t_billing,
                   t_datacap, t_fee, t_bcustomer, t_hbo,
                   t_price,t_contract,t_bait,t_charges)]<- "Other"

# Now, we can create the frequency table
# Lets organize the data 
f_complaints <- complaints %>%
  group_by(Type)%>%
  summarise(Frequency = n())

f_complaints<- arrange(f_complaints,(-Frequency))
f_complaints

# Lets make a visual appealing table

kbl(f_complaints, align = 'c',
    caption="Frequency by 5Complaint Type") %>%
  kable_paper("striped", full_width = F) %>%
  column_spec(1, bold = T, border_right = T) %>%
  column_spec(2, width = "5em") 

# We have so many "complaints description
# without being identified, which is something that
# the company have to work on in the future
# Besides that, complaints related to Internet and biling
# issues are the most common registered

# 2. Create a new categorical variable with the values
# of Open and Closed 
# Open and Pending to categorized as Open
# Closed and Solved is to be categorized as Closed

open_complaints <- (complaints$Status =="Open" 
                    | complaints$Status == "Pending")
closed_complaints <- (complaints$Status =="Closed" 
                      | complaints$Status == "Solved")

# Now we add a new categorical variable with these observations
complaints$NewStatus[open_complaints]<- "Open"
complaints$NewStatus[closed_complaints]<- "Closed"

# Provide State Wise Status of complaints in a 
# stacked bar chart
complaints_state <- complaints %>%
  group_by(State,NewStatus) %>%
  summarise(Count_status = n())
complaints_state

# We plot the data in a stacked bar chart
ggplot (as.data.frame(complaints_state), 
        aes(x = State, y = Count_status,
            label = Count_status,width=0.6)) +
  geom_col(aes(fill= NewStatus)) +
  labs (title = "Complaints Status by State", 
        x = "States", y = "Number of Complaints") +
  theme(plot.title = element_text(hjust= 0.5),
        axis.text.x = element_text(angle = 90)) +
  scale_fill_manual(values = c("Open"="firebrick", "Closed"= "steelblue")) +
  geom_text(data = complaints_state,
            aes(label= Count_status), 
            size= 2.5)
# The State with more Cases is Georgia with:
# Open: 208, Closed: 80

# Which state has the highest percentage of unresolved complaints?
# If we use the data frame created previously 

max_open <- filter(complaints_state, NewStatus== "Open")
max_open <- arrange(max_open, desc(Count_status))
max_open

# The top 3 States with most unresolved complaints
# Georgia= 80, California= 61, and Tennessee= 47

# Percentage of unresolved complaints 
p_unresolved <- summarise(max_open, Perc_u = Count_status/nrow(max_open))
p_unresolved

#- Provide the percentage of complaints (by State) resolved until date
resolved <- filter(complaints_state, NewStatus== "Closed")
resolved
p_resolved <- summarise(resolved, Perc_r = Count_status/nrow(resolved))
p_resolved
             
#Percentage of all complaints (Open and Close)
t_complaints <- group_by(complaints, NewStatus)
t_complaints
p_open_close <- summarise(t_complaints,percentage=(n()/nrow(t_complaints)))
p_open_close

# Lets plot this data
# Step 1: Starting with a bar chart
# Step 2: Add color before converting to polar (avoid errors)
# Step 3: Converting it to polar coordinate system to make it round
# Step 4: Adding the title, removing axis labels and centering title
ggplot(p_open_close,
       aes(x= "",y = percentage,fill = NewStatus))+
  geom_bar(stat = "identity",width = 1)+ #Step1
  scale_fill_manual(values = c("Open"="firebrick", 
                               "Closed"= "steelblue")) + #Step 2
  coord_polar("y",start = 0)+
  geom_text(aes(label = paste0(round(percentage*100),"%")),
            position = position_stack(vjust = 0.5))+ #Step 3
  labs(x = NULL,y = NULL,fill = NULL, 
       title = "Percentage of Open and Closed Tickets")+ 
 theme_classic()+
 theme(axis.line = element_blank(),
       axis.text = element_blank(),
       axis.ticks = element_blank(),
       plot.title = element_text(hjust = 0.5)) # Step 4


# Which were received through the Internet and customer care calls.


# Lets see first how many are open and close by category
# Just to go a little deeper
resolved_via_sta <- group_by(complaints,ReceivedVia,NewStatus)
category_resloved<- summarise(resolved_via_sta,p_via =(n()/nrow(resolved_via_sta))) 
category_resloved
# Then just only by category
resolved_via <- group_by(complaints,ReceivedVia)
category_resloved_via <- summarise(resolved_via,p_via =(n()/nrow(resolved_via))) 
category_resloved_via
