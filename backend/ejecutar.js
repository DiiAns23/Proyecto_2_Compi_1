const parse = require('./parser');

parse.parse(`

int ackerman(int m, int n)
{
    if( (n<0) || (m<0) )
    {
        print("Parametros no validos");
    }
    if(m==0)
    {
        return (n+1);
    }
    if(n==0)
    {
        return ackerman(m-1,1);
    }
    return ackerman(m-1,ackerman(m,n-1));
}

exec ackerman(2,4);


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