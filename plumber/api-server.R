library(plumber)

# plumbobject <- plumb(paste(getwd(),"Api/runSparql.R",sep = "/"))
# 
# plumbobject <- plumb(paste(getwd(),"Api/createSparqlRfile.R",sep = "/"))

 plumbobject <- plumb(paste(getwd(),"apiServerCall.R",sep = "/"))

#plumbobject <- plumb("plumber/apiServerCall.R")

plumbobject$run(port=8500)
