const Lesson = require('../models/lessonModel');

exports.getExercises = async (req, res) => {
  try {
    const exercises = await Lesson.getExercisesForLesson(req.params.lessonId);
    res.json(exercises);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch exercises' });
  }
};

exports.getLessons = async (req, res) => {

  try {
    lessons = await Lesson.getLessons();

    res.status(200).json(lessons);
  } catch (err) {
    console.error(err);
    res.status(500).json("حدث خطأ ما");
  }
}

exports.getLessonsWithExercises = async (req, res) => {
  try {
    lessonsWithExercises = await Lesson.getLessonsWithExercises();
    console.log(lessonsWithExercises);
    res.status(200).json(lessonsWithExercises);
  } catch (err) {
    console.error(err);
    res.status(500).json("حدث خطأ ما");
  }
}