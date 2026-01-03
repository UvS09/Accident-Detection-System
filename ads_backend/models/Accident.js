const mongoose = require('mongoose');

const accidentSchema = new mongoose.Schema({
  location: { type: String, required: true },
  vehicle: { type: String },
  severity: { type: String },
  casualties: { type: Number },
  description: { type: String },
  timestamp: { type: Date, default: Date.now },
  userId: { type: String, default: 'guest' }
});

module.exports = mongoose.model('Accident', accidentSchema);
