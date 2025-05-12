const db = require('../db/index');

exports.getExercisesForLesson = async (lessonId) => {
  const result = await db.query(`
SELECT 
  e.id,
  e.lesson_id,
  e.title,
  e.type,
  e.archived,
  COUNT(q.id) AS question_count
FROM exercises e
JOIN questions q ON q.exercise_id = e.id
WHERE e.lesson_id = $1
  AND e.archived = FALSE
  AND q.archived = FALSE
GROUP BY e.id, e.lesson_id, e.title, e.type, e.archived
  `, [lessonId]);
  return result.rows;
};

exports.getLessons = async () => {
  const result = await db.query(
    'SELECT * FROM lessons'
  );
  return result.rows;
}

exports.getLessonsWithExercises = async () => {

  const result = await db.query(
    `SELECT 
      l.id AS id,
      l.title AS title,
      l.institute_id AS institute_id,
      COALESCE(json_agg(
        CASE 
          WHEN e.id IS NOT NULL THEN
            json_build_object(
              'id', e.id,
              'lesson_id', e.lesson_id,
              'title', e.title,
              'type', e.type,
              'archived', e.archived,
              'questions', (
                SELECT COALESCE(json_agg(
                  json_build_object(
                    'id', q.id,
                    'text', q.text,
                    'archived', q.archived
                  )
                ) FILTER (WHERE q.id IS NOT NULL), '[]')
                FROM questions q
                WHERE q.exercise_id = e.id
              )
            )
        END
      ) FILTER (WHERE e.id IS NOT NULL), '[]') AS exercises
    FROM lessons l
    LEFT JOIN exercises e ON e.lesson_id = l.id
    GROUP BY l.id, l.title, l.institute_id
    ORDER BY l.id;`
  );
  return result.rows;
};
