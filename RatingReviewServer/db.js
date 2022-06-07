require('dotenv').config();
const {Client} = require ('pg');

const client = new Client({
  host: process.env.HOST,
  user: process.env.POSTGRESUSER,
  port: process.env.POSTGRESPORT,
  password: process.env.POSTGRESPASS,
  database: process.env.DATABASE
})

module.exports = client;