const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const accidentRoutes = require('./routes/accidentRoutes');
const sosRoutes = require('./routes/sosRoutes');
const contactRoutes = require('./routes/contactRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middleware
app.use(cors());
app.use(express.json()); // Parses incoming JSON requests

// Mount all routes
app.use('/api/accidents', accidentRoutes);
app.use('/api/sos', sosRoutes);
app.use('/api/contacts', contactRoutes);
app.use('/api/auth', authRoutes); // Load auth routes last (login/register)

// Test route (optional)
app.get('/', (req, res) => {
  res.send('🚀 ADS Backend Running');
});

// Connect MongoDB and start server
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('✅ MongoDB Connected');
    app.listen(8080, () => console.log('🚀 Server running on port 8080'));
  })
  .catch(err => console.error('MongoDB connection error:', err));
