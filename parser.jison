%{
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
                    var res=Evaluar(elemento.Operacion, ent);
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
                        console.log("Intruccion romper fuera de un seleccionar o un ciclo")
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
                        // numero puede sumarse con cualquier otro tipo
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
        var dam;
        if(dimension)
        {
            dam = dimension.Valor
        }
        return {
            Id: id,
            Tipo: tipo,
            Tipo2: tipo2,
            Dimension: dam,
            Expresion: expresion,
            TipoInstruccion: "crear"
        }
    }
    function EjecutarCrear(crear,ent)
    {
        if(ent.tablaSimbolos.has(crear.Id)) //Validar si existe la variable
        {
            //error
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
                    console.log("El tipo no coincide con la variable a crear");                    
                    return
                }
            }
            else
            {
                if(crear.Tipo == crear.Tipo2)
                {
                    valor = []
                    for(var exp of crear.Expresion)
                    {
                        valore = Evaluar(exp,ent)
                        valor.push(valore)
                        if(valore.Tipo == crear.Tipo)
                        {
                        }
                        else
                        {
                            console.log("Los tipos de datos no coinciden")
                            return
                        }
                    }
                }
                else
                {
                    console.log("Los tipos de datos no coinciden")
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
                    var dimension = crear.Dimension
                    var valor = []
                    var tmp = ""
                    for(var exp = 0; exp<dimension; exp++)
                    {
                        switch(crear.Tipo)
                        {
                            case "numero":
                                tmp = nuevoSimbolo(0,"numero");
                                break;
                            case "decimal":
                                tmp = nuevoSimbolo("0.00","decimal");
                                break;
                            case "bool":
                                tmp = nuevoSimbolo(true,"bool");
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
                    console.log("Los tipos de datos no coinciden")
                    return
                }
            }
        }
        console.log(valor)
        //Crear objeto a insertar
        ent.tablaSimbolos.set(crear.Id, valor);
    }
    //Asignar
    const Asignar = function(id,Expresion)
    {
        return{
            Id: id,
            Expresion: Expresion,
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
                if(valor.Tipo =="char")
                {
                    if(valor.Valor.length!=0)
                    {
                        //error
                        console.log("No se puede asignar "+valor.Valor+" tipo no compatible con char")
                        return
                    }
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
            temp=temp.anterior;
        }
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
            console.log("Se esperaba una condicion dentro del If");
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
		var ejecutado = false;  
      	var nuevo = Entorno(ent);
        for(var elemento of seleccionar.LCasos)
        {
            var condicion=Evaluar(NuevaOperacion(seleccionar.Expresion,elemento.Expresion,"=="), ent)
            if(condicion.Tipo=="bool")
            {
              	if(condicion.Valor || ejecutado)
              	{
                	ejecutado=true;
                	var res = EjecutarBloque(elemento.Bloque, nuevo)
                	if(res && res.TipoInstruccion=="romper")
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
        pilaCiclosSw.push("ciclo");        
        while(true)
        {
            nuevo = Entorno(ent);
        	var resultadoCondicion = Evaluar(mientras.Condicion, ent)
            if(resultadoCondicion.Tipo=="bool")
            {
            	if(resultadoCondicion.Valor)
            	{
                	var res = EjecutarBloque(mientras.Bloque, nuevo);
                	if(res && res.TipoInstruccion=="romper")
                	{
                		break;
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
                console.log("Se esperaba una condicion dentro del Mientras")
                pilaCiclosSw.pop();
                return
            }
		}
        pilaCiclosSw.pop();
        return
    }

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
            if(res && res.TipoInstruccion=="romper")
            {
                break;
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
    
    const Casteo = function(Valor, Casteo)
    {
        return{
            Valor: Valor,
            Casteo: Casteo,
            TipoInstruccion:"casteo"
        }
    }
    function EjecutarCasteo(casteo,ent)
    {
        if(casteo.Casteo != "round" && casteo.Casteo != "truncate")
        {
            switch(casteo.Valor.Tipo)
            {
                case "numero":
                    switch(casteo.Casteo)
                    {
                        case "cadena":
                            return nuevoSimbolo(casteo.Valor.Valor+"","cadena");
                        case "decimal":
                            return nuevoSimbolo(casteo.Valor.Valor,"decimal");
                        case "char":
                            return nuevoSimbolo(String.fromCharCode(casteo.Valor.Valor)+"","char")
                        default:
                            console.log("Tipo de casteo no definida :c");
                            return nuevoSimbolo("@error@","error");
                    }
                case "decimal":
                    switch(casteo.Casteo)
                    {
                        case "numero":
                            return nuevoSimbolo(Math.trunc(casteo.Valor.Valor),"numero");
                        case "cadena":
                            return nuevoSimbolo(casteo.Valor.Valor+"","cadena");
                        default:
                            console.log("Tipo de casteo no definida :c");
                            return nuevoSimbolo("@error@","error");
                    }
                case "char":
                    switch(casteo.Casteo)
                    {
                        case "numero":
                            return nuevoSimbolo(casteo.Valor.Valor.charCodeAt(0),"numero");
                        case "double":
                            return nuevoSimbolo(casteo.Valor.Valor.charCodeAt(0),"decimal");
                        default:
                            console.log("Tipo de casteo no definida :c");
                            return nuevoSimbolo("@error@","error");
                    }

                case "ID":
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
        // Si no es casteo normal, entonces es un toString(), toLower() o toUpper()

        switch(casteo.Casteo)
        {
            case "cadena":
                switch(casteo.Valor.Tipo)
                {
                    case "bool":
                    case "numero":
                    case "decimal":
                        return nuevoSimbolo(casteo.Valor.Valor+"","cadena");
                    case "ID":
                        var temp=ent;
                        var encontrada = false
                        while(temp!=null)
                        {
                            if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                            {
                                valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                                //VALOR = 10.56
                                //TIPO = NUMERO
                                var cast = Casteo(valorID, "cadena")
                                return EjecutarCasteo(cast,ent)
                            }
                            temp=temp.anterior;
                        }
                        if(!encontrada)
                        {
                            console.log("No se encontro la variable a castear");
                            return nuevoSimbolo("@error@","error");
                        }
                    default:
                        console.log("Tipo de casteo no definida F");
                        return nuevoSimbolo("@error@","error");
                }
                break;
            case "lower":
                if(casteo.Valor.Tipo=="ID")
                {   
                    var temp=ent;
                    var encontrada = false
                    while(temp!=null)
                    {
                        if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                        {
                            valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                            var cast = Casteo(valorID, "cadena")
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
                if(casteo.Valor.Tipo=="cadena")
                {
                    return nuevoSimbolo(casteo.Valor.Valor.toLowerCase(),"cadena");
                }
                console.log("Error semantico en la funcion toLower")
                return nuevoSimbolo("@error","error");
                break;
            case "upper":
                if(casteo.Valor.Tipo=="ID")
                    {   
                        var temp=ent;
                        var encontrada = false
                        while(temp!=null)
                        {
                            if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                            {
                                valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                                var cast = Casteo(valorID, "cadena")
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
                if(casteo.Valor.Tipo=="cadena")
                {
                    return nuevoSimbolo(casteo.Valor.Valor.toUpperCase(),"cadena");
                }
                console.log("Error semantico en la funcion toLower")
                return nuevoSimbolo("@error","error");
                break;
            case "truncate":
                if(casteo.Valor.Tipo=="ID")
                {   
                    var temp=ent;
                    var encontrada = false
                    while(temp!=null)
                    {
                        if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                        {
                            valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                            var cast = Casteo(valorID, "truncate")
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
                if(casteo.Valor.Tipo=="decimal")
                {
                    return nuevoSimbolo(Math.trunc(casteo.Valor.Valor),"numero")
                }
                console.log("Se esperaba una expresion de tipo double")
                return nuevoSimbolo("@error","error");
                break;
            case "round":
                if(casteo.Valor.Tipo=="ID")
                {   
                    var temp=ent;
                    var encontrada = false
                    while(temp!=null)
                    {
                        if(temp.tablaSimbolos.has(casteo.Valor.Valor+""))
                        {
                            valorID = temp.tablaSimbolos.get(casteo.Valor.Valor); 
                            var cast = Casteo(valorID, "round")
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
                if(casteo.Valor.Tipo=="numero" || casteo.Valor.Tipo=="decimal")
                {
                    return nuevoSimbolo(Math.round(casteo.Valor.Valor),"numero")
                }
                console.log("Se esperaba una expresion de tipo double")
                return nuevoSimbolo("@error","error"); 
                break;

        
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
"toString"          return "RtoString";
"toLower"           return "RtoLower";
"toUpper"           return "RtoUpper";
"round"             return "Rround";
"truncate"          return "Rtruncate"
"while"             return "Rwhile";
"break"             return "Rbreak";
"for"               return "Rfor";
"new"               return "Rnew";

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

INI
    : LINS EOF  {EjecutarBloque($1, EntornoGlobal) }
    | error EOF {console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
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
    | WHILE                           {$$ = $1}
    | FOR                             {$$ = $1}
    | SWITCH                          {$$ = $1}
    | Rbreak PTCOMA                   {$$ = Romper()}
    | FUNCIONES                       {$$ = $1}
    | LLAMADA  PTCOMA                 {$$ = $1}
    | RETORNO                         {$$ = $1}
	| error INS {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

RETORNO   
    : Rretorno Exp PTCOMA    { $$ = Retorno($2); }
    | Rretorno PTCOMA        { $$ = Retorno(Simbolo("@Vacio@","void")); }
;

DECLARAR
    : TIPO ID                 {$$ = Crear($2,$1,null,null,null)}
    | TIPO ID IGUAL Exp       {$$ = Crear($2,$1,null,null,$4)}
    | TIPO CORIZR CORDER ID IGUAL Rnew TIPO CORIZR Exp CORDER       {$$ = Crear($4,$1,$7,$9,null)}
    | TIPO CORIZR CORDER ID IGUAL LLAVEIZQ L_EXP LLAVEDER           {$$ = Crear($4,$1,$1,null,$7)}
    | TIPO error PTCOMA       {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")")}
;

FUNCIONES
    : TIPO ID PARIZQ PARDER BLOQUE                  { $$ = Funcion($2,[],$1,$5); }
    | Rvoid ID PARIZQ PARDER BLOQUE                 { $$ = Funcion($2,[],"void",$5); }
    | TIPO ID PARIZQ PARAMETROS PARDER BLOQUE       { $$ = Funcion($2,$4,$1,$6); }
    | Rvoid ID PARIZQ PARAMETROS PARDER BLOQUE      { $$ = Funcion($2,$4,"void",$6); }
    | TIPO ID PARIZQ error LLAVEDER                 {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

PARAMETROS
    : PARAMETROS COMA TIPO ID   { $$=$1;$$.push(Crear($4,$3,null,null)) }
    | TIPO ID                   { $$=[];$$.push(Crear($2,$1,null,null)) }
;

ASIGNAR
    : ID IGUAL Exp              {$$ = Asignar($1,$3)}
    | ID INCRE                  {$$ = Asignar($1,NuevaOperacion(nuevoSimbolo($1,"ID"),nuevoSimbolo(parseFloat(1),"numero"),$2))}
    | ID error PTCOMA           {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")")}
;

INCRE
    : MAS MAS   {$$= $1}
    | MENOS MENOS {$$=$1}
;

TERNARIO
    : Exp RTER   
;

IF
    : Rif PARIZQ Exp PARDER BLOQUE              {$$ = Si($3,$5,null)}       //If(){}
    | Rif PARIZQ Exp PARDER BLOQUE Relse BLOQUE {$$ = Si($3,$5,$7)}         //If(){}else{}
    | Rif error LLAVEDER                        {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

SWITCH
    : Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS Rdefault DPUNTOS LINS LLAVEDER  {$$ = Seleccionar($3,$6,$9)}
    | Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS LLAVEDER                {$$ = Seleccionar($3,$6,null)}
    | Rswitch error LLAVEDER                    {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

LCASOS
    :Rcase Exp DPUNTOS LINS               {$$=[];$$.push(Caso($2,$4));}
    |LCASOS Rcase Exp DPUNTOS LINS        {$$=$1;$$.push(Caso($3,$5));}
    |Rcase error PARDER                   {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
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
    |Rfor error LLAVEDER        {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

ACTUALIZAR
    : ID IGUAL Exp         {$$ = Actualizacion($1,$3)}
    | ID INCRE             {$$ = Actualizacion($1,NuevaOperacion(nuevoSimbolo($1,"ID"),nuevoSimbolo(parseFloat(1),"numero"),$2))}
    | ID error   {console.log("Se recupero en ",yytext," (", this._$.last_line,", ", this._$.last_column,")");}
;

LLAMADA 
    : ID PARIZQ PARDER            { $$=Llamada($1,[]); }
    | ID PARIZQ L_EXP PARDER      { $$=Llamada($1,$3); }
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
    : Exp MAS Exp                   { $$=NuevaOperacion($1,$3,"+"); }
    | Exp MENOS Exp                 { $$=NuevaOperacion($1,$3,"-"); }
    | Exp POR Exp                   { $$=NuevaOperacion($1,$3,"*"); }
    | Exp DIV Exp                   { $$=NuevaOperacion($1,$3,"/"); }
    | Exp POT Exp                   { $$=NuevaOperacion($1,$3,"^"); }
    | Exp MOD Exp                   { $$=NuevaOperacion($1,$3,"%"); }
    | Exp MENOR Exp                 { $$=NuevaOperacion($1,$3,"<"); }
    | Exp MAYOR Exp                 { $$=NuevaOperacion($1,$3,">"); }
    | Exp DIFERENTE Exp             { $$=NuevaOperacion($1,$3,"!="); }
    | Exp IGUALDAD Exp              { $$=NuevaOperacion($1,$3,"=="); }
    | Exp MAYORI Exp                { $$=NuevaOperacion($1,$3,">="); }
    | Exp MENORI Exp                { $$=NuevaOperacion($1,$3,"<="); }
    | Exp AND Exp                   { $$=NuevaOperacion($1,$3,"&&"); }
    | Exp OR Exp                    { $$=NuevaOperacion($1,$3,"||"); }
    | Exp MAS MAS                   { $$=NuevaOperacion($1,nuevoSimbolo(parseFloat(1),"numero"),"+")}
    | Exp MENOS MENOS               { $$=NuevaOperacion($1,nuevoSimbolo(parseFloat(1),"numero"),"-")}
    | NOT Exp                       { $$=NuevaOperacionUnario($2,"!"); }
    | MENOS Exp %prec UMENOS        { $$=NuevaOperacionUnario($2,"umenos"); }
    | Cadena                        { $$=nuevoSimbolo($1,"cadena"); }
    | Char                          { $$=nuevoSimbolo($1,"char"); }
    | ID							{ $$=nuevoSimbolo($1,"ID");}
    | ID PARIZQ PARDER              { $$=nuevoSimbolo({Id:$1,Params:[]},"funcion"); }
    | ID PARIZQ L_EXP PARDER        { $$=nuevoSimbolo({Id:$1,Params:$3},"funcion"); }
    | ID CORIZR Exp CORDER          { $$}
    | NUMERO                        { $$=nuevoSimbolo(parseFloat($1),"numero"); }
    | DECIMAL                        { $$=nuevoSimbolo(parseFloat($1),"decimal"); }
    | TRUE                          { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                         { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ Exp PARDER             { $$=$2}
    | PARIZQ TIPO2 PARDER Exp     %prec FCAST    {$$ = nuevoSimbolo({Id:$4,Tipo:$2}, "casteo") }
    | RtoString PARIZQ Exp PARDER %prec FCAST    {$$ = nuevoSimbolo({Id:$3,Tipo:"cadena"}, "casteo") }
    | RtoLower PARIZQ Exp PARDER  %prec FCAST    {$$ = nuevoSimbolo({Id:$3,Tipo:"lower"}, "casteo") }
    | RtoUpper PARIZQ Exp PARDER  %prec FCAST    {$$ = nuevoSimbolo({Id:$3,Tipo:"upper"}, "casteo") }
    | Rtruncate PARIZQ Exp PARDER  %prec FCAST    {$$ = nuevoSimbolo({Id:$3,Tipo:"truncate"}, "casteo") }
    | Rround PARIZQ Exp PARDER  %prec FCAST    {$$ = nuevoSimbolo({Id:$3,Tipo:"round"}, "casteo") }
    
    
;

L_EXP 
    :L_EXP COMA Exp                 { $$=$1;$$.push($3); }
    |Exp                            { $$=[];$$.push($1); }
;