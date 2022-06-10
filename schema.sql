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
  response VARCHAR DEFAULT null,
  helpfulness INTEGER,
  PRIMARY KEY (id)
);

-- change default for response as null;

CREATE TABLE photos (
  id INTEGER,
  review_id INTEGER,
  url VARCHAR(200),
  PRIMARY KEY (id)
);

CREATE TABLE char (
  id INTEGER,
  product_id INTEGER,
  name VARCHAR (10),
  PRIMARY KEY (id)
);

CREATE TABLE revchar (
  id INTEGER,
  characteristic_id INTEGER,
  review INTEGER,
  value INTEGER,
  PRIMARY KEY (id)
);

CREATE TABLE avgchar (
  id SERIAL,
  value INTEGER,

);

COPY reviews FROM '/home/joshspc/Desktop/HackReactor/SDCwook/reviews.csv' DELIMITER ',' CSV HEADER;

COPY photos FROM '/home/joshspc/Desktop/HackReactor/SDCwook/reviews_photos.csv' DELIMITER ',' CSV HEADER;

COPY char FROM '/home/joshspc/Desktop/HackReactor/SDCwook/characteristics.csv' DELIMITER ',' CSV HEADER;

COPY revchar FROM '/home/joshspc/Desktop/HackReactor/SDCwook/characteristic_reviews.csv' DELIMITER ',' CSV HEADER;

ALTER TABLE reviews
  RENAME COLUMN id TO review_id;

-- ALTER TABLE reviews
--   ADD  photos text[] DEFAULT array[]::varchar[];






-- CREATE TABLE ratings (
--   id SERIAL,
--   product_id INTEGER,
--   five INTEGER,
--   four INTEGER,
--   three INTEGER,
--   two INTEGER,
--   one INTEGER,
--   PRIMARY KEY (id)
-- );




-- reviews v
-- id,product_id,rating,date,summary,body,recommend,reported,reviewer_name,reviewer_email,response (null or string),helpfulness

-- phtotos v
-- id,review_id,url


-- /home/joshspc/Desktop/HackReactor/SDCwook/Ratings-and-Reviews/schema.sql

-- char_review
-- id,characteristic_id,review_id,value
-- 19327575,3347679,5774952,5

-- char
-- id,product_id,name
-- 3347679,1000011,"Quality"