const Student = require('../models/studentModel');

exports.getLessons = async (req, res) => {
  try {
    const lessons = await Student.getLessonsForStudent(req.params.id);
    res.json(lessons);
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
};

