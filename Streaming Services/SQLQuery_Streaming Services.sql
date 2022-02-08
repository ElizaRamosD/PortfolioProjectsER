-- Streaming Services Project

-- Data CLeaning and EDA by Elizabeth Ramos

-- Data collected from Kaggle. Several files combined using Excel

-- Let's take a look of the data set first

SELECT *  FROM [Movies].[dbo].[Channels]

/* First impressions
1. The Director column has a lot of NULL values
2. The date_added it's a date/time, we don't need the time
3. Release year should be date type
4. The column new_rating was created in Excel before but it wasn't populated, so we need to populated with the correct rating
*/


-- Let's check for duplictes in the column show_id (sanity check)
SELECT COUNT(show_id)
FROM Movies.dbo.Channels 
GROUP BY show_id
HAVING COUNT(show_id) >1

-- We got 0 duplicates for show_id
-- Let's look for duplicates in the title column per Channel
-- We can have the samme Title but in different channels
-- Amazon show_id =a%

SELECT COUNT(*),
title
FROM [Movies].[dbo].Channels
WHERE show_id like 'a%' 
GROUP BY title
HAVING   COUNT(*) >1
ORDER BY title
----------
-- We have 17 duplicate records that need to be deleted for amazon
-- Let' create a CTE to delete those records
WITH Title_New AS (
					SELECT *, 
					ROW_NUMBER() OVER (PARTITION BY title 
									   ORDER BY title) AS RowNumber 
					FROM [Movies].[dbo].Channels
					WHERE show_id LIKE 'a%'
					)
--SELECT * FROM Title_New
--WHERE RowNumber >1

-- Now, instead of select let's change it for DELETE

DELETE FROM Title_New
WHERE RowNumber >1
-- 17 rows affected.
-- Let's do the same for Disney+, Hulu and Netflix

-- Disney+
SELECT COUNT(*),
title
FROM [Movies].[dbo].Channels
WHERE show_id LIKE 'd%'
GROUP BY title
HAVING COUNT(*)>1
ORDER BY title

-- no duplicates
-- Hulu
SELECT COUNT(*),
title
FROM [Movies].[dbo].Channels
WHERE show_id LIKE 'h%'
GROUP BY title
HAVING COUNT(*) >1
ORDER BY title

-- We got 2 rows, let's delete those records
WITH Title_New AS (
				   SELECT *,
				   ROW_NUMBER() OVER  (PARTITION BY title
										ORDER BY title) RowNumber
					FROM [Movies].[dbo].Channels
					WHERE show_id LIKE 'h%'
					)
--SELECT * FROM Title_New WHERE RowNumber>1

DELETE FROM Title_New WHERE RowNumber>1

-- 2 rows affected
-- Netflix
SELECT COUNT(*),
title
FROM [Movies].[dbo].Channels
WHERE show_id LIKE 's%'
GROUP BY title
HAVING COUNT(*) >1
ORDER BY title

-- We got 8 rows
WITH Title_New AS (
				   SELECT *,
				   ROW_NUMBER() OVER  (PARTITION BY title
										ORDER BY title) RowNumber
					FROM [Movies].[dbo].Channels
					WHERE show_id LIKE 's%'
					)
--SELECT * FROM Title_New WHERE RowNumber>1
DELETE FROM Title_New WHERE RowNumber>1

---8 rows affected

SELECT * FROM Movies.dbo.Channels

--type column
SELECT DISTINCT(type) 
FROM Movies.dbo.Channels

-- We got only two types: Movie and Tv Show

-----------
-- Let's check for NULL values in the director column
SELECT show_id,
title,
COUNT (*) number
FROM Movies.dbo.Channels
WHERE director IS  NULL
GROUP BY show_id, title
ORDER BY title

-- There are 8,258 movie titles without a Director, it's about 35.9%, that's a lot. Let's try to populated as much
-- as we can from the exact same movie title from other channel 


-- If the title has an director and the same title hasn't, let's populate it with the first director
SELECT 
m1.title,
m1.director,
m2.title,
m2.director,
ISNULL(m1.director,m2.director)
FROM Movies.dbo.Channels m1
JOIN Movies.dbo.Channels m2
	ON m1.title = m2.title
	AND m1.show_id<> m2.show_id
WHERE m1.director IS NULL

-- There are 1021 rows that potentially we can populate some of them
-- Let's update the table
-- Let's update it
UPDATE m1
SET m1.director =ISNULL(m1.director, m2.director)
FROM Movies.dbo.Channels m1
JOIN Movies.dbo.Channels m2
	ON m1.title = m2.title
	AND m1.show_id <> m2.show_id
WHERE m1.director IS NULL

-- 901 rows affected, decent number, let's check it out
SELECT show_id,
title,
COUNT (*) number
FROM Movies.dbo.Channels
WHERE director IS  NULL
GROUP BY show_id, title
ORDER BY title

-- Now we have 7931 movies without director, for Tableau purposes let's fill this with "n/a"
SELECT * FROM 
 Movies.dbo.Channels
 WHERE director IS NULL

UPDATE Movies.dbo.Channels
SET director = 'n/a'
WHERE director IS NULL
-- Now, we filled it out the most we could and for the rest they are 'n/a'

-------------
-- Let's change the format of date_added from date/time to only date
SELECT date_added, 
CONVERT(date, date_added)
FROM Movies.dbo.Channels

-- Let's add a new column to add the new_date format
ALTER TABLE Movies.dbo.Channels
ADD date_included Date

-- Let's update it
UPDATE Movies.dbo.Channels
SET date_included = CONVERT(date, date_added)

-- Let's check it out the changes
SELECT * FROM Movies.dbo.Channels

-- Let's drop off the date_added because is not needed anymore
ALTER TABLE Movies.dbo.Channels
DROP COLUMN date_added

-------------

-- Let's work with the cast column
-- Let's check for NULL values in the cast column
SELECT COUNT(*)
FROM Movies.dbo.Channels
WHERE cast IS NULL

-- We got 5320 rows, not bad
-- Let's fill if is possible with some of the mmovies from other channels

SELECT 
m1.title,
m1.cast,
m2.title,
m2.cast,
ISNULL(m1.cast,m2.cast)
FROM Movies.dbo.Channels m1
JOIN Movies.dbo.Channels m2
	ON m1.title = m2.title
	AND m1.show_id<> m2.show_id
WHERE m1.cast IS NULL

-- Let's update the cast column
UPDATE m1
SET m1.cast =ISNULL(m1.cast, m2.cast)
FROM Movies.dbo.Channels m1
JOIN Movies.dbo.Channels m2
	ON m1.title = m2.title
	AND m1.show_id <> m2.show_id
WHERE m1.cast IS NULL

----------
-- Checking all
SELECT * FROM Movies.dbo.Channels

--  Let's see what we can do with column country
SELECT DISTINCT(country)
FROM Movies.dbo.Channels

-- Cehcking the null values
SELECT
COUNT(*)
FROM Movies.dbo.Channels
WHERE country IS NULL


-- Filled null country with n/a
UPDATE Movies.dbo.Channels
SET country = 'n/a'
WHERE country IS NULL

-- Let's separate the countries and then stored in a new table
SELECT show_id, VALUE
FROM Movies.dbo.Channels
CROSS APPLY
string_split(country,',')

--Create a new table Country
CREATE TABLE Movies.dbo.Countries(
show_id nvarchar(255) NOT NULL,
country nvarchar(255) NOT NULL
)
-- Insert all records from the previous query
INSERT INTO Movies.dbo.Countries
SELECT show_id, VALUE
FROM Movies.dbo.Channels
CROSS APPLY
string_split(country,',')

-- Now let's see the unique values
SELECT DISTINCT(country)
FROM Movies.dbo.Countries


-- It seems there are spaces before and after the name, let's clean it
UPDATE  Movies.dbo.Countries
SET country =  TRIM(country)

-- Now, let's check again
SELECT DISTINCT(country)
FROM Movies.dbo.Countries
ORDER BY country

-- Checking all
SELECT * FROM Movies.dbo.Channels

-- Create Casts and Genres (listed_in) Tables
CREATE TABLE Movies.dbo.Casts(
show_id nvarchar(255) NOT NULL,
cast_name nvarchar(255) NOT NULL
)

CREATE TABLE Movies.dbo.Genres(
show_id nvarchar(255) NOT NULL,
genre nvarchar(255) NOT NULL
)

-- Data Validation. Let's verify running the following two queries
SELECT show_id, VALUE
FROM Movies.dbo.Channels
CROSS APPLY
string_split(cast,',')

SELECT show_id, cast
FROM Movies.dbo.Channels
WHERE show_id = 'd692' or show_id='d693'

-- So, it worked, let's insert the records in the new table
INSERT INTO Movies.dbo.Casts
SELECT show_id, VALUE
FROM Movies.dbo.Channels
CROSS APPLY
string_split(cast,',')

UPDATE  Movies.dbo.Casts
SET cast_name = TRIM(cast_name)

-- Let's populate the table Genre
SELECT show_id, VALUE
FROM Movies.dbo.Channels
CROSS APPLY
string_split(listed_in,',')

INSERT INTO Movies.dbo.Genres
SELECT show_id, VALUE
FROM Movies.dbo.Channels
CROSS APPLY
string_split(listed_in,',')

-- CLean the column

UPDATE  Movies.dbo.Genres
SET genre = TRIM(genre)

-- Checking all
SELECT * FROM Movies.dbo.Channels

-- Work on director colum, we eed to split the names to answers business questions
-- Create a table Directors
CREATE TABLE Movies.dbo.Directors (
show_id NVARCHAR(255) NOT NULL,
director NVARCHAR(255) NOT NULL
)

-- let's select the values to populate the table
SELECT 
 show_id,
 VALUE
FROM  Movies.dbo.Channels
CROSS APPLY STRING_SPLIT(director,',')
 
-- Inserting the values in the table
INSERT INTO Movies.dbo.Directors
SELECT 
 show_id,
 VALUE
FROM  Movies.dbo.Channels
CROSS APPLY STRING_SPLIT(director,',')
-- Work on rating and new_rating column 
-- The new_rating column was created before, it's empty ready to be populated with a standard rating for all
-- Let's see how many types of rating we have

SELECT DISTINCT(rating)
FROM Movies.dbo.Channels
ORDER BY rating

/* This column needs the following:
1. There are values that should not be here like duration of the movie
2. We need to standarize the groups ratings
3. Fill those movies that existed in other channels with the rating for those nulls values or blank values */

-- Let's start with replacing those duration values
-- Basically if it found the word 'min' or 'season' the value of the records should be blank

SELECT rating
FROM  Movies.dbo.Channels
WHERE CONTAINS (rating,'season')
OR CONTAINS (rating, 'min')

-- I need to create a primary key for the table to be able to use the Channel indexes
-- We missed one important step in adding a PRIMARY KEY to the Channels table, let's do it now
ALTER TABLE Movies.Dbo.Channels
ALTER COLUMN show_id nvarchar(255) NOT NULL


ALTER TABLE Movies.Dbo.Channels
ADD PRIMARY KEY (show_id)

-- I had to create a full catalog index for the table Channels in order to use CONTAINS -- I also can use LIKE
-- Now, I can run the following query

SELECT rating
FROM  Movies.dbo.Channels
WHERE CONTAINS (rating,'season')
OR CONTAINS (rating, 'min')
-- Output: 275 rows

-- Now, we have to replace those records with blanks

UPDATE Movies.dbo.Channels
SET rating = ''
WHERE CONTAINS (rating,'season')
OR CONTAINS (rating, 'min')

-- Output: 275 rows updated
-- Let's run the unique values again
SELECT DISTINCT(rating)
FROM Movies.dbo.Channels
ORDER BY rating

-- I made a mistake, I forgot to include the word "Seasons" in the previous query, so let's update it
UPDATE Movies.dbo.Channels
SET rating = ''
WHERE CONTAINS (rating,'Seasons')
-- ok, 20 rows affected, we're in better shape now

SELECT DISTINCT(rating)
FROM Movies.dbo.Channels
ORDER BY rating

/*Next steps is to standarize those groups for rating

13+ : PG-13
16: TV-16
16+ : TV-16
18+ : TV-18
7+ : TV-Y7 
AGES_16_: TV-14
AGES_18_: TV-18
ALL: TV-G
ALL_AGES: TV-G
G: TV-G
NC-17-->ok
NOT RATED: UNRATED
NOT_RATE: UNRATED
NR: UNRATED
PG --> ok
PG-13 --> ok
R --> ok
TV-14 --> ok
TV-G -->ok
TV-MA -->ok
TV-NR -->ok
TV-PG -->ok
TV-Y -->ok
TV-Y7 -->ok
TV-Y7-FV --> ok
UNRATED --> ok
UR: UNRATED  */

-- Now that the ratings has been grouped let's replace those values
SELECT rating,
	CASE WHEN rating = '13+' THEN 'PG-13'
	     WHEN rating = '16' THEN 'TV-16'
		 WHEN rating = '16+' THEN 'TV-16'
		 WHEN rating = '18+' THEN 'TV-18'
		 WHEN rating = '7+' THEN 'TV-Y7'
		 WHEN rating = 'AGES_16_' THEN 'TV-16'
		 WHEN rating = 'AGES_18_' THEN 'TV-18'
		 WHEN rating = 'ALL' THEN 'TV-G'
		 WHEN rating = 'G' THEN 'TV-G'
		 WHEN rating = 'NOT RATED' THEN 'UNRATED'
		 WHEN rating = 'NOT_RATE' THEN 'UNRATED'
		 WHEN rating = 'UR' THEN 'UNRATED'
		ELSE rating
	END
FROM Movies.dbo.Channels

-- We can update those records, but since we already created a new column named new_rating, let's populate the column

UPDATE Movies.dbo.Channels
SET new_rating = CASE WHEN rating = '13+' THEN 'PG-13'
	             WHEN rating = '16' THEN 'TV-16'
		         WHEN rating = '16+' THEN 'TV-16'
				 WHEN rating = '18+' THEN 'TV-18'
				 WHEN rating = '7+' THEN 'TV-Y7'
				 WHEN rating = 'AGES_16_' THEN 'TV-16'
				 WHEN rating = 'AGES_18_' THEN 'TV-18'
				 WHEN rating = 'ALL' THEN 'TV-G'
				 WHEN rating = 'G' THEN 'TV-G'
				 WHEN rating = 'NOT RATED' THEN 'UNRATED'
				 WHEN rating = 'NOT_RATE' THEN 'UNRATED'
				 WHEN rating = 'UR' THEN 'UNRATED'
	 			 ELSE rating
			     END


-- Let's take a look
SELECT rating, 
new_rating 
FROM Movies.dbo.Channels

-- Next step is fill those Null values with the same new_rating for the same movie that exist already in another channel
-- Let's JOIN the table itself using the new_rating column that is cleaned

SELECT 
m1.title,
m2.title,
m1.new_rating,
m2.new_rating,
ISNULL(m1.new_rating, m2.new_rating)
FROM Movies.dbo.Channels m1
JOIN Movies.dbo.Channels m2
ON m1.title = m2.title
AND m1.show_id <> m2.show_id
WHERE m1.new_rating IS NULL

--
-- Let's update those values
UPDATE m1
SET m1.new_rating = ISNULL(m1.new_rating, m2.new_rating)
FROM Movies.dbo.Channels m1
JOIN Movies.dbo.Channels m2
ON m1.title = m2.title
AND m1.show_id <> m2.show_id
WHERE m1.new_rating IS NULL

-- Checking all
SELECT * FROM Movies.dbo.Channels

-- We still have some NULL values for  new_rating
-- Let's fill those values with n/a for Viz purposes

SELECT COUNT(*)
FROM Movies.dbo.Channels
WHERE new_rating IS NULL
-- output 807 rows

SELECT COUNT(*)
FROM Movies.dbo.Channels
WHERE date_included IS NULL
-- output 9642 records

---
UPDATE Movies.dbo.Channels
SET new_rating = 'n/a'
WHERE new_rating IS NULL
-- output 807 rows affected

-- I will use a calculated field to handle the nulls in date_included in Tableau

-- Let's drop the columms no need it in the Channels table and we are ready to explore the data in Tableu

ALTER TABLE Movies.dbo.Channels
DROP COLUMN director, cast, country, listed_in

-- Checking all
SELECT * FROM Movies.dbo.Channels
