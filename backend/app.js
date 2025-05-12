const express = require('express');
const app = express();
const bodyParser = require('body-parser');

app.use(bodyParser.json());

app.use('/students', require('./routes/students'));
app.use('/teachers', require('./routes/teachers'));
app.use('/lessons', require('./routes/lessons'));
app.use('/exercises', require('./routes/excercises'));
app.use('/attempts', require('./routes/attempts'));
app.use('/admin', require('./routes/admin'));
app.use('/institutes', require('./routes/institutes'));
app.use('/centers', require('./routes/centers'));
app.use('/circles', require('./routes/circles'));
app.use('/auth', require('./routes/auth'));

module.exports = app;
