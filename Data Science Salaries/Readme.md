This project explores salaries among Data Science in the US

Steps performed:

1. Data from Github - (Glassdoor salaries - Year 2020)

Data:

![image](https://user-images.githubusercontent.com/84399055/153438024-894f3fd2-9e8d-4ceb-a02b-0d8c7559cc4e.png)

![image](https://user-images.githubusercontent.com/84399055/153438195-c8c4d8ca-33e5-4c1a-96e7-b85570a3d427.png)



2.  Data wrangling performed using Python - Pandas library

- We have records with a -1 which doesn't add value to it. We should delete them

- The '(Glassdoor est.)" is not adding value so we should remove it

- The 'Employer Provided Salary:' I think we should keep it (but in another column)

- Per Hour: we should keep it (but in another column)

- Add new columns for minumun and maximun salary (split Salary Estimate)

- Add a new column for avg salary

- Add a column for the most wanted skills


4. Visualization to communicate the findings in Tableau: https://public.tableau.com/app/profile/elizabeth.ramos/viz/DataScienceSalariesAnalysisinUS/DataScienceSalariesinUS
