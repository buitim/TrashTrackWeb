var express = require('express');
var express_handlebars = require('express-handlebars');
var handlebars = require('handlebars'); // handlebars is a template system we will use for our pages


var app = express();
app.set('view engine', 'handlebars');
app.engine('handlebars', express_handlebars({
	defaultLayout: 'main'
}));
app.use(express.static('public'));


//for parsing data
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var path = require('path');


// connect to heroku postgres database using example code from heroku

const {
	Client
} = require('pg');

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


// check if string contains only digits and thus is semantically same as an integer
function is_integer(string) {
	
	if (string.length === 0) { return false; }
	
	for (x in string) {
		
		if (string[x] < '0' || string[x] > '9') { return false; }
		
	}
	
	return true;
}

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

// replace underscores in each string of array with spaces`
function underscores_to_spaces(strings) {

	var new_strings = [];

	for (x in strings) {

		new_strings.push(strings[x].replace(/_/g, ' ')); // replace underscores with space using regular expression, add new string to array of processed strings

	}

	return new_strings;

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
			year = 'any';
		}

	} else {
		year = 'any';
	}

	console.log([type, season, year]);

	return [type, season, year];

}

// constructs query for database using array of strings as parameters
function build_browse_query(parameters) {

	var query_text, query_values = [],
		query;

	query_text = 'SELECT * FROM public.' + parameters[0] + '_view';

	if (parameters[1] != 'any' && parameters[2] != 'any') {

		query_text = query_text + ' WHERE season = $1 AND year = $2';
		query_values.push(capitalize_string(parameters[1]), parameters[2]); // add value of $1 and $2 to the list

	} else if (parameters[1] != 'any' || parameters[2] != 'any') {

		query_text = query_text + ' WHERE ';

		if (parameters[1] != 'any') {

			query_text = query_text + 'season = $1'
			query_values.push(capitalize_string(parameters[1]));

		} else {

			query_text = query_text + 'year = $1'
			query_values.push(parameters[2]);

		}

	}


	query = {
		text: query_text,
		values: query_values
	};

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
	name = parameters.show;
	character_first = parameters.char_first;
	character_last = parameters.char_last;
	voice_first = parameters.voice_first;
	voice_last = parameters.voice_last;
	studio = parameters.studio;
	season = parameters.season;

	return [name,character_first,character_last,voice_first,voice_last,studio,year,season];


}

function build_create_query(parameters) {

	var show_query, season_query, character_query, studio_query, voice_query;
	var query1, query2, query3, query4, query5;

	show_query = 'INSERT INTO public.show (title) VALUES ($1)';
	character_query = 'INSERT INTO public.character (first_name,last_name) VALUES ($1, $2)';
	voice_query = 'INSERT INTO public.voice_actor (first_name,last_name) VALUES ($1, $2)';
	studio_query = 'INSERT INTO public.studio (name) VALUES ($1)';
	season_query = 'INSERT INTO public.season (year,season) VALUES ($1, $2)';

	var query_array = [show_query, character_query, voice_query, studio_query, season_query];

	query1 = {
		text: show_query,
		values: [ parameters[0] ]
	};
	query2 = {
		text: character_query,
		values: [ parameters[1], parameters[2] ]
	};
	query3 = {
		text: voice_query,
		values: [ parameters[3], parameters[4] ]
	};
	query4 = {
		text: studio_query,
		values: [ parameters[5] ]
	};
	query5 = {
		text: season_query,
		values: [ parameters[6], parameters[7] ]
	};

	var query_array = [ query1, query2, query3, query4, query5 ];

	// console.log("query1: "+ query_values[0].values);

	return query_array;

}


// checks input from POST request form and returns list of valid parameters for delete operation on database
function process_delete_parameters(parameters) {

	var table, id, delete_parameters = []; // row with specified id will be deleted from the specified table

	// check for table name and check if id value is valid
	
	if ('show' in parameters && is_integer(parameters.show) === true) {
		id = parameters.show;
		table = 1;
	}
	else if ('character' in parameters && is_integer(parameters.character) === true) {
		id = parameters.character;
		table = 2;
	}
	else if ('voice_actor' in parameters && is_integer(parameters.voice_actor) === true) {
		id = parameters.voice_actor;
		table = 3;
	}
	else if ('studio' in parameters && is_integer(parameters.studio) === true) {
		id = parameters.studio;
		table = 4;
	}
	else if ('season' in parameters && is_integer(parameters.season) === true) {
		id = parameters.season;
		table = 5;
	}
	else {
		id = -1;
		table = -1;
	}

	console.log(table, id);

	delete_parameters = [ table, id ];
	return delete_parameters;
	
}

// constructs query for database using array of strings as parameters
function build_delete_query(parameters) {

	var query_text;

	// check table number from given parameters and make a query that targets the correct table and column
	
	switch( parameters[0] ) {
		
		case 1:
			query_text = 'DELETE FROM public.show WHERE show_id = ' + parameters[1];
			break;
			
		case 2:
			query_text = 'DELETE FROM public.character WHERE char_id = ' + parameters[1];
			break;
		
		case 3:
			query_text = 'DELETE FROM public.voice_actor WHERE actor_id = ' + parameters[1];
			break;
		
		case 4: 
			query_text = 'DELETE FROM public.studio WHERE studio_id = ' + parameters[1];
			break;

		case 5:
			query_text = 'DELETE FROM public.season WHERE season_id = ' + parameters[1];
			break;
			
		default:
			query_text = '';
			break;
			
	}
	
	return query_text;
	
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

// if home page is requested, find "index.handlebars" in views and show it to user
app.get('/index', function (req, res) {
	res.render('index');
});


app.get('/update', function (req, res) {
	res.render('update');
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

			var query_results = [],
				query_headers = [];

			query_headers = underscores_to_spaces(Object.keys(result.rows[0]));

			for (x in result.rows) {
				query_results.push(Object.values(result.rows[x]));
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

// if page for managing database is requested, find "manage.handlebars" in views and show it to user
app.get('/manage', function (req, res) {
	res.render('manage');
});

// if page for createng rows in the database is requested, find "create.handlebars" in views and show it to user
app.get('/create', function(req,res){
	// res.sendFile('create.handlebars', {root: path.join(__dirname, './views')});
	res.render('create');
});

// if page for deletiing rows in the database is requested, find "delete.handlebars" in views and show it to user
app.post('/create', function (req, res) {

console.log(req.body);

	try{
		var parameters = process_create_parameters(req.body);
		var query = build_create(parameters);
	
		// console.log("query 0: " + query[0]);
	
		console.log("inside the try but outside the loop");
		for (x in query) {
			console.log("Before query");


			db.query(query[x].text,query[x].values, function (error, result) {
			
				console.log("inside query loop");
				if (error) {
					throw error;
				} 
			});
		}
		res.render('create');
	}
	catch(e){
	console.log("Hello!");
	res.status(404).send("Error! boi!");

	}

	// res.end(JSON.stringify(req.body.year));
	// process_create_parameters(req.body.show);

	// var show_name = req.body.show;
	// console.log(show_name);

});


// if page for deletiing rows in the database is requested, find "delete.handlebars" in views and show it to user
app.get('/delete', function(req,res){
	res.render('delete');
});

// handles POST request from form on delete view 
app.post('/delete', function(req,res){

	console.log(req.body);

	var parameters = process_delete_parameters(req.body);
	var query = build_delete_query(parameters);
	var context;
	
	console.log(query);
	
	db.query(query, function(error, result) {

		if(error) {
			context = { message: capitalize_string(error.message) };
			res.render('delete', context);
		}
		else {
			
			console.log("Query did not fail.");
			
			if (result.rowCount <= 0) { context = { message: 'None of the rows in the table have the specified ID.' }; }
			else if (result.rowCount > 0) { context = { message: 'Number of rows deleted: ' + result.rowCount }; }
			
			res.render('delete', context);
			
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