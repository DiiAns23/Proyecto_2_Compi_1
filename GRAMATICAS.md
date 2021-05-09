GRAMATICAS
=================

## Índice 📚
- [Terminales](#terminales)
- [No Terminales](#noterminales)
- [Producciones](#producciones)

<div id='terminales'/>

## Terminales
   
   | **NOMBRE** | **SIMBOLO** |  **NOMBRE** | **SIMBOLO** |
   |------------|---------|----------|-------------|
   | `Rprint`  | print | `Rif` | if 
   | `Relse`        |   else  | `Rswitch`    | switch
   | `Rcase`       |  case    | `Rdefault` | default
   | `Rint`     |  int   | `Rdouble`    | double
   | `Rboolean`    | boolean     | `Rchar`   | char
   | `Rstring`    | string      | `Rvoid `  | void
   | `Rretorno`   | return   | `Rcontinue` | continue
   | `RtoString` | toString  |  `RtoLower` | toLower
   | `RtoUpper` |  toUpper  | `Rround` | round
   | `Rtruncate`   |  truncate  | `Rwhile` | while
   | `Rbreak`  | break |  `Rfor` | for
   | `Rnew` | new  | `Rlist`  | list
   | `Radd`  | add | `Rexec` | exec 
   | `Rlength`        |   length  | `Rtypeof`    | typeof
   | `Rdo`       |  do    | `PUNTO` | .
   | `DPUNTOS`     |  :   | `PTCOMA`    | ;
   | `COMA`    | ,     | `PARIZQ`   | (
   | `PARDER`    | )      | `CORIZR `  | [
   | `CORDER`   | ]   | `LLAVEIZQ` | {
   | `LLAVEDER` | }  |  `TRUE` | true
   | `FALSE` |  false  | `MAYORI` | >=
   | `MENORI`   |  <=  | `IGUALDAD` | ==
   | `DIFERENTE`  | != |  `IGUAL` | =
   | `MAS` | +  | `MENOS`  | -
   | `POR` | *  | `DIV`  | /
   | `MOD`  | % | `POT` | ^ 
   | `MAYOR`        |   >  | `MENOR`    | <
   | `AND`       |  &&    | `OR` | \|\|
   | `NOT`     |  !   | `ID`    | [a-zA-Z][a-zA-Z0-9_]*
   | `DECIMAL`    | [0-9]+("."[0-9]+)+\b     | `NUMERO`   | [0-9]+\b
   | `Cadena`    |   ""    |   | 


<div id='noterminales'/>

## No terminales

   | **NOMBRE**    |    **NOMBRE**  |    **NOMBRE**   |
   |---------------|----------------|-----------------|
   | `INI`          | `LINS`    | `INS `   |
   | `RETORNO`   |   `DECLARAR`  | `FUNCIONES`|
   | `PARAMETROS`|  `ASIGNAR`       | `INCRE`      | 
   | `TERNARIO`        |  `IF`       | `SWITCH`   | 
   | `ELSEIF` | `LCASOS`      | `DOWHILE`        |
   | `WHILE`        | `BLOQUE`        |   
   | `FOR`          | `ACTUALIZAR`    | `LLAMADA `   |
   | `CASTEO`   |   `TIPO2`  | `TIPO`|
   | `TIPO`|  `Exp`       | `L_EXP`      |   


<div id='producciones'/>

## Producciones
`start -> INI`

`INI -> LINS  EOF`

`LINS -> LINS INS
        | INS`

`INS -> Rprint PARIZQ Exp PARDER PTCOMA
    | DECLARAR  PTCOMA               
    | ASIGNAR   PTCOMA               
    | IF                             
    | DOWHILE PTCOMA                 
    | WHILE                          
    | FOR                            
    | SWITCH                         
    | Rbreak PTCOMA                  
    | Rcontinue PTCOMA               
    | FUNCIONES                      
    | LLAMADA  PTCOMA                
    | RETORNO                        
	| error INS`

`RETORNO -> Rretorno Exp PTCOMA   
    | Rretorno PTCOMA`

`DECLARAR-> TIPO ID                                                       
    | TIPO ID IGUAL Exp                                             
    | TIPO CORIZR CORDER ID IGUAL Rnew TIPO CORIZR Exp CORDER       
    | TIPO CORIZR CORDER ID IGUAL LLAVEIZQ L_EXP LLAVEDER           
    | Rlist MENOR TIPO MAYOR ID IGUAL Rnew Rlist MENOR TIPO MAYOR   
    | TIPO error PTCOMA`                                             