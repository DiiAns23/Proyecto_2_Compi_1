MANUAL DE USUARIO 🕹️
===================
## Índice 📚
- [Introduccion](#introduccion)
- [Descripción General del Sistema](#descrip)
- [Aplicacion](#apli)
- [FAQ](#questions)

<div id='introduccion'/>

## Introducción 📑
Con la finalidad de la implementación de las gramáticas de tipo LALR del curso Organización de Lenguajes y Compiladores 1 se llevó a cabo el programa denominado `Typesty`,
dicho programa fue desarrollado por medio de lenguajes de programación los cuales corresponden a `JavaScript` como desarrollo del backend y `Node Angular` como lenguaje para
el desarrollo del frontend. El programa tiene la capacidad de resolver métodos avanzados, teniendo un excelente manejo de la recursividad en funciones.

<div id='descrip'/>

## Descripción 📄

  - **Comentarios**: 
Para llevar un registro de acciones que se realizan dentro del codigo, `Typesty` trae consigo el manejo de ._Comentatios_. los cuales son permitidos dentro del código de las
distintas formas:

  | Tipo | Notación | 
  | ------------------------------- | ----------------------------------------- |
  | Unilínea | Se debe de comenzar con "//" y terminar con un salto de línea ("\\n") |
  | Multilínea | Se debe de comenzar con "\/\*" y terminar con  "\*\\" |

  - **Declaración de Variables**: 
`Typesty` maneja distintos tipos de variables, entre los cuales se encuentran:

   | **Tipo** | **Palabra Reservada** | **Valores que almacena**|
   | ---------- | ----------------- | --------------------------- |
   | Entero | `int` | -2147483648 - 2147483647 |
   | Doble  | `double` | Valores en decimales |
   | Booleano | `boolean` | `true` o `false` |
   | Caracter   | `char`  | 1 solo caracter |
   | Cadena   | `string` | Cadenas de texto |

  - **Palabras Reservadas**:
Además de poseer palabras reservadas para las declaraciones de variables, `Typesty` cuenta con un amplio conjunto de palabras reservadas las cuales se definen a continuacion:

   | **Palabra Reservada** | **Funcionalidad**|
   | ----------------- | --------------------------- |
   | `if` | Evalua una expresion y ejecuta el caso `true` o `false` |
   | `else` | Ejecuta la porcion de código correspondiente al caso `false`|
   | `switch` | Toma decisiones multiples para una variable |
   | `case` | Evalua la si se cumple la condicion declarada en el `switch` y de ser verdadero ejecuta la porción de código correspondiente |
   | `default`  | De no cumplirse ninguna condicion, se ejecutará la condición por defecto y a su vez la porción de código correspondiente |
   | `while` | Ejecuta una secuencia de instrucciones mientras la condicion de ejecución se mantenga verdadera |
   | `for` | Ejecuta una N cantidad de veces la secuencia de instrucciones que se encuentra dentro de ella |
   | `do` | Palabra que permite la ejecución de código al menos 1 vez |
   | `break` | Su funcionalidad es cerrar un ciclo inmediatamente, saltando las condiciones dadas a un inicio |
   | `continue` | Detiene la ejecución actual y salta al siguiente paso |
   | `return` | Finaliza la ejecución de un método o función y devuelve el valor indicado |
   | `void` | Palabra utilizada para realizar la declaración de un método |
   | `print` | Permite la impresión de expresiones de tipo `int`, `double`, `boolean`, `string`, `char` |  

  - **Funciones Nativas**:
`Typesty` al igual que otros lenguajes de programación cuenta con sus propias funciones internas entre las cuales se encuentran:

   | **Funcion** | **Aplicación**|
   | ----------------- | --------------------------- |
   | `toLower()` | Recibe como parametro una expresión de tipo `string` y retorna una `string` con todas las letras minúsculas |
   | `toUpper()` | Recibe como parametro una expresión de tipo `string` y retorna una `string` con todas las letras mayúsculas |
   | `length` | Recibe como parámetro un `vector`, una `list` o un `string` y retorna el tamaño de este (`int`)|
   | `truncate()` | Recibe como parametro una expresión de tipo `double` o `int` y retorna un `int` eliminando los decimales de este|
   | `round()` | Recibe como parametro una expresión de tipo `double` o `int` y retorna un `int` con un valor aproximado al original |
   | `typeof()` | Retorna un `string` con el nombre del tipo de dato evaluado |
   | `toString()` | Recibe como parametro una expresión de tipo `int`,`double` o `boolean` y retorna un `string`|
   | `toCharArray()` | Permite convertir un `string` en una `lista` de datos de tipo `char` |

  - **Ejemplo de Programación**:
```java
double r_toRadians;
double r_sine;
void toRadians(double angle) {
    r_toRadians = angle * 3.141592653589793 / 180;
}

void sine(double x) {
    double sin = 0.0;
    int fact;
    int i = 1;
    while (i <= 10) {
        fact = 1;
        int j = 1;
        while (j <= 2 * i - 1) {
            fact = fact * j;
            j = j + 1;
        }
        sin = sin + ((x^(2*i-1)) / fact);
        i = i + 1;
    }
    r_sine = sin;
}

void drawTree(double x1, double y1, double angle, int depth) {
    if (depth != 0) {
        toRadians(angle);
        sine(3.141592653589793 / 2 + r_toRadians);
        double x2 = x1 + (r_sine * depth * 10.0);
        toRadians(angle);
        sine(r_toRadians);
        double y2 = y1 + (r_sine * depth * 10.0);
        Print(x1 + " " + y1 + " " + x2 + " " + y2 + "");
        drawTree(x2, y2, angle - 20, depth - 1);
        drawTree(x2, y2, angle + 20, depth - 1);
    }

}

void Principal() {
    Print("===============¿SI SALE?=================");
    drawTree(250.0, 500.0, -90.0, 4);
    Print("================ FIN ====================");
}

exec Principal();
```
   
<div id='apli'/>

## Aplicación 🔲
### Interfaz Gráfica (GUI)
El programa cuenta con una vista gráfica la cual facilita la interacción entre el sistema y el usuario final para un mejor desempeño del mismo. Por medio de dicha interfaz, al usuario se le permite seleccionar de forma _gráfica_ una archivo de entrada que contendrá el código a analizar. El usuario puede navegar por la aplicación seleccionando a través de botones la acción que desea realizar, si ocurre un error en el ingreso de datos el programa mostrará un listado de los errores cometidos durante la lectura. 

- Ventana Inicial: La _Ventana Inicial_ cuenta con las opciones: *_Analizar_*, *_Generar AST_*, *_Abrir_* y *_Guardar_*.

![](https://github.com/DiiAns23/Prueba-2/blob/Master/Typesty.PNG)
     
El código debe de ser ingresado en el área de escritura posicionada en el lado izquierdo de la aplicación, el usuario generará el código que desea programar para posteriormente analizarlo presionando click sobre el boton `Analizar`, en la parte derecha de la aplicaciónn se mostrarán las salidas corresepondientes a las funciones `print` así como la lista de `errores` cometidos.

<div id='questions'/> 

## Preguntas Frecuentes (FAQ) ❓
**1. ¿Se puede cargar un archivo que sea otro tipo de extensión?** 

> _R//_ *No, el programa admite solo extensiones olc*

**2. ¿Puedo correr el .py desde otro dispositivo?** 

> _R//_ *Sí, solo si tu ordenador debe contar con Node y Angular*

**3. ¿Cuántos archivos puedo ingresar?** 

> _R//_ *El programa no tiene un límite para el ingreso de arcchivos*

**4.¿En donde se almacenan los archivos guardados?** 

> _R//_ *El programa deberá preguntar/indicar el lugar en el cual deseas almacenar tu código*

**5. ¿Por qué no me imprime nada mi código?** 

> _R//_ *Suele suceder porque el código no cuenta con la estructura correspondiente.*

```java
Universidad San Carlos de Guatelama 2021
Programador: Diego Andrés Obín Rosales
Carné: 201903865
```