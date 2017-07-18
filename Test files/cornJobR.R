library(cronR)

f <- system.file(package = "cronR", "extdata", "helloworld.R")

f <- system.file(package = "cronR", "extdata", "sparql.R")
cmd <- cron_rscript(f)
cmd
help(cron_add)
cron_add(cmd, frequency = 'minutely', id = 'job1', description = 'Customers')

cron_ls()

help(cron_add)
cron_njobs()
help(cron_clear)

read.csv("/usr/local/lib/R/site-library/cronR/extdata/test.csv")

