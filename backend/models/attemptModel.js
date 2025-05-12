const db = require('../db/index');

exports.submitAnswers = async (attemptId, answers) => {
  for (const ans of answers) {
    const check = await db.query(
      'SELECT is_correct FROM answers WHERE id = $1',
      [ans.answer_id]
    );
    const isCorrect = check.rows[0]?.is_correct ?? false;

    await db.query(`
      INSERT INTO student_answers (attempt_id, question_id, answer_id, is_correct)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (attempt_id, question_id) DO NOTHING
    `, [attemptId, ans.question_id, ans.answer_id, isCorrect]);
  }

  const scoring = await db.query(`
    SELECT
      SUM(CASE WHEN is_correct THEN 10 ELSE -5 END) as total
    FROM student_answers
    WHERE attempt_id = $1
  `, [attemptId]);

  const score = scoring.rows[0].total ?? 0;

  await db.query(`
    UPDATE student_attempts
    SET score = $1, completed_at = CURRENT_TIMESTAMP
    WHERE id = $2
  `, [score, attemptId]);

  return score;
};

exports.createStudentAttempt = async (studentId, exerciseId, score) => {
  const result = await db.query(
    `INSERT INTO student_attempts (student_id, exercise_id, score)
     VALUES ($1, $2, $3) RETURNING id`,
    [studentId, exerciseId, score]
  );
  return result.rows[0].id;
};

exports.addStudentAnswers = async (attemptId, answers) => {
  const values = answers.map((a) => [
    attemptId,
    a.question_id,
    a.answer_id,
    a.is_correct,
  ]);

  const query = `
    INSERT INTO student_answers (attempt_id, question_id, answer_id, is_correct)
    VALUES ${values.map((_, i) => `($${i * 4 + 1}, $${i * 4 + 2}, $${i * 4 + 3}, $${i * 4 + 4})`).join(', ')}
  `;

  const flatValues = values.flat();
  await db.query(query, flatValues);
};


exports.getLatestScore = async (studentId, exerciseId) => {
  const result = await db.query(
    `
    SELECT score
    FROM student_attempts
    WHERE student_id = $1 AND exercise_id = $2
    ORDER BY completed_at DESC
    LIMIT 1
    `,
    [studentId, exerciseId]
  );
  
  return result.rows[0]?.score ?? null;
};

exports.getAllLatestScoresForStudent = async (studentId) => {
  const result = await db.query(`
    SELECT exercise_id, MAX(score) AS score
    FROM student_attempts
    WHERE student_id = $1
    GROUP BY exercise_id
  `, [studentId]);

  return result.rows; // Array of { exercise_id, score }
};
