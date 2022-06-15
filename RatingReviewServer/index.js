require('dotenv').config();
const express = require('express');
// const client = require('./db.js');
const pool = require('./db.js');
const controller = require('./controllers');


const app = express();

app.use(express.urlencoded({extended: true}));
app.use(express.json());

app.get('/reviews', controller.getReviews);

app.get('/reviews/meta', controller.getMetaData);


app.listen(process.env.PORT, () => {
  console.log(`listening on port ${process.env.PORT}`)
});

pool.connect();