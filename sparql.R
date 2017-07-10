library(SPARQL) # SPARQL querying package
library(ggplot2)
library(plumber)

# DBpedia Sparql endpoint
# endpoint <- "https://dbpedia.org/sparql"


# 3cixty Sparql endpoint
endpoint<-"http://kb.3cixty.com/sparql"

# # create query statement
# query <-
#   "select ?s  ?o where { 
# ?s  <http://dbpedia.org/ontology/lccnId> ?o .
# ?s a <http://xmlns.com/foaf/0.1/Person> .
# } order by asc (?s) LIMIT 15"

#* @get /queryResult 
queryResult <- function(){

query <-" select * 
  where {
  graph<http://3cixty.com/nice/places> {?s a dul:Place}
  ?s ?p ?o.
}LIMIT 2"

qd <- SPARQL(endpoint,query)

# Extracted data
df <- qd$results
date<-Sys.Date()
date<-as.character(date)
# name<-paste(date,".RData")

name<-paste(date,".csv")
#Finally we save the Rdata using as name the date from the download
write.csv(qd,file =paste("/usr/local/lib/R/site-library/cronR/extdata",name,sep = "/") ,row.names = F)
# save(qd, file =name)

  # return(mytext) 
} 




