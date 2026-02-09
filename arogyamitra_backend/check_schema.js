const pool = require('./db');

async function checkSchema() {
    try {
        const res = await pool.query(
            "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'appointments'"
        );
        console.log('Schema for appointments table:');
        console.table(res.rows);
    } catch (err) {
        console.error('Error querying schema:', err);
    } finally {
        pool.end();
    }
}

checkSchema();
