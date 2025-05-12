const Circle = require('../models/circleModel');

exports.getCircles = async (req, res) => {
  try {
    const circles = await Circle.getCircles();
    res.json(circles);
  } catch (err) {
  	console.log(err);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.getCirclesAvailable = async (req, res) => {
  try {
    const circles = await Circle.getCirclesAvailable();
    res.json(circles);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: 'Server error' });
  }
};
