const pool = require('./db');

async function createInsuranceTables() {
    try {
        // 1. Add insurance columns to registrations table if they don't exist
        await pool.query(`
            ALTER TABLE registrations 
            ADD COLUMN IF NOT EXISTS insurance_id VARCHAR(50),
            ADD COLUMN IF NOT EXISTS policy_type VARCHAR(20)
        `);
        console.log('✅ Added insurance_id and policy_type to registrations');

        // 2. Create claims table
        await pool.query(`
            CREATE TABLE IF NOT EXISTS claims (
                id SERIAL PRIMARY KEY,
                health_id VARCHAR(50) NOT NULL,
                doctor_name VARCHAR(255) NOT NULL,
                treatment_cost NUMERIC(10, 2) NOT NULL,
                status VARCHAR(50) DEFAULT 'Pending',
                approved_amount NUMERIC(10, 2),
                reason TEXT,
                date DATE NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        `);
        console.log('✅ Created claims table');
    } catch (err) {
        console.error('❌ Error updating schema:', err);
    } finally {
        pool.end();
    }
}

createInsuranceTables();
