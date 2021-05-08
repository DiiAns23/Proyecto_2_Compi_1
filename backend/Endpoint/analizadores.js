
module.exports=(parser, app)=>{
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
            for(var b of ast.Errores)
            {
                imprimibles+= b+'\n';
            }
            console.log("CONSOLA:\n",imprimibles);
            imprimibles = imprimibles.substring(0,imprimibles.length-1);
            var resultado = 
            {
                arbol: imprimibles,
                consola: imprimibles
            }
            res.send(resultado)
        }
         
    })
}
