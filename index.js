const parse = require('./parser');

parse.parse(`
boolean a = false;
boolean b = true;
print(a+b);
`);
