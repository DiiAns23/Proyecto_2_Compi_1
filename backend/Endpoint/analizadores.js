
module.exports = (parser, app)=>{
    app.post('/analizar',(req,res)=>{
        var prueba = req.body.prueba
        if(prueba)
        {
            var ast = parser.parse(prueba);
            var imprimibles="";    
            for(var a of ast.Imprimibles)
            {
                imprimibles+= a+'\n';
            }
            console.log("CONSOLA:\n",imprimibles);
            imprimibles = imprimibles.substring(0,imprimibles.length-1);
            var resultado = 
            {
                arbol: ast.Arbol,
                consola: imprimibles,
                errores: ast.Errores,
                entorno: ast.Entorno
            }
            res.send(resultado)
        }
         
    })
}
