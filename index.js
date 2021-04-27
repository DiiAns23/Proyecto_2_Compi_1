const parse = require('./parser');

parse.parse(`
int b = 10;
string a = (string) 10;
print(a);
`);
