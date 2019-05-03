library(XML)
library(purrr)
library(glue)
library(GEOquery)


mensaje_error <- function(nombre) {
    print('Hubo un error inesperado. Ver informaci�n pertinente abajo.')
    print(nombre)
}


generar_url <- function(t, nmax) {
    base <-
        'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?'
    db <- 'db=gds'
    t <- gsub(' ', '+', t)
    term <- glue('&term={t}+AND+gds[Entry Type]')
    retmax = glue('&retmax={nmax}') # numero de resultados
    paste0(base, db, term, retmax)
}

listar_opciones <- function(t, nmax = 10) {
    url <- generar_url(t, nmax)
    download.file(url, 'busqueda.xml', quiet = TRUE)
    results <- xmlParse('busqueda.xml')
    ids <- xmlToList(results)$IdList %>% flatten_chr()
    ids
}

ver_sumario <- function(uid) {
    base <-
        'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?'
    db <- 'db=gds'
    id <- glue('&id={uid}')
    url <- paste0(base, db, id)
    download.file(url, 'q.xml', quiet = TRUE)
    results <- xmlToList(xmlParse('q.xml'))
    titulo <- results$DocSum[4]$Item$text
    descripcion <- results$DocSum[5]$Item$text
    c(titulo, descripcion)
}

leer_opciones <- function(uids) {
    df <- data.frame(id = rep(' ', length(uids)),
                     title = rep(' ', length(uids)), 
                     desc = rep(' ', length(uids)),
                     stringsAsFactors = FALSE)
    for (i in seq(uids)) {
        b <- ver_sumario(uids[i])
        df$id[i] <- uids[i]
        df$title[i] <- b[1]
        df$desc[i] <- b[2]
        Sys.sleep(0.5)
    }
    df
}

# plataforma <- Meta(gds)$platform

db_genes <- function(plataforma, matriz) {
    glp <- getGEO(plataforma, destdir=".")
    # sacamos los nombres de los genes de la matriz de expresion original
    genes <- rownames(matriz)
    gen_db <- Table(glp)[Table(glp)$ID %in% genes,]
    gen_db
}


info_gen <- function(id, db) {
    g <- db[db$ID == id, ]
    secuencia <- g$SEQUENCE
    nombre <- g$Definition
    componente <- g$Ontology_Component
    proceso <- g$Ontology_Process
    funcion <- g$Ontology_Function
    # texto <- paste(
    #     'MOLECULAR FUNCTION',
    #     funcion, 
    #     'CELLULAR COMPONENT',
    #     componente,
    #     'BIOLOGICAL PROCESS\n',
    #     proceso,
    #     collapse = '\n'
    # )
    list(nombre, secuencia, funcion, componente, proceso)
}










