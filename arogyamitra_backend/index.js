const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

// Global error handlers
process.on('uncaughtException', (err) => {
  console.error('UNCAUGHT EXCEPTION:', err);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('UNHANDLED REJECTION:', reason);
});

const app = express();
app.use(cors());
app.use(bodyParser.json());

const pool = require('./db'); // Import pool

// Direct route for debugging
app.delete('/api/delete-appointment/:id', async (req, res) => {
  console.log(`[INDEX.JS] Received DELETE request for ID: ${req.params.id}`);
  try {
    const { id } = req.params;
    const result = await pool.query(
      'DELETE FROM appointments WHERE id = $1 RETURNING *',
      [id]
    );
    if (result.rowCount === 0) {
      console.log(`[INDEX.JS] Appointment ${id} not found.`);
      return res.status(404).json({ message: 'Appointment not found' });
    }
    console.log(`[INDEX.JS] Deleted ${id}`);
    res.json({ message: 'Appointment deleted successfully' });
  } catch (err) {
    console.error('[INDEX.JS] Error:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// Routes
app.use('/api', require('./routes/appointments'));
app.use('/api', require('./routes/register'));
app.use('/api', require('./routes/login'));
app.use('/api', require('./routes/provider_login'));

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

