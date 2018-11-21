var express = require('express');
var app = express();

// set the port of our application
// process.env.PORT lets the port be set by Heroku
var port = process.env.PORT || 8080;

// make express look in the public directory for assets (css/js/img)
app.use(express.static(__dirname + '/public'));

app.get('/test', function (req, res) {
	res.send('Hello World!');
});

var server = app.listen(port, function () {
	console.log(`== Express running → PORT ${server.address().port}`);
});