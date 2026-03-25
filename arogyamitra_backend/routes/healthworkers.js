const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../db');

const router = express.Router();

// Create a new doctor/nurse
router.post('/healthworkers', async (req, res) => {
    try {
        const { name, hospital_name, username, password, district, role } = req.body;

        if (!name || !hospital_name || !username || !password || !district || !role) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const hashedPassword = await bcrypt.hash(password, 4);

        const result = await pool.query(
            `INSERT INTO healthworkers (name, hospital_name, username, password, district, role) 
             VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
            [name, hospital_name, username, hashedPassword, district, role]
        );

        res.status(201).json({
            message: 'Health worker created successfully',
            healthworker: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        if (err.code === '23505') { // Unique constraint violation (likely username)
            return res.status(400).json({ message: 'Username already exists' });
        }
        res.status(500).json({ message: 'Server error creating health worker' });
    }
});

// Get all doctors/nurses in a district
router.get('/healthworkers', async (req, res) => {
    try {
        const { district } = req.query;
        let query = "SELECT * FROM healthworkers";
        let params = [];
        
        if (district) {
            query += " WHERE LOWER(district) = LOWER($1)";
            params.push(district);
        }
        
        query += " ORDER BY role, name";
        const result = await pool.query(query, params);
        
        // Don't send passwords back
        const safeData = result.rows.map(row => {
            const { password, ...safeRow } = row;
            return safeRow;
        });

        res.json(safeData);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching health workers' });
    }
});

// Delete a doctor/nurse by username
router.delete('/healthworkers/:username', async (req, res) => {
    try {
        const { username } = req.params;
        const result = await pool.query(
            'DELETE FROM healthworkers WHERE username = $1 RETURNING *',
            [username]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ message: 'Health worker not found' });
        }

        res.json({ message: 'Health worker deleted successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error deleting health worker' });
    }
});

module.exports = router;
