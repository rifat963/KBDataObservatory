library(plumber)

plumbobject <- plumb(paste(getwd(),"postTest.R",sep = "/"))
plumbobject$run(port=8500)
