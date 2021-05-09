const parse = require('./parser');

parse.parse(`
int [] fila = {1,2,4,5,6,7,8};
string hola;
hola = hola + tostring(fila[2]);
print(hola);
`)
/*
  public int ackerman(int m, int n) throws Exception {
        if (n < 0 || m < 0) {
            throw new Exception(“Parametros no validos”);
        }
        if (m == 0) {

            return n + 1;
        }

        if (n == 0) {
            return ackerman(m – 1, 1); // CUANDO EL CUERPO DEL IF CONTIENE UN
                                        // RETURN, MUCHAS VECES NO SE PONE ELSE
                                        // PARA LOS OTROS CASOS
        }
        return ackerman(m – 1, ackerman(m, n – 1));
    }
*/