const http = require('http');

function checkRoute(path) {
  const req = http.request('http://127.0.0.1:3000' + path, { method: 'POST', timeout: 3000 }, (res) => {
      console.log(path, 'STATUS:', res.statusCode);
      res.resume();
  });
  req.on('timeout', () => {
      console.log(path, 'TIMEOUT');
      req.destroy();
  });
  req.on('error', (e) => {
      console.log(path, 'ERROR:', e.message);
  });
  req.end();
}

checkRoute('/api/provider-login');
checkRoute('/api/login');
checkRoute('/api/alerts?district=Ernakulam');
