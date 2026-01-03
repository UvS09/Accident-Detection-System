const EmergencyContact = require('../models/EmergencyContact');

// POST /api/contacts
exports.createContact = async (req, res) => {
  try {
    const { name, phone, email, userId } = req.body;

    if (!name || !phone || !email || !userId) {
      return res.status(400).json({ error: 'Name, phone, email, and userId are required' });
    }

    const newContact = new EmergencyContact({ name, phone, email, userId });
    const savedContact = await newContact.save();
    res.status(201).json(savedContact);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


// GET /api/contacts/:userId
exports.getContactsByUser = async (req, res) => {
  const { userId } = req.params;

  try {
    const contacts = await EmergencyContact.find({ userId });
    res.status(200).json(contacts);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
