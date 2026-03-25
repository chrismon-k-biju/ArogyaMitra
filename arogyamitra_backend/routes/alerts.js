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

        // Run all queries concurrently to reduce latency
        const [vacQuery, disQuery, feedQuery] = await Promise.all([
            pool.query(`SELECT SUM(patients_count) as total FROM health_alerts WHERE ${filterStr} alert_type = 'Vaccination'`, queryParams),
            pool.query(`SELECT COUNT(*) as total FROM health_alerts WHERE ${filterStr} alert_type = 'Disease'`, queryParams),
            pool.query(`SELECT * FROM health_alerts ${filterStr ? 'WHERE ' + filterStr.replace(' AND', '') : ''} ORDER BY created_at DESC`, queryParams)
        ]);

        const totalVaccination = vacQuery.rows[0].total || 0;
        const totalDisease = disQuery.rows[0].total || 0;
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

// Create new circular
router.post('/circulars', async (req, res) => {
    try {
        const { title, content, date, publisherName, district } = req.body;
        
        await pool.query(
            `INSERT INTO department_circulars (title, content, date, publisher_name, district) 
             VALUES ($1, $2, $3, $4, $5)`,
            [title, content, date, publisherName, district]
        );
        res.status(201).json({ message: 'Circular created successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error creating circular' });
    }
});

// Get all circulars
router.get('/circulars', async (req, res) => {
    try {
        const { district } = req.query;
        let query = 'SELECT * FROM department_circulars';
        let params = [];
        if (district && district !== 'All Districts') {
            query += ' WHERE district = $1';
            params.push(district);
        }
        query += ' ORDER BY id DESC';
        
        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching circulars' });
    }
});

module.exports = router;
