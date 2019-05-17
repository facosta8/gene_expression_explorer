## Inicio. Cargo mis librerias y la matriz
library(dplyr)
library(purrr)
library(tidyr)
setwd("C:/Users/facosta8/giteando/gene_expression_explorer/ejemplo")
m1 <- read.csv('matriz_ejemplo.csv')
# quito las columnas con valores NA. Son pocas, pero igual debemos 
# decidir si queremos quitarlas o cambiar los NA por 0.
m1 <- drop_na(m1)
m <- as.matrix(m1[,-1])
rownames(m) <- m1[,1]
mm <- head(m, 20)


##########################################
## Funciones

# calculo distancia euclidiana
dist_eu <- function(x, y) {
    sqrt(sum((x - y)^2))
}

# Función para crear un vector unitario de longitud n
crear_vector <- function(n) {
    x <- runif(n, 0, 1)
    x / sqrt(sum(x^2))
}

# función para crear una función hash con un vector aleatorio y 
# determinar en qué segmento cae el hash.
crear_hash <- function(n, d) {
    v <- crear_vector(n)
    f <- function(x) {
        as.integer(round((v %*% x)/d, 0))
    }
    f
}

# función para, ya tiendo un vectorsote, lo dividas en las cubetas
# que quieres. Para distinguirlas, antepone una letra; lo cual significa
# que tendremos que modificarla si queremos más de 26 cubetas
crear_cubetas <- function(vector, n_cubetas) {
    ifelse(length(vector)%%n_cubetas == 0, 
           t <- length(vector)/n_cubetas,
           stop())
    cubetas <- split(vector, ceiling(seq_along(vector)/t)) %>% 
        lapply(paste0, collapse = '-') %>% 
        flatten_chr()
    paste0(letters[1:n_cubetas], '||', cubetas)
}

# le das dos nombres de genes y los busca en el documento con 
# candidatos. Si están, cuenta en cuántas cubetas aparecen
# juntos
buscar_cubetas <- function(v1,v2, dd) {
    conteo = 0
    for (i in 1:nrow(dd)) {
        exito <- 
            v1 %in% dd$candidatos[[i]] &
            v2 %in% dd$candidatos[[i]]
        conteo = conteo + as.integer(exito)
    }
    conteo
}

#######################################
### Aplicacion

# si quieren hacer una prueba chica, pueden hacer un muestreo
#mm <- head(m, 2000)
mm <- m

t <- 125  # numero de funciones hash
# tamaño de cada segmento en mi hiperplano. Determina las distancias
# en mi familia
delta <- 6 # tamaño del segmento en la recta unitaria
b <- 25   # numero de bandas
v <- ncol(mm)  # tamaño de cada vector
r <- t/b  # elementos por bandas

# definición de la familia
glue::glue(
    'Con esta familia, si tenemos una distancia menor
    o igual a {delta/2}, la probabilidad de que las
    secuencias tengan el mismo hash es {1-(1-(0.5^r))^b}.
    Si la distancia es mayor a a {delta*2}, la probabilidad de
    que tengan el  mismo hash es menor a {1-(1-((1/3)^r))^b}'
)

# creamos la lista con todas las funciones hash
lista <- replicate(t, crear_hash(v, delta))

# la aplicamos a todos los elementos
c <- sapply(lista, function(x) apply(mm, MARGIN=1, x))
# creamos las cubetas
cc <- t(apply(c, MARGIN=1, crear_cubetas, n_cubetas=b))
# agrupamos por cubetas
d <- as_tibble(cc, rownames='gen') %>% 
    gather('v', 'cubeta', -gen) %>% 
    select(-v) %>% 
    group_by(cubeta) %>% 
    summarise(n_elementos = n(),
              candidatos = list(gen)) %>% 
    arrange(desc(n_elementos)) 

# eliminamos las cubetas de un elemento
dd <- filter(d, n_elementos > 1)


#######################################
#### COMPROBACION

# Calculamos todas las combinaciones
df <- gtools::combinations(n = nrow(mm),
                           r = 2,
                           v = rownames(mm),
                           repeats.allowed = FALSE)
df <- as_tibble(df)
colnames(df) <- c('vector1', 'vector2')

# para cada combinación, calculamos su distancia real y vemos
# si se encuentra en una o más cubetas
df <- df %>% 
    rowwise() %>% 
    mutate(distancia = dist_eu(mm[vector1,], mm[vector2,]),
           cubetas = buscar_cubetas(vector1, vector2, dd)) 

# histograma comparatorio
ggplot(df, aes(distancia)) +
    geom_histogram(data = filter(df, cubetas == 0),
                   fill = 'red', bins = 50, alpha=0.4) +
    geom_histogram(data = filter(df, cubetas >= 1),
                   fill = 'blue', bins=50, alpha=0.4)




