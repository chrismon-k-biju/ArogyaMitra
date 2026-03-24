const pool = require('./db');

async function run() {
  try {
    await pool.query(`
      ALTER TABLE registrations
      ADD COLUMN IF NOT EXISTS district VARCHAR(100),
      ADD COLUMN IF NOT EXISTS blood_group VARCHAR(10),
      ADD COLUMN IF NOT EXISTS allergies TEXT;
    `);
    console.log("Migration successful: added district, blood_group, allergies.");
  } catch(e) {
    console.error(e);
  } finally {
    pool.end();
  }
}
run();
