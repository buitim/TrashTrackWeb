var express = require('express');
var express_handlebars = require('express-handlebars');
var handlebars = require('handlebars'); // handlebars is a template system we will use for our pages


var app = express();
app.set('view engine', 'handlebars');
app.engine('handlebars', express_handlebars({ defaultLayout: 'main' }));
app.use(express.static('public'));


//Parsing data
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
var path = require('path');


// connect to heroku postgres database using example code from heroku

const { Client } = require('pg');

var db = new Client({

	connectionString: process.env.DATABASE_URL,
	ssl: true,

});

db.connect();


var min_year;
var max_year;

// gets the least recent year value and most recent year value from the database
function get_year_range() {

	db.query('SELECT MIN(year) AS year FROM public.season', (error, result) => {
		if (error) {
			min_year = 0;
		} else {
			min_year = (result.rows[0]["year"])
		}
	});

	db.query('SELECT MAX(year) AS year FROM public.season', (error, result) => {
		if (error) {
			max_year = 0;
		} else {
			max_year = (result.rows[0]["year"])
		}
	});

}

get_year_range();


// compares value to list of values, returns true if it matches any or false if it matches none
function compare_values(value, list) {

	for (x in list) {

		if (value === list[x]) {
			return true;
		}

	}

	return false;

}

// capitalize first character of a string and return result
function capitalize_string(string) {

	var new_string = string[0].toUpperCase() + string.substring(1); // toUpperCase() returns only the first character, must add the rest
	return new_string;

}

// fixes the column names retrieved from the database to have spaces instead of underscores and proper capitalization
function fix_headers(headers) {
	
	var new_headers = [];
	
	for (x in headers) {
		
		new_headers.push( capitalize_string(headers[x]) );
		
		/* 
		
		new_headers[x] = new_headers[x].replace(/_/g, ' ');
		
		for (y in new_headers[x]) {
			
			if (new_headers[x][y] === ' ') {
				
				new_headers[x] = new_headers[x].slice(0, y) + capitalize_string( new_headers[x].slice(y + 1) ); console.log(new_headers[x].slice(0, y) + capitalize_string( new_headers[x].slice(y + 1) ));
				
			}
			
		}
		
		*/
		
	}
	
	return new_headers;
	
}

// checks query parameters and returns a list of valid values
function process_browse_parameters(parameters) {

	var type, season, year;

	console.log(parameters);

	if ('type' in parameters) {

		var type_valid = compare_values(parameters.type, ['show', 'character', 'voice_actor', 'studio']);
		if (type_valid === true) {
			type = parameters.type;
		} else {
			type = 'show';
		}

	} else {
		type = 'show';
	}

	if ('season' in parameters) {

		var season_valid = compare_values(parameters.season, ['any', 'fall', 'winter', 'spring', 'summer']);
		if (season_valid === true) {
			season = parameters.season;
		} else {
			season = 'any';
		}

	} else {
		season = 'any';
	}

	if ('year' in parameters) {

		if (parameters.year >= min_year && parameters.year <= max_year) {
			year = parameters.year;
		} else {
			year = max_year;
		}

	} else {
		year = max_year;
	}

	console.log([type, season, year]);

	return [type, season, year];

}

// constructs query for database using array of strings as parameters
function build_browse_query(parameters) {

	var query_text, query_values = [], query;

	query_text = 'SELECT * FROM public.' + parameters[0] + '_view WHERE year = $1';
	query_values.push(parameters[2]); // add value of $1 to the list

	if (parameters[1] != 'any') {

		query_text = query_text + ' AND season = $2'; // add another condition for WHERE if a particular season was specified
		query_values.push(capitalize_string(parameters[1])); // add the value of $2 to the list

	}

	query = { text: query_text, values: query_values };

	return query;

}


function process_create_parameters(parameters){

	var year, name, character_first, character_last, voice_first, voice_last, season, studio;

	// console.log(parameters);

	// if ('title' in parameters){
	// 	if(parameters.title )

	// }
	// if('year')
	// year = parameters.year;
	// name = parameters.title;
	// character_first = parameters.
	for(x in parameters){
		if(parameters[x] == '\0')
			parameters[x] = NULL;
	}

	year = parameters.year;
	name = parameters.title;
	character_first = parameters.char_first;
	character_last = parameters.char_last;
	voice_first = parameters.voice_first;
	voice_last = parameters.voice_last;
	studio = parameters.studio;
	season = parameters.season;

	console.log(parameters.year);

	return [name,character_first,character_last,voice_first,voice_last,studio,year,season];


}

function build_create(parameters) {

	var show_query, season_query, character_query, studio_query, voice_query;
	var query1, query2, query3, query4, query5;

	show_query = 'INSERT INTO public.show (title) VALUES ($1)';
	character_query = 'INSERT INTO public.character (first_name,last_name) VALUES ($2,$3)';
	voice_query = 'INSERT INTO public.voice_actor (first_name,last_name) VALUES ($4,$5)';
	studio_query = 'INSERT INTO public.studio (name) VALUES ($6)';
	season_query = 'INSERT INTO public.season (year,season) VALUES ($7,$8)';

	var query_array = [show_query, character_query, voice_query, studio_query, season_query];

	query1 = {
		text: show_query,
		values: parameters[0],
		rowMode: 'array'
	};
	query2 = {
		text: character_query,
		values: [parameters[1], parameters[2]],
		rowMode: 'array'
	};
	query3 = {
		text: voice_query,
		values: [parameters[3], parameters[4]],
		rowMode: 'array'
	};
	query4 = {
		text: studio_query,
		values: parameters[5],
		rowMode: 'array'
	};
	query5 = {
		text: season_query,
		values: [parameters[6], parameters[7]],
		rowMode: 'array'
	};

	var query_values = [query1, query2, query3, query4, query5];

	return query_values;

}


function build_delete(parameters) {

}


function build_update(parameters) {

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

app.get('/manage', function (req, res) {
	res.render('manage');
});


app.get('/create', function(req,res){
	// res.sendFile('create.handlebars', {root: path.join(__dirname, './views')});
	res.render('create');
});

app.post('/create', function (req, res) {

	try{
		console.log(req.body);
		var parameters = process_create_parameters(req.body);
		var query = build_create(parameters);
	
		console.log(query);
	
		for (x in query) {
			db.query(query[x], function (error, result) {
	
				if (error) {
					throw error;
				} else {
					// res.render('create',query[x]);
					res.send("Work");
				}
			});
		}
	}
	catch(e){
	console.log("Hello!");
	res.send("Error! boi!");

	}

	// res.end(JSON.stringify(req.body.year));
	// process_create_parameters(req.body.show);

	// var show_name = req.body.show;
	// console.log(show_name);
	// res.render('create');

});

// handles any queries user makes through the limited front end interface
app.get('/browse*', function (req, res, next) {


	get_year_range(); // update values just in case they have changed, does not matter when this completes

	var parameters = process_browse_parameters(req.query);

	var query = build_browse_query(parameters); // this should be safe from injection, because of parameter processing 

	console.log(query);

	db.query(query, function (error, result) {

		if (error) {
			throw error;
		} else {

			console.log("Query done!");

			var query_results = [], query_headers = [];
			
			query_headers = fix_headers( Object.keys(result.rows[0]) ); console.log(query_headers);
			
			for (x in result.rows) {
				query_results.push( Object.values(result.rows[x]) );
			}

			var context = {
				min_year: min_year,
				max_year: max_year,
				headers: query_headers,
				results: query_results
			};
			
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