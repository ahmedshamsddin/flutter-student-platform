const express = require('express');
const router = express.Router();
const attemptController = require('../controllers/attemptController');

router.post('/:id/answers', attemptController.submitAnswers);
router.post('/', attemptController.submitAttempt);
router.get('/latest', attemptController.getLatestAttemptScore);
router.get('/latest_scores', attemptController.getAllLatestScores);

module.exports = router;
