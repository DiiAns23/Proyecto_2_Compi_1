const parse = require('./parser');

parse.parse(`
//COMENTARIo
list <string> nombres = new list<string>;
nombres.add("Diego");
nombres.add("Jose");
nombres.add("Kristian");
nombres.add("Juan");
print(length(nombres));
`);
/*
void metodo1(){
    figura1(10);
}
void figura1(int n) {
        String cadenaFigura = "";
        double i; 
        i=-3*n/2;
        while(i<=n){
            cadenaFigura = "";
            double j; 
            j=-3*n/2;
            while(j<=3*n){
                double absolutoi;
                absolutoi = i;
                double absolutoj;
                absolutoj = j;
                if(i < 0)
                {
                    absolutoi = i * -1;
                }
                if(j < 0)
                {
                    absolutoj = j * -1;
                }
                if((absolutoi + absolutoj < n)
                        || ((-n / 2 - i) * (-n / 2 - i) + (n / 2 - j) * (n / 2 - j) <= n * n / 2)
                        || ((-n / 2 - i) * (-n / 2 - i) + (-n / 2 - j) * (-n / 2 - j) <= n * n / 2)) {
                    cadenaFigura = cadenaFigura + "* ";
                }
                else
                {
                    cadenaFigura = cadenaFigura + ". ";
                }
                j=j+1;
            }
            print(cadenaFigura);
            i=i+1;
        }
        print("Si la figura es un corazón, te aseguro que tendrás un 100 :3");
    }

metodo1();
*/