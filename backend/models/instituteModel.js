const db = require('../db/index');

exports.getInstitutes = async () => {
  const result = await db.query('SELECT * FROM institutes');
  return result.rows;
};
