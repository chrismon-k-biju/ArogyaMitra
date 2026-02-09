const http = require('http');
const pool = require('./db');

async function testDelete() {
    try {
        console.log('Inserting test appointment...');
        const insertRes = await pool.query(
            "INSERT INTO appointments (health_id, doctor_name, date, time, facility, visit_type, status) VALUES ('TEST_HID', 'Dr. Test', '2025-01-01', '10:00 AM', 'Test Facility', 'Follow-up', 'Scheduled') RETURNING id"
        );
        const id = insertRes.rows[0].id;
        console.log(`Inserted appointment with ID: ${id}`);

        console.log(`Attempting DELETE request for ID: ${id}...`);

        const options = {
            hostname: 'localhost',
            port: 3000,
            path: `/api/delete-appointment/${id}`,
            method: 'DELETE'
        };

        const req = http.request(options, (res) => {
            console.log(`STATUS: ${res.statusCode}`);
            res.setEncoding('utf8');
            res.on('data', (chunk) => {
                console.log(`BODY: ${chunk}`);
            });
            res.on('end', async () => {
                console.log('No more data in response.');

                // Verify deletion from DB
                const checkRes = await pool.query('SELECT * FROM appointments WHERE id = $1', [id]);
                if (checkRes.rowCount === 0) {
                    console.log('SUCCESS: Appointment deleted from DB.');
                } else {
                    console.log('FAILURE: Appointment still exists in DB.');
                }
                pool.end();
            });
        });

        req.on('error', (e) => {
            console.error(`problem with request: ${e.message}`);
            pool.end();
        });

        req.end();

    } catch (err) {
        console.error('Error:', err);
        pool.end();
    }
}

testDelete();
