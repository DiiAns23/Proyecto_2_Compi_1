const parse = require('./parser');

parse.parse(`
string Hola(string Nombre, string Apell)
{
    print("Hola "+ Nombre +" "+ Apell + " tu funcion ha sido implementada con exito :3");
    return "Diego";
}
string a = Hola("Diego", "Obin");

print("Si llego hasta aca ;3");
`);

