const parse = require('./parser');

parse.parse(`
int a = 6;
int b = 6;
if(a != b){
    print("Esto esta bien :3");
}else {
    print("Esto si esta malo :c");
}
boolean z = false;
z = ("hola" == "hola");
print(z);
`);