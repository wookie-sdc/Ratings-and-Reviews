const models = require('../models');


const get = (req, res) => {

  let values = [req.query.product_id];
  if (req.query.count === undefined) {
    values.push('5');
  } else {
    values.push(req.query.count);
  }
  models((err, response) => {
    if (err) {
      console.log('error at controller')
    } else {
      res.status(200).json(response);
    }
  }, values)
}

module.exports = get;