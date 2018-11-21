var express = require('express');

var app = express();


app.set('view engine', 'ejs');
app.use(express.static('public'));

// connect to heroku postgres database using example code from heroku

const { Client } = require('pg');

var db = new Client({
	
  connectionString: process.env.DATABASE_URL,
  ssl: true,
  
});

db.connect();

db.query('SELECT table_schema,table_name FROM information_schema.tables;', (error, result) => {
	
  if (error) throw error;
  
  for (let row of result.rows) { console.log(JSON.stringify(row)); }
  
  db.end();
  
});


// set the port of our application
// process.env.PORT lets the port be set by Heroku
var port = process.env.PORT || 8080;

// make express look in the public directory for assets (css/js/img)
app.use(express.static(__dirname + '/public'));

app.get('/app', function (req, res) {
	res.render('index');
});

var server = app.listen(port, function () {
	console.log(`== Express running → PORT ${server.address().port}`);
});