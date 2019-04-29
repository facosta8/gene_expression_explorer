library(XML)
library(purrr)
library(glue)


generarURL <- function(t, nmax) {
    base <- 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?'    
    db <- 'db=gds'
    t <- gsub(' ', '+', t)
    term <- glue('&term={t}+AND+gds[Entry Type]')
    retmax = glue('&retmax={nmax}') # numero de resultados
    return(paste0(base, db, term, retmax))
}

listar_opciones <- function(t, nmax=10) {
    url <- generarURL(t, nmax)
    download.file(url, 'busqueda.xml')
    results <- xmlParse('busqueda.xml')
    ids <- xmlToList(results)$IdList %>% flatten_chr()
    return(ids)
}


sumario <- function(uid) {
    base <- 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?'
    db <- 'db=gds'
    id <- glue('&id={uid}')
    url <- paste0(base, db, id)
    download.file(url, 'q.xml')
    results <- xmlToList(xmlParse('q.xml'))
    titulo <- results$DocSum[4]$Item$text
    descripcion <- results$DocSum[5]$Item$text
    return(c(titulo, descripcion))
}


