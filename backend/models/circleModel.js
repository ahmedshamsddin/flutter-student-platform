const db = require('../db/index');

exports.getCircles = async () => {
  const result = await db.query('SELECT * FROM circles');
  return result.rows;
};

exports.getCirclesAvailable = async () => {
  const result = await db.query('SELECT * FROM circles WHERE teacher_id is null');
  return result.rows;
};
