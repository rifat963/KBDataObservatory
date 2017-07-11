library(plumber)

# plumbobject <- plumb(paste(getwd(),"Api/runSparql.R",sep = "/"))
# 
# plumbobject <- plumb(paste(getwd(),"Api/createSparqlRfile.R",sep = "/"))

# plumbobject <- plumb(paste(getwd(),"Api/apiServerCall.R",sep = "/"))

plumbobject <- plumb("Api/apiServerCall.R")

plumbobject$run(port=9000)
