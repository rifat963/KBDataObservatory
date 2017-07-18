library(plumber)
library(cronR)
# The list of values, start with the number 15
values <- 15

# The maximum number of values to store in our list
MAX_VALS <- 50

#* @get /cornList
cornList <- function(){
  cron_ls()
}

#* @post /sum
function(s){
  #a<-s+5
  list(result=s)
}

#* @post /append
function(val, res){
  v <- as.numeric(val)
  if (is.na(v)){
    res$status <- 400
    res$body <- "val parameter must be a number"
    return(res)
  }
  values <<- c(values, val)
  
  if (length(values) > MAX_VALS){
    values <<- tail(values, n=MAX_VALS)
  }
  
  list(result="success")
}

