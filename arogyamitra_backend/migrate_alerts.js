const pool = require('./db');

async function run() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS health_alerts (
        id SERIAL PRIMARY KEY,
        district VARCHAR(255),
        alert_type VARCHAR(50), 
        disease_name VARCHAR(255),
        affected_health_id VARCHAR(255),
        vaccination_name VARCHAR(255),
        patients_count INTEGER,
        reporter_name VARCHAR(255),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log('health_alerts table created successfully');
  } catch (err) {
    console.error('Error creating health_alerts table:', err);
  } finally {
    pool.end();
  }
}

run();
