const client = require('../db.js');

const getAll = (cb, values) => {
  client.query(
    `WITH photos AS (
      SELECT review_id, jsonb_agg(to_jsonb(photos) - 'review_id')
      AS photos FROM photos
      GROUP BY review_id
    )
      SELECT reviews.*, photos.photos,
      CASE WHEN photos.photos is NULL THEN '[]' ELSE photos.photos END AS photos
      FROM reviews
      LEFT JOIN photos
      ON reviews.review_id = photos.review_id
      WHERE reviews.product_id = $1 limit $2
    `
    , values, (err, result) => {
    if (err) {
      console.log(err, 'error at model')
    } else {
      cb(err, result.rows);
    }
  })
}

module.exports = getAll;
