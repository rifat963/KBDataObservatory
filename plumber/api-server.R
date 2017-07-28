library(plumber)

plumbobject <- plumb(paste(getwd(),"apiServerCall.R",sep = "/"))

plumbobject$run(port=9500)
