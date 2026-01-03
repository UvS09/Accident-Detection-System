const express = require('express');
const router = express.Router();
const { triggerSOS, getAllSOS } = require('../controllers/sosController');

router.post('/', triggerSOS);
router.get('/', getAllSOS);

module.exports = router;
