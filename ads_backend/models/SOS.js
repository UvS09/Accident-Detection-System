const mongoose = require('mongoose');

const sosSchema = new mongoose.Schema({
  location: {
    type: String ,
    required: true,
  },
  userId: {
    type: String, // You can make this required once auth is added
    default: 'guest',
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('SOS', sosSchema);
