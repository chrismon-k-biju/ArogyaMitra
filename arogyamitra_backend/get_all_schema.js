const pool = require('./db');
async function getSchema() {
  const result = await pool.query(`
    SELECT table_name, column_name, data_type 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    ORDER BY table_name, ordinal_position;
  `);
  console.log(JSON.stringify(result.rows, null, 2));
  pool.end();
}
getSchema();
