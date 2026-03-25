const pool = require('./db');

async function checkPasswords() {
    try {
        const res = await pool.query('SELECT username, password FROM healthdept');
        console.log("Total users:", res.rows.length);
        res.rows.forEach(r => {
            if (r.password && (r.password.startsWith('$2a$') || r.password.startsWith('$2b$'))) {
                console.log(`User ${r.username} has bcrypt hash: ${r.password}`);
            }
        });
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}
checkPasswords();
