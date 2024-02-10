-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie. (Semi-Tough, 1977, $37,187,139)
SELECT s.film_title, s.release_year,r.worldwide_gross
FROM specs AS s
INNER JOIN revenue AS r
USING (movie_id)
ORDER BY r.worldwide_gross
LIMIT 1;
-- 2. What year has the highest average imdb rating? (1991)
SELECT s.release_year, avg(r.imdb_rating)
FROM specs AS s
INNER JOIN rating AS r
USING (movie_id)
GROUP BY s.release_year
ORDER BY avg(r.imdb_rating) DESC;
-- 3a. What is the highest grossing G-rated movie? (Toy Story 4)
SELECT s.film_title, rev.worldwide_gross
FROM specs AS s
INNER JOIN revenue AS rev
USING (movie_id)
WHERE s.mpaa_rating = 'G'
ORDER BY rev.worldwide_gross DESC;
-- 3b. Which company distributed it? (Walt Disney)
SELECT s.film_title, rev.worldwide_gross, dist.company_name
FROM specs AS s
INNER JOIN revenue AS rev
USING (movie_id)
INNER JOIN distributors AS dist
ON (s.domestic_distributor_id = dist.distributor_id)
WHERE s.mpaa_rating = 'G'
ORDER BY rev.worldwide_gross DESC;
-- 4a. Write a query that returns, for each distributor in the distributors table
-- the distributor name and the number of movies associated with that distributor in the movies table.
-- Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT d.company_name,COUNT(s.*)
FROM distributors AS d
INNER JOIN specs AS s
ON (d.distributor_id = s.domestic_distributor_id)
GROUP BY d.company_name;
-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT d.company_name,avg(film_budget)
FROM distributors AS d
LEFT JOIN specs AS s
ON (d.distributor_id = s.domestic_distributor_id)
LEFT JOIN revenue AS r
ON (s.movie_id = r.movie_id)
GROUP BY d.company_name;
-- 6a. How many movies in the dataset are distributed by a company which is not headquartered in California? (419)
SELECT COUNT(*)
FROM specs AS s
LEFT JOIN distributors AS d
ON (s.domestic_distributor_id = d.distributor_id)
WHERE d.headquarters != 'CA';
-- 6b. Which of these movies has the highest imdb rating? (The Dark Knight)
SELECT *
FROM specs AS s
LEFT JOIN distributors AS d
ON (s.domestic_distributor_id = d.distributor_id)
LEFT JOIN rating AS r
ON (s.movie_id = r.movie_id)
WHERE d.headquarters != 'CA'
ORDER BY r.imdb_rating DESC
LIMIT 1;
-- 7b. Which have a higher average rating
-- movies which are over two hours long or movies which are under two hours?
SELECT s.length_in_min/60, AVG(r.imdb_rating)
FROM specs AS s
LEFT JOIN rating AS r
ON (s.movie_id = r.movie_id)
GROUP BY s.length_in_min/60;