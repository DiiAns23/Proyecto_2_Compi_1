%{
    var imprimibles = [];
    var errores = [];
    var pilaCiclosSw = [];
    var pilaFunciones = [];

  	// entorno
  	const Entorno = function(anterior)
    {
    	return {
        	tablaSimbolos:new Map(),
          	anterior:anterior
        }
    }
  	var EntornoGlobal = Entorno(null)
  	//Ejecuciones
    function EjecutarBloque(LINS, ent)
	{
        var retorno=null;
        for(var elemento of LINS)
        {
        	switch(elemento.TipoInstruccion)
          	{
            	case "print":
                    var res = Evaluar(elemento.Operacion, ent);
                    imprimibles.push(res.Valor+"");
                    console.log(res.Valor);
                    break;
                case "crear":
                    retorno = EjecutarCrear(elemento, ent);
                    break;
                case "asignar":
                    retorno = EjecutarAsignar(elemento, ent);
                    break;
                case "if":
                    retorno = EjecutarSi(elemento, ent);
                    break;
                case "while":
                    retorno = EjecutarMientras(elemento, ent);
                    break;
                case "dowhile":
                    retorno = EjecutarHacerMientras(elemento,ent);
                    break;
                case "for":
                    retorno = EjecutarDesde(elemento, ent);
                    break;
                case "switch":
                    retorno = EjecutarSeleccionar(elemento, ent);
                    break;
                case "funcion":
                    retorno = EjecutarFuncion(elemento, EntornoGlobal);
                    break;
                case "llamada":
                    EjecutarLlamada(elemento,ent);
                    retorno = null
                    break

                case "return":
                    if (pilaFunciones.length>0)
                    {
                        retorno = elemento.Expresion;
                    }
                    else
                    {
                        console.log("Intruccion retorno fuera de una funcion")
                    }
                    break;
                case "break":
                    if (pilaCiclosSw.length>0)
                    {
                        return elemento;
                    }
                    else
                    {
                        console.log("Intruccion break fuera de un switch o un ciclo")
                    }
                case "continue":
                    if(pilaCiclosSw.length>0)
                    {
                        return elemento
                    }
                    else
                    {
                        console.log("Intruccion continue fuera de un ciclo")
                    }

                    
          	}
            if(retorno)
            {
                return retorno;
            }
        }
        return null;
    }
    //Expresion
    function nuevoSimbolo(Valor,Tipo){
        return{
            Valor:Valor,
            Tipo:Tipo
        }
    }
    const NuevaOperacion= function(OperandoIzq,OperandoDer,Tipo)
    {
        return{
            OperandoIzq:OperandoIzq,
            OperandoDer:OperandoDer,
            Tipo:Tipo
        }
    }
    function NuevaOperacionUnario(Operando,Tipo)
    {
        return{
            OperandoIzq:Operando,
            OperandoDer:null,
            Tipo:Tipo
        }
    }
    function Evaluar(Operacion,ent)
    {
        var Valorizq=null;
        var Valorder=null;
        //Simbolos
        switch(Operacion.Tipo)
        {
            case "bool":
                return nuevoSimbolo(Operacion.Valor,Operacion.Tipo);
            case "cadena":
                return nuevoSimbolo(Operacion.Valor,Operacion.Tipo);
            case "char":
                return nuevoSimbolo(Operacion.Valor.charAt(0),Operacion.Tipo)
            case "numero":
                return nuevoSimbolo(parseFloat(Operacion.Valor),Operacion.Tipo);
            case "decimal":
                return nuevoSimbolo(parseFloat(Operacion.Valor),Operacion.Tipo);
            case "ID":
                var temp=ent;
                while(temp!=null)
                {
                    if(temp.tablaSimbolos.has(Operacion.Valor))
                    {
                        var valorID = temp.tablaSimbolos.get(Operacion.Valor);
                        return nuevoSimbolo(valorID.Valor,valorID.Tipo);
                    }
                    temp=temp.anterior;
                }
                console.log("No existe la variable " + Operacion.Valor);
                return nuevoSimbolo("@error@","error");
            case "vector":
                var aux1 = Evaluar(Operacion.Valor.Params,ent)
                var temp=ent;
                while(temp!=null)
                {
                    if(temp.tablaSimbolos.has(Operacion.Valor.Id))
                    {
                        var valorID = temp.tablaSimbolos.get(Operacion.Valor.Id);
                        if(aux1.Tipo =="numero" && aux1.Valor>=0 && aux1.Valor<valorID.length)
                        {
                            valorID = valorID[aux1.Valor]
                            return nuevoSimbolo(valorID.Valor,valorID.Tipo);
                        }
                        else
                        {
                            console.log("No existe la posicion " + aux1.Valor);
                            return nuevoSimbolo("@error@","error");
                        }
                    }
                    temp=temp.anterior;
                }
                console.log("No existe la variable " + Operacion.Valor);
                return nuevoSimbolo("@error@","error");
                break;
            case "lista":
                var aux1 = Evaluar(Operacion.Valor.Params,ent)
                var temp=ent;
                while(temp!=null)
                {
                    if(temp.tablaSimbolos.has(Operacion.Valor.Id))
                    {
                        var valorID = temp.tablaSimbolos.get(Operacion.Valor.Id);
                        if(aux1.Tipo =="numero" && aux1.Valor>=0 && aux1.Valor<valorID.length)
                        {
                            valorID = valorID[aux1.Valor+1]
                            return nuevoSimbolo(valorID.Valor,valorID.Tipo);
                        }
                        else
                        {
                            console.log("No existe la posicion " + aux1.Valor);
                            return nuevoSimbolo("@error@","error");
                        }
                    }
                    temp=temp.anterior;
                }
                console.log("No existe la variable " + Operacion.Valor);
                return nuevoSimbolo("@error@","error");
                break;
            case "funcion":
                var res = EjecutarLlamada(Llamada(Operacion.Valor.Id,Operacion.Valor.Params), ent)
                return res
            case "casteo":
                var res = EjecutarCasteo(Casteo(Operacion.Valor.Id,Operacion.Valor.Tipo), ent)
                return res;
        }
        //Operaciones
        Valorizq = Evaluar(Operacion.OperandoIzq, ent);
        if(Operacion.OperandoDer!=null)
        {
            Valorder=Evaluar(Operacion.OperandoDer, ent);
        }
        var tipoRetorno = "error";
        // identificar qué operaciones sí podemos realizar dependiendo del tipo
        switch (Operacion.Tipo)
        {
            case "+":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        if(!Valorder){
                            tipoRetorno="numero";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "bool":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor.charCodeAt(0), tipoRetorno);
                                break;
                            case "cadena":
                                tipoRetorno = "cadena";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);	
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "bool":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor.charCodeAt(0), tipoRetorno);	
                                break;
                            case "cadena":
                                tipoRetorno = "cadena";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                    case "bool":
                        // bool puede sumarse con numero, decimal y cadena
                        if(!Valorder){
                            tipoRetorno="bool";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);	
                                break;
                            case "cadena":
                                tipoRetorno = "cadena";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                    case "char":
                        // char puede sumarse con numero, decimal, char y cadena
                        if(!Valorder){
                            tipoRetorno="char";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) + Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) + Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "cadena";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                            case "cadena":
                                tipoRetorno = "cadena";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                    case "cadena":
                        // cadena puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "bool":
                            case "char":
                            case "cadena":
                                tipoRetorno = "cadena";	
                                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;

                }
            case "-":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="numero";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);	
                                break;
                            case "bool":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor.charCodeAt(0), tipoRetorno);
                                break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);	
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                                break;
                            case "bool":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor.charCodeAt(0), tipoRetorno);
                                break;
                        }
                        break;
                    case "bool":
                        // bool puede sumarse con numero, decimal y cadena
                        if(!Valorder){
                            tipoRetorno="bool";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                    case "char":
                        // char puede sumarse con numero, decimal, char y cadena
                        if(!Valorder){
                            tipoRetorno="char";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) - Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) - Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                }
            case "*":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="numero";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, tipoRetorno);	
                                break;
                            case "char":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor.charCodeAt(0), tipoRetorno);
                                break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, tipoRetorno);	
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, tipoRetorno);	
                                break;
                            case "char":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor.charCodeAt(0), tipoRetorno);	
                                break;
                        }
                        break;
                    case "char":
                        // char puede sumarse con numero, decimal, char y cadena
                        if(!Valorder){
                            tipoRetorno="char";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) * Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) * Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                }
            case "/":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="numero";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor.charCodeAt(0), tipoRetorno);	
                                break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, tipoRetorno);	
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, tipoRetorno);
                                break;
                            case "char":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor.charCodeAt(0), tipoRetorno);
                                break;
                        }
                        break;
                    case "char":
                        // char puede sumarse con numero, decimal, char y cadena
                        if(!Valorder){
                            tipoRetorno="char";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) / Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor.charCodeAt(0) / Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                }
            case "^":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="numero";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "numero";	
                                return nuevoSimbolo(Math.pow(Valorizq.Valor , Valorder.Valor), tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Math.pow(Valorizq.Valor , Valorder.Valor), tipoRetorno);
                                break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Math.pow(Valorizq.Valor , Valorder.Valor), tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";
                                return nuevoSimbolo(Math.pow(Valorizq.Valor , Valorder.Valor), tipoRetorno);	
                                break;
                        }
                        break;
                }
            case "%":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="numero";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, tipoRetorno);
                                break;
                            case "decimal":
                                tipoRetorno = "decimal";	
                                return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                }
            case "umenos":
                switch(Valorizq.Tipo)
                {
                    case "numero":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="numero";
                            return nuevoSimbolo(0-Valorizq.Valor, tipoRetorno);
                            break;
                        }
                        break;
                    case "decimal":
                        // decimal puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="decimal";
                            return nuevoSimbolo(0-Valorizq.Valor, tipoRetorno);
                            break;
                        }
                        break;
                }
                break;
            case "!":
                switch(Valorizq.Tipo)
                {
                    case "bool":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="bool";
                            return nuevoSimbolo(!Valorizq.Valor, tipoRetorno);
                            break;
                        }                   
                        break;
                }
                break;
            case "&&":
                switch(Valorizq.Tipo)
                {
                    case "bool":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="bool";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";	
                                return nuevoSimbolo(Valorizq.Valor && Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                }
                break;
            case "||":
                switch(Valorizq.Tipo)
                {
                    case "bool":
                        // numero puede sumarse con cualquier otro tipo
                        if(!Valorder){
                            tipoRetorno="bool";
                            break;
                        }
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";	
                                return nuevoSimbolo(Valorizq.Valor || Valorder.Valor, tipoRetorno);
                                break;
                        }
                        break;
                }
                break;
            case "==":
                switch(Valorizq.Tipo)
                {
                    case "cadena":
                        switch(Valorder.Tipo)
                        {
                            case "cadena":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, tipoRetorno);	
                        }
                        break;
                    case "bool":
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, tipoRetorno) 
                        }
                        break;
                    case "char":
                    case "numero":
                    case "decimal":
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "char":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, tipoRetorno)    
                        }
                        break;
                    
                    
                }
                break;
            case "!=":
                switch(Valorizq.Tipo)
                {
                    case "char":
                    case "numero":
                    case "decimal":
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "char":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, tipoRetorno)    
                        }
                        break;
                    case "bool":
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, tipoRetorno) 
                        }
                        break;
                    case "cadena":
                        switch(Valorder.Tipo)
                        {
                            case "cadena":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, tipoRetorno);	
                        }
                        break;
                }
                break;
            case ">":
                switch(Valorizq.Tipo)
                {
                    case "char":
                    case "numero":
                    case "decimal":
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "char":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, tipoRetorno)    
                        }
                        break;
                    case "bool":
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, tipoRetorno) 
                        }
                        break;
                    case "cadena":
                        switch(Valorder.Tipo)
                        {
                            case "cadena":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, tipoRetorno);	
                        }
                        break;
                }
                break;
            case "<":
                switch(Valorizq.Tipo)
                {
                    case "char":
                    case "numero":
                    case "decimal":
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "char":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, tipoRetorno)    
                        }
                        break;
                    case "bool":
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, tipoRetorno) 
                        }
                        break;
                    case "cadena":
                        switch(Valorder.Tipo)
                        {
                            case "cadena":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, tipoRetorno);	
                        }
                        break;
                }
                break;
            case ">=":
                switch(Valorizq.Tipo)
                {
                    case "char":
                    case "numero":
                    case "decimal":
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "char":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, tipoRetorno)    
                        }
                        break;
                    case "bool":
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, tipoRetorno) 
                        }
                        break;
                    case "cadena":
                        switch(Valorder.Tipo)
                        {
                            case "cadena":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, tipoRetorno);	
                        }
                        break;
                }
                break;
                break;
            case "<=":
                switch(Valorizq.Tipo)
                {
                    case "char":
                    case "numero":
                    case "decimal":
                        switch(Valorder.Tipo)
                        {
                            case "numero":
                            case "decimal":
                            case "char":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, tipoRetorno)    
                        }
                        break;
                    case "bool":
                        switch(Valorder.Tipo)
                        {
                            case "bool":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, tipoRetorno) 
                        }
                        break;
                    case "cadena":
                        switch(Valorder.Tipo)
                        {
                            case "cadena":
                                tipoRetorno = "bool";
                                return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, tipoRetorno);	
                        }
                        break;
                }
                break;
        }
        errores.push("Error Semantico: Tipos incompatibles " + ( Valorizq ? Valorizq.Tipo : "" ) + 
        " y " + ( Valorder ? Valorder.Tipo : "" ))
        console.log(
        "Tipos incompatibles " + ( Valorizq ? Valorizq.Tipo : "" ) + 
        " y " + ( Valorder ? Valorder.Tipo : "" )); 
        return nuevoSimbolo("@error@", "error");

    }
    //Imprimir
    const Imprimir=function(TipoInstruccion,Operacion)
    {
        return {
            TipoInstruccion:TipoInstruccion,
            Operacion:Operacion
        }
    }
    //Crear
    const Crear = function(id, tipo,tipo2,dimension,expresion)
    {

        return {
            Id: id,
            Tipo: tipo,
            Tipo2: tipo2,
            Dimension: dimension,
            Expresion: expresion,
            TipoInstruccion: "crear"
        }
    }
    function EjecutarCrear(crear,ent)
    {
        if(ent.tablaSimbolos.has(crear.Id)) //Validar si existe la variable
        {
            //error
            errores.push("La variable ",crear.Id," ya ha sido declarada en este ambito")
            console.log("La variable ",crear.Id," ya ha sido declarada en este ambito");
      		return;
        }
        var valor;
        if (crear && crear.Expresion)
        {
            if(!crear.Tipo2)
            {
                valor = Evaluar(crear.Expresion,ent);    
                if(valor.Tipo != crear.Tipo)
                {
                    //error
                    errores.push("El tipo no coincide con la variable a crear: ", crear.Tipo)
                    console.log("El tipo no coincide con la variable a crear");                    
                    return
                }
            }
            else
            {
                //string [] a = {"Diego"};
                if(crear.Tipo == crear.Tipo2)
                {
                    crear.Tipo2 = "vector";
                    valor = []
                    for(var exp of crear.Expresion)
                    {
                        valore = Evaluar(exp,ent)
                        if(valore.Tipo == crear.Tipo)
                        {
                            valor.push(valore)
                        }
                        else
                        {
                            errores.push("Los tipos de datos no coinciden: ", valore.Tipo, " y ", crear.Tipo)
                            console.log("Los tipos de datos no coinciden: ", valore.Tipo, " y ", crear.Tipo)
                            return
                        }
                    }

                }
                else
                {
                    errores.push("Los tipos de datos no coinciden: ", crear.Tipo, " y ", crear.Tipo2)
                    console.log("Los tipos de datos no coinciden", crear.Tipo, " y ", crear.Tipo2)
                    return
                }
            }

        }
        else
        {
            if(!crear.Tipo2)
            {
                switch(crear.Tipo)
                {
                    case "numero":
                        valor = nuevoSimbolo(0,"numero");
                        break;
                    case "decimal":
                        valor = nuevoSimbolo("0.00","decimal");
                        break;
                    case "bool":
                        valor = nuevoSimbolo(true,"bool");
                        break;
                    case "char":
                        valor = nuevoSimbolo('\u0000',"char");
                        break;
                    case "cadena":
                        valor = nuevoSimbolo("","cadena");
                        break;
                }
            }
            else
            {
                if(crear.Tipo == crear.Tipo2) 
                {
                    var dimension;
                    valor = []
                    if(crear.Dimension) 
                    {
                        crear.Tipo2 = "vector";
                        dimension = Evaluar(crear.Dimension,ent)
                        var tmp = ""
                        for(var exp = 0; exp<dimension.Valor; exp++)
                        {
                            switch(crear.Tipo)
                            {
                                case "numero":
                                    tmp = nuevoSimbolo(0,"numero");
                                    break;
                                case "decimal":
                                    tmp = nuevoSimbolo("0.00","decimal");
                                    break;
                                case "char":
                                    tmp = nuevoSimbolo('\u0000',"char");
                                    break;
                                case "cadena":
                                    tmp = nuevoSimbolo("","cadena");
                                    break;
                            }
                            valor.push(tmp)
                        }
                    }
                    else
                    {
                        crear.Tipo2 = "lista";
                        valor.push(nuevoSimbolo("lista",crear.Tipo))
                    }
                }
                else
                {
                    errores.push("Los tipos de datos no coinciden: ", crear.Tipo, " y ", crear.Tipo2)
                    console.log("Los tipos de datos no coinciden")
                    return
                }
            }
        }
        //Crear objeto a insertar  []
        ent.tablaSimbolos.set(crear.Id, valor);
    }
    //Asignar
    const Asignar = function(id,Expresion,Expresion2)
    {
        return{
            Id: id,
            Expresion: Expresion,
            Expresion2: Expresion2,
            TipoInstruccion: "asignar"
        }
    }
    function EjecutarAsignar (asignar,ent) 
	{
      	//Evaluar la expresion
      	var valor = Evaluar(asignar.Expresion,ent);
        // validar si existe la variable
      	temp=ent;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(asignar.Id))
            {
                // evaluar el resultado de la expresión 
                var simbolotabla = temp.tablaSimbolos.get(asignar.Id);
                if(!asignar.Expresion2)
                {
                    //console.log("Chale entro aqui :c")
                    if(valor.Tipo =="char")
                    {
                        if(valor.Valor.length!=0)
                        {
                            //error
                            errores.push("No se puede asignar "+valor.Valor+" tipo no compatible con char")
                            console.log("No se puede asignar "+valor.Valor+" tipo no compatible con char")
                            return
                        }
                    }
                    if(simbolotabla.Tipo =="decimal" && valor.Tipo =="numero")
                    {
                        valor.Tipo = "decimal";
                    }

                    if (simbolotabla.Tipo == valor.Tipo)
                    {
                        // reasignar el valor
                        temp.tablaSimbolos.set(asignar.Id, valor);
                        return
                    }
                    else
                    {
                        //error
                        console.log("Tipos incompatibles ",simbolotabla.Tipo," , ",valor.Tipo)
                        return
                    }
                }
                else
                {

                    if(asignar.Expresion2.Tipo != "lista")
                    {
                        var aux = Evaluar(asignar.Expresion2,ent)
                        if(aux.Tipo == "numero" && valor.Tipo == simbolotabla[0].Tipo)
                        {
                            if(aux.Valor >=0 && aux.Valor<simbolotabla.length)
                            {
                                simbolotabla[aux.Valor] = valor
                                return;
                            }
                            else
                            {
                                errores.push("Ocurrio un error durante la asignacion del valor en el vector: ", asignar.Id)
                                console.log("Ocurrio un error durante la asignacion del valor en el vector: ", asignar.Id)
                                return
                            }
                        }
                        else
                        {
                            errores.push("Ocurrio un error durante la asignacion del valor en el vector: ", asignar.Id)
                            console.log("Ocurrio un error durante la asignacion del valor en el vector: ", asignar.Id)
                            return
                        }
                    }
                    else
                    {
                        if(valor.Tipo == simbolotabla[0].Tipo)
                        {                              
                            simbolotabla.push(valor);
                            temp.tablaSimbolos.set(asignar.Id, simbolotabla);
                            return
                        }
                    }
                }
            }
            temp=temp.anterior;
        }
        errores.push("No se encontro la varible ", asignar.Id);
        console.log("No se encontro la variable ",asignar.Id);
    }
    //If
    const Si=function(Condicion,BloqueSi,BloqueElse)
    {
          return {
            Condicion:Condicion,
            BloqueSi:BloqueSi,
            BloqueElse:BloqueElse,
            TipoInstruccion:"if"
          }
    }
    function EjecutarSi (si,ent)
    {
    	var res = Evaluar(si.Condicion, ent);
        if(res.Tipo=="bool")
        {
        	if(res.Valor)
          	{
      	        var nuevosi=Entorno(ent);
            	return EjecutarBloque(si.BloqueSi, nuevosi);
          	}
          	else if(si.BloqueElse!=null)
          	{
      	        var nuevosino=Entorno(ent);
            	return EjecutarBloque(si.BloqueElse, nuevosino);
        	}
    	}
        else
        {
            errores.push("Se esperaba una condicion dentro del If");
            console.log("Se esperaba una condicion dentro del If");
        }
    }
    const ElseIf = function(Expresion,Bloque)
    {
        return{
            Expresion: Expresion,
            Bloque: Bloque
        }
    }
    const Ternario = function(Condicion,BloqueSi, BloqueSino)
    {
        return{
            Condicion: Condicion,
            BloqueSi: BloqueSi,
            BloqueSino: BloqueSino,
            TipoInstruccion: "ternario"
        }
    }
    function EjecutarTernario(ternario,ent)
    {
        return{
            Ternario:null
        }
    }
    //Switch 
    const Seleccionar = function(Expresion, LCasos, NingunoBloque)
    {
        return  {
            Expresion: Expresion,
            LCasos: LCasos,
            NingunoBloque: NingunoBloque,
            TipoInstruccion: "switch"
        }
    }
    const Caso = function(Expresion,Bloque)
    {
        return {
            Expresion:Expresion,
            Bloque:Bloque
        }
    }
    function EjecutarSeleccionar(seleccionar,ent)
    {
        pilaCiclosSw.push("seleccionar");
		var ejecutado = false; //esta variable hace que se ejecute el DEFAULT;
      	var nuevo = Entorno(ent);
        for(var elemento of seleccionar.LCasos)
        {
            var condicion = Evaluar(NuevaOperacion(seleccionar.Expresion,elemento.Expresion,"=="), ent)
            if(condicion.Tipo=="bool")
            {
              	if(condicion.Valor)//Se le puede poner || ejecutado para que evalue todas las demas expresiones aunque no se cumplan
              	{
                	//ejecutado=true;
                	var res = EjecutarBloque(elemento.Bloque, nuevo)
                	if(res && res.TipoInstruccion=="break")
                	{
                        pilaCiclosSw.pop();
                  		return
                	}
                    else if (res)
                    {
                        pilaCiclosSw.pop();
                        return res
                    }
              	}
            }
          	else
            {
                pilaCiclosSw.pop();
                return
            }
        }
        if(seleccionar.NingunoBloque && !ejecutado)
        {
            EjecutarBloque(seleccionar.NingunoBloque, nuevo)
        }
        pilaCiclosSw.pop();
        return
    }
    // Break
    const Romper = function()
    {
        return{
            TipoInstruccion: "break"
        }
    }
    //Continue
    const Continuar = function()
    {
        return{
            TipoInstruccion: "continue"
        }
    }
    // Return
    const Retorno = function(Expresion)
    {
        return {
            Expresion:Expresion,
        	TipoInstruccion: "return"
        }
    }
    //Mientras
    const Mientras = function(Condicion, Bloque)
    {
        return {
            Condicion: Condicion,
            Bloque: Bloque,
            TipoInstruccion:"while"
        }
    }
    function EjecutarMientras(mientras,ent)
    {
        while(true)
        {
            pilaCiclosSw.push("ciclo"); 
            nuevo = Entorno(ent);
        	var resultadoCondicion = Evaluar(mientras.Condicion, ent)
            if(resultadoCondicion.Tipo=="bool")
            {
            	if(resultadoCondicion.Valor)
            	{
                	var res = EjecutarBloque(mientras.Bloque, nuevo);
                	if(res && res.TipoInstruccion=="break")
                	{
                		break;
                	}
                    if(res && res.TipoInstruccion=="continue")
                    {
                        continue;
                    }
                    else if (res)
                    {
                        pilaCiclosSw.pop();
                        return res
                    }
            	}
            	else
            	{
                	break;
              	}
            }
            else
            {
                errores.push("Se esperaba una condicion dentro del Switch");
                console.log("Se esperaba una condicion dentro del Mientras")
                pilaCiclosSw.pop();
                return
            }
		}
        pilaCiclosSw.pop();
        return
    }
    //Do While
    const HacerMientras = function(Condicion, Bloque)
    {
        return{
            Condicion: Condicion,
            Bloque: Bloque,
            TipoInstruccion: "dowhile"
        }
    }
    function EjecutarHacerMientras(hacer,ent)
    {
        do
        {
            pilaCiclosSw.push("ciclo")
            nuevo = Entorno(ent)
            var res = EjecutarBloque(hacer.Bloque, nuevo);
            if(res && res.TipoInstruccion=="break")
            {
                break;
            }
            if(res && res.TipoInstruccion=="continue")
            {
                var resultadoCondicion = Evaluar(hacer.Condicion, nuevo)
                if(resultadoCondicion.Tipo == "bool")
                {
                    if(!resultadoCondicion.Valor)
                    {   
                        break;
                    }
                }                 
                continue;
            }
            else if (res)
            {
                pilaCiclosSw.pop();
                return res
            }
            var resultadoCondicion = Evaluar(hacer.Condicion, ent)
            if(resultadoCondicion.Tipo == "bool")
            {
                if(!resultadoCondicion.Valor)
                {   
                    break;
                }
            }
            else
            {
                errores.push("Se esperaba una condicion dentro del Do While");
                console.log("Se esperaba una condicion dentro del Do while")
                pilaCiclosSw.pop();
                return
            }
        }while(true);
        pilaCiclosSw.pop();
    }
    //For
    const Desde = function(ExpDesde, ExpHasta, ExpPaso, Bloque, ent)
    {
        return {
            ExpDesde: ExpDesde,
            ExpHasta: ExpHasta,
            ExpPaso: ExpPaso,
            Bloque: Bloque,
            TipoInstruccion:"for"
        }
    }
    const Actualizacion = function(id, Expresion)
    {
        return{
            Id: id,
            Expresion: Expresion
        }
    }
    function EjecutarDesde(Desde, ent)
	{
        pilaCiclosSw.push("ciclo"); 
      	var nuevo = Entorno(ent);
    	//controlador de la condicion
    	if( Desde.ExpDesde.TipoInstruccion == "crear" )
    	{
      		EjecutarCrear(Desde.ExpDesde, nuevo);
    	}
    	else
    	{
        	EjecutarAsignar(Desde.ExpDesde, nuevo);
    	}
        var contador = 0;
    	while(true)
    	{
            var condicion = Evaluar(Desde.ExpHasta, nuevo); //verifica si la condicion se cumple y retorna un bool
      	    //si no se cumple la condicion
            if(!condicion.Valor)
            {
                pilaCiclosSw.pop();
                return;
            }
            var nuevo2 = Entorno(nuevo);
            var res = EjecutarBloque(Desde.Bloque, nuevo2);
            if(res && res.TipoInstruccion=="break")
            {
                break;
            }
            if(res && res.TipoInstruccion=="continue")
            {
                if(Desde.ExpPaso.Expresion.OperandoDer)
                {
                    EjecutarAsignar(Asignar(Desde.ExpPaso.Id,NuevaOperacion(Desde.ExpPaso.Expresion.OperandoIzq,Desde.ExpPaso.Expresion.OperandoDer,Desde.ExpPaso.Expresion.Tipo)), nuevo)                            
                }
                continue;
            }
            else if (res)
            {
                pilaCiclosSw.pop();
                return res
            }
            if(Desde.ExpPaso.Expresion.OperandoDer)
            {
        	    EjecutarAsignar(Asignar(Desde.ExpPaso.Id,NuevaOperacion(Desde.ExpPaso.Expresion.OperandoIzq,Desde.ExpPaso.Expresion.OperandoDer,Desde.ExpPaso.Expresion.Tipo)), nuevo)                            
            }		
    	}
        pilaCiclosSw.pop();
        return;
	}
    //Funciones
    const Funcion=function(Id, Parametros, Tipo, Bloque)
    {
        return{
            Id: Id,
            Parametros: Parametros,
            Bloque: Bloque,
            Tipo: Tipo,
            TipoInstruccion: "funcion"
        }
    }
    function EjecutarFuncion(elemento,ent)
    {
        var nombrefuncion = elemento.Id + "$";
        // for(var Parametro of elemento.Parametros) //Esto permite la sobrecarga de metodos :3
        // {
        //     nombrefuncion+=Parametro.Tipo;
        // }
        if (ent.tablaSimbolos.has(nombrefuncion))//aca se permitiria la sobrecarga 
      	{
            errores.push("La funcion ",elemento.Id," ya ha sido declarada");
            console.log("La funcion ",elemento.Id," ya ha sido declarada");
      		return;
      	}
        ent.tablaSimbolos.set(nombrefuncion, elemento);
    }
    //Llamada
    const Llamada=function(Id,Params)
    {
        return {
            Id: Id,
            Params: Params,
            TipoInstruccion: "llamada"
        }
    }
    function EjecutarLlamada(Llamada,ent)
    {
        var nombrefuncion = Llamada.Id+"$";
        var Resueltos = [];
        for(var param of Llamada.Params)
        {
            var valor = Evaluar(param,ent);
            //nombrefuncion += valor.Tipo;
            Resueltos.push(valor);
        }
        var temp = ent;
        var simboloFuncion = null;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(nombrefuncion))
            {
                // evaluar el resultado de la expresión 
                simboloFuncion = temp.tablaSimbolos.get(nombrefuncion);	
                break;
            }
            temp=temp.anterior;
        }
        if(!simboloFuncion){
            errores.push("No se encontró la funcion \""+Llamada.Id + "\" con esa combinacion de parametros")
            console.log("No se encontró la funcion "+Llamada.Id + " con esa combinacion de parametros")
            return nuevoSimbolo("@error@","error");
        } 
        pilaFunciones.push(Llamada.Id);
        var nuevo = Entorno(EntornoGlobal)
        var index = 0;
        for(var crear of simboloFuncion.Parametros)
        {
            crear.Expresion=Resueltos[index];
            EjecutarCrear(crear,nuevo);
            index++;
        }
        var retorno=nuevoSimbolo("@error@","error");
        var res = EjecutarBloque(simboloFuncion.Bloque, nuevo)
        if(res)
        {
            if(res.Tipo=="void" )
            {
                if(simboloFuncion.Tipo!="void")
                {
                    errores.push("No se esperaba un return")
                    console.log("No se esperaba un retorno");
                    retorno=nuevoSimbolo("@error@","error");
                }
                else
                {
                    retorno=nuevoSimbolo("@vacio@","vacio")
                }
            }
            else
            {
                var exp = Evaluar(res,nuevo);
                if(exp.Tipo!=simboloFuncion.Tipo)
                {
                    errores.push("El tipo del return no coincide");
                    console.log("El tipo del retorno no coincide");
                    retorno=nuevoSimbolo("@error@","error");
                }
                else
                {
                    retorno=exp;
                }
            }
        }
        else
        {
            if(simboloFuncion.Tipo!="void")
            {
                errores.push("Se esperaba un return")
                console.log("Se esperaba un retorno");
                retorno=nuevoSimbolo("@error@","error");
            }
            else
            {
                retorno=nuevoSimbolo("@vacio@","vacio")
            }
        }
        pilaFunciones.pop();
        return retorno;
    }
    //Casteos
    const Casteo = function(Valor, Casteo)
    {
        return{
            Valor: Valor,
            Casteo: Casteo, //cadena
            TipoInstruccion:"casteo"
        }
    }
    function EjecutarCasteo(casteo,ent)
    {
        var aux = Evaluar(casteo.Valor,ent)
        if(casteo.Casteo != "cadena" && casteo.Casteo != "round" && casteo.Casteo != "truncate" && casteo.Casteo != "typeof" && casteo.Casteo != "length")
        {
            switch(aux.Tipo)
            {
                case "numero":
                    switch(casteo.Casteo)
                    {
                        case "numero":
                            return nuevoSimbolo(aux.Valor+"","numero");
                        case "cadena":
                            return nuevoSimbolo(aux.Valor+"","cadena");
                        case "decimal":
                            return nuevoSimbolo(aux.Valor,"decimal");
                        case "char":
                            return nuevoSimbolo(String.fromCharCode(aux.Valor)+"","char")
                        default:
                            errores.push("Tipo de casteo no definida: ", casteo.Casteo)
                            console.log("Tipo de casteo no definida :c");
                            return nuevoSimbolo("@error@","error");
                    }
                case "decimal":
                    switch(casteo.Casteo)
                    {
                        case "numero":
                            return nuevoSimbolo(Math.trunc(aux.Valor),"numero");
                        case "decimal":
                            return nuevoSimbolo(Math.trunc(aux.Valor),"decimal");
                        case "char":
                            return nuevoSimbolo(String.fromCharCode(aux.Valor)+"","char");
                        case "cadena":
                            return nuevoSimbolo(aux.Valor+"","cadena");
                        default:
                            errores.push("Tipo de casteo no definida: ", casteo.Casteo)
                            console.log("Tipo de casteo no definida :c");
                            return nuevoSimbolo("@error@","error");
                    }
                case "char":
                    switch(casteo.Casteo)
                    {
                        case "numero":
                            return nuevoSimbolo(aux.Valor.charCodeAt(0),"numero");
                        case "char":
                            return nuevoSimbolo(aux.Valor.charCodeAt(0),"char");
                        case "decimal":
                            return nuevoSimbolo(aux.Valor.charCodeAt(0),"decimal");
                        default:
                            errores.push("Tipo de casteo no definida: ", casteo.Casteo)
                            console.log("Tipo de casteo no definida :c");
                            return nuevoSimbolo("@error@","error");
                    }

       
                    var temp=ent;
                    var encontrada = false
                    while(temp!=null)
                    {
                        if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                        {
                            valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                            var cast = Casteo(valorID, casteo.Casteo)
                            return EjecutarCasteo(cast,ent)
                            
                        }
                        temp=temp.anterior;
                    }
                    if(!encontrada)
                    {
                        console.log("No se encontro la variable a castear");
                        return nuevoSimbolo("@error@","error");
                    }
                
            }
        }
        // Si no es casteo normal, entonces es un toString(), toLower(), toUpper(), truncate(), round(), length() o typeof()
        switch(casteo.Casteo)
        {
            case "cadena": 
                switch(aux.Tipo)
                {
                    case "bool":
                    case "numero":
                    case "decimal":
                    case "cadena":
                    case "char":
                        return nuevoSimbolo(aux.Valor+"","cadena");
                    default:
                        errores.push("Error Semantico: Tipo de casteo no definida: "+ aux.Tipo)
                        console.log("Tipo de casteo no definida F");
                        return nuevoSimbolo("@error@","error");
                }
                break;
            case "lower":
                if(aux.Tipo=="cadena")
                {
                    return nuevoSimbolo(aux.Valor.toLowerCase(),"cadena");
                }
                errores.push("Error semantico: Funcion toLower esperaba un elemento de tipo String")
                console.log("Error semantico en la funcion toLower")
                return nuevoSimbolo("@error","error");
                break;
            case "upper":
                if(aux.Tipo=="cadena")
                {
                    return nuevoSimbolo(aux.Valor.toUpperCase(),"cadena");
                }
                errores.push("Error semantico: Funcion toUpper esperaba un elemento de tipo String")
                console.log("Error semantico en la funcion toUpper")
                return nuevoSimbolo("@error","error");
                break;
            case "truncate":
                if(aux.Tipo=="decimal" || aux.Tipo == "numero")
                {
                    return nuevoSimbolo(Math.trunc(aux.Valor),"numero")
                }
                errores.push("Error semantico: Funcion truncate esperaba un elemento de tipo numerico")
                console.log("Error semantico: Funcion truncate esperaba un elemento de tipo numerico")
                return nuevoSimbolo("@error","error");
                break;
            case "round":
                if(aux.Tipo=="numero" || aux.Tipo=="decimal")
                {
                    return nuevoSimbolo(Math.round(aux.Valor),"numero")
                }
                
                errores.push("Error semantico: Funcion round esperaba un elemento de tipo numerico")
                console.log("Error semantico: Funcion round esperaba un elemento de tipo numerico")
                return nuevoSimbolo("@error","error"); 
                break;
            case "length":
                switch(aux.Tipo)
                {
                    case "cadena":
                        return nuevoSimbolo(aux.Valor.length,"numero")
                        break;
                    default:
                        if(aux.Tipo!="numero" && aux.Tipo!="bool" && aux.Tipo!="decimal" && aux.Tipo!="char")
                        {
                            var temp=ent;
                            var encontrada = false
                            while(temp!=null)
                            {
                                if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                                {
                                    valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                                    if(valorID[0].Valor == "lista")
                                    {
                                        return nuevoSimbolo(valorID.length-1,"numero")
                                    }
                                    else
                                    {
                                        return nuevoSimbolo(valorID.length,"numero")
                                    }
                                }
                                temp=temp.anterior;
                            }
                            if(!encontrada)
                            {
                                console.log("No se encontro la variable a castear");
                                return nuevoSimbolo("@error@","error");
                            }
                        }
                        else
                        {
                            errores.push("Error semantico: Funcion length no esperaba el tipo: "+aux.Tipo)
                            console.log("Error semantico: Funcion length no esperaba el tipo: "+aux.Tipo)
                            return nuevoSimbolo("@error@","error");
                        }
                    
                }
                break;
            case "typeof":
                switch(aux.Tipo)
                {
                    case "cadena":
                        return nuevoSimbolo("string","cadena")
                    case "numero":
                        return nuevoSimbolo("int","cadena")
                    case "decimal":
                        return nuevoSimbolo("double","cadena")
                    case "bool":
                        return nuevoSimbolo("boolean","cadena")
                    case "char":
                        return nuevoSimbolo("char","cadena")
                    default:
                        var temp=ent;
                        var encontrada = false
                        while(temp!=null)
                        {
                            if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                            {
                                valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                                if(valorID[0].Valor =="lista")
                                {
                                    return nuevoSimbolo("list","cadena")
                                }
                                else
                                {
                                    return nuevoSimbolo("vector","cadena")
                                }
                            }
                            temp=temp.anterior;
                        }
                         if(!encontrada)
                        {
                            errores.push("No se encontro la variable a castear",casteo.Valor.Valor+"")
                            console.log("No se encontro la variable a castear");
                            return nuevoSimbolo("@error@","error");
                        }
                }
        }
        
    } 
%}
/* Definición Léxica */
%lex

%options case-insensitive
%x string

%%
/* Espacios en blanco */
"//".*            	{}
[ \r\t]+            {}
\n                  {}
(\/\/).*                             {} 
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]  {}

"print"		        return "Rprint";
"if"                return "Rif";
"else"              return "Relse"
"switch"            return "Rswitch";
"case"              return "Rcase"
"default"           return "Rdefault"
"int"               return "Rint";
"double"            return "Rdouble";
"boolean"           return "Rboolean";
"char"              return "Rchar";
"string"            return "Rstring";
"void"              return "Rvoid";
"return"            return "Rretorno";
"continue"          return "Rcontinue";
"toString"          return "RtoString";
"toLower"           return "RtoLower";
"toUpper"           return "RtoUpper";
"round"             return "Rround";
"truncate"          return "Rtruncate"
"while"             return "Rwhile";
"break"             return "Rbreak";
"for"               return "Rfor";
"new"               return "Rnew";
"list"              return "Rlist";
"add"               return "Radd";
"exec"              return "Rexec";
"length"            return "Rlength";
"typeof"            return "Rtypeof";
"do"                return "Rdo";
"toCharArray"       return "Rtochar"

"."                 return "PUNTO";
":"                 return 'DPUNTOS'
";"                 return 'PTCOMA';
","                 return 'COMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';
"["                 return 'CORIZR';
"]"                 return 'CORDER';
"{"                 return 'LLAVEIZQ';
"}"                 return "LLAVEDER";
"true"              return 'TRUE';
"false"             return 'FALSE';

">="                return 'MAYORI';
"<="                return 'MENORI';
"=="                return 'IGUALDAD';
"!="                return 'DIFERENTE';
"="                 return 'IGUAL';
"+"                 return 'MAS';
"-"                 return 'MENOS';
"*"                 return 'POR';
"/"                 return 'DIV';
"%"                 return 'MOD';
"^"                 return 'POT';
"?"                 return 'RTER';
">"                 return 'MAYOR';
"<"                 return 'MENOR';
"&&"                return 'AND';
"||"                return 'OR';
"!"                 return 'NOT';

[a-zA-Z][a-zA-Z0-9_]*   return 'ID';
[0-9]+("."[0-9]+)+\b    return 'DECIMAL';  
[0-9]+\b                return 'NUMERO';  
["]                             {cadena="";this.begin("string");}
<string>[^"\\]+                 {cadena+=yytext;}
<string>"\\\""                  {cadena+="\"";}
<string>"\\n"                   {cadena+="\n";}
<string>"\\t"                   {cadena+="\t";}
<string>"\\\\"                  {cadena+="\\";}
<string>"\\\'"                  {cadena+="\'";}
<string>["]                     {yytext=cadena; this.popState(); return 'Cadena';}

\'((\\\')|[^\n\'])*\'	{ yytext = yytext.substr(1,yyleng-2); return 'Char'; }
\`[^\n\`]*\`			{ yytext = yytext.substr(1,yyleng-2); return 'TEMPLATE'; }

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

/* Asociación de operadores y precedencia */
%left JError
%left 'OR'
%left 'AND'
%right 'NOT'
%right 'FCAST'
%left 'IGUALDAD' 'DIFERENTE'
%left 'MENOR' 'MAYOR' 'MAYORI' 'MENORI'
%left 'MAS' 'MENOS' 
%left 'POR' 'DIV' 'MOD'
%left 'POT'
%left UMENOS

%start INI

%% /* Definición de la gramática */
//console.log(JSON.stringify($1,null,2));
INI
    : LINS EOF  {imprimibles = [];errores = [];EntornoGlobal = Entorno(null);EjecutarBloque($1, EntornoGlobal); return {Imprimibles:imprimibles,Errores:errores,Arbol:JSON.stringify($1,null,2)}}
    | error EOF {errores.push("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column); console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
;

LINS 
    : LINS INS   { $$=$1; $$.push($2) }
    | INS        { $$=[]; $$.push($1) }
;

INS 
    : Rprint PARIZQ Exp PARDER PTCOMA {$$=Imprimir("print",$3);}
    | DECLARAR  PTCOMA                {$$ = $1}
    | ASIGNAR   PTCOMA                {$$ = $1}
    | IF                              {$$ = $1}
    | DOWHILE PTCOMA                  {$$ = $1}
    | WHILE                           {$$ = $1}
    | FOR                             {$$ = $1}
    | SWITCH                          {$$ = $1}
    | Rbreak PTCOMA                   {$$ = Romper()}
    | Rcontinue PTCOMA                {$$ = Continuar()}
    | FUNCIONES                       {$$ = $1}
    | LLAMADA  PTCOMA                 {$$ = $1}
    | RETORNO                         {$$ = $1}
	| error INS {errores.push("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")"); console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column);console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

RETORNO   
    : Rretorno Exp PTCOMA    { $$ = Retorno($2); }
    | Rretorno PTCOMA        { $$ = Retorno(Simbolo("@Vacio@","void")); }
;

DECLARAR
    : TIPO ID                                                       {$$ = Crear($2,$1,null,null,null)}
    | TIPO ID IGUAL Exp                                             {$$ = Crear($2,$1,null,null,$4)}
    | TIPO CORIZR CORDER ID IGUAL Rnew TIPO CORIZR Exp CORDER       {$$ = Crear($4,$1,$7,$9,null)} 
    | TIPO CORIZR CORDER ID IGUAL LLAVEIZQ L_EXP LLAVEDER           {$$ = Crear($4,$1,$1,null,$7)}
    | Rlist MENOR TIPO MAYOR ID IGUAL Rnew Rlist MENOR TIPO MAYOR   {$$ = Crear($5,$3,$10,null,null)}
    | TIPO error PTCOMA                                             {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")")}
;

FUNCIONES
    : TIPO ID PARIZQ PARDER BLOQUE                  { $$ = Funcion($2,[],$1,$5); }
    | Rvoid ID PARIZQ PARDER BLOQUE                 { $$ = Funcion($2,[],"void",$5); }
    | TIPO ID PARIZQ PARAMETROS PARDER BLOQUE       { $$ = Funcion($2,$4,$1,$6); }
    | Rvoid ID PARIZQ PARAMETROS PARDER BLOQUE      { $$ = Funcion($2,$4,"void",$6); }
    | TIPO ID PARIZQ error BLOQUE                   {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;
PARAMETROS
    : PARAMETROS COMA TIPO ID   { $$=$1;$$.push(Crear($4,$3,null,null)) }
    | TIPO ID                   { $$=[];$$.push(Crear($2,$1,null,null)) }
;

ASIGNAR
    : ID IGUAL Exp                                      {$$ = Asignar($1,$3,null)}
    | ID INCRE                                          {$$ = Asignar($1,NuevaOperacion(nuevoSimbolo($1,"ID"),nuevoSimbolo(parseFloat(1),"numero"),$2),null)}
    | ID CORIZR Exp CORDER IGUAL Exp                    {$$ = Asignar($1,$6,$3)}  
    | ID PUNTO Radd PARIZQ Exp PARDER                   {$$ = Asignar($1,$5,nuevoSimbolo("","lista"))} 
    | ID CORIZR CORIZR Exp CORDER CORDER IGUAL Exp      {$$ = Asignar($1,$8,NuevaOperacion($4,nuevoSimbolo(parseFloat(1),"numero"),"+"))}
    | ID error PTCOMA                                   {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")")}
;

INCRE
    : MAS MAS   {$$= $1}
    | MENOS MENOS {$$=$1}
;

TERNARIO
    : Exp RTER Exp DPUNTOS Exp                  {$$ = Ternario($1,$3,$5)} 
    | Exp error PTCOMA                        {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

IF
    : Rif PARIZQ Exp PARDER BLOQUE              {$$ = Si($3,$5,null)}       //If(){}
    | Rif PARIZQ Exp PARDER BLOQUE Relse BLOQUE {$$ = Si($3,$5,$7)}         //If(){}else{}
    //| Rif PARIZQ Exp PARDER BLOQUE Relse IF 
    | Rif error LLAVEDER                        {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

SWITCH
    : Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS Rdefault DPUNTOS LINS LLAVEDER  {$$ = Seleccionar($3,$6,$9)}
    | Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS LLAVEDER                        {$$ = Seleccionar($3,$6,null)}
    | Rswitch error LLAVEDER                                                    {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

ELSEIF
    : Rif PARIZQ Exp PARDER BLOQUE        {$$=[];$$.push(ElseIf($3,$5))}
    | ELSEIF Rif PARIZQ Exp PARDER BLOQUE {$$=$1;$$.push(ElseIf($4,$6))}
    | Rif error PARDER
;

LCASOS
    :Rcase Exp DPUNTOS LINS               {$$=[];$$.push(Caso($2,$4));}
    |LCASOS Rcase Exp DPUNTOS LINS        {$$=$1;$$.push(Caso($3,$5));}
    |Rcase error PARDER                   {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

DOWHILE
    :Rdo BLOQUE Rwhile PARIZQ Exp PARDER    {$$ = HacerMientras($5,$2)}
    |Rdo error PTCOMA                       {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

WHILE
    :Rwhile PARIZQ Exp PARDER BLOQUE        {$$ = new Mientras($3,$5);}
    |Rwhile error PARDER                    {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

BLOQUE
    : LLAVEIZQ LINS LLAVEDER    {$$ = $2}
    | LLAVEIZQ LLAVEDER         {$$ = []}
    | LLAVEDER error LLAVEDER   {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

FOR
    :Rfor PARIZQ ASIGNAR PTCOMA Exp PTCOMA ACTUALIZAR PARDER BLOQUE         {$$ = Desde($3,$5,$7,$9)}
    |Rfor PARIZQ DECLARAR PTCOMA Exp PTCOMA ACTUALIZAR PARDER BLOQUE        {$$ = Desde($3,$5,$7,$9)}
    |Rfor error LLAVEDER                                                    {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

ACTUALIZAR
    : ID IGUAL Exp         {$$ = Actualizacion($1,$3)}
    | ID INCRE             {$$ = Actualizacion($1,NuevaOperacion(nuevoSimbolo($1,"ID"),nuevoSimbolo(parseFloat(1),"numero"),$2))}
    | ID error              {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

LLAMADA 
    : ID PARIZQ PARDER                  { $$=Llamada($1,[]); }
    | ID PARIZQ L_EXP PARDER            { $$=Llamada($1,$3); }
    | Rexec ID PARIZQ PARDER            { $$=Llamada($2,[]); }
    | Rexec ID PARIZQ L_EXP PARDER      { $$=Llamada($2,$4); }
;

CASTEO
    : PARIZQ TIPO2 PARDER Exp       {$$ = Casteo({Expresion:$4,Tipo:$2}, "casteo") }
    | PARIZQ error Exp              {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

TIPO2
    : Rint          {$$ = "numero"}
    | Rdouble       {$$ = "decimal"}
    | Rstring       {$$ = "cadena"}
    | Rchar         {$$ = "char"}
;

TIPO 
    : Rint          {$$ = "numero"}
    | Rdouble       {$$ = "decimal"}
    | Rstring       {$$ = "cadena"}
    | Rboolean      {$$ = "bool"}
    | Rchar         {$$ = "char"}
;
Exp 
    : Exp MAS Exp                                   { $$=NuevaOperacion($1,$3,"+"); }
    | Exp MENOS Exp                                 { $$=NuevaOperacion($1,$3,"-"); }
    | Exp POR Exp                                   { $$=NuevaOperacion($1,$3,"*"); }
    | Exp DIV Exp                                   { $$=NuevaOperacion($1,$3,"/"); }
    | Exp POT Exp                                   { $$=NuevaOperacion($1,$3,"^"); }
    | Exp MOD Exp                                   { $$=NuevaOperacion($1,$3,"%"); }
    | Exp MENOR Exp                                 { $$=NuevaOperacion($1,$3,"<"); }
    | Exp MAYOR Exp                                 { $$=NuevaOperacion($1,$3,">"); }
    | Exp DIFERENTE Exp                             { $$=NuevaOperacion($1,$3,"!="); }
    | Exp IGUALDAD Exp                              { $$=NuevaOperacion($1,$3,"=="); }
    | Exp MAYORI Exp                                { $$=NuevaOperacion($1,$3,">="); }
    | Exp MENORI Exp                                { $$=NuevaOperacion($1,$3,"<="); }
    | Exp AND Exp                                   { $$=NuevaOperacion($1,$3,"&&"); }
    | Exp OR Exp                                    { $$=NuevaOperacion($1,$3,"||"); }
    | Exp MAS MAS                                   { $$=NuevaOperacion($1,nuevoSimbolo(parseFloat(1),"numero"),"+")}
    | Exp MENOS MENOS                               { $$=NuevaOperacion($1,nuevoSimbolo(parseFloat(1),"numero"),"-")}
    | NOT Exp                                       { $$=NuevaOperacionUnario($2,"!"); }
    | MENOS Exp %prec UMENOS                        { $$=NuevaOperacionUnario($2,"umenos"); }
    | Cadena                                        { $$=nuevoSimbolo($1,"cadena"); }
    | Char                                          { $$=nuevoSimbolo($1,"char"); }
    | ID							                { $$=nuevoSimbolo($1,"ID");}
    | ID PARIZQ PARDER                              { $$=nuevoSimbolo({Id:$1,Params:[]},"funcion"); }
    | ID PARIZQ L_EXP PARDER                        { $$=nuevoSimbolo({Id:$1,Params:$3},"funcion"); }
    | ID CORIZR Exp CORDER                          { $$=nuevoSimbolo({Id:$1,Params:$3},"vector")}
    | ID CORIZR CORIZR Exp CORDER CORDER            { $$=nuevoSimbolo({Id:$1,Params:$4},"lista")}
    | NUMERO                                        { $$=nuevoSimbolo(parseFloat($1),"numero"); }
    | DECIMAL                                       { $$=nuevoSimbolo(parseFloat($1),"decimal"); }
    | TRUE                                          { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                                         { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ Exp PARDER                             { $$=$2}
    | PARIZQ TIPO2 PARDER Exp     %prec FCAST       { $$ = nuevoSimbolo({Id:$4,Tipo:$2}, "casteo") }
    | RtoString PARIZQ Exp PARDER %prec FCAST       { $$ = nuevoSimbolo({Id:$3,Tipo:"cadena"}, "casteo") }
    | RtoLower PARIZQ Exp PARDER  %prec FCAST       { $$ = nuevoSimbolo({Id:$3,Tipo:"lower"}, "casteo") }
    | RtoUpper PARIZQ Exp PARDER  %prec FCAST       { $$ = nuevoSimbolo({Id:$3,Tipo:"upper"}, "casteo") } 
    | Rtruncate PARIZQ Exp PARDER  %prec FCAST      { $$ = nuevoSimbolo({Id:$3,Tipo:"truncate"}, "casteo") }
    | Rround PARIZQ Exp PARDER  %prec FCAST         { $$ = nuevoSimbolo({Id:$3,Tipo:"round"}, "casteo") }
    | Rlength PARIZQ Exp PARDER %prec FCAST         { $$ = nuevoSimbolo({Id:$3,Tipo:"length"}, "casteo")}
    | Rtypeof PARIZQ Exp PARDER %prec FCAST         { $$ = nuevoSimbolo({Id:$3,Tipo:"typeof"}, "casteo")}
;

L_EXP 
    :L_EXP COMA Exp                 { $$=$1;$$.push($3); }
    |Exp                            { $$=[];$$.push($1); }
;