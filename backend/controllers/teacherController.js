const Teacher = require('../models/teacherModel');

exports.addTeacher = async (req, res) => {
  const { name, email, password, circle_id } = req.body;

  if (!name || !email || !password || !circle_id) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  try {
    await Teacher.createTeacher({ name, email, password, circle_id });
    res.status(201).json({ message: 'Teacher added successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to add teacher' });
  }
};