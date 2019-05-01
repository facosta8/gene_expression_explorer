# Intentos de Clustering no supervisado para entender relaciones de genes

El objetivo de esta aproximación es encontrar un método de clustering no supervisado que sea optimo computacionalmente, potencialmente paralelizable y que arroje resultados confiables.

Revisando la documentación de scikit-learn encontramos una comparación de algoritmos de clustering, de los cuáles se seleccionarán algunos métodos para probarlos.

![Alt text](images/sklearn_clustering.png?raw=true "A comparison of the clustering algorithms in scikit-learn")


## Basados en Distancia 

### Birch (Balanced Iterative Reducing and Clustering Using Hierarchies)

Las primeras aproximaciones de clustering sugeridas en el equipo fueron las basadas en distancia euclidiana entre los vectores que representan a un gen en distintas muestras, por esa razón decido experimentar con este método. Algunas bondades del método son: **Escalabilidad:** se puede utilizar para grandes números de clusters y de muestras, **Casos de uso:** Grandes conjuntos de datos, reducción de información y eliminación de outliers.



#### Hiperparámetros

