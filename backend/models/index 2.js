const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
const sessionRoutes = require('./routes/sessionRoutes');
const userRoutes = require('./routes/userRoutes');

// Enable CORS
app.use(cors());

// Use JSON body parser middleware
app.use(bodyParser.json());

// Routes
app.use('/api/sessions', sessionRoutes);
app.use('/api/users', userRoutes);

// Basic error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

// Server listener
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});