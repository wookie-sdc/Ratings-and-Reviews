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

create index review_review_id ON reviews(review_id);
create index product_product_id ON reviews(product_id);
create index name ON char(name);
create index char_product_id ON char(product_id);
create index allrpductid_product_id ON allproductid(product_id);
create index photos_review_id ON photos(review_id);


INSERT INTO allproductid (product_id)
SELECT DISTINCT reviews.product_id
FROM reviews;


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

create index avgchar_product_id ON avgchar(product_id);

ALTER TABLE reviews
  ADD photos jsonb default '[]'::jsonb;

WITH photos AS (
  SELECT review_id, jsonb_agg(to_jsonb(photos) - 'review_id') AS photos
  FROM photos
  GROUP BY review_id
  )
  UPDATE reviews
  SET photos = CASE WHEN photos.photos IS NULL THEN '[]' ELSE photos.photos END
  FROM photos
  WHERE reviews.review_id = photos.review_id
