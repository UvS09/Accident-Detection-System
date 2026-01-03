const Accident = require('../models/Accident');

exports.createAccident = async (req, res) => {
  try {
    const acc = await Accident.create(req.body);
    res.status(201).json(acc);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

exports.getAccidents = async (req, res) => {
  try {
    const list = await Accident.find().sort('-timestamp');
    res.json(list);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
