library(plumber)
plumbobject <- plumb("plumber/stockfunction.R")
plumbobject$run(port=8000)

