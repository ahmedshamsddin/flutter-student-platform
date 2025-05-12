const Admin = require('../models/adminModel');

exports.addLesson = async (req, res) => {
  const { title, institute_id } = req.body;

  if (!title || !institute_id) {
    return res.status(400).json({ error: 'العنوان و المعهد مطلوبان' });
  }

  try {
    const lesson = await Admin.createLesson(title, institute_id);
    res.status(201).json(lesson);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'فشل في إنشاء الدرس' });
  }
};

exports.addExerciseWithQuestions = async (req, res) => {
  const { lesson_id, type, title, questions } = req.body;

  if (!lesson_id || !type || !Array.isArray(questions)) {
    return res.status(400).json({ error: 'بيانات غير مكتملة' });
  }

  try {
    const result = await Admin.createExerciseWithQuestions({ lesson_id, type, title, questions });
    res.status(201).json({ message: 'تم إضافة التمرين بنجاح', id: result.id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'فشل في إضافة التمرين' });
  }
};

exports.addStudent = async (req, res) => {
  const { name, email, password, circle_id } = req.body;

  if (!name || !email || !password || !circle_id) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  try {
    await Admin.createStudent({ name, email, password, circle_id });
    res.status(201).json({ message: 'Student added successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to add student' });
  }
};

exports.addTeacher = async (req, res) => {
  const { name, email, password, circle_id } = req.body;

  if (!name || !email || !password || !circle_id) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  try {
    await Admin.createTeacher({ name, email, password, circle_id });
    res.status(201).json({ message: 'Teacher added successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to add teacher' });
  }
};

exports.addCircle = async (req, res) => {
  const { name, center_id } = req.body;

  if (!name || !center_id) {
    return res.status(400).json({ error: 'name and center_id are required' });
  }

  try {
    const circle = await Admin.createCircle(name, center_id);
    res.status(201).json(circle);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to add circle' });
  }
};

exports.archiveExercise = async (req, res) => {
  const { id } = req.params;
  try {
    const exercise = await Admin.archiveExercise(id);
    if (!exercise) {
      return res.status(404).json({ error: 'Exercise not found' });
    }
    res.json({ message: 'Exercise archived', exercise });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to archive exercise' });
  }
};

exports.archiveQuestion = async (req, res) => {
  const { id } = req.params;

  try {
    const question = await Admin.archiveQuestion(id);
    if (!question) {
      return res.status(404).json({ error: 'Question not found' });
    }
    res.json({ message: 'Question archived', question });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to archive question' });
  }
};

