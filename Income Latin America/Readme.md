# Identify the level of income qualification needed for the families in Latin America.

Last Updated: 08/16/2021


## Problem Statement Scenario:

Many social programs have a hard time ensuring that the right people are given enough aid. It’s tricky when a program focuses on the poorest segment of
the population. This segment of the population can’t provide the necessary income and expense records to prove that they qualify.

In Latin America, a popular method called Proxy Means Test (PMT) uses an algorithm to verify income qualification. With PMT, agencies use a model that considers a family’s observable household attributes like the material of their walls and ceiling or the assets found in their homes to classify them and predict their level of need.

While this is an improvement, accuracy remains a problem as the region’s population grows and poverty declines.

The Inter-American Development Bank (IDB)believes that new methods beyond traditional econometrics, based on a dataset of Costa Rican household characteristics, might help improve PMT’s performance. Following actions should be performed:

Identify the output variable.

![image](https://user-images.githubusercontent.com/84399055/153474090-c3742a9e-2c13-439a-adf6-50f897bfab69.png)

![image](https://user-images.githubusercontent.com/84399055/153474179-40bdc235-bee5-42ce-827a-b1935888db93.png)

Our Test Data Set there are 129 integer columns, 8 float (numeric) columns, and 5 object columns. 

The test data has many more rows (23856 compared to 9557 in the Train data set)

There is no Target --It does have one fewer column.

Check if there are any biases in your dataset.

![image](https://user-images.githubusercontent.com/84399055/153475635-15833aba-9cba-42d8-8d5f-cdd0449ba637.png)

![image](https://user-images.githubusercontent.com/84399055/153476952-87a5f2f7-4919-4bab-bd7c-45fce5cda4dd.png)

Bias Analysis: extreme poverty (1) is the smallest count in the train dataset with 222 count. The dataset is biased.

Check if there is a house without a family head.----------------------------

Set poverty level of the members and the head of the house within a family.
![image](https://user-images.githubusercontent.com/84399055/153476194-6ee768ad-1347-464f-8206-75f051fb5ec2.png)

![image](https://user-images.githubusercontent.com/84399055/153477221-7cfb73af-e5cf-4cea-a22f-6eefc9268abd.png)

Count how many null values are existing in columns.

Remove null value rows of the target variable.

Predict the accuracy using random forest classifier.

Check the accuracy using random forest with cross validation.

![image](https://user-images.githubusercontent.com/84399055/153477996-7246fa80-dcd9-40b5-a2ba-03417ddacdbb.png)
