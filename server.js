const express = require('express');
const path = require('path');

const app = express();
const PORT = 5500;
const HOST = '127.0.0.1';

app.use(express.static(path.join(__dirname, 'public')));

app.listen(PORT, HOST, () => {
console.log(`🚀   Codespaces live-reload (what??!!) working at http://${HOST}:${PORT}`);
});
