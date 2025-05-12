const express = require('express');
const router = express.Router();
const excerciseController = require('../controllers/excerciseController');

router.post('/:id/attempts', excerciseController.startAttempt);
router.get('/:id/questions', excerciseController.getQuestionsWithAnswers);

module.exports = router;
