library(SPARQL)
library(jsonlite)


sd<-"library(httr)

library(jsonlite)

#filename,queryText,endpoint
filename= \"test1.csv\"

# 3cixty Sparql endpoint
endpoint<-\"http://kb.3cixty.com/sparql\"
className<-\"dul:Place\"
graph<-\"<http://3cixty.com/nice/places>\" "

save(sd, file = "test.R")


sink("Api/tt.R")
cat("hello")
cat("\n")
cat("world")
sink()

file.remove("Api/tt.R")


