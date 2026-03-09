const pool = require('./db');

async function createMedicalRecordsTable() {
    try {
        await pool.query(`
            CREATE TABLE IF NOT EXISTS medical_records (
                id SERIAL PRIMARY KEY,
                health_id VARCHAR(50) NOT NULL,
                doctor_name VARCHAR(255) NOT NULL,
                date DATE NOT NULL,
                record_type VARCHAR(100) NOT NULL,
                description TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        `);
        console.log('✅ medical_records table created successfully');
    } catch (err) {
        console.error('❌ Error creating table:', err);
    } finally {
        pool.end();
    }
}

createMedicalRecordsTable();
