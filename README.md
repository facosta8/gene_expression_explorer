![](/resources/logo.png)# Gene Expression Explorer

Una herramienta de R para explorar los patrones de expresión de genes con base en resultados de experimentos de de microarreglos.

## Pendientes

Sugiero fuertemente leer el [tutorial](https://github.com/facosta8/gene_expression_explorer/tree/master/tutorial) antes de ver esto. Fases que quedan por hacer:

### Búsqueda del dataset

Herramienta que le permita al usuario hacer búsquedas en la base de datos de microarreglos [Geo Datasets](https://www.ncbi.nlm.nih.gov/gds) y elegir uno de los resultados.

*Output*: el código único del dataset elegido.

***Encargado:***

*Status*: por hacer.

### Carga de datos

Toma el código del dataset y utiliza la librería `Geoquery` para descargar la matriz de expresión del microarreglo.

*Output*: un objeto matriz de resultados, donde los nombres de columnas son las muestras y los nombres de fila los códigos de los genes.
***Encargado:***

*Status*: Casi concluido.

### Cálculo de distancias

Toma la matriz de expresión y calcula la distancia entre los diferentes elementos (renglones). Sugiero que tenga varios parámetros:

* Comportamiento: puede hacer el cálculo de distancias entre todos los genes o puede usar una implementación minhash para agrupar los vectores en cubetas y calcular sólo la distancia entre los elementos de una misma cubeta.
* Cubetas: permite al usario elegir la sensibilidad del minhash; algo así como "quiero capturar a todos los vectores que tengan una distancia de 70%" o algo así. Esto se logra modificando el tamaño del hash y el número de bandas, claro.
* Tamaño de las cubetas: sólo calcula las distancias de las cubetas que tengan más de `n` elementos.

*Output*: Matrices simétricas de distancias entre los elementos.

***Encargado:***

*Status*: por hacer.

### Creación de red

Toma la matriz de expresión y las matrices distancias y las usas para generar una representación de las diferentes redes. Las uniones son las distancias, claro está, y los nodos son los genes. La matriz de expresión da los valores de expresión de cada gen, que puede representarse en el tamaño o color del nodo. También permite visualizar la importancia de los nodos, usando centralidad, betweenness y demás medidas que vimos en clase. Finalmente (y esto no me queda tan claro), te debe permitir seleccionar un nodo para obtener más información del mismo.

*Output*: representación de la red de expresión.

***Encargado:***

*Status*: por hacer.

### Información del gen

Cuando seleccionas un gen, busca su ID y extrae de la base de datos la información del mismo. Tipo de gen, código genético, en qué parte de los procesos celulares interviene, etc.

*Output*: información del gen seleccionado.

***Encargado:***

*Status*: En proceso.
