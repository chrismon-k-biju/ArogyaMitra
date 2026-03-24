const pool = require('./db');
async function run() {
  await pool.query('ALTER TABLE healthworkers ADD COLUMN IF NOT EXISTS district VARCHAR(255), ADD COLUMN IF NOT EXISTS hospital_name VARCHAR(255);');
  console.log('Migration done.');
  pool.end();
}
run();
