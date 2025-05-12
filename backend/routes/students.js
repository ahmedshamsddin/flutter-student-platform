const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');

router.get('/:id/lessons', studentController.getLessons);


module.exports = router;
