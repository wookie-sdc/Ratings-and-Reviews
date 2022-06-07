const models = require('../models');


const get = (req, res) => {
  models((err, response) => {
    if (err) {
      console.log('error at controller')
    } else {
      res.json(response);
    }
  })
}

module.exports = get;