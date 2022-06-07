const client = require('../db.js');

const getAll = (cb) => {
  client.query(`SELECT * from test1`, (err, result) => {
    if (err) {
      console.log('error at model')
    } else {
      cb(err, result);
    }
  })
}

module.exports = getAll;