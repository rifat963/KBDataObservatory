library(SPARQL)
library(jsonlite)
library(cronR)
library(stringr)

#* @get /readCSV
readCSVfiles<-function(filename){
  st<-read.csv(paste(getwd(),filename,sep="/"),header = T)
  
  toJSON(st)
  # list(p=st$p,freq=st$freq,Release=st$Release,ClassName=st$ClassName,Graph=st$Graph,Count=st$Count)
}


#* @get /createCornJob
createCornJob<-function(filename,freq,time){

  name<-paste(filename,".R",sep = "")
  f <- system.file(package = "cronR", "extdata", name)
  cmd <- cron_rscript(f)
  # cmd
  # cron_add(cmd, frequency = 'daily', id = filename , at = '14:20')
  
  cron_add(cmd, frequency = freq, id = filename, description = 'SaveData')
  list(result="success")
}

#* @get /getAllCornList
getAllCornList<-function(){
  cron_ls()
}


#* @get /deleteAllCorn
deleteAllCorn<-function(){
  cron_clear(ask=FALSE)
}



#* @get /createRfile
createRfile<-function(filename,className,endpoint,graph){
  
  # filename="/Api/yy.R"
  # edp<-"http://kb.3cixty.com/sparql"
  # cln<-"dul:Place"
  # graph<-"<http://3cixty.com/nice/places>"
  
  file<-paste("filename=","\"",filename,".csv\"",sep="")
  end<-paste("endpoint=","\"",endpoint,"\"",sep="")
  class<-paste("className=","\"",className,"\"",sep="")
  grp<-paste("graph=","\"",graph,"\"",sep="")
  
  
  sink(paste("/usr/local/lib/R/site-library/cronR/extdata","/",filename,".R",sep=""))
  cat("library(SPARQL)")
  cat("\n")
  cat("library(jsonlite)")
  cat("\n")
  cat(file)
  cat("\n")
  cat(end)
  cat("\n")
  cat(class)
  cat("\n")
  cat(grp)
  cat("\n")
  # 3cixty Sparql endpoint
  cat("parm<-paste(\"http://178.62.126.59:8500/\",\"runQuery?filename=\",filename,\"&className=\",
      className,\"&endpoint=\",endpoint,\"&graph=\",graph,sep = \"\")")  
  cat("\n")
  cat("r<-GET(parm)")   
  cat("\n")
  cat("rd<-content(r)")
  cat("\n")
  cat("df <- fromJSON(rd[[1]])") 
  cat("\n")
  cat("destfile=paste(\"/usr/local/lib/R/site-library/cronR/extdata/saveData/\",filename,sep = \"\")")
  cat("\n")
  cat("if(file.exists(destfile)){")
  cat("\n")
  cat("ddf<- read.csv(destfile,header = T)")
  cat("\n")
  cat("ddf<- rbind(ddf,df)}else{ddf<-df}")
  cat("\n")
  cat("write.csv(ddf , destfile,row.names = FALSE)")
  cat("\n")
  cat("rm(ddf)")
  cat("\n")
  cat("list(result=\"success\")")
  cat("\n")
  sink()
  
  list(result=filename)
}


sparlQuery_snapsots_summary_properties<-function(endpoint,className,graph){
  
  tryCatch(
    ## This is what I want to do:
    if(is.null(graph)){
      
      query<-"SELECT ?p (COUNT(?p) as ?freq) WHERE { ?s ?p ?o. ?s a"
      query<-paste(query,className,sep = " ")
      query<-paste(query,".}",sep = " ")
      # print(query)
      query_data <- SPARQL(endpoint,query)
      # query results for all the class in a given version
      query_result <- query_data$results
      
      query_result$Release<-Sys.Date()
      query_result$className<-className
      
      query_count<-"SELECT count(*) where { ?s a"
      query_count<-paste(query_count,className,sep = " ")
      query_count<-paste(query_count,".}",sep=" ")
      
      
      query_data_count <- SPARQL(endpoint,query_count)
      # query results for all the class in a given version
      query_result_count <- query_data_count$results
      
      query_result$Count<-query_result_count$callret.0
      
      # print(query_result)
      
      return(query_result)
      
    }else{
      
      query<-"SELECT ?p (COUNT(?p) as ?freq) where { graph"
      query<-paste(query,graph,sep = " ")
      query<-paste(query,"{?s a",sep = " ")
      query<-paste(query,className,sep = " ")
      query<-paste(query,"} ?s ?p ?o . }")
      
      query_data <- SPARQL(endpoint,query)
      # query results for all the class in a given version
      query_result <- query_data$results
      
      query_result$Release<- Sys.Date()
      query_result$ClassName<-className
      query_result$Graph<-graph
      
      query_count<-"SELECT count(*)  where{ graph "
      query_count<-paste(query_count,graph,sep = " ")
      query_count<-paste(query_count,"{ ?s a",sep = " ")
      query_count<-paste(query_count,className,sep = " ")
      query_count<-paste(query_count,".}}",sep = " ")
      
      query_data_count <- SPARQL(endpoint,query_count)
      # query results for all the class in a given version
      query_result_count <- query_data_count$results
      
      query_result$Count<-query_result_count$callret.0
      # query_result$Count<-239892
      # print(query_result)
      
      return(query_result)
    }
    
    ,
    ## But if an error occurs, do the following: 
    error=function(error_message) {
      message("Connection Error.")
      # message("Here is the actual R error message:")
      message(error_message)
      return(NA)
    }
  )
}

# Api function for run sparql query
#* @get /runQuery
runQuery <- function(filename,className,endpoint,graph){
  
  df<-sparlQuery_snapsots_summary_properties(endpoint,className,graph)
  
  toJSON(df)

}