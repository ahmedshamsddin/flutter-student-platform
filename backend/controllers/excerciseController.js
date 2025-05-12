const Exercise = require('../models/excerciseModel');

exports.startAttempt = async (req, res) => {
  const { student_id } = req.body;
  const { id: exercise_id } = req.params;

  try {
    const attemptId = await Exercise.startAttempt(student_id, exercise_id);
    res.status(201).json({ attempt_id: attemptId });
  } catch (err) {
    if (err.message === "student_already_perfect") {
      return res.status(400).json({ error: "You already got full score for this exercise" });
    }
    res.status(500).json({ error: "Could not start attempt" });
  }
};

exports.getQuestionsWithAnswers = async (req, res) => {
  const exerciseId = req.params.id;

  try {
    const questions = await Exercise.getQuestionsWithAnswers(exerciseId);
    res.status(200).json(questions);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'فشل في تحميل الأسئلة والإجابات' });
  }
};
