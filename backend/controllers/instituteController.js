const Institute = require('../models/instituteModel');

exports.getInstitutes = async (req, res) => {
  try {
    const institutes = await Institute.getInstitutes();
    res.json(institutes);
  } catch (err) {
  	console.log(err);
    res.status(500).json({ error: 'Server error' });
  }
};
