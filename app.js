var express = require('express');
var app = express();
app.get('/', function (req, res) {
	res.send('Hello World!');
});
var server = app.listen(5000, function () {
	console.log(`== Express running → PORT ${server.address().port}`);
});