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

```typescript
start -> INI

INI -> LINS  EOF

LINS -> LINS INS
        | INS

INS -> Rprint PARIZQ Exp PARDER PTCOMA
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
	| error INS

RETORNO -> Rretorno Exp PTCOMA   
    | Rretorno PTCOMA

DECLARAR -> TIPO ID                                                       
    | TIPO ID IGUAL Exp                                             
    | TIPO CORIZR CORDER ID IGUAL Rnew TIPO CORIZR Exp CORDER       
    | TIPO CORIZR CORDER ID IGUAL LLAVEIZQ L_EXP LLAVEDER           
    | Rlist MENOR TIPO MAYOR ID IGUAL Rnew Rlist MENOR TIPO MAYOR   
    | TIPO error PTCOMA                                            

FUNCIONES -> TIPO ID PARIZQ PARDER BLOQUE                  
    | Rvoid ID PARIZQ PARDER BLOQUE                 
    | TIPO ID PARIZQ PARAMETROS PARDER BLOQUE       
    | Rvoid ID PARIZQ PARAMETROS PARDER BLOQUE      
    | TIPO ID PARIZQ error BLOQUE

PARAMETROS -> PARAMETROS COMA TIPO ID   
    | TIPO ID   

ASIGNAR -> ID IGUAL Exp                                     
    | ID INCRE                                         
    | ID CORIZR Exp CORDER IGUAL Exp                   
    | ID PUNTO Radd PARIZQ Exp PARDER                  
    | ID CORIZR CORIZR Exp CORDER CORDER IGUAL Exp     
    | ID error PTCOMA                                  

INCRE -> MAS MAS   
    | MENOS MENOS

TERNARIO -> Exp RTER Exp DPUNTO
    | Exp error PTCOMA  

IF -> Rif PARIZQ Exp PARDER BLOQUE              
    | Rif PARIZQ Exp PARDER BLOQUE Relse BLOQUE 
    | Rif error LLAVEDER                        

SWITCH -> Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS Rdefault DPUNTOS LINS 

LLAVEDER  
    | Rswitch PARIZQ Exp PARDER LLAVEIZQ LCASOS LLAVEDER                        
    | Rswitch error LLAVEDER                                                    

LCASOS -> Rcase Exp DPUNTOS LINS       
    |LCASOS Rcase Exp DPUNTOS LINS
    |Rcase error PARDER           

DOWHILE -> Rdo BLOQUE Rwhile PARIZQ Exp PARDER 
    |Rdo error PTCOMA                    

WHILE ->Rwhile PARIZQ Exp PARDER BLOQUE
    |Rwhile error PARDER            

BLOQUE -> LLAVEIZQ LINS LLAVEDER 
    | LLAVEIZQ LLAVEDER      
    | LLAVEDER error LLAVEDER

FOR -> Rfor PARIZQ ASIGNAR PTCOMA Exp PTCOMA ACTUALIZAR PARDER BLOQUE   
    |Rfor PARIZQ DECLARAR PTCOMA Exp PTCOMA ACTUALIZAR PARDER BLOQUE  
    |Rfor error LLAVEDER                                              

ACTUALIZAR -> ID IGUAL Exp 
    | ID INCRE     
    | ID error     

LLAMADA -> ID PARIZQ PARDER            
    | ID PARIZQ L_EXP PARDER      
    | Rexec ID PARIZQ PARDER      
    | Rexec ID PARIZQ L_EXP PARDER

CASTEO -> PARIZQ TIPO2 PARDER Exp 
    | PARIZQ error Exp        

TIPO2 -> Rint    
    | Rdouble 
    | Rstring 
    | Rchar   

TIPO -> Rint    
    | Rdouble 
    | Rstring 
    | Rboolean
    | Rchar   

Exp -> Exp MAS Exp                              
    | Exp MENOS Exp                            
    | Exp POR Exp                              
    | Exp DIV Exp                              
    | Exp POT Exp                              
    | Exp MOD Exp                              
    | Exp MENOR Exp                            
    | Exp MAYOR Exp                            
    | Exp DIFERENTE Exp                        
    | Exp IGUALDAD Exp                         
    | Exp MAYORI Exp                           
    | Exp MENORI Exp                           
    | Exp AND Exp                              
    | Exp OR Exp                               
    | Exp MAS MAS                              
    | Exp MENOS MENOS                          
    | NOT Exp                                  
    | MENOS Exp %prec UMENOS                   
    | Cadena                                   
    | Char                                     
    | ID							           
    | ID PARIZQ PARDER                         
    | ID PARIZQ L_EXP PARDER                   
    | ID CORIZR Exp CORDER                     
    | ID CORIZR CORIZR Exp CORDER CORDER       
    | NUMERO                                   
    | DECIMAL                                  
    | TRUE                                     
    | FALSE                                    
    | PARIZQ Exp PARDER                        
    | PARIZQ TIPO2 PARDER Exp     %prec FCAST  
    | RtoString PARIZQ Exp PARDER %prec FCAST  
    | RtoLower PARIZQ Exp PARDER  %prec FCAST  
    | RtoUpper PARIZQ Exp PARDER  %prec FCAST  
    | Rtruncate PARIZQ Exp PARDER  %prec FCAST 
    | Rround PARIZQ Exp PARDER  %prec FCAST    
    | Rlength PARIZQ Exp PARDER %prec FCAST    
    | Rtypeof PARIZQ Exp PARDER %prec FCAST    

L_EXP -> L_EXP COMA Exp
    |Exp           
```

```java
Universidad San Carlos de Guatemala 2021
Programador: Diego Andrés Obín Rosales
Carné: 201903865
```
