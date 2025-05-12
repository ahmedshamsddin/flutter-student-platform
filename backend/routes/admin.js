const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');

router.post('/lessons', adminController.addLesson);
router.post('/exercises', adminController.addExerciseWithQuestions);
router.post('/students', adminController.addStudent);
router.post('/teachers', adminController.addTeacher);
router.post('/circles', adminController.addCircle);
router.patch('/exercises/:id/archive', adminController.archiveExercise);
router.patch('/questions/:id/archive', adminController.archiveQuestion);

module.exports = router;
