const http = require('http');

const req = http.request('http://127.0.0.1:3000/api/public-health-login', { method: 'POST', timeout: 3000 }, (res) => {
    console.log('STATUS:', res.statusCode);
    res.resume();
});
req.on('timeout', () => {
    console.log('TIMEOUT');
    req.destroy();
});
req.on('error', (e) => {
    console.log('ERROR:', e.message);
});
req.end();
