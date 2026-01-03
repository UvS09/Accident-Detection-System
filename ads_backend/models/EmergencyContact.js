const mongoose = require('mongoose');

const emergencyContactSchema = new mongoose.Schema({
  name: String,
  phone: String,
  email: String, // ← required for email alert
  userId: String
});

module.exports = mongoose.model('EmergencyContact', emergencyContactSchema);
