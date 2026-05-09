# Correctitud

## Notación de predicados

**Cuantificador**: Permite definir funciones sobre conjuntos de elementos.

**Predicado**: Función cuyo rango es booleano ($\{0, 1\}$).

### Notación general:

$\square  𝑥 \colon 𝑇 | 𝑄 ∶ 𝑅$ 

$\square$: Cuantificador u operador generalizado, $\forall \ \exists \ \sum \ \prod$.

$x$: Variable de cuantificación.

$T$ : Tipo de la variable $x$. Tácito si es entendible. Cualquier conjunto puede tomarse como un tipo de variable! $\mathbb{N}$ en este contexto se denota `nat`. Y así, `real`, `int`, etc.
𝑄 : rango de valores que puede tomar $x$, expresión booleana
𝑅 : expresión sobre el operación $\square$.

Ejemplos:

$(\sum i \colon \verb|nat| \ | \ 0 \leq 2i < 4 \colon 8i)$

Sumar todos los 8i tales que 2i es mayor o igual a 0 y menor a 4. = 8*0 + 8*1 = 8

$(\forall i\colon \verb|nat| \ | \ 0 \leq i <2\colon id \neq 6)$, lo que traduce a $(0d\neq 6) \land (1d\neq 6)$

## Especificación: entradas y salidas

Tengo que especificar formalmente el problema para poder verificar una solución algorítmica para el mismo.

Para definir las instrucciones de un algoritmo formalmente se hace uso del lenguaje GCL

**Precondición**: Lo que se presupone de la entrada. Denotada por $Q$.

Especificaciones de los datos de entrada.

**Postcondición**: Lo que se espera resolver. Denotada por $R$. La postcondición me permite chequear si el resultado es correcto! No me importa cómo legué a la solución.

La precondición es un conjunto de la forma $\{Q\colon \verb|<bool>|\}$ y la postcondición es un conjunto de la forma  $\{R\colon \verb|<bool>|\}$. El término $\verb|<bool>|$ debe ser un booleano, `true` o `false`, o condiciones que evalúen a un booleano, e.g. $(N = M) \land (\forall x | x \in b \colon x \in a)$. 

Si no hay precondiciones se escribe $\{Q\colon \verb|true|\}$.

- Ejemplos especificación
    #TODO(agosto 2022): Falta corregir estos ejemplos!
    #TODO (mayo 2026): Omití correctitud en esta revisión
    
    **Especificación**: Determinar si un número es primo.
    
    **Tipo de dato:** Naturales. $n \in \mathbb{N}$.
    
    **Precondición:** Ninguna (el tipo de dato no es precondición). $Q\colon n$ .
    
    **Postcondición:**  $\{R\colon b = (\forall k | 2 \leq k < n\colon A \mod k > 0)\}$.
    
    **Especificación**. Dado un número primo, hallar el siguiente primo.
    
    Tipo de dato: $n \in \mathbb{N}$
    
    Precondición: $Q\colon (\forall k | 2 \leq k < n\colon n \mod k > 0)$
    
    Postcondición: $R\colon (p > n) \land  (\forall k | n < k < p\colon p \mod k > 0)$ $\land (\forall i \forall j | n < i < j \land j < k \colon j \mod i >0)$}
    
    Solución más fácil: defino un predicado $serPrimo$ y lo uso!! Como una función de código.
    
    **Especificación**: Hallar menor elemento de arreglo de enteros.
    
    Tipo de dato: Arreglo de enteros
    
    **Precondición**: Arreglo no está vacío.
    
    **Postcondición**: **Que esté en el arreglo** y que sea menor que cualquier número en el arreglo.
    
    $R\colon (\exists x \in Arreglo | x = m) \land (\forall x \in Arreglo \colon m \leq x)$.
    
    Ojo: Siempre que tengo una **estructura estática** (arreglos, matrices, conjuntos) como un arreglo debo especificar su **tamaño**. Por ejemplo, si el arreglo lo denoto $L$, escribo $L[0, N)$. Se Inicia en 0 y N no se incluye para que tenga $N$ elementos. Únicamente en estructuras **dinámicas no lo especifico** (pilas, colas, listas abstractas, arreglos dinámicos, grafos).
    
    Postcondiciones corregidas: $R\colon (\exists x \in \mathbb{Z} |x \in L \colon x = m) \land (\forall y\in L| m \leq y)$.
    
    Especificación: Dado arreglo, ordenarlo ascendentemente.
    
    Entrada: $a[0, N)$. Tipo: Array of int.
    
    Salida: $b[0, N)$. Tipo: Array of int.
    
    Precondición: Q: True
    
    Postcondición: b es una permutación de a (tiene los mismos elementos y en la misma cantidad/frecuencia cada uno!!) y b está ordenado.
    
    $b = permutacion(a)$ (ese predicado toca definirlo en la tarea)
    
    $\forall k | 0 < k < N\colon b[k-1]\leq b[k]$. 
    
    >💡 **Nótese** que como comparo con el anterior, no miro $0 \leq$  sino $<0$. Nótese también que no se llega hasta $N$ porque como el arreglo empieza desde 0 la última posición es $N-1$.
    
    
    <aside>
    💡 Esto es usual, todas las estructuras de datos se inicializan en 0, salvo grafos.
    
    </aside>
    

## Verificación: GCL y Hoare

Para verificar un algoritmo:

1. GCL (*Guarded Command Language*) para escribir las instrucciones de un algoritmo formalmente.
2. Cálculo de Hoare para demostrar matemáticamente que el algoritmo es correcto.

### GCL

*Guarded Command Language*

Lenguaje de pseudocódigo. Escrito por Dijkstra.

**Teorema del programa estructurado:** Toda función computable, que pueda ser calculada a través de un lenguaje de programación, se puede escribir implementando únicamente el siguiente tipo de instrucciones:

- Secuencia: $S_1, S_2,\ldots$
- Selección: `if`-`else`
- Iteración: `while`

Ese teorema cimenta GCL. También ese teorema hace que los lenguajes con `goto` y ese tipo de cosas no sean más poderosos que los estructurados.

#### Instrucciones básicas

- No hacer nada: `skip`.
- Terminar el programa de manera anormal, con error o excepción: `abort`.
- Para escribir asignaciones se usa el operador `:=`, e.g. `x := 567`.Se puede hacer asignación paralela: `x, y := <expresión 1>, <expresión 2>`. En ese caso la asignación es completamente al tiempo! (eso en la vida real no se puede pero ajá)
- Se hace secuenciación con punto y coma: `<instrucción 1>;<instrucción 2>;...`. El punto y coma va entre instrucciones, no se pone tras la última.

#### Variables

Para definir variables: Palabra reservada `var`, nombre de la variable, dos puntos y tipo de dato.

`var x: int`.

En GCL cualquier conjunto es un tipo de dato válido (e.g. $\mathbb{N}$, pero se escribe `nat`). Hay que tratar de aproximarse a los tipos de datos de lenguajes de programación conocidos.

Se debe especificar el tamaño de las estructuras de datos estáticas. En las bidimensionales se debe hacer explícito el tamaño de cada dimensión.

```GCL
var x, y, z: int
var i, j: nat
var arrayJava: array[0, N) of char
var matrixPython: array[0, M)x[0, N) of bool
```

String es `array[0, n) of char` o `list of char`.

Para devolver varias cosas usar similar a tuplas, `ret <x, y> pair of int`

#### Funciones

Como las funciones matemáticas, solo se devuelve un tipo de dato. Se pueden devolver dos cosas pero solo de un solo tipo (como en Java).

Las signaturas son muy similares a Python:

`fun <nombre función> (<param1>: <tipo param1>, <param 2>: <tipo param 2>):ret <nombre_retorno>: <tipo retorno>, <nombre_retorno>: <tipo retorno>`

Solo cambia la palabra clave `def` por `fun` y el operador de retorno de `->` a `:`.

Ejemplo de función:

```GCL
fun multiplicar (a: nat, b: nat): nat
	var r, s: nat
	if b = 0 -> r := 0
	[] b > 0 ∧ b mod 2 = 0 -> s := 2*multiplicar(a, b/2); r := 2*s
	[] b mod 2 = 1 -> r := multiplicar(a, b-1)+a
	fi
ret r
```

#### Ciclos

Los ciclos en GCL cuentan con un conjunto de guardas, que son condiciones booleanas.

Cada vez que se ejecuta el ciclo, se revisa si al menos una de las guardas son verdaderas. 

- Si una o más guardas son verdaderas, se selecciona **aleatoriamente** una de las guardas que son verdaderas y se corre el subprograma al que está asociada.
- Si ninguna guarda es verdadera, el ciclo no corre y se detiene el ciclo.

Si se quiere que un ciclo sea determinístico en GCL, es necesario que las guardas sean disyuntas siempre: que una sola sea verdadera a la vez.  Nótese que el subprograma de una guarda puede cambiar el valor de verdad de esa u otras guardas.

```erlang
do B1 -> S1
[] B2 -> S2
...
[] Bn -> Bn
od
```

#### Condicionales

Los condicionales en GCL se asemejan a los ciclos, con la diferencia de que sólo revisan el conjunto de guardas (condiciones booleanas) una vez.

- Si una o más guardas son verdaderas, se selecciona **aleatoriamente** una de las guardas que son verdaderas y se corre el subprograma al que está asociada.
- Si ninguna guarda es verdadera, no se ejecuta el condicional.

Similar a antes, si se quiere que el condicional sea determinístico basta con que solo una guarda sea verdadera.  

```erlang
if B1 -> S1
[] B2 -> S2
...
[] Bn -> Sn
fi
```

#### Ejemplos

![](gcl_if.png)

![](gcl_do.png)

![](complejidad_gcl.png)

### Cálculo de Hoare

#### Triplas de Hoare

Las Triplas de Hoare describen un algoritmo. Son predicado $\{Q\} S \{R\}$ donde $S$ es el programa, e conjunto $\{Q\}$ la precondición y el $\{R\}$ la postcondición. 

Se quiere que la tripla $\{Q\}S\{R\}$ sea verdadera si y solamente si el programa $S$ es correcto respecto a las precondiciones y postcondiciones, o sea a ls especificación $Q$, $R$.

Ejemplo:

$\{2x > 10\}x\colon=x+1\{x\geq 1\}$ 

donde la precondición es $Q\colon 2x>10$, el programa es $S\colon x\colon=x+1$ y la postcondición es $R\colon x \geq 1$Esa tripla de Hoare tiene como valor de verdad `true`.

### Axiomas básicos

#### **Axioma de sustitución en predicados**

Se puede sustituir una variable en un predicado. Esto *puede cambiar su valor de verdad.*

La notación 

$$
P[x := E]
$$

denota que en el predicado $P$, la variable $x$ se define como la expresión $E$. Es decir, representa el predicado que resulta de sustituir en $P$ todas las apariciones de la variable $x$ por la expresión $E$. 

E.g., $(x > 0)[x := y+z]\ \equiv \ (y+z > 0)$.

#### Axioma skip

Si el programa no hace nada, entonces para que sea correcto, la precondición $\{Q\}$tiene que implicar sin más la postcondición  $\{R\}$:

$\{Q\}$`skip`$\{R\}$ $\equiv$ $Q \implies R$.

El `skip` se reemplaza por un implica, $\implies$.

Ya con esto se pueden hacer demostaciones primitivas:

$$
\{Q\colon x>1\} \ \verb|skip| \ \{R\colon x>0\} \\ \equiv \text{<Ax. skip> } x>1\implies x>0 \\ \equiv \text{<Orden lineal naturales> } \verb|true| 
$$

#### Axioma abort

Si el programa solo aborta, o sea genera una excepción en cualquier caso, entonces cualquier precondición debe implicar `false`.

$\{Q\}$`abort`$\{R\}$ $\equiv$ $Q \implies$ `false`.

Para demostrar que algoritmo es correcto con cálculo de Hoare:

1. Se obtiene la WP (*Weakest Precondition*), la precondición menos restrictiva con la que funcionaría el programa.
2. Se prueba que la precondición del programa implica la WP (que es menos restrictiva que la WP, entonces el programa funcionará).

Ojo: Si no está seguro que el programa es correcto (no le dicen demuestre sino determine), vale la pena tratar de buscar un contraejemplo. Con uno que cumple $Q$ basta, prueba que el programa no es correcto y se ahorra la demostración. 

El paso 2 usualmente es fácil y funciona por el axioma de corrección:

#### Axioma de corrección

Que un programa esté **correcto** significa que si la tupla de Hoare es verdadera, entonces la precondición de la tupla implica la precondición más débil posible para ese programa y esa postcondición. Eso lleva a la definición formal de corrección mediante el axioma de corrección:

$$
\{Q\}S\{R\} \equiv Q \implies wp(S|R)
$$

El axioma indica que para saber si un programa es correcto, se verifica si la precondición implica la precondición más débil. Se intenta demostrar matemáticamente. Si la demostración falla, el programa es incorrecto. 

Si $Q = wp(S|R)$, la demostración de la corrección del programa es trivial.

El paso 1 no es tan. Voy de abajo hacia arriba sacando $wp(S|R)$. Cada wp es mi nuevo R.

### WP: Precondición más débil

#### Definición

**WP (*Weakest precondition*, precondiciónn más débil):** La precondición menos restrictiva a las entradas que igual hace que se cumpla la postcondición. 

Las mínimas condiciones que necesito que cumplan lo que entre para que la tupla sea verdadera.

Dada una tripla $\{Q\}S\{R\}$, la precondición más débil para que el programa $S$ satisfaga la postcondición $R$ se denota por

$$
wp(S|R)
$$

La notación se puede entender como WP de $S$ tal que $R$ (es verdadero). Por ende, la definición formal de la precondición más débil está dada por $Q = wp(S|R)$ en la tripla de Hoare:

$$
\{wp(S|R)\}S\{R\}
$$

#### Axioma de asignación

**Axioma de asignación:** Dado un programa que consiste de una asignación (o sea, $S = (x :=E)$ donde $E$ es una expresión) y de una postcondición $R$ . Su WP es equivalente a realizar la sustitución directamente en la postcondición. 

$$
wp(x\colon = E|R)\equiv R[x\colon = E].
$$

Se enunció con la notación introducida en el axioma de sustitución de predicados. 

O sea, para hallar la precondición más débil para solo una instrucción, se reemplaza la instrucción en la postcondición y listo.

El axioma es fácil si se analiza. Dice que la WP (la precondición más débil, la mínima entrada tal que el programa la procesa y retorna algo que satisface la postcondición) se puede obtener partiendo de la postcondición y aplicandole el programa.

#### WP para secuencia de instrucciones

**Axioma de secuencia:** Dada una tripla de Hoare $\{Q\}S_1;S_2\{R\}$, su precondición más débil está dada por

$$
wp(S_1;S_2|R) \equiv wp(S_1|wp(S_2|R))
$$

Con eso se reduce el problema a encontrar la wp de un programa con una asignación, lo cual ya se sabe hacer. 

Generalizando el axioma para una secuencia de $n$ pasos:

$$
wp(S_1;S_2;\cdots;S_n|R) \equiv wp(S_1|wp(S_2|wp(S_i|\cdots wp(S_n|R))))
$$

Si cada una de las instrucciones es una asignación, $S_1 = (x:=E_1), S_2 = (y := E_2)$, se expresa el axioma como

$$
wp(x:=E_1, y:=E_2|R) \equiv R[y:=E_2][x:=E_1]
$$

Es decir, se hacen las ***sustituciones desde la última hasta la primera*** sustituyendo primero la última instrucción y finalmente la primera.

#### WP para condicionales

Se verifica que *alguna* de las guardas sea cierta y que *todos los subprogramas* son programas correctos.

Eso último es que para todos los subprogramas, su precondición (guarda) implica la precondición más débil de su subprograma y la postcondición. Para dos guardas $B_1$ y $B_2$ con subprogramas $S_1$ y $S_2$:

$$
wp(S|R) \equiv (B_1 \lor B_2) \land [(B_1 \implies wp(S_1|R)) \land (B_2 \implies wp(S_1|R))]
$$

En la práctica, solo se verifican los subprogramas de las guardas verdaderas o con valor de verdad aún desconocido, no las falsas: por un lado las falsas ni corren; por otro, para las falsas se usa Thm. Antecedente Falso y la implicación da verdadera.

Formalmente:

**Axioma del `if`:** Sea $\{Q\}S\{R\}$ un programa donde $S$ es una instrucción condicional con $n$ guardas $B_1\ldots B_n$, cada una con su respectivo subprograma $S_1\ldots S_n$. La precondición más débil de dicho programa está dada por 

$$
wp(S|R) \equiv (B_1 \lor B_2 \lor \cdots \lor B_n) \ \land \ (\forall i\ | \ 1\leq i \leq n \colon \{B_i\}S_i\{R\})
$$

La primera expresión en paréntesis antes de la conjunción dice que al menos una de las guardas debe ser cierta. Si ninguna se cumple, wp = `false` (el programa no es correcto???). La segunda dice que se debe cumplir la tripla de Hoare para cada guarda (que actúa como precondición) y cada subprograma. Aplicando el axioma de corrección, se reescribe como

$$
wp(S|R) \equiv (B_1 \lor B_2 \lor \cdots \lor B_n) \ \land \ (\forall i\ | \ 1\leq i \leq n \colon B_i\implies wp(S_i|R))
$$

Donde cada guarda debe implicar la wp de su subprograma y la postcondición. Si la guarda es falsa,  ya lo implica (la implicación es verdadera por Thm. Antecedente Falso).

#### Axiomas útiles para WP

##### Milagro excluido
    
    $$
    wp(S|\verb|false|)\equiv \verb|false|
    $$
    
Si la postcondición es falsa, el programa debe fallar sin importar qué, entonces se necesita que siempre entre `false`. 
    
##### Múltiples postcondiciones

$$
wp(S | R_1 \land R_2) \equiv wp(S|R_1) \land wp(S|R_2)
$$

Si necesita satisfacer múltiples postcondiciones, halle la precondición más débil que satisfaga cada uno y para su wp requiera todas al tiempo.

Más formal, para $n$ postcondiciones:

$$
wp(S|\forall i|1\leq i\leq n:R_i) \equiv (\forall i|1\leq i\leq n:wp(S|R_i))
$$

##### Axioma skip con wp
$$wp(\verb|skip| | R) \equiv R$$

Si el programa no hace nada, lo mínimo que necesito para obtener $R$ es que entre $R$.

##### Axioma abort con wp
$$
    wp(\verb|abort| | R) \equiv \verb|false|
    $$

Si el programa fijo va a generar una excepción, la precondición es falsa: el programa no es correcto. 


#### WP para ciclos

Se agrega un predicado denominado **invariante**, denotado por $P$. El invariante debe ser siempre cierto siempre durante la ejecución del ciclo (no solo antes para entrar, *durante*) y debe involucrar todas las variables que están asociadas al ciclo, operándolas entre sí. 

Diseñar el invariante es complejo. Los programas se ven de esta forma:

$$
\{Q\}\\ \text{Inicialización} \\ \{P\} \\ do \\ \vdots \\ od \\ \{R\}
$$

La inicialización hace que el invariante sea cierto antes del ciclo.

Se debe demostrar secuencialmente:

1. $\{Q\} INIC\{P\}$. 
2. $(P \land \neg BC) \implies R$.
3. $\forall i | 1\leq i \leq n\colon \{P \land B_i\}S_i\{P\}$.
4. $(P \land BC) \implies t>0$.
5. $\forall i | 1\leq i \leq n\colon \{P \land B_i \land t = C\}S_i\{t < C\}$

##### Explicación
1. La precondición, las pasos de iniciación y el invariante como postcondición forman un programa correcto. Esto garantiza que el invariante es válido antes de entrar a iterar:
	
	$$
	\{Q\}INIC\{P\}
	$$
	
	Eso se puede escribir por el axioma de corrección como
	
	$$
	Q \implies wp(INIC|P)
	$$
	
2. Cuando el ciclo termina (ninguna guarda es cierta) el invariante (que ya no cambia más) sirve para probar la postcondición:
	
	$$
	(P \land \neg BC) \implies R
	$$
	
	Donde $BC$ es cierto cuando alguna guarda es cierta, $BC = (B_1 \lor B_2\lor \cdots \lor B_n)$.
	
3. Después de un ciclo, se llega a un estado que nuevamente satisface $P$.
	
	$$
	(\forall i \ | \ 1\leq i\leq n : \{P\land B_i\}S_i\{P\})
	$$
	
	Para todas las guardas, el invariante y cada guarda forman un programa correcto con su subprograma y el invarante como postcondición.
	
4. El ciclo termina. Para ello se define una cota: Un número natural $t$ que disminuye (no necesariamente en unidad) con cada ejecución del ciclo, deseable que en la última ejecución del ciclo sea igual a 0. Está definido en términos de las variables de las guardas. 
	
	Se mira que la cota es válida, que mientras alguna guarda es cierta (el ciclo corre) la cota es positiva,
	
	$$
	(P \land BC) \implies t>0
	$$
	
	Se mira que el ciclo terminará eventualmente, que cada vez que hace una iteración, la cota disminuye:
	
	$$
	(\forall i | 1\leq i \leq n : \{P\land B_i\land t=C\} S_i \{t<C\})
	$$
	


#### Problema horarios: Principio de optimización de agendamiento

Un montón de trabajos. Todos pagan igual.

Quiero tomar la mayor cantidad de trabajos en un día.

Problema genérico: Buscar conjuntos en una línea de tiempo que no se sobrelapen.

Soluciones **erróneas**:

- Acepto primer trabajo $j$ de $I$ que no se superpone a ningún trabajo aceptado previamente. Repetir hasta que no queden más trabajos.
- Tome el trabajo más corto posible. Borro todos los que se cruzan. Repito. Para pasar el menor tiempo trabajando y tener la mayor disponibilidad.

Soluciones correctas:

- Algoritmo exhaustivo. Todas las posibles combinaciones y busco la mejor.
- **Programación óptima:** Siempre acepte el trabajo con horario de finalización más temprana (que no se cruce con las ya aceptados).