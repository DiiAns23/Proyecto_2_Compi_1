MANUAL TÉCNICO 💻
===================

## Indice 🚀

#### • [Descripción de la solución](#descipcion-de-la-solucion-⚙️) ####

#### • [Requerimientos Funcionales del Sistema](#requerimientos-funcionales-del-sistema-📋) ####

#### • [Requerimientos del Entorno de Desarrollo](#requerimientos-del-entorno-de-desarrollo-🔧) ####

#### • [Diccionario de Clases](#diccionario-de-clases-📖) ####

#### • [Diccionario de Funciones](#diccionario-de-funciones-📦) ####


Descripción de la solución ⚙️
-----------------------

#### Ejecucion ####

El programa `Typesty` puede ser ejecutado desde cualquier ordenador siempre y cuando contenga entre su software las aplicaciones `Node` y `Angular`. Para poder arrancar el programa es necesario mantener 2 terminales abriertas, una en la cual se debe de mantener la ejecución de la aplicación en el servidor (`Angular`) y la segunda terminal en donde se corra el archivo `parser.js` el cual es el medio de conexión entre el _Backend_ y el _Frontend_

#### Lectura ####

El código maestro se encuentra en el archivo `parser.js` el cual es creado a partir del archivo `parser.jison`, en el cual se encuentra la lectura y creacion del código mismo. Ejecuta las instrucciones correspondientes y devuelve los elementos imprimibles así como los errores generados durante la lectura del archivo de entrada.

#### Analizador ####

El programa lee caracter por caracter el archivo de entrada, el cual deberá de tener una extensión de tipo _ty_ , si un caracter no cumple con la estructura definida en el programa se creará un Reporte de Errores el cual será impreso después de la ejecución de todo el código a analizar.

Requerimientos Funcionales del Sistema 📋
-----------------------
• Existe un paquete el cual es el encargado de gestionar el almacenamiento de las bases de datos, proporcionando al servidor un conjunto de funciones para ingresar, modificar extraer y eliminar la información.

• Cada registro que corresponde a una tupla de una tabla será almacenado en cada nodo que corresponden a un Arbol B. Estos registros seran débilmente tipados.

• Se proporcionan funciones relacionadas al CRUD de bases de datos, tablas y registros.

• El paquete cuenta con una interfaz gráfica que facilita el manejo de la información, para ello se requiere tener instalado [Angular](https://angular.io)


Requerimientos del Entorno de Desarrollo 🔧
-----------------------
• Versión de JavaScript: JavaScript 14.16.1 o superior [Node](https://nodejs.org/es/).

• IDE utilizada: Visual Studio Code 1.56.0

• Espacio en memoria: 500 MB como mínimo


Diccionario de Clases 📖
-----------------------
Clase |  Definición 
------------ | -------------
`parser` | Es el encargado de ejecutar todo el código que se ha ingresado, funciona recursivamente.

Diccionario de Funciones 📦
-----------------------

### Funciones Principales ###

Función |  Definición 
------------ | -------------
`Entorno` | Contiene consigo la tabla de símbolos correspondientes al ámbito en el cual se esta trabajando así como a su entorno anterior
`EjecutarBloque` | Manda a llamar a los distintos métodos para realizar todas las funciones del programa
`nuevoSimbolo` | Genera los nodos que identifican a los valores durante el programa.
`NuevaOperacion` | Genera nodos que contienen 2 operandos y un tipo de operación para su ejecución
`NuevaOperacionUnario` | Genera específicamente el nodo de la negación unaria
`Evaluar` | Realiza todas las operaciones especificadas durante la lectura del código.
`EjecutarCrear` | Esta función permite la creación de nuevas variables así como los métodos, listas y vectores.
`EjecutarAsignar` | Asigna un nuevo valor a una variable la cual debió de ser creada con anterioridad.
`EjecutarSi` | Esta función permite la ejecución de la condición `if`.
`EjecutarSeleccionar` | Esta función permite la ejecución de la condición `switch`.
`EjecutarMientras` | Esta función permite la ejecución del ciclo `while`.
`EjecutarDesde` | Esta función permite la ejecución del ciclo `for`.
`EjecutarHacerMientras` | Esta función permite la ejecución del ciclo `do-while`.
`EjecutarFuncion` | Permite la ejecucion de funciones dentro del código.
`EjecutarLlamada` | Accede a las funciones o métodos del código.
`EjecutarCasteo` | Realiza los casteos correspondientes a cada caso.


### Funciones Secundarias  ###

Función |  Definición 
------------ | -------------
`Imprimir` | Instruccion que es ejecutada en `EjecutarBloque`, permite la impresión de los datos.
`Crear` | Devuelve el objeto con los datos de la nueva variable.
`Asignar` | Devuelve los datos con los nuevos valores de la variable.
`Si` | Regresa el objeto con los datos de la sentencia `if`.
`Seleccionar` | Regresa el objeto con los datos de la sentencia `switch`. 
`Caso` | Almacena y devuelve los casos a evaluar en la sentencias `switch`. 
`Romper` | Devuelve la instruccion `break`. 
`Continuar` | Devuelve la instruccion `continue`.
`Retorno` | Devuelve la instruccion `return`. 
`Mientras` | Regresa el objeto con los datos del ciclo `while`. 
`HacerMientras` | Regresa el objeto con los datos del ciclo `do-while`. 
`Desde` | Regresa el objeto con los datos del ciclo `for`.
`Actualizacion` | Crea el objeto para realizar la adicion unaria.
`Funcion` | Regresa el objeto con los datos para ejecutar las funciones.
`Llamada` | Recibe y regresa la lista de datos necesarios para la ejecucion de una funcion .
`Casteo` | Almacena y regresa los datos a castear.

```java
Universidad San Carlos de Guatelama 2021
Programador: Diego Andrés Obín Rosales
Carné: 201903865
```
