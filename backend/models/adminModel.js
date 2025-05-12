const db = require('../db/index');
const bcrypt = require('bcrypt');

exports.createLesson = async (title, instituteId) => {
  const result = await db.query(
    `INSERT INTO lessons (title, institute_id)
     VALUES ($1, $2) RETURNING *`,
    [title, instituteId]
  );
  return result.rows[0];
};

exports.createExerciseWithQuestions = async ({ lesson_id, title, type, questions }) => {
  // Insert the exercise
  const exerciseRes = await db.query(
    `INSERT INTO exercises (lesson_id, title, type) VALUES ($1, $2, $3) RETURNING id`,
    [lesson_id, title, type]
  );
  const exerciseId = exerciseRes.rows[0].id;

  for (const question of questions) {
    const qRes = await db.query(
      `INSERT INTO questions (exercise_id, text, "order") VALUES ($1, $2, $3) RETURNING id`,
      [exerciseId, question.text, question.order]
    );
    const questionId = qRes.rows[0].id;

    for (const answer of question.answers) {
      await db.query(
        `INSERT INTO answers (question_id, text, is_correct) VALUES ($1, $2, $3)`,
        [questionId, answer.text, answer.is_correct]
      );
    }
  }

  return { id: exerciseId };
};

exports.createStudent = async ({ name, email, password, circle_id }) => {
  const hashedPassword = await bcrypt.hash(password, 10);

  await db.query(
    `INSERT INTO students (name, email, password, circle_id) VALUES ($1, $2, $3, $4)`,
    [name, email, hashedPassword, circle_id]
  );
};


exports.createTeacher = async ({ name, email, password, circle_id }) => {
  const hashedPassword = await bcrypt.hash(password, 10);

   const teacherRes =   await db.query(
    `INSERT INTO teachers (name, email, password, circle_id) VALUES ($1, $2, $3, $4) RETURNING id`,
    [name, email, hashedPassword, circle_id]
  );
   
  const teacherId = teacherRes.rows[0].id;

  if (circle_id) {
    await db.query(
      `UPDATE circles SET teacher_id = $1 WHERE id = $2`,
      [teacherId, circle_id]
    );
  }

  return { id: teacherId };
};

exports.createCircle = async (name, center_id) => {
  const result = await db.query(
    `INSERT INTO circles (name, center_id) VALUES ($1, $2) RETURNING *`,
    [name, center_id]
  );
  return result.rows[0];
};

exports.archiveExercise = async (exercise_id) => {
  const result = await db.query(
    `UPDATE exercises
     SET archived = NOT archived
     WHERE id = $1
     RETURNING *`,
    [exercise_id]
  );
  return result.rows[0];
};

exports.archiveQuestion = async (question_id) => {
  const result = await db.query(
    `UPDATE questions SET archived = NOT archived WHERE id = $1 RETURNING *`,
    [question_id]
  );
  return result.rows[0];
};
