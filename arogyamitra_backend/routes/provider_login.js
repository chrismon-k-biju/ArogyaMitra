const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../db');

const router = express.Router();

router.post('/provider-login', async (req, res) => {
    const { username, password, role } = req.body;

    try {
        const result = await pool.query(
            'SELECT * FROM healthworkers WHERE LOWER(username) = LOWER($1) AND LOWER(role) = LOWER($2)',
            [username, role]
        );

        console.log(`[Login Attempt] User: ${username}, Role: ${role}`);

        if (result.rows.length === 0) {
            console.log('[Login Failed] User not found or role mismatch.');
            return res.status(401).json({ message: 'User not found or role mismatch' });
        }

        const user = result.rows[0];

        // Check if password matches (Try Bcrypt first, then correct plain text fallback)
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
            console.log('[Login Failed] Password incorrect.');
            return res.status(401).json({ message: 'Invalid password' });
        }

        console.log('[Login Success] Authenticated.');
        res.json({
            message: 'Login successful',
            name: user.name,
            role: user.role,
            district: user.district
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

module.exports = router;

// Public Health Login Route
router.post('/public-health-login', async (req, res) => {
    const { username, password, district } = req.body;

    try {
        // Check for user by username OR name AND district
        const result = await pool.query(
            'SELECT * FROM healthdept WHERE (LOWER(username) = LOWER($1) OR LOWER(name) = LOWER($1)) AND LOWER(district) = LOWER($2)',
            [username, district]
        );

        console.log(`[Public Health Login Attempt] User: ${username}, District: ${district}`);

        if (result.rows.length === 0) {
            console.log('[Login Failed] User not found or district mismatch.');
            return res.status(401).json({ message: 'User not found or district mismatch' });
        }

        const user = result.rows[0];

        // Check password (Bcrypt with plain text fallback)
        let isMatch = false;
        if (user.password && (user.password.startsWith('$2a$') || user.password.startsWith('$2b$'))) {
            try {
                isMatch = await bcrypt.compare(password, user.password);
            } catch (e) {
                console.log('[Bcrypt Warning] Failed to compare hash');
            }
        }

        if (!isMatch && password === user.password) {
            console.log('[Login Success] Plain text password matched.');
            isMatch = true;
        }

        if (!isMatch) {
            console.log('[Login Failed] Password incorrect.');
            return res.status(401).json({ message: 'Invalid password' });
        }

        console.log('[Login Success] Authenticated.');
        res.json({
            message: 'Login successful',
            name: user.name,
            district: user.district,
            role: 'Public Health Official'
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});
