# Examining Factors Responsible for Heart Attacks

## DESCRIPTION

Cardiovascular diseases are one of the leading causes of deaths globally. To identify the causes and develop a system to predict potential heart attacks in an effective manner 
is necessary. The data presented has all the information about relevant factors that might have an impact on cardiovascular health. 
The data needs to be studied in detail for further analysis.

There is one dataset data that has 14 attributes with more than 4000 data points.

You are required to determine and examine the factors that play a significant role in increasing the rate of heart attacks. 
Also, use the findings to create and predict a model.

Steps to perform:
Importing, Understanding, and Inspecting Data :

![image](https://user-images.githubusercontent.com/84399055/153450940-6bed94e8-a2e2-48a3-858c-6b2c9de7b193.png)


Perform preliminary data inspection and report the findings as the structure of the data, missing values, duplicates, etc.

Based on the findings from the previous question, remove duplicates (if any) and treat missing values using an appropriate strategy.

Get a preliminary statistical summary of the data. Explore the measures of central tendencies and the spread of the data overall.

![image](https://user-images.githubusercontent.com/84399055/153451271-128e816f-2bc1-4cd9-98e6-d81db3fe39c3.png)


![image](https://user-images.githubusercontent.com/84399055/153454416-77e77da7-a51e-4681-a16d-844e167aca9e.png)

![image](https://user-images.githubusercontent.com/84399055/153454984-9e4c284a-fc2d-4ea9-b25a-7ece14afb321.png)

![image](https://user-images.githubusercontent.com/84399055/153455068-d4723e4a-f2be-4f87-844d-bfe1fc139c7b.png)

![image](https://user-images.githubusercontent.com/84399055/153455170-2b6a06e7-8850-4715-8f54-b4a00c2a4ebd.png)

## Performing EDA and Modeling:

a) Identify the data variables which might be categorical in nature. Describe and explore these variables using appropriate tools. For example: count plot.

### Univariate Analysis:
![image](https://user-images.githubusercontent.com/84399055/153455725-9ce8e8d1-05b9-4a27-afde-eb9213253967.png)

![image](https://user-images.githubusercontent.com/84399055/153455931-134ed943-29c5-4f8f-af27-480e18b20fb2.png)

Observation:

- We clear see that in a study of 302 people we found:
  
   The most common chest pain type is 'typical angina' with a 143 count, follow by 'non-anginal pain' with a count of 86, the type of chest pain: atypical angina recorded a number of 50, and finally the less ocurrence in chest pain type: asymptomatic has a count of 23.
   
   ![image](https://user-images.githubusercontent.com/84399055/153456070-14a3b6b5-e15d-486e-afa2-55467b77456e.png)

![image](https://user-images.githubusercontent.com/84399055/153456156-02287564-2efc-4e48-b493-3a7478cad61c.png)


b) Study the occurrence of CVD (Cardiovascular Disease) across different ages.

![image](https://user-images.githubusercontent.com/84399055/153456252-1eb7313e-40db-4666-a8a1-87da9d78e876.png)


c) Can we detect heart attack based on anomalies in resting blood pressure of the patient?

![image](https://user-images.githubusercontent.com/84399055/153456758-f66f7b74-46a1-4ab1-9fdb-da792a26bf41.png)


d) Study the composition of overall patients w.r.t . gender.

![image](https://user-images.githubusercontent.com/84399055/153456849-4e17030c-0d67-405d-a8c5-39fa8426ecaa.png)


e) Describe the relationship between cholesterol levels and our target variable.

![image](https://user-images.githubusercontent.com/84399055/153456933-7b3a54d4-35b9-49b1-89ff-a4b0a6958760.png)


f) What can be concluded about the relationship between peak exercising and occurrence of heart attack?

![image](https://user-images.githubusercontent.com/84399055/153457061-e1603856-94b0-40ab-a10a-c25fc7f4d387.png)

![image](https://user-images.githubusercontent.com/84399055/153457207-603ff314-76b5-49ac-bc61-53693ad8ceca.png)

g) Is thalassemia a major cause of CVD? How are the other factors determining the occurrence of CVD?

![image](https://user-images.githubusercontent.com/84399055/153457267-34aec6b3-02ee-4f03-ab89-99cc8c43435c.png)


h) Use a pair plot to understand the relationship between all the given variables.



i) Perform logistic regression, predict the outcome for test data, and validate the results by using the confusion matrix.

![image](https://user-images.githubusercontent.com/84399055/153457529-0524f71b-8374-4c22-a8a4-012e3c694dec.png)
