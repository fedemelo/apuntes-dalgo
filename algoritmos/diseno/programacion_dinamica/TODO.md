- [ ] En corte_de_vara digo que el número de combinaciones se reduce a la función de partición de enteros, \(\mathrm{e}^\mathrm{\pi}\sqrt{2n/3}/(4n\sqrt{3})\) y que ese es un resultado poco trivial de alcanzar. Debería añadir un apéndice de cómo se llega a eso (al menos la intuición) o una referencia. Mejor la referencia yo creo.

- [ ] knapsack
En Napsack, ponerle el diagrama, digamos, el árbol de recursión, pero el que hice en clase con las maletas, que usa como maletas, cada maleta es como un color y una forma geométrica y va bajando, va quitándose la maleta, como diciendo ya la contemplé, pero y se va restando el peso a la capacidad y sumando el valor. Y ese diagrama es brutal porque además permite explicar la idea de que no importa si es +1 o -1. El i+1, i-1, como que no importa si es prefijo o sufijo, es en la misma idea.

En la implementación bottom-up cambiar las variables como para hacer énfasis en que hay un menos uno, que es de que los valores y los pesos están corridos. Entonces como poner una variable, qué sé yo, como VI y WI, que son el valor corrido y el peso corrido y es así usarlas. Porque el otro menos uno que hay es el de i menos uno, que sí es normal, digamos, que es en la matriz, que no tiene corrimiento. y explicar que todo esto nace de que claro, como en la matriz corrimos una fila para los casos base, entonces todo queda como si fuera uno indexado. Entonces cuando hacemos el ciclo sobre la matriz, que está uno indexada, los valores y pesos cero indexados, pues toca correrlos hacia atrás.

- [ ] Kadane revisarlo completo completo

- [ ] Matrices cadena mirar si incluirlo o no. Imo actual yo no lo incluiria
