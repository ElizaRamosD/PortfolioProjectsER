# App Rating prediction

# DESCRIPTION

Objective: Make a model to predict the app rating, with other information about the app provided.


Data dictionary:

Reviews: Number of user reviews for the app

Size: Size of the app

Installs: Number of user downloads/installs for the app

Type: Paid or Free

Price: Price of the app

Content Rating: Age group the app is targeted at - Children / Mature 21+ / Adult

Genres: An app can belong to multiple genres (apart from its main category). For example, a musical family game will belong to Music, Game, Family genres.

Last Updated: Date when the app was last updated on Play Store

Current Ver: Current version of the app available on Play Store

Android Ver: Minimum required Android version

# Data:

The head of our data set:

![image](https://user-images.githubusercontent.com/84399055/153304643-345b8ec0-9a17-4299-beaf-83f7b741103a.png)


Some stats:



![image](https://user-images.githubusercontent.com/84399055/153304441-5e433ebd-cd0b-4236-86d7-d62e91906a8d.png)

After cleaning the data we performed Univariate Analysis:

Histogram for Ratings shows the ocurrence of different values in ratings are toward higher rating. They are higher in 4.5 and then, they decrease a little bit

![image](https://user-images.githubusercontent.com/84399055/153305190-3970da95-15ee-48b6-8d12-0f582d99f2ea.png)


# Bivariate Analysis:

- Most apps show free, but it doesn't seem a relationship between free apps and high rating

- The regression line shows a sligh positive correlation on the other hand most app are free or less than $15, so there is no conclusive

- The increase in size does not guarantee a high rating. The majority of heavier apps shows to have better rating

- More reviews necessarily doesn't mean a better rating.

- Content Rating: Everyone, Teen, Everyone 10+ looks they are in a close range with the same Rating. For the Mature 17+ looks to have the lowest mean together with the group of Unrated. Adults only 18+ have the highest mean.

- The Genres with the highest mean are Health and Fitness, Books and Reference and Events

- The Genre with lower mean Rating is Dating

# Technique: Linear Regression

 - The Adjusted R-squared is 0.987 which means is very close to 1, so the correlation between the predicted and the test value is good

   


