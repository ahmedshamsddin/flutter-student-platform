const jwt = require('jsonwebtoken');
const Auth = require('../models/authModel');

exports.login = async (req, res) => {
  const { email, password } = req.body;
  console.log(email);
  try {
    const user = await Auth.findUserByEmail(email);
    if (!user) return res.status(401).json({ error: 'مستخدم غير موجود' });

    const valid = await Auth.verifyPassword(password, user.password);
    if (!valid) return res.status(401).json({ error: 'كلمة المرور غير صحيحة' });

    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET || 'mysecret',
      { expiresIn: '7d' }
    );

    res.json({ token, role: user.role, id: user.id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'خطأ في تسجيل الدخول' });
  }
};

exports.getCurrentUser = async (req, res) => {
  const { user } = req; // attached by middleware
  res.json({ id: user.id, role: user.role });
};
