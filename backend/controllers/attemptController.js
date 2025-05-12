const Attempt = require('../models/attemptModel');

exports.submitAnswers = async (req, res) => {
  const attemptId = req.params.id;
  const answers = req.body.answers;

  try {
    const score = await Attempt.submitAnswers(attemptId, answers);
    res.json({ score });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Could not submit answers' });
  }
};

exports.submitAttempt = async (req, res) => {
  const { student_id, exercise_id, score, answers } = req.body;

  try {
    const attemptId = await Attempt.createStudentAttempt(student_id, exercise_id, score);
    await Attempt.addStudentAnswers(attemptId, answers);

    res.status(201).json({ message: 'تم الحفظ بنجاح', attemptId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'فشل في حفظ المحاولة' });
  }
};


exports.getLatestAttemptScore = async (req, res) => {
  const studentId = req.query.student_id;
  const exerciseId = req.query.exercise_id;

  if (!studentId || !exerciseId) {
    return res.status(400).json({ error: 'student_id و exercise_id مطلوبان' });
  }

  try {
    const score = await Attempt.getLatestScore(studentId, exerciseId);
    res.status(200).json({ score });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'فشل في جلب النتيجة الأخيرة' });
  }
};

exports.getAllLatestScores = async (req, res) => {
  const studentId = req.query.student_id;

  if (!studentId) {
    return res.status(400).json({ error: 'student_id مطلوب' });
  }

  try {
    const rows = await Attempt.getAllLatestScoresForStudent(studentId);
    const response = {};
    rows.forEach(row => {
      response[row.exercise_id] = row.score;
    });

    res.status(200).json(response);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'فشل في جلب المحاولات' });
  }
};
