const pool = require('./db');

async function addColumn() {
    try {
        const res = await pool.query(`
      ALTER TABLE registrations 
      ADD COLUMN IF NOT EXISTS emergency_no VARCHAR(20);
    `);
        console.log("Column 'emergency_no' added successfully or already exists.");
    } catch (err) {
        console.error("Error adding column:", err);
    } finally {
        pool.end();
    }
}

addColumn();
