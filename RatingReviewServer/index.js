require('dotenv').config();
const express = require('express');
const client = require('./db.js');
const controller = require('./controllers');


const app = express();

app.use(express.urlencoded({extended: true}));
app.use(express.json());

app.get('/test', controller);

app.listen(3000, () => {
  console.log("listening on port 3000")
});


client.connect();