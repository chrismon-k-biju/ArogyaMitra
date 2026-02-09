const http = require('http');

function makeRequest(options, data) {
    return new Promise((resolve, reject) => {
        const req = http.request(options, (res) => {
            let body = '';
            res.on('data', (chunk) => body += chunk);
            res.on('end', () => resolve({ statusCode: res.statusCode, body: body }));
        });

        req.on('error', (e) => reject(e));

        if (data) {
            req.write(data);
        }
        req.end();
    });
}

async function testProfile() {
    try {
        console.log('Registering test user...');
        const registerData = JSON.stringify({
            phone: Math.floor(Math.random() * 10000000000).toString(),
            name: 'Test Profile User',
            age: '30',
            gender: 'Male',
            state: 'Kerala',
            occupation: 'Tester',
            password: 'password123'
        });

        const registerRes = await makeRequest({
            hostname: 'localhost',
            port: 3000,
            path: '/api/register',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': registerData.length
            }
        }, registerData);

        console.log(`Register Status: ${registerRes.statusCode}`);
        const registerBody = JSON.parse(registerRes.body);

        if (registerRes.statusCode !== 201) {
            console.error('Registration failed:', registerRes.body);
            return;
        }

        const healthId = registerBody.healthId;
        console.log(`Registered with Health ID: ${healthId}`);

        console.log('Fetching profile...');
        const profileRes = await makeRequest({
            hostname: 'localhost',
            port: 3000,
            path: `/api/profile/${healthId}`,
            method: 'GET'
        });

        console.log(`Profile Status: ${profileRes.statusCode}`);
        console.log(`Profile Body: ${profileRes.body}`);

        if (profileRes.statusCode === 200) {
            const profile = JSON.parse(profileRes.body);
            if (profile.name === 'Test Profile User' && profile.health_id === healthId) {
                console.log('SUCCESS: Profile data matches.');
            } else {
                console.log('FAILURE: Profile data mismatch.');
            }
        } else {
            console.log('FAILURE: Could not fetch profile.');
        }

    } catch (err) {
        console.error('Error:', err);
    }
}

testProfile();
