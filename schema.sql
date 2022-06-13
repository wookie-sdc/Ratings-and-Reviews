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

-- CREATE TABLE avgchar (
--   id SERIAL,
--   product_id INTEGER,
--   name VARCHAR (10),
--   value INTEGER,
--   PRIMARY KEY (id)
-- );

CREATE TABLE avgchar (
  id SERIAL,
  product_id INTEGER,
  fit INTEGER,
  length INTEGER,
  comfort INTEGER,
  quality INTEGER,
  width INTEGER,
  size INTEGER,
  PRIMARY KEY (id)
);

COPY reviews FROM '/home/joshspc/Desktop/HackReactor/SDCwook/reviews.csv' DELIMITER ',' CSV HEADER;

COPY photos FROM '/home/joshspc/Desktop/HackReactor/SDCwook/reviews_photos.csv' DELIMITER ',' CSV HEADER;

COPY char FROM '/home/joshspc/Desktop/HackReactor/SDCwook/characteristics.csv' DELIMITER ',' CSV HEADER;

COPY revchar FROM '/home/joshspc/Desktop/HackReactor/SDCwook/characteristic_reviews.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE allproductid (
  id serial,
  product_id INTEGER,
  PRIMARY KEY (id)
);

ALTER TABLE reviews
  RENAME COLUMN id TO review_id;

-- create index review_id ON reviews(review_id);
-- create index product_id ON reviews(product_id);
-- create index name ON char(name);
-- create index product_id ON char(product_id);
-- create index product_id ON allproductid(product_id);

-- ALTER TABLE reviews
--   ADD  photos text[] DEFAULT array[]::varchar[];

-- INSERT INTO avgchar (product_id, name, value)
--   SELECT char.product_id, char.name, AVG(revchar.value)
--   FROM revchar JOIN char
--   ON revchar.characteristic_id = char.id
--   WHERE char.name = 'Fit'
--   GROUP BY char.product_id, char.name;

-- with fittable as (
--   SELECT allproductid.productid, char.name, AVG(revchar.value) FILTER (WHERE char.name = 'Fit') AS value
--   FROM allproductid
--   JOIN
--   )


INSERT INTO allproductid (product_id)
SELECT DISTINCT reviews.product_id
FROM reviews;

-- SELECT allproductid.product_id, AVG(revchar.value) AS value FROM revchar JOIN char ON revchar.characteristic_id = char.id JOIN allproductid ON allproductid.product_id = char.product_id WHERE char.name = 'Fit' GROUP BY allproductid.product_id LIMIT 5;

WITH fittable AS (
  SELECT allproductid.id, allproductid.product_id, AVG(revchar.value) AS fitvalue
    FROM revchar JOIN char ON revchar.characteristic_id = char.id
    JOIN allproductid
    ON allproductid.product_id = char.product_id
    WHERE char.name = 'Fit'
    GROUP BY allproductid.product_id, allproductid.id
), lengthtable AS (
  SELECT allproductid.id, allproductid.product_id, AVG(revchar.value) AS lengthvalue
    FROM revchar JOIN char ON revchar.characteristic_id = char.id
    JOIN allproductid
    ON allproductid.product_id = char.product_id
    WHERE char.name = 'Length'
    GROUP BY allproductid.product_id , allproductid.id
), comforttable AS (
  SELECT allproductid.id, allproductid.product_id, AVG(revchar.value) AS comfortvalue
    FROM revchar JOIN char ON revchar.characteristic_id = char.id
    JOIN allproductid
    ON allproductid.product_id = char.product_id
    WHERE char.name = 'Comfort'
    GROUP BY allproductid.product_id, allproductid.id
), qualitytable AS (
  SELECT allproductid.id, allproductid.product_id, AVG(revchar.value) AS qualityvalue
    FROM revchar JOIN char ON revchar.characteristic_id = char.id
    JOIN allproductid
    ON allproductid.product_id = char.product_id
    WHERE char.name = 'Quality'
    GROUP BY allproductid.product_id , allproductid.id
), sizetable AS (
  SELECT allproductid.id, allproductid.product_id, AVG(revchar.value) AS sizevalue
    FROM revchar JOIN char ON revchar.characteristic_id = char.id
    JOIN allproductid
    ON allproductid.product_id = char.product_id
    WHERE char.name = 'Size'
    GROUP BY allproductid.product_id , allproductid.id
), widthtable AS (
  SELECT allproductid.id, allproductid.product_id, AVG(revchar.value) AS widthvalue
    FROM revchar JOIN char ON revchar.characteristic_id = char.id
    JOIN allproductid
    ON allproductid.product_id = char.product_id
    WHERE char.name = 'Width'
    GROUP BY allproductid.product_id , allproductid.id
), averagetable AS (
  SELECT allproductid.id,
   allproductid.product_id,
  --  JSON_BUILD_OBJECT('id', allproductid.id, 'value', fittable.fitvalue) AS Fit,
  --  JSON_BUILD_OBJECT('id', allproductid.id, 'value', lengthtable.lengthvalue) AS Length,
  --  JSON_BUILD_OBJECT('id', allproductid.id, 'value', comforttable.comfortvalue) AS Comfort,
  --  JSON_BUILD_OBJECT('id', allproductid.id, 'value', qualitytable.qualityvalue) AS Quality,
  --  JSON_BUILD_OBJECT('id', allproductid.id, 'value', widthtable.widthvalue) AS Width,
  --  JSON_BUILD_OBJECT('id', allproductid.id, 'value', sizetable.sizevalue) AS Size
  fittable.fitvalue AS Fit,
  lengthtable.lengthvalue AS Length,
  comforttable.comfortvalue AS Comfort,
  qualitytable.qualityvalue AS Quality,
  widthtable.widthvalue AS Width,
  sizetable.sizevalue AS Size
    FROM allproductid
    LEFT JOIN fittable
    ON allproductid.product_id = fittable.product_id
    LEFT JOIN lengthtable
    ON allproductid.product_id = lengthtable.product_id
    LEFT JOIN comforttable
    ON allproductid.product_id = comforttable.product_id
    LEFT JOIN qualitytable
    ON allproductid.product_id = qualitytable.product_id
    LEFT JOIN widthtable
    ON allproductid.product_id = widthtable.product_id
    LEFT JOIN sizetable
    ON allproductid.product_id = sizetable.product_id
)
INSERT INTO avgchar (product_id, fit, length, comfort, quality, width, size)
SELECT averagetable.product_id, averagetable.Fit, averagetable.Length, averagetable.Comfort, averagetable.Quality, averagetable.Width, averagetable.Size
FROM averagetable;

-- to_jsonb(averagetable.*) - 'id' - 'product_id'



-- WITH allratings AS (
--   SELECT
--   AVG(reviews.rating) FILTER (WHERE reviews.rating = 1) AS one
--   FROM reviews
--   WHERE reviews.product_id = 1
-- )
-- SELECT * FROM allratings LIMIT 5;


  --  lengthtable.lengthvalue,
  --  comforttable.comfortvalue,
  --  qualitytable.qualityvalue,
  --  widthtable.widthvalue,
  --  sizetable.sizevalue

-- CREATE TABLE avgchar (
--   id SERIAL,
--   product_id INTEGER,
--   characteristics JSON,
--   PRIMARY KEY (id)
-- );


-- CREATE TABLE test (W
--   id serial,
--   name VARCHAR(10),
--   PRIMARY KEY (id)
-- );

-- CREATE TABLE testtwo (
--   id serial,
--   name VARCHAR(10),
--   city VARCHAR(10),
--   PRIMARY KEY (id)
-- );

-- INSERT INTO test (name) VALUES ('bob'), ('harry'), ('me');

-- INSERT INTO testtwo (name, city) VALUES ('bob', 'sf'), ('harry', 'sd'), ('me', 'la'), ('bob', 'sj');

-- SELECT test.name FROM test JOIN testtwo ON test.name = testtwo.name;



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