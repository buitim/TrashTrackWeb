var http = require('http');
var url = require('url');
var express = require('express');
var express_handlebars = require('express-handlebars');
var handlebars = require('handlebars'); // handlebars is a template system we will use for our pages


var app = express();
app.set('view engine', 'handlebars');
app.engine('handlebars', express_handlebars({defaultLayout: 'main'}));
app.use(express.static('public'));


// connect to heroku postgres database using example code from heroku

const { Client } = require('pg');

var db = new Client ({

	connectionString: process.env.DATABASE_URL,
	ssl: true,

});

db.connect();


var min_year, max_year;

db.query('SELECT MIN(year) AS year FROM public.season', (error, result) => {
	if (error) { throw error; } 
	else { min_year = (result.rows[0]["year"]) }
});

db.query('SELECT MAX(year) AS year FROM public.season', (error, result) => {
	if (error) { throw error; } 
	else { max_year = (result.rows[0]["year"]) }
});


// set the port of our application
// process.env.PORT lets the port be set by Heroku
var port = process.env.PORT || 8080;

// make express look in the public directory for assets (css/js/img)
app.use(express.static(__dirname + '/public'));

// if root page is requested, find "index.handlebars" in views and show it to user
app.get('/', function (req, res) {
	res.render('index');
});

// if index page is requested, find "index.handlebars" in views and show it to user
app.get('/index', function (req, res) {
	res.render('index');
});

app.get('browse?*', function (req, res) {
	
	var url = req.url;
	console.log(req.url);
	
});

// if browse page is requested, find "browse.handlebars" in views and show it to user
app.get('/browse', function (req, res) {
	
	var context, query, query_result = [];

	query = {text: 'SELECT * FROM (public.season NATURAL JOIN public.show) WHERE year = $1', values: [ max_year ], rowMode: 'array'};
	
	db.query(query, function (error, result) {

		if (error) { throw error; } 
		else { 
			
			for (x in result.rows) {
				query_result.push( result.rows[x] );
				console.log( result.rows[x] );
			}
			
			context = { min_year: min_year, max_year: max_year, results: query_result };
			
			res.render('browse', context);
		}
		
	});
	
});

// for anything else, just show 404 error
app.get('*', function (req, res) {
	res.status(404);
	res.render('error404');
});


var server = app.listen(port, function () {
	console.log(`== Express running → PORT ${server.address().port}`);
});