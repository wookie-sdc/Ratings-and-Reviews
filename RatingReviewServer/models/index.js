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
      `SELECT avg(revchar.value) FILTER (WHERE char.name = 'Fit') AS average1 FROM revchar JOIN char ON revchar.characteristic_id = char.id LIMIT 5`

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