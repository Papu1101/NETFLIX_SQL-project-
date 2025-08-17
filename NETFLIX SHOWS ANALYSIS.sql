CREATE TABLE NETFLIX
(
show_id VARCHAR(10),
type    VARCHAR (20),
title   VARCHAR(255),
director VARCHAR(255),
cast_names    TEXT,
country VARCHAR(255),
date_added DATE,
release_year INT,
rating VARCHAR(10),
duration VARCHAR(50),
listed_in VARCHAR(255),
description TEXT
);
SELECT * FROM NETFLIX;


-- Convert blanks to NULL
UPDATE netflix
SET director = NULL
WHERE director = '';

UPDATE netflix
SET cast_names = NULL
WHERE cast_names = '';

UPDATE netflix
SET country = NULL
WHERE country = '';

UPDATE netflix
SET country = TRIM(country),
    director = TRIM(director),
    cast_names = TRIM(cast_names),
    rating = TRIM(rating),
    listed_in = TRIM(listed_in);


DELETE FROM netflix a
USING netflix b
WHERE a.ctid < b.ctid
  AND a.title = b.title
  AND a.type = b.type;

------ Count the number of Movies vs TV Shows?

SELECT type,
   COUNT(*) AS total_titles
FROM NETFLIX
GROUP BY type 
ORDER BY total_titles DESC;

--------- Find the most common rating for movies and TV shows?--

 WITH rating_count AS (
  SELECT type,
         rating,
  COUNT(*) AS total,
  ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
  FROM NETFLIX
  GROUP BY type,rating		 
 )
SELECT type,rating,total
FROM rating_count
WHERE rn = 1;

--- List all movies released in a specific year (e.g., 2020)
SELECT type,title,release_year FROM NETFLIX
WHERE release_year = 2020 AND type = 'Movie';

--------------Find the top 5 countries with the most content on Netflix??

SELECT country,
   COUNT(*) AS total_titles 
FROM NETFLIX
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC ;

---------------- Identify the longest movie

SELECT type,duration  FROM NETFLIX 
  WHERE type = 'Movie'
 ORDER BY SPLIT_PART (duration,'',1) DESC;

------Find content added in the last 5 years?

SELECT *
FROM netflix
WHERE date_added >= (CURRENT_DATE - INTERVAL '5 years')
ORDER BY date_added DESC;

-------Find all the movies/TV shows by director 'Rajiv Menon'!

SELECT type 
 FROM NETFLIX 
WHERE director = 'Rajiv Menon';

-----List all TV shows with more than 5 seasons----

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

------Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1;

------Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	UNNEST(STRING_TO_ARRAY(cast_names, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;








