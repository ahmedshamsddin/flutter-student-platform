const db = require('../db');
const bcrypt = require('bcrypt');

exports.findUserByEmail = async (email) => {
  console.log(email);
  // Search both admins and students
  const adminRes = await db.query('SELECT id, email, password, \'admin\' AS role FROM admins WHERE email = $1', [email]);
  if (adminRes.rows.length > 0) return adminRes.rows[0];

  const studentRes = await db.query('SELECT id, email, password, \'student\' AS role FROM students WHERE email = $1', [email]);
  if (studentRes.rows.length > 0) return studentRes.rows[0];

  return null;
};

exports.verifyPassword = async (plain, hash) => {
  return bcrypt.compare(plain, hash);
};
