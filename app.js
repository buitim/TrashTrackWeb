var express = require('express');
var express_handlebars = require('express-handlebars');
var handlebars = require('handlebars'); // handlebars is a template system we will use for our pages


var app = express();
app.set('view engine', 'handlebars');
app.engine('handlebars', express_handlebars({
	defaultLayout: 'main'
}));
app.use(express.static('public'));


// mainly for parsing data from POST request
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


// check if string contains only digits and thus is semantically same as an integer
function is_integer(string) {
	
	if (string.length < 1) { return false; }
	
	for (x in string) {
		
		if (string[x] < '0' || string[x] > '9') { return false; }
		
	}
	
	return true;
}

// compares value to array of values, returns true if it matches any or false if it matches none
function compare_values(value, value_array) {

	if (value.length < 1 || Array.isArray(value_array) != true) { return false; }

	for (x in value_array) {

		if (value === value_array[x]) {
			return true;
		}

	}

	return false;

}

// capitalize first character of a string and return result
function capitalize_string(string) {
	
	if (string.length < 1) { return; }

	var new_string = string[0].toUpperCase() + string.substring(1); // toUpperCase() returns only the first character, must add the rest
	return new_string;

}

// replace underscores in each string of array with spaces
function underscores_to_spaces(strings) {

	if (Array.isArray(strings) != true) { return; }

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

// constructs select statement for database using array of strings as parameters (uses views instead of tables)
function build_browse_query(parameters) {

	var query_text, query_values = [], query;
	
	// parameter 0 is category, parameter 1 is season, parameter 2 is year

	query_text = 'SELECT * FROM public.' + parameters[0] + '_view'; // basic select statement, add more to it if needed

	if (parameters[1] != 'any' && parameters[2] != 'any') {

		query_text = query_text + ' WHERE season = $1 AND year = $2'; // add this part if both season and year are specified
		query_values.push( capitalize_string(parameters[1]), parameters[2] ); // seasons in database are capitalized

	} 
	else if (parameters[1] != 'any' || parameters[2] != 'any') {

		query_text = query_text + ' WHERE '; // add this part if season or year is specified (not both)

		if (parameters[1] != 'any') {

			query_text = query_text + 'season = $1'; // add this part if season is specified
			query_values.push( capitalize_string(parameters[1]) ); // seasons in database are capitalized

		} 
		else {

			query_text = query_text + 'year = $1'; // add this part if year is specified
			query_values.push(parameters[2]);

		}

	}

	query = {
		text: query_text,
		values: query_values
	};

	return query;

}


// checks and trims input from POST request form and returns array of parameters for create operation on database
function process_create_parameters(parameters) {
	
	var values = Object.values(parameters);
	var new_values = [];
	
	for (x in values) { 
	
		if (values[x].trim() === '') { new_values.push( null ); }
		else { new_values.push( values[x].trim() ); }

	}

	return new_values;
		
}

// constructs insert statement for database using array of strings as parameters
function build_create_query(parameters) {

	var query, query_text, query_values = [];

	// make different insert statement depending on what table is being worked with
	// parameter 0 is table name, the others are column values
	
	switch(parameters[0]) {
		
		case 'character':
			query_text = 'INSERT INTO public.' + parameters[0] + ' (first_name, last_name, actor_id, show_id) VALUES ( $1, $2, $3, $4 )';
			query_values = [ parameters[1], parameters[2], parameters[3], parameters[4] ];
			break;

		case 'voice_actor':
			query_text = 'INSERT INTO public.' + parameters[0] + ' (first_name, last_name) VALUES ( $1, $2 )';
			query_values = [ parameters[1], parameters[2] ];
			break;

		case 'show':
			query_text = 'INSERT INTO public.' + parameters[0] + ' (title, studio_id, season_id) VALUES ( $1, $2, $3 )';
			query_values = [ parameters[1], parameters[2], parameters[3] ];
			break;
		case 'studio':
			query_text = 'INSERT INTO public.' + parameters[0] + ' (name) VALUES ( $1 )';
			query_values = [ parameters[1] ];
			break;
			
		case 'season':
			query_text = 'INSERT INTO public.' + parameters[0] + ' (season, year) VALUES ( $1, $2 )';
			query_values = [ parameters[1], parameters[2] ];
			break;
			
		default:
			query_text = '';
			console.log('something weird happened in /create'); // may be the result of the user editing the front end HTML

	}

	query = { text: query_text, values: query_values };

	return query;

}


// checks input from POST request form and returns array of valid parameters for read operation on database
function process_read_parameters(parameters) {

	var type;

	console.log(parameters);

	if ('type' in parameters) {

		var type_valid = compare_values(parameters.type, ['show', 'character', 'voice_actor', 'studio', 'season']);
		if (type_valid === true) {
			type = parameters.type;
		} 
		else {
			type = 'show';
		}
	} 
	else {
		type = 'show';
	}

	console.log(type);

	return [ type ];

}

// constructs select statement for database using array of strings as parameters
function build_read_query(parameters) {

	var query_text, query;

	query_text = 'SELECT * FROM public.' + parameters[0];

	query = { text: query_text };

	return query;

}


// checks input from POST request form and returns array of valid parameters for delete operation on database
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

// constructs delete statement for database using array of strings as parameters
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



function process_update_parameters(parameters) {
	
	var values = Object.values(parameters);
	var names = Object.keys(parameters);
	var counter = 0;
	var new_values = [];
	var column_names = [];
	
	for (x in values) { 
	
		// if (values[x].trim() === '') { new_values.push( null ); }
		// else { new_values.push( values[x].trim() ); }


		if (values[x].trim() != ''){
			new_values.push( values[x].trim() );
			column_names.push( names[x].trim() );
			counter += 1;
		}
	}

	return {columns: column_names, values: new_values, counting: counter};
		
}



function build_update_query(parameters){

	var query, query_text, query_values = [], query_parts='', query_where = ' WHERE ';


		console.log(parameters.counting);
		console.log(parameters.values[0]);

	query_text = 'UPDATE public.' + parameters.values[0] + ' SET ';
	var i=0,x;
	for(x=2; x< parameters.counting; x++){
		i +=1;
		query_parts = query_parts + parameters.columns[x] + ' = $' + i;
		// query_parts = query_parts + "$" + x; 

		if (x != parameters.counting-1)
			query_parts = query_parts + ', ';

		query_values.push(parameters.values[x]);

	}
	i+=1;
	query_parts = query_parts + query_where + parameters.columns[1] + '=' + ' $' + i;
	query_text = query_text + query_parts + ';';
	query_values.push(parameters.values[1]);


	console.log('text: ' + query_text);
	query = { text: query_text, values: query_values };

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

// if home page is requested, find "index.handlebars" in views and show it to user
app.get('/index', function (req, res) {
	res.render('index');
});

// handles any queries user makes through the limited front end interface
app.get('/browse*', function (req, res, next) {

	get_year_range(); // update values just in case they have changed, does not matter when this completes

	var parameters = process_browse_parameters(req.query);
	var query = build_browse_query(parameters); // this should be safe from injection, because of parameter processing 
	var context;

	console.log(query);

	db.query(query, function (error, result) {

		if (error) {
			console.log(error);
		} 
		else {

			console.log("query did not fail");

			var query_results = [],
				query_headers = [];


			if (result.rowCount > 0) { 
			
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
			else {

				context = { 
					min_year: min_year,
					max_year: max_year,
					message: 'No data was found. Please try selecting different options.'
				}
				
				res.render('browse', context);
				
			}

		}

	});

});

// if page for managing database is requested, find "manage.handlebars" in views and show it to user
app.get('/manage', function (req, res) {
	res.render('manage');
});


// if page for creating rows in the database is requested, find "create.handlebars" in views and show it to user
app.get('/create', function(req,res){
	res.render('create');
});

// handles POST request from any of forms on create view 
app.post('/create', function (req, res) {

	console.log(req.body);
	
	var parameters = process_create_parameters(req.body);
	var query = build_create_query(parameters);
	var context;

	console.log(query);

	db.query(query, function (error, result) {

		if (error) {
			context = { message: capitalize_string(error.message) }
			res.render('create', context);
		}
		else {
						
			console.log("query did not fail");
			
			context = { message: 'A new row has been added to the table.' };
			
			res.render('create', context);
			
		}

	});
		
});


// if page for viewing rows in the database is requested, find "read.handlebars" in views and show it to user
app.get('/read', function(req,res){

	var parameters = process_read_parameters(req.query);

	var query = build_read_query(parameters); // this should be safe from injection, because of parameter processing 

	console.log(query);

	db.query(query, function (error, result) {

		if (error) {
			console.log("Error!");
		} 
		else {

			console.log("Query done!");

			var query_results = [], query_headers = [];

			query_headers = underscores_to_spaces(Object.keys(result.rows[0]));

			for (x in result.rows) {
				query_results.push(Object.values(result.rows[x]));
			}

			var context = {
				headers: query_headers,
				results: query_results
			};

			res.render('read', context);

		}

	});


});


// if page for updating rows in the database is requested, find "delete.handlebars" in views and show it to user
app.get('/update', function (req, res) {
	res.render('update');
});


app.post('/update', function(req,res){


	var parameters = process_update_parameters(req.body);
	var query = build_update_query(parameters);



	console.log("queryLOL: " + query.text);

	var context;

	// console.log();

	db.query(query, function (error, result) {

		if (error) {
			context = { message: capitalize_string(error.message) }
			res.render('update', context);
		}
		else {
						
			console.log("query did not fail");
			
			context = { message: 'Update Successful!' };
			
			res.render('update', context);
			
		}

	});

});



// if page for deletiing rows in the database is requested, find "delete.handlebars" in views and show it to user
app.get('/delete', function(req,res){
	res.render('delete');
});

// handles POST request from any of the forms on delete view 
app.post('/delete', function(req,res){

	console.log(req.body);

	var parameters = process_delete_parameters(req.body);
	var query = build_delete_query(parameters);
	var context;
	
	console.log(query);
	
	db.query(query, function(error, result) {

		if (error) {
			context = { message: capitalize_string(error.message) };
			res.render('delete', context);
		}
		else {
			
			console.log("query did not fail");
			
			if (result.rowCount <= 0) { context = { message: 'None of the rows in the table have the specified ID.' }; }
			else if (result.rowCount > 0) { context = { message: 'The specified row has been removed from the table.' }; }
			
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