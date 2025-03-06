require('dotenv').config();
const express = require('express');
const pool = require('./config/db');
const app = express();
const port = process.env.PORT || 5000;

app.use(express.json());

app.get('/', (req, res) => res.send('Backend is running!'));

app.get('/test-db', async (req, res) => {
    try {
      const result = await pool.query('SELECT NOW()');
      res.send(`Database connected: ${result.rows[0].now}`);
    } catch (err) {
      console.error('Database Connection Error:', err.message);
      res.status(500).send('Database connection failed');
    }
  });

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
