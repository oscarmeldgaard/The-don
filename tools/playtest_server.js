#!/usr/bin/env node
// Static server for the playtest build. Zero dependencies — node only.
//
//   flutter build web --release
//   node tools/playtest_server.js
//
// Then open the URLs it prints. See docs/playtest.md for the session.
//
// Why this exists rather than `python -m http.server`: the build has to be
// served over HTTP (a file:// page cannot load main.dart.js), the correct wasm
// and json MIME types matter to canvaskit, and the facilitator should not be
// debugging a web server in front of the participant.

const http = require('http');
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', 'build', 'web');
const PORT = Number(process.env.PORT || 8080);

const TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.wasm': 'application/wasm',
  '.css': 'text/css; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.ico': 'image/x-icon',
  '.svg': 'image/svg+xml',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.bin': 'application/octet-stream',
  '.symbols': 'text/plain; charset=utf-8',
};

if (!fs.existsSync(path.join(ROOT, 'index.html'))) {
  console.error('No build found at ' + ROOT);
  console.error('Run:  flutter build web --release');
  process.exit(1);
}

http.createServer((req, res) => {
  // Query string carries the playtest hooks; strip it before resolving a file.
  const url = decodeURIComponent(req.url.split('?')[0]);
  let file = path.join(ROOT, url === '/' ? 'index.html' : url);

  // Never serve outside the build directory.
  if (!path.resolve(file).startsWith(path.resolve(ROOT))) {
    res.writeHead(403).end('forbidden');
    return;
  }
  if (fs.existsSync(file) && fs.statSync(file).isDirectory()) {
    file = path.join(file, 'index.html');
  }
  fs.readFile(file, (err, body) => {
    if (err) {
      res.writeHead(404, { 'content-type': 'text/plain' }).end('not found');
      return;
    }
    res.writeHead(200, {
      'content-type': TYPES[path.extname(file).toLowerCase()] ||
        'application/octet-stream',
      // The build is rebuilt between sessions; never let a stale run be cached.
      'cache-control': 'no-store',
    }).end(body);
  });
}).listen(PORT, () => {
  const base = 'http://localhost:' + PORT;
  console.log('');
  console.log('  Playtest build served from ' + ROOT);
  console.log('');
  console.log('  Runs 1-3, unguided and recorded:');
  console.log('    ' + base + '/?trace=1&label=run1');
  console.log('    ' + base + '/?trace=1&label=run2');
  console.log('    ' + base + '/?trace=1&label=run3');
  console.log('');
  console.log('  Run 4, the seeded burn run, recorded separately:');
  console.log('    ' + base + '/?trace=1&seed=100&label=burn');
  console.log('');
  console.log('  Open devtools console BEFORE the session and leave it on a');
  console.log('  second screen or minimised. The trace prints there at each');
  console.log('  death. The participant must never see it.');
  console.log('');
  console.log('  Ctrl-C to stop.');
});
