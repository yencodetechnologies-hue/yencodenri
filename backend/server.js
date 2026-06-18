const express = require('express');
const cors = require('cors');
const path = require('path');
const connectDB = require('./src/config/db');
const config = require('./src/config/env');
const routes = require('./src/routes');
const { runSeed } = require('./src/services/seed.service');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.get('/health', (_req, res) => {
  res.json({ success: true, message: 'NRI Property Management API is running', port: config.port });
});

app.use('/api', routes);

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ success: false, message: err.message || 'Internal server error' });
});

const start = async () => {
  await connectDB();
  await runSeed();

  app.listen(config.port, () => {
    console.log(`Server running on port ${config.port}`);
  });
};

start();
