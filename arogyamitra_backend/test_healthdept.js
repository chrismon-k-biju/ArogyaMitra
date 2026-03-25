const pool = require('./db');
const bcrypt = require('bcryptjs');

async function test() {
    try {
        const res = await pool.query('SELECT * FROM healthdept LIMIT 5');
        console.log(res.rows);
        if (res.rows.length > 0) {
            const user = res.rows[0];
            console.log("Testing bcrypt for", user.username);
            const start = Date.now();
            await bcrypt.compare("password123", user.password);
            console.log("Time taken:", Date.now() - start, "ms");
        }
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}
test();
