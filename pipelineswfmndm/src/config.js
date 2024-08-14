require("dotenv").config()
const { Pool } = require("pg");

  const poolA = new Pool({
    host: process.env.DB_A_HOST,
    port: process.env.DB_A_PORT,
    user: process.env.DB_A_USER,
    password: process.env.DB_A_PASSWORD,
    database: process.env.DB_A_DATABASE,
    // ssl: process.env.DB_A_SSL === 'false',
  });

  const poolB = new Pool({
    host: process.env.DB_B_HOST,
    port: process.env.DB_B_PORT,
    user: process.env.DB_B_USER,
    password: process.env.DB_B_PASSWORD,
    database: process.env.DB_B_DATABASE,
    // ssl: process.env.DB_B_SSL === 'false',
  });

  module.exports = {
  // queryA: (text, params) => poolA.query(text, params),
  // queryB: (text, params) => poolB.query(text, params),
  poolSWFM: async () => {
    const Pool = await poolA.connect();
    return Pool;
  },
  poolNDM: async () => {
    const Pool = await poolB.connect();
    return Pool;
  },
};