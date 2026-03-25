const express = require('express');
const pool = require('../db');

const router = express.Router();

// Get claims (all for Health Worker, or filtered by healthId for patient)
router.get('/claims', async (req, res) => {
    try {
        const { healthId } = req.query;
        let query = "SELECT c.*, r.name as patient_name, r.insurance_id, r.policy_type FROM claims c JOIN registrations r ON c.health_id = r.health_id";
        let params = [];
        
        if (healthId) {
            query += " WHERE c.health_id = $1";
            params.push(healthId);
        }
        
        query += " ORDER BY c.created_at DESC";
        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching claims' });
    }
});

// Create a claim
router.post('/claims', async (req, res) => {
    try {
        const { healthId, doctorName, treatmentCost, date } = req.body;

        if (!healthId || !doctorName || !treatmentCost || !date) {
            return res.status(400).json({ message: 'Missing required fields for claim' });
        }

        const result = await pool.query(
            `INSERT INTO claims (health_id, doctor_name, treatment_cost, date) 
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [healthId, doctorName, treatmentCost, date]
        );

        res.status(201).json({
            message: 'Claim created successfully',
            claim: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error creating claim' });
    }
});

// Approve or Reject a claim
router.put('/claims/:id/status', async (req, res) => {
    try {
        const { id } = req.params;
        const { status, approvedAmount, reason } = req.body;

        if (!['Approved', 'Rejected'].includes(status)) {
            return res.status(400).json({ message: 'Invalid status' });
        }

        const result = await pool.query(
            'UPDATE claims SET status = $1, approved_amount = $2, reason = $3 WHERE id = $4 RETURNING *',
            [status, status === 'Approved' ? approvedAmount : null, status === 'Rejected' ? reason : null, id]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ message: 'Claim not found' });
        }

        res.json({ message: `Claim ${status}`, claim: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error updating claim status' });
    }
});

module.exports = router;
