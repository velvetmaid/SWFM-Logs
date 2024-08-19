require("dotenv").config();
const { Pool } = require("pg");

const poolA = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  // ssl: process.env.DB_SSL === 'false',
});

module.exports = {
  poolSWFM: async () => {
    const Pool = await poolA.connect();
    return Pool;
  },
};
