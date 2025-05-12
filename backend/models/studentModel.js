const db = require('../db/index');
const bcrypt = require('bcrypt');

exports.getLessonsForStudent = async (studentId) => {

  const result = await db.query(`
    SELECT DISTINCT l.*
    FROM lessons l
    JOIN institutes i ON l.institute_id = i.id
    JOIN centers c ON c.institute_id = i.id
    JOIN circles h ON h.center_id = c.id
    JOIN students s ON s.circle_id = h.id
    WHERE s.id = $1
  `, [studentId]);
  console.log(result.rows);
  return result.rows;
};

