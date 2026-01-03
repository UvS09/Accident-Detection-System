const express = require('express');
const { createAccident, getAccidents } = require('../controllers/accidentController');
const router = express.Router();

// debug middleware
router.use((req, res, next) => {
  console.log('→', req.method, req.originalUrl);
  next();
});

router.post('/', createAccident);
router.get('/', getAccidents);

module.exports = router;
