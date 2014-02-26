require('coffee-script');
app = require('./server');

if (process.argv[2] == 'console') {
  var repl = require("repl");
  repl.start({prompt: ">"});
} else {
  app.listen(process.env.PORT || 3000) }