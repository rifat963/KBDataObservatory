library(cronR)
f <- system.file(package = "cronR", "extdata", "helloworld.R")
cmd <- cron_rscript(f)
cmd
cron_add(command = cmd, frequency = 'minutely', id = 'test1', description = 'My process 1', tags = c('lab', 'xyz'))
cron_njobs()

cron_ls()
system.file("extdata", "helloworld.log", package = "cronR")
cron_clear(ask=FALSE)
cron_ls()
