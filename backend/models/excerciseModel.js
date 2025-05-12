const db = require('../db/index');

exports.startAttempt = async (student_id, exercise_id) => {
  const existing = await db.query(
    `SELECT * FROM student_attempts WHERE student_id = $1 AND exercise_id = $2`,
    [student_id, exercise_id]
  );

  const previousScore = existing.rows[0]?.score ?? 0;
  if (previousScore === 20) {
    throw new Error("student_already_perfect");
  }

  const result = await db.query(`
    INSERT INTO student_attempts (student_id, exercise_id, score)
    VALUES ($1, $2, 0)
    RETURNING id
  `, [student_id, exercise_id]);

  return result.rows[0].id;
};

exports.getQuestionsWithAnswers = async (exerciseId) => {
  const result = await db.query(`
    SELECT
      q.id AS question_id,
      q.text AS question_text,
      json_agg(json_build_object(
        'id', a.id,
        'text', a.text,
        'is_correct', a.is_correct
      )) AS answers
    FROM questions q
    JOIN answers a ON a.question_id = q.id
    WHERE q.exercise_id = $1 AND q.archived = FALSE
    GROUP BY q.id, q.text
    ORDER BY q."order" ASC
  `, [exerciseId]);

  return result.rows.map(row => ({
    id: row.question_id,
    text: row.question_text,
    answers: row.answers
  }));
};

