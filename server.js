const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000;
const VNM_HOST = 'localhost';
const VNM_PORT = 9000;

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css':  'text/css',
  '.js':   'application/javascript',
  '.png':  'image/png',
  '.ico':  'image/x-icon',
};

const server = http.createServer((req, res) => {
  const reqUrl = new URL(req.url, `http://localhost:${PORT}`);

  // CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    });
    return res.end();
  }

  // Proxy /api/* → VNM REST API
  if (reqUrl.pathname.startsWith('/api')) {
    const options = {
      hostname: VNM_HOST,
      port: VNM_PORT,
      path: reqUrl.pathname + reqUrl.search,
      method: req.method,
      headers: {
        'Content-Type': 'application/json',
        'Host': `${VNM_HOST}:${VNM_PORT}`,
      },
    };

    const proxy = http.request(options, (proxyRes) => {
      res.writeHead(proxyRes.statusCode, {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      });
      proxyRes.pipe(res);
    });

    proxy.on('error', () => {
      res.writeHead(502, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'VNM service unavailable', status: 'disconnected' }));
    });

    req.pipe(proxy);
    return;
  }

  // Serve static files from public/
  let filePath = reqUrl.pathname === '/' ? '/index.html' : reqUrl.pathname;
  filePath = path.join(__dirname, 'public', filePath);

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      return res.end('Not found');
    }
    const ext = path.extname(filePath);
    res.writeHead(200, { 'Content-Type': MIME[ext] || 'text/plain' });
    res.end(data);
  });
});

server.listen(PORT, () => {
  console.log('');
  console.log('  VNM Control Web Started');
  //console.log(`  → http://localhost:${PORT}`);
  //console.log(`  → Proxying API to http://${VNM_HOST}:${VNM_PORT}`);
  console.log('');
});
