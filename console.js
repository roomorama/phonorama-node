require('coffee-script');
app = require('./server');
repl = require('repl');
repl.start({prompt: '>'});