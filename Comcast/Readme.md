# Comcast Telecom Consumer Complaints. (R project)

# DESCRIPTION 

Comcast is an American global telecommunication company. 
The firm has been providing terrible customer service. They continue to fall short despite repeated promises to improve. Only last month (October 2016)
the authority fined them a $2.3 million, after receiving over 1000 consumer complaints. The existing database will serve as a repository of public customer complaints filed 
against Comcast. It will help to pin down what is wrong with Comcast's customer service.

Data Dictionary

• Ticket #: Ticket number assigned to each complaint

• Customer Complaint: Description of complaint 

• Date: Date of complaint

• Time: Time of complaint

• Received Via: Mode of communication of the complaint 

• City: Customer city

• State: Customer state

• Zipcode: Customer zip

• Status: Status of complaint

• Filing on behalf of someone Analysis Task


Import data into R environment.

# Data:

![image](https://user-images.githubusercontent.com/84399055/153307573-e723acbd-f681-446b-b77f-ff4b722abe74.png)


• Provide the trend chart for the number of complaints at monthly and daily granularity levels.


![image](https://user-images.githubusercontent.com/84399055/153307934-bd7c8191-840f-4fbc-a5c9-e89695916f28.png)

## Analysis: 
 
 We clearly see that the month with more complaints is June with 1046 complaints and the month with lower complaints is November with 38
 

Let's see daily granularity level

![image](https://user-images.githubusercontent.com/84399055/153308303-5804ff1f-db22-4998-9119-c6c32f97042d.png)

## Analysis:

The day with more complaints was the 24/06/2015 with 218 complaints


• Provide a table with the frequency of complaint types.

![image](https://user-images.githubusercontent.com/84399055/153308636-75ecb81b-2802-4dfb-8b9f-5f5c3b347505.png)

## Analysis:

We have so many "complaints description without being identified, which is something that the company have to work on in the future. Besides that, complaints related to Internet and biling issues are the most common registered


• Which complaint types are maximum i.e., around internet, network issues, or across any other domains.


• Create a new categorical variable with value as Open and Closed.

• Open & Pending is to be categorized as Open and Closed & Solved is to be categorized as Closed.

• Provide state wise status of complaints in a stacked bar chart.

![image](https://user-images.githubusercontent.com/84399055/153308935-2179e7c4-a69d-4bcf-b304-0dc9aa3fcd43.png)


The State with more Cases is Georgia with: Open: 208, Closed: 80

• Use the categorized variable from Q3. 

Provide insights on: 

• Which state has the maximum complaints

• Which state has the highest percentage of unresolved complaints

![image](https://user-images.githubusercontent.com/84399055/153309151-3b769c9e-f3a3-4a80-866f-b2cd81c25912.png)

The top 3 States with most unresolved complaints: Georgia= 80, California= 61, and Tennessee= 47


Provide the percentage of complaints resolved till date, which were received through the Internet and customer care calls.

![image](https://user-images.githubusercontent.com/84399055/153309418-fd13ca84-1dbd-4a38-b855-3a3a3af2e2e7.png)

![image](https://user-images.githubusercontent.com/84399055/153309580-71ac13e2-9c8d-43e2-ba93-b84df1bf8297.png)

Analysis: Most of the complaints were received Via: Customer Care Call, although the difference with the Internet is 1%.

- The analysis results to be provided with insights wherever applicable.


## Conclusion:

Comcast needs to work on most Internet and Billing issues. Due to the lack of standard description when the operators are filling the request, this tend to make an analysis not 100% accurate.

Recommendation in this case is to develop a better software to filling up these request with standard descriptions.

The States with bigger complaints are Georgia, California and Tennesse. Stakeholders needs to evaluate what is producing this major complaints (further analysis)

There is still 23% of Open tickets, needs to evaluate what it's causing this delay in resolving the issues. (further analysis)





