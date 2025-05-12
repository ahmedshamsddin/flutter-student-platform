const express = require('express');
const router = express.Router();
const lessonController = require('../controllers/lessonController');

router.get('/:lessonId/exercises', lessonController.getExercises);
router.get('/', lessonController.getLessons);
router.get('/exercises', lessonController.getLessonsWithExercises);

module.exports = router;
