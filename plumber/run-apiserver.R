library(plumber)
myplumobject <- plumb(paste(getwd(),"api-server.R",sep="/"))
myplumobject$run(port=8500)
