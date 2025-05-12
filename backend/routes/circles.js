const express = require('express');
const router = express.Router();
const circleController = require('../controllers/circleController');

router.get('/available', circleController.getCirclesAvailable);
router.get('/', circleController.getCircles);


module.exports = router;
