const express = require('express');
const pool = require('../db');
const router = express.Router();

// Create new alert
router.post('/alerts', async (req, res) => {
    try {
        const { district, alertType, diseaseName, affectedHealthId, vaccinationName, patientsCount, reporterName } = req.body;
        
        await pool.query(
            `INSERT INTO health_alerts 
             (district, alert_type, disease_name, affected_health_id, vaccination_name, patients_count, reporter_name) 
             VALUES ($1, $2, $3, $4, $5, $6, $7)`,
            [district, alertType, diseaseName, affectedHealthId, vaccinationName, patientsCount, reporterName]
        );
        res.status(201).json({ message: 'Alert created successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error creating alert' });
    }
});

// Get alerts logic for public health dashboard
router.get('/alerts', async (req, res) => {
    try {
        const { district } = req.query;
        let queryParams = [];
        let filterStr = "";
        
        if (district && district !== 'All Districts') {
            filterStr = "district = $1 AND";
            queryParams.push(district);
        }

        // Fetch total vaccinations
        const vacQuery = await pool.query(`SELECT SUM(patients_count) as total FROM health_alerts WHERE ${filterStr} alert_type = 'Vaccination'`, queryParams);
        const totalVaccination = vacQuery.rows[0].total || 0;

        // Fetch total disease alerts
        const disQuery = await pool.query(`SELECT COUNT(*) as total FROM health_alerts WHERE ${filterStr} alert_type = 'Disease'`, queryParams);
        const totalDisease = disQuery.rows[0].total || 0;

        // Fetch all alerts for feed
        const feedQuery = await pool.query(`SELECT * FROM health_alerts ${filterStr ? 'WHERE ' + filterStr.replace(' AND', '') : ''} ORDER BY created_at DESC`, queryParams);
        const feed = feedQuery.rows;

        res.json({
            totalVaccination,
            totalDisease,
            feed
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching alerts' });
    }
});

module.exports = router;
