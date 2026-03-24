const pool = require('./db');
const bcrypt = require('bcryptjs');

const districts = [
  'Thiruvananthapuram', 'Kollam', 'Pathanamthitta', 'Alappuzha', 
  'Kottayam', 'Idukki', 'Ernakulam', 'Thrissur', 'Palakkad', 
  'Malappuram', 'Kozhikode', 'Wayanad', 'Kannur', 'Kasaragod'
];

async function run() {
  try {
    const password = await bcrypt.hash('password123', 10);
    let count = 0;
    
    for (const district of districts) {
      const hospitals = [`General Hospital ${district}`, `CHC ${district}`];
      
      for (const hospital of hospitals) {
        // 5 Doctors per hospital
        for (let i = 1; i <= 5; i++) {
          await pool.query(
            `INSERT INTO healthworkers (username, password, role, name, district, hospital_name) VALUES ($1, $2, $3, $4, $5, $6)`,
            [`doc_${district.toLowerCase().substring(0,4)}_${hospital.startsWith('General')?1:2}_${i}`, password, 'Doctor', `Dr. ${district} ${i}`, district, hospital]
          );
          count++;
        }
        
        // 10 Nurses per hospital 
        for (let i = 1; i <= 10; i++) {
          await pool.query(
            `INSERT INTO healthworkers (username, password, role, name, district, hospital_name) VALUES ($1, $2, $3, $4, $5, $6)`,
            [`nurse_${district.toLowerCase().substring(0,4)}_${hospital.startsWith('General')?1:2}_${i}`, password, 'Nurse', `Nurse ${district} ${i}`, district, hospital]
          );
          count++;
        }
        
        // 10 Health Workers per hospital
        for (let i = 1; i <= 10; i++) {
          await pool.query(
            `INSERT INTO healthworkers (username, password, role, name, district, hospital_name) VALUES ($1, $2, $3, $4, $5, $6)`,
            [`hw_${district.toLowerCase().substring(0,4)}_${hospital.startsWith('General')?1:2}_${i}`, password, 'Health Worker', `Worker ${district} ${i}`, district, hospital]
          );
          count++;
        }
      }
      console.log(`Seeded ${district}`);
    }
    console.log(`Seeding complete. Inserted ${count} records.`);
  } catch (e) {
    console.error(e);
  } finally {
    pool.end();
  }
}
run();
