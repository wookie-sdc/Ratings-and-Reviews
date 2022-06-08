DROP DATABASE IF EXISTS rr WITH (FORCE);

CREATE DATABASE rr;

\connect rr;

CREATE TABLE reviews (
  id INTEGER,
  product_id INTEGER,
  rating INTEGER,
  date BIGINT,
  summary VARCHAR(1000),
  body VARCHAR(1000),
  recommend BOOLEAN,
  reported BOOLEAN,
  reviewer_name VARCHAR (60),
  reviewer_email VARCHAR (60),
  response VARCHAR,
  helpfulness INTEGER,
  PRIMARY KEY (id)
);

CREATE TABLE photos (
  id INTEGER,
  review_id INTEGER,
  url VARCHAR(200)
);

COPY reviews FROM '/home/joshspc/Desktop/HackReactor/SDCwook/reviews.csv' DELIMITER ',' CSV HEADER;

COPY photos FROM '/home/joshspc/Desktop/HackReactor/SDCwook/reviews_photos.csv' DELIMITER ',' CSV HEADER;

-- reviews v
-- id,product_id,rating,date,summary,body,recommend,reported,reviewer_name,reviewer_email,response (null or string),helpfulness

-- phtotos v
-- id,review_id,url


-- /home/joshspc/Desktop/HackReactor/SDCwook/Ratings-and-Reviews/schema.sql