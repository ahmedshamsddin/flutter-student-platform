const express = require('express');
const router = express.Router();
const centerController = require('../controllers/centerController');

router.get('/', centerController.getCenters);

module.exports = router;
