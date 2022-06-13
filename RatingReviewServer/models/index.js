const client = require('../db.js');


module.exports = {

  getReviews: (cb, values) => {
    client.query (
      `WITH photos AS (
        SELECT review_id, jsonb_agg(to_jsonb(photos) - 'review_id') AS photos
        FROM photos
        GROUP BY review_id
        )
        SELECT reviews.*, photos.photos,
      CASE WHEN photos.photos is NULL THEN '[]' ELSE photos.photos END AS photos
      FROM reviews
      LEFT JOIN photos
      ON reviews.review_id = photos.review_id
      WHERE reviews.product_id = $1
      LIMIT $2
      `
      //use order by for sort options
    , values, (err, result) => {
    if (err) {
      console.log(err, 'error at model')
    } else {
      cb(err, result.rows);
    }
    })
  },

  getMetaData: (cb, values) => {
    client.query (
      `WITH allratings AS (
        SELECT
        reviews.product_id,
        COUNT(reviews.rating) FILTER (WHERE reviews.rating = 1) AS one,
        COUNT(reviews.rating) FILTER (WHERE reviews.rating = 2) AS two,
        COUNT(reviews.rating) FILTER (WHERE reviews.rating = 3) AS three,
        COUNT(reviews.rating) FILTER (WHERE reviews.rating = 4) AS four,
        COUNT(reviews.rating) FILTER (WHERE reviews.rating = 5) AS five
        FROM reviews
        WHERE reviews.product_id = $1
        GROUP BY reviews.product_id
      ), allrecommends AS (
        SELECT
        reviews.product_id,
        COUNT(reviews.recommend) FILTER (WHERE reviews.recommend = false) as false,
        COUNT(reviews.recommend) FILTER (WHERE reviews.recommend = true) as true
        FROM reviews
        WHERE reviews.product_id = $1
        GROUP BY reviews.product_id
      )
      SELECT
      allratings.product_id,
      JSON_BUILD_OBJECT('false', allrecommends.false, 'true', allrecommends.true) AS recommended,
      JSON_BUILD_OBJECT('one', allratings.one, 'two', allratings.two, 'three', allratings.three, 'four', allratings.four, 'five', allratings.five) AS ratings,
      JSON_BUILD_OBJECT(
        'Fit', JSON_BUILD_OBJECT('id', avgchar.id, 'value', avgchar.fit),
        'Length', JSON_BUILD_OBJECT('id', avgchar.id, 'value', avgchar.length),
        'Comfort', JSON_BUILD_OBJECT('id', avgchar.id, 'value', avgchar.comfort),
        'Quality', JSON_BUILD_OBJECT('id', avgchar.id, 'value', avgchar.quality),
        'Width', JSON_BUILD_OBJECT('id', avgchar.id, 'value', avgchar.width),
        'Size', JSON_BUILD_OBJECT('id', avgchar.id, 'value', avgchar.size)
      ) AS characteristics
      FROM reviews
      JOIN allratings
      ON reviews.product_id = allratings.product_id
      JOIN allrecommends
      ON reviews.product_id = allrecommends.product_id
      JOIN avgchar
      ON reviews.product_id = avgchar.product_id
      GROUP BY
       allratings.product_id,
       allrecommends.false,
       allrecommends.true,
       allratings.one,
       allratings.two,
       allratings.three,
       allratings.four,
       allratings.five,
       avgchar.id,
       avgchar.fit,
       avgchar.length,
       avgchar.comfort,
       avgchar.quality,
       avgchar.size,
       avgchar.size
      `
      , values, (err, result) => {
        if (err) {
          console.log(err, 'error at model');
        } else {
          cb(err, result.rows);
        }
      }
    )
  }

}

// , allrecommends AS (
//   SELECT
//   reviews.product_id,
//   COUNT(reviews.recommend) FILTER (WHERE reviews.recommend = false) as false,
//   COUNT(reviews.recommend) FILTER (WHERE reviews.recommend = true) as true
//   FROM reviews
//   WHERE reviews.product_id = $1
//   GROUP BY reviews.product_id
// )
      // SELECT avgchar.product_id, JSON_CREATE_OBJECT('ratings', allratings.*)
      // FROM avgchar
      // JOIN allratings ON reviews.product_id = avgchar.product_id
      // LIMIT 5















/*
json build object (
  'characteristics',
  table1 with average size, width, comfort, with maybe to_jsonb
)

Inside table1:
  json build object(
    'Size',
    table with an id and average value
  )
*/