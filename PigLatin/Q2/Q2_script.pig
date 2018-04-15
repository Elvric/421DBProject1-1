--load the data from HDFS and define the schema
movies = LOAD '/data/movies.csv' USING PigStorage(',') AS (movieid:INT, title:CHARARRAY, year:INT);
moviegenres = LOAD '/data/moviegenres.csv' USING PigStorage(',') AS (movieid:INT, genre:CHARARRAY);

movies2015 = FILTER movies BY year == 2015;

genres_of_interest = FILTER moviegenres by genre IN ('Comedy','Sci-Fi');

movies_of_interest = JOIN movies2015 by movieid, genres_of_interest by movieid;

titles = FOREACH movies_of_interest generate $1 as title;

distinct_titles =  DISTINCT titles;

sorted_titles = ORDER distinct_titles by title;

dump sorted_titles;

