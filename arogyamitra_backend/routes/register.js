const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../db');

const router = express.Router();

router.post('/register', async (req, res) => {
  try {
    const {
      phone,
      name,
      age,
      gender,
      state,
      occupation,
      password
    } = req.body;

    const hashedPassword = await bcrypt.hash(password, 10);
    const healthId = `AM-${Math.random().toString(36).substr(2, 6).toUpperCase()}`;

    const result = await pool.query(
      `INSERT INTO registrations
       (phone, name, age, gender, state, occupation, password, health_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
       RETURNING health_id`,
      [phone, name, age, gender, state, occupation, hashedPassword, healthId]
    );

    res.status(201).json({
      message: 'Registration successful',
      healthId: result.rows[0].health_id
    });

  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.get('/profile/:healthId', async (req, res) => {
  try {
    const { healthId } = req.params;
    const result = await pool.query(
      'SELECT * FROM registrations WHERE health_id = $1',
      [healthId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error fetching profile' });
  }
});

module.exports = router;
