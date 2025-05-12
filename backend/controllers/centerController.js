const Center = require('../models/centerModel');

exports.getCenters = async (req, res) => {
  try {
    const centers = await Center.getCenters();
    res.json(centers);
  } catch (err) {
  	console.log(err);
    res.status(500).json({ error: 'Server error' });
  }
};
