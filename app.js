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


var min_year;
var max_year;

// gets the least recent year value and most recent year value from the database
function get_year_range () {
	
	db.query('SELECT MIN(year) AS year FROM public.season', (error, result) => {
		if (error) { min_year = 0; } 
		else { min_year = (result.rows[0]["year"]) }
	});

	db.query('SELECT MAX(year) AS year FROM public.season', (error, result) => {
		if (error) { max_year = 0; } 
		else { max_year = (result.rows[0]["year"]) }
	});
	
}

get_year_range();


// compares value to list of values, returns true if it matches any or false if it matches none
function compare_values (value, list) {
	
	for (x in list) {
		
		if (value === list[x]) { return true; }
		
	}
	
	return false;
	
}

// capitalize first character of a string and return result
function capitalize_string (string) {
	
	var new_string = string[0].toUpperCase() + string.substring(1); // toUpperCase() returns only the first character, must add the rest
	return new_string;
	
}

// checks query parameters and returns a list of valid values
function process_parameters (parameters) {
	
	var type, season, year;
	
	console.log(parameters);
	
	if ('type' in parameters) {
		
		var type_valid = compare_values( parameters.type, [ 'show', 'character', 'voice_actor', 'studio' ] );
		if (type_valid === true) { type = parameters.type; }
		else { type = 'show'; }
		
	}
	else { type = 'show'; }
	
	if ('season' in parameters) {
		
		var season_valid = compare_values( parameters.season, [ 'any', 'fall', 'winter', 'spring', 'summer' ] );
		if (season_valid === true) { season = parameters.season; }
		else { season = 'any'; }
		
	}
	else { season = 'any'; }
	
	if ('year' in parameters) {
		
		if (parameters.year >= min_year && parameters.year <= max_year) { year = parameters.year; }
		else { year = max_year; }
		
	}
	else { year = max_year; }
	
	console.log([ type, season, year ]);
	
	return [ type, season, year ];
	
}

// constructs query for database using array of strings as parameters
function build_query (parameters) {
	
	var query_text, query_values = [], query;
	
	query_text = 'SELECT * FROM public.' + parameters[0] + '_view WHERE year = $1';
	query_values.push( parameters[2] );
		
	if (parameters[1] != 'any') {
	
		query_text = query_text + ' AND season = $2'; // add another condition for WHERE if a particular season was specified
		query_values.push( capitalize_string(parameters[1]) );
		
	}
	
	query = { text: query_text, values: query_values, rowMode: 'array' }
	
	return query;
	
}


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


app.get('/manage', function(req,res){
	res.render('manage');
});


// handles any queries user makes through the limited front end interface
app.get('/browse*', function (req, res, next) {
	
	get_year_range(); // update values just in case they have changed, does not matter when this completes
	
	var parameters = process_parameters(req.query);
	
	var query = build_query(parameters); // this should be safe from injection, because of parameter processing 
	
	console.log(query);
	
	db.query(query, function (error, result) {

		if (error) { throw error; } 
		else { 
			
			console.log("Query done!");
			
			var query_result = [];
			for (x in result.rows) { query_result.push( result.rows[x] ); }
	
			var context = { min_year: min_year, max_year: max_year, results: query_result };
			res.render('browse', context);
			
		}
		
	});
	
});

/*

// if browse page is requested, find "browse.handlebars" in views and show it to user
app.get('/browse', function (req, res) {
	
	var context, query, query_result = [];

	query = {text: 'SELECT title, name, season, year FROM (public.show NATURAL JOIN public.studio NATURAL JOIN public.season) WHERE year = $1 ORDER BY title', values: [ max_year ], rowMode: 'array'};
	
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

*/

// for anything else, just show 404 error
app.get('*', function (req, res) {
	res.status(404);
	res.render('error404');
});


var server = app.listen(port, function () {
	console.log(`== Express running → PORT ${server.address().port}`);
});