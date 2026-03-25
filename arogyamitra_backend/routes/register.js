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
      district,
      occupation,
      password
    } = req.body;

    const hashedPassword = await bcrypt.hash(password, 4);
    const healthId = `AM-${Math.random().toString(36).substr(2, 6).toUpperCase()}`;

    const result = await pool.query(
      `INSERT INTO registrations
       (phone, name, age, gender, state, district, occupation, password, health_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
       RETURNING health_id`,
      [phone, name, age, gender, state, district, occupation, hashedPassword, healthId]
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

router.put('/profile/:healthId/health', async (req, res) => {
  try {
    const { healthId } = req.params;
    const { blood_group, allergies } = req.body;

    const result = await pool.query(
      'UPDATE registrations SET blood_group = $1, allergies = $2 WHERE health_id = $3 RETURNING *',
      [blood_group, allergies, healthId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ message: 'Health info updated successfully', user: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error updating health info' });
  }
});


router.put('/profile/:healthId/emergency', async (req, res) => {
  try {
    const { healthId } = req.params;
    const { emergencyNo } = req.body;

    // Validate input if needed, though frontend handles basic validation

    const result = await pool.query(
      'UPDATE registrations SET emergency_no = $1 WHERE health_id = $2 RETURNING *',
      [emergencyNo, healthId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ message: 'Emergency number updated successfully', user: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error updating emergency number' });
  }
});

router.get('/camp-patients', async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM registrations WHERE LOWER(state) = 'camp' OR LOWER(district) = 'camp' ORDER BY id DESC"
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error fetching camp patients' });
  }
});

router.put('/profile/:healthId/insurance', async (req, res) => {
  try {
    const { healthId } = req.params;
    const { insurance_id, policy_type } = req.body;

    const result = await pool.query(
      'UPDATE registrations SET insurance_id = $1, policy_type = $2 WHERE health_id = $3 RETURNING *',
      [insurance_id, policy_type, healthId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ message: 'Insurance info updated successfully', user: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error updating insurance info' });
  }
});

module.exports = router;
