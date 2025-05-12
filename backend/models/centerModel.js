const db = require('../db/index');

exports.getCenters = async () => {
  const result = await db.query('SELECT * FROM centers');
  return result.rows;
};
