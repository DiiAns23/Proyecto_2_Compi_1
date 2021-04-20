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
                case "switch":
                    retorno = EjecutarSeleccionar(elemento, ent);
                    break;
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
        return {
            Valor:Valor,
            Tipo:Tipo
        }
    }
    const NuevaOperacion= function(OperandoIzq,OperandoDer,Tipo)
    {
        return {
            OperandoIzq:OperandoIzq,
            OperandoDer:OperandoDer,
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
            case "numero":
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
        }
      	//Operaciones
        Valorizq=Evaluar(Operacion.OperandoIzq, ent);
        if(Operacion.OperandoDer!=null)
        {
            Valorder=Evaluar(Operacion.OperandoDer, ent);
        }
      	var tipoRetorno = "error";
      	// identificar qué operaciones sí podemos realizar dependiendo del tipo
    	switch(Valorizq.Tipo)
        {
          case "cadena":
            // cadena puede sumarse con cualquier otro tipo
            if(!Valorder){
            	tipoRetorno="cadena";
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
              	case "numero":
                case "bool":
                	tipoRetorno = "cadena";	
                	break;
            }
            break;
          case "numero":
            if(!Valorder){
            	tipoRetorno="numero";
              	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
                	tipoRetorno = "cadena";
                	break;
              	case "numero":
                	tipoRetorno = "numero";	
                	break;
            }
            break;
          case "bool":
            if(!Valorder){
            	tipoRetorno="bool";
              	break;
            }
            if(!Valorder){
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "bool":
                	tipoRetorno = "bool";
              		break;
            }
            break;
        }
      
        switch (Operacion.Tipo)
        {
            case "+":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
            			return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                		break;
                }
            case "-":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                		break;
                }
            case "umenos":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(0-Valorizq.Valor, tipoRetorno);
                }
            case "*":
                switch(tipoRetorno)
                {
                	case "numero":
                    	return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, tipoRetorno);
                }
            case "/":
                switch(tipoRetorno)
                {
                	case "numero":	
                    	return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, tipoRetorno);
                }
            case "%":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, tipoRetorno);
                }
            case "^":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(Math.pow(Valorizq.Valor,Valorder.Valor), tipoRetorno);
                }
            case "!":
                switch(tipoRetorno)
                {
                	case "bool":
            			return nuevoSimbolo(!Valorizq.Valor, tipoRetorno);
                }
            case "&&":
                switch(tipoRetorno)
                {
                	case "bool":
            			return nuevoSimbolo(Valorizq.Valor && Valorder.Valor, tipoRetorno);
                }
            case "||":
                switch(tipoRetorno)
                {
                	case "bool":
                		return nuevoSimbolo(Valorizq.Valor || Valorder.Valor, tipoRetorno);
                }
            case ">":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, "bool");
                }
            case "<":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, "bool");
                }
            case ">=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, "bool");
                }
            case "<=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, "bool");
                }
            case "==":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, "bool");
                }
            case "!=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                		return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, "bool");
                }
        }
      	console.log(
          "Tipos incompatibles " + ( Valorizq ? Valorizq.Tipo : "" ) + 
          " y " + ( Valorder ? Valorder.Tipo : "" )); 
      	return nuevoSimbolo("@error@", "error");
    }

    function NuevaOperacionUnario(Operando,Tipo)
    {
        return {
            OperandoIzq:Operando,
            OperandoDer:null,
            Tipo:Tipo
        }
    }
    //Imprimir
    const Imprimir=function(TipoInstruccion,Operacion){
        return {
            TipoInstruccion:TipoInstruccion,
            Operacion:Operacion
        }
    }
    //Crear
    const Crear = function(id, tipo, expresion){
        return {
            Id: id,
            Tipo: tipo,
            Expresion: expresion,
            TipoInstruccion: "crear"
        }
    }
    function EjecutarCrear(crear,ent)
    {
        if(ent.tablaSimbolos.has(crear.Id)) //Validar si existe la variable
        {
            console.log("La variable ",crear.Id," ya ha sido declarada en este ambito");
      		return;     //Aca se regresa el valor :3
        }
        var valor;
        if (crear && crear.Expresion)
        {
            valor = Evaluar(crear.Expresion);
        }
        else
        {
            switch(crear.Tipo)
            {
                case "int":
                    valor = nuevoSimbolo(0,"numero");
                    break;
                case "double":
                    valor = nuevoSimbolo(0.0,"decimal");
                    break;
                case "boolean":
                    valor = nuevoSimbolo(true,"bool");
                case "char":
                    valor = nuevoSimbolo('\u0000',"char");
                case "string":
                    valor = nuevoSimbolo("","cadena");
            }
        }
        //Crear objeto a insertar
        ent.tablaSimbolos.set(crear.Id, valor);
    }
    //Asignar
    const Asignar = function(id,Expresion){
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
              	
                // comparar los tipos
                if (simbolotabla.Tipo === valor.Tipo)
                {
                	// reasignar el valor
                    temp.tablaSimbolos.set(asignar.Id, valor);
                    return
                }
                else
                {
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
    function EjecutarSeleccionar(seleccionar,ent){
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
    const Romper = function(){
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
    const Mientras = function(Condicion, Bloque){
        return{
            Condicion: Condicion,
            Bloque: BloqueNinguno,
            TipoInstruccion: "while"
        }
    }

    function EjecutarMientras(mientras,ent){
        pilaCiclosSw.push("ciclo");        
      	nuevo=Entorno(ent);
        while(true)
        {
        	var resultadoCondicion = Evaluar(mientras.Condicion, ent)
            if(resultadoCondicion.Tipo=="bool")
            {
            	if(resultadoCondicion.Valor)
            	{
                	var res=EjecutarBloque(mientras.Bloque, nuevo);
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
    
%}
/* Definición Léxica */
%lex

%options case-insensitive

%%
/* Espacios en blanco */
"//".*            	{}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]           {}
[ \r\t]+            {}
\n                  {}

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

"while"             return "Rwhile";
"break"             return "Rbreak";

"for"               return "Rfor";

":"                 return 'DPUNTOS'
";"                 return 'PTCOMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';
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
">"                 return 'MAYOR';
"<"                 return 'MENOR';
"&&"                return 'AND';
"||"                return 'OR';
"!"               return 'NOT';

[a-zA-Z][a-zA-Z0-9_]*   return 'ID'
[0-9]+("."[0-9]+)?\b    return 'NUMERO';  
\"((\\\")|[^\n\"])*\"   { yytext = yytext.substr(1,yyleng-2); return 'Cadena'; }
\'((\\\')|[^\n\'])*\'	{ yytext = yytext.substr(1,yyleng-2); return 'Cadena'; }
\`[^\n\`]*\`			{ yytext = yytext.substr(1,yyleng-2); return 'TEMPLATE'; }

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

/* Asociación de operadores y precedencia */
%left JError
%left 'OR'
%left 'AND'
%right 'NOT'
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
    | DECLARAR                        {$$ = $1}
    | ASIGNAR                         {$$ = $1}
    | IF                              {$$ = $1}
    | SWITCH                          {$$ = $1}
    | Rbreak                          {$$ = Romper()}
    | MIENTRAS                        {$$ = $1}
;

MIENTRAS
    :Rwhile PARIZQ Exp PARDER BLOQUE    { $$ = new Mientras($3,$5)}
;
IF
    : Rif PARIZQ Exp PARDER BLOQUE              {$$ = Si($3,$5,null)}       //If(){}
    | Rif PARIZQ Exp PARDER BLOQUE Relse BLOQUE {$$ = Si($3,$5,$7)}         //If(){}else{}
    //| Rif PARDER Exp PARDER BLOQUE Relse IF     {$$ = Si($3,$5,$7)}         //If(){}else if(){}
;

SWITCH
    : Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS Rdefault LINS LLAVEDER  {$$ = Seleccionar($3,$6,$8)}
    | Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS LLAVEDER                {$$ = Seleccionar($3,$6,null)}
;

LCASOS
    :Rcase Exp DPUNTOS LINS               {$$=[];$$.push(Caso($2,$4));}
    |LCASOS Rcase Exp DPUNTOS LINS        {$$=$1;$$.push(Caso($3,$5));}
;

WHILE
    :Rwhile PARIZQ Exp PARDER BLOQUE        {$$ = new Mientras($3,$5);}
;
BLOQUE
    : LLAVEIZQ LINS LLAVEDER    {$$ = $2}
    | LLAVEIZQ LLAVEDER         {$$ = []}
;

DECLARAR
    : INT                           {$$ = $1}
    | STRING                        {$$ = $1}
    | BOOLEANO                      {$$ = $1}
    | CHAR                          {$$ = $1}     

;
INT
    : Rint ID PTCOMA                {$$ = Crear($2, "int", 0)}
    | Rint ID IGUAL Exp PTCOMA      {$$ = Crear($2, "int", $4)}

;
DOUBLE
    : Rdouble ID PTCOMA                 {$$ = Crear($2, "double", 0.0)}
    | Rdouble ID IGUAL Exp PTCOMA       {$$ = Crear($2, "double", $4)}

;
STRING
    : Rstring ID PTCOMA                 {$$ = Crear($2, "string", "")}
    | Rstring ID IGUAL Exp PTCOMA       {$$ = Crear($2, "string", $4)}
;
BOOLEANO
    : Rboolean ID PTCOMA                {$$ = Crear($2, "boolean", true)}
    | Rboolean ID IGUAL Exp PTCOMA      {$$ = Crear($2, "boolean", $4)}
;
CHAR
    : Rchar ID PTCOMA                   {$$ = Crear($2, "char", '\u0000')}
    | Rchar ID IGUAL Exp PTCOMA         {$$ = Crear($2, "char", $4)}
;

ASIGNAR
    : ID IGUAL Exp PTCOMA               {$$ = Asignar($1,$3)}

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
    | Exp IGUALDAD Exp             { $$=NuevaOperacion($1,$3,"=="); }
    | Exp MAYORI Exp                { $$=NuevaOperacion($1,$3,">="); }
    | Exp MENORI Exp                { $$=NuevaOperacion($1,$3,"<="); }
    | Exp AND Exp                   { $$=NuevaOperacion($1,$3,"&&"); }
    | Exp OR Exp                    { $$=NuevaOperacion($1,$3,"||"); }
    | NOT Exp                       { $$=NuevaOperacionUnario($2,"!"); }
    | MENOS Exp %prec UMENOS        { $$=NuevaOperacionUnario($2,"umenos"); }
    | Cadena                        { $$=nuevoSimbolo($1,"cadena"); }
    | ID							{ $$=nuevoSimbolo($1,"ID");}
    | NUMERO                        {$$=nuevoSimbolo(parseFloat($1),"numero"); }
    | TRUE                          { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                         { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ Exp PARDER             { $$=$2 }
;
