const pool = require('./db');

async function createTable() {
    try {
        await pool.query(`
            CREATE TABLE IF NOT EXISTS department_circulars (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                content TEXT NOT NULL,
                date VARCHAR(50) NOT NULL,
                publisher_name VARCHAR(255) NOT NULL
            )
        `);
        console.log('department_circulars table created successfully.');
        process.exit(0);
    } catch (err) {
        console.error('Error creating table:', err);
        process.exit(1);
    }
}

createTable();
