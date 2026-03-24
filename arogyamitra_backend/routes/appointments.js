const express = require('express');
const pool = require('../db');

const router = express.Router();

// Get all appointments for a specific health_id
router.get('/appointments/:healthId', async (req, res) => {
    try {
        const { healthId } = req.params;
        const result = await pool.query(
            'SELECT * FROM appointments WHERE health_id = $1 ORDER BY date ASC, time ASC',
            [healthId]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching appointments' });
    }
});

// Book a new appointment
router.post('/book-appointment', async (req, res) => {
    try {
        const { healthId, doctorName, date, time, facility, visitType, notes } = req.body;

        // Basic validation
        if (!healthId || !doctorName || !date || !time || !facility || !visitType) {
            return res.status(400).json({ message: 'All required fields must be provided' });
        }

        const result = await pool.query(
            `INSERT INTO appointments 
       (health_id, doctor_name, date, time, facility, visit_type, notes) 
       VALUES ($1, $2, $3, $4, $5, $6, $7) 
       RETURNING *`,
            [healthId, doctorName, date, time, facility, visitType, notes]
        );

        res.status(201).json({
            message: 'Appointment booked successfully',
            appointment: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error booking appointment' });
    }
});

// Delete an appointment
router.delete('/delete-appointment/:id', async (req, res) => {
    console.log(`Received DELETE request for appointment ID: ${req.params.id}`);
    try {
        const { id } = req.params;
        const result = await pool.query(
            'DELETE FROM appointments WHERE id = $1 RETURNING *',
            [id]
        );

        if (result.rowCount === 0) {
            console.log(`Appointment with ID ${id} not found.`);
            return res.status(404).json({ message: 'Appointment not found' });
        }

        console.log(`Successfully deleted appointment ID: ${id}`);
        res.json({ message: 'Appointment deleted successfully' });
    } catch (err) {
        console.error('Error deleting appointment:', err);
        res.status(500).json({ message: 'Server error deleting appointment', error: err.message });
    }
});

// Get list of distinct hospitals
router.get('/hospitals', async (req, res) => {
    try {
        const result = await pool.query(
            "SELECT DISTINCT hospital_name FROM healthworkers WHERE hospital_name IS NOT NULL ORDER BY hospital_name"
        );
        res.json(result.rows.map(row => row.hospital_name));
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching hospitals' });
    }
});

// Get list of doctors 
// Logic: Doctors are healthworkers with role 'Doctor'
router.get('/doctors', async (req, res) => {
    try {
        const { hospitalName } = req.query;
        let query = "SELECT name FROM healthworkers WHERE LOWER(role) = 'doctor'";
        let params = [];
        if (hospitalName) {
            query += " AND hospital_name = $1";
            params.push(hospitalName);
        }
        query += " ORDER BY name";
        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching doctors' });
    }
});

// Get all booked time slots for a specific doctor on a specific date
router.get('/booked-slots', async (req, res) => {
    try {
        const { doctorName, date } = req.query;
        if (!doctorName || !date) {
            return res.status(400).json({ message: 'doctorName and date are required' });
        }
        
        const result = await pool.query(
            'SELECT time FROM appointments WHERE doctor_name = $1 AND date = $2',
            [doctorName, date]
        );
        res.json(result.rows.map(row => row.time));
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching booked slots' });
    }
});

// Get all patients (appointments) for a specific doctor on a specific date
router.get('/doctor-appointments', async (req, res) => {
    try {
        const { doctorName, date } = req.query;
        if (!doctorName || !date) {
            return res.status(400).json({ message: 'doctorName and date are required' });
        }
        
        const result = await pool.query(
            'SELECT * FROM appointments WHERE doctor_name = $1 AND date = $2 ORDER BY time ASC',
            [doctorName, date]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching doctor appointments' });
    }
});

// Add a new medical record
router.post('/medical-records', async (req, res) => {
    try {
        const { healthId, doctorName, date, recordType, description } = req.body;

        if (!healthId || !doctorName || !date || !recordType) {
            return res.status(400).json({ message: 'Required fields missing' });
        }

        const result = await pool.query(
            `INSERT INTO medical_records 
             (health_id, doctor_name, date, record_type, description) 
             VALUES ($1, $2, $3, $4, $5) 
             RETURNING *`,
            [healthId, doctorName, date, recordType, description]
        );

        res.status(201).json({
            message: 'Medical record added successfully',
            record: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error adding medical record' });
    }
});

// Get all medical records for a specific health_id
router.get('/medical-records/:healthId', async (req, res) => {
    try {
        const { healthId } = req.params;
        const result = await pool.query(
            'SELECT * FROM medical_records WHERE health_id = $1 ORDER BY date DESC, created_at DESC',
            [healthId]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error fetching medical records' });
    }
});

// Mocked Public Health Stats Route
router.get('/public-health-stats', async (req, res) => {
  try {
    const { district } = req.query;
    
    // In a production app, complex joins with `registrations` table filtering by district would be here.
    // For this demonstration, we query totals.
    const activeCasesResult = await pool.query('SELECT COUNT(*) as count FROM medical_records');
    const healthCampsResult = await pool.query('SELECT COUNT(DISTINCT doctor_name) as count FROM medical_records');
    
    // Generate dummy active alerts
    const alertsList = [
      { title: "Dengue Warning", subtitle: "New cases reported in the region.", priority: "HIGH", color: "error" },
      { title: "Typhoid Watch", subtitle: "Minor incidence detected, monitoring situation.", priority: "MODERATE", color: "warning" }
    ];
    
    res.json({
      activeCases: activeCasesResult.rows[0].count,
      vaccinationRate: "75%",
      outbreakAlerts: alertsList.length,
      healthCamps: healthCampsResult.rows[0].count,
      activeAlertsList: alertsList,
      recentActivityList: [
        { title: "Camp Concluded", subtitle: "A medical camp in the selected district finished successfully." },
        { title: "New Records Synced", subtitle: "50+ new medical records uploaded today system-wide." }
      ]
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error fetching stats' });
  }
});

module.exports = router;
