const models = require('../models');


module.exports = {

  getReviews: (req, res) => {
    let values = [req.query.product_id];
    if (req.query.count === undefined) {
      values.push('5');
    } else {
      values.push(req.query.count);
    }
    models.getReviews((err, response) => {
      if (err) {
        console.log('error at controller');
      } else {
        res.status(200).json(response);
      }
    }, values)
  },

  getMetaData: (req, res) => {
    let values = [req.query.product_id];
    models.getMetaData((err, response) => {
      if (err) {
        console.log('error at controller');
      } else {
        res.status(200).json(response);
      }
    }, values)
  }

}