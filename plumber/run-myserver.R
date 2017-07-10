library(plumber)
myplumobject <- plumb('plumber/myserver.R')
myplumobject$run(port=8000)
