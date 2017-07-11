library(plumber)

plumbobject <- plumb(paste(getwd(),"postTest.R",sep = "/"))
plumbobject$run(port=9500)
