const parse = require('./parser');

parse.parse(`
print("Hola mundo" + " Diego Obin");
print("Adios gente");
double a = 10.5;
print(a);
`);
