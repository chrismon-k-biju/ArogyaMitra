const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../db');

const router = express.Router();

router.post('/login', async (req, res) => {
  const { phone, password } = req.body;

  const result = await pool.query(
    'SELECT * FROM registrations WHERE phone = $1',
    [phone]
  );

  if (result.rows.length === 0) {
    return res.status(401).json({ message: 'User not found' });
  }

  const user = result.rows[0];
  
  let isMatch = false;
  if (user.password && (user.password.startsWith('$2a$') || user.password.startsWith('$2b$'))) {
      try {
          isMatch = await bcrypt.compare(password, user.password);
      } catch (e) {
          console.log('[Bcrypt Warning] Failed to compare hash');
      }
  }

  // Fallback: Check plain text if bcrypt failed or didn't match
  if (!isMatch && password === user.password) {
      console.log('[Login Success] Plain text password matched.');
      isMatch = true;
  }

  if (!isMatch) {
    return res.status(401).json({ message: 'Invalid password' });
  }

  res.json({
    message: 'Login successful',
    healthId: user.health_id,
    name: user.name
  });
});

module.exports = router;
