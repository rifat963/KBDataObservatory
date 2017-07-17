library(SPARQL)
library(jsonlite)
library(cronR)

#* @get /createCornJob
createCornJob<-function(filename){
  
  f <- system.file(package = "cronR", "extdata", "sparql.R")
  cmd <- cron_rscript(f)
  # cmd
  cron_add(cmd, frequency = 'minutely', id = 'job1', description = 'SaveData')
  list(result="success")
}


sparqlCornJob<-function(filename,className,endpoint,graph){
  
  df<-sparlQuery_snapsots_summary_properties(endpoint,className,graph)
  
  destfile=paste(getwd(),filename,sep = "/")
  
  
  if(file.exists(destfile))
  {
    
    ddf<- read.csv(destfile,header = T)
    
    ddf<- rbind(ddf,df)
    
    
  }else{
    
    ddf<-df
    # write.csv(ddf , file = destfile ,row.names = T)
  }
  # write.csv(dbp_min_card,"C:/Users/rifat/Desktop/R_milan/KB_Integrity_Constraints/dbp-min-card.csv",row.names =   FALSE)
  
  write.csv(ddf , destfile,row.names = FALSE)
  rm(ddf)
  
}



#* @get /readCSV
readCSVfiles<-function(filename){
  st<-read.csv(paste(getwd(),filename,sep="/"),header = T)
  
  toJSON(st)
  # list(p=st$p,freq=st$freq,Release=st$Release,ClassName=st$ClassName,Graph=st$Graph,Count=st$Count)
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
  
  # filename= "test1.csv"
  # 
  # # 3cixty Sparql endpoint
  # endpoint<-"http://kb.3cixty.com/sparql"
  # className<-"dul:Place"
  # graph<-"<http://3cixty.com/nice/places>"
  
  df<-sparlQuery_snapsots_summary_properties(endpoint,className,graph)
  
  toJSON(df)
  # qd <- SPARQL(endpoint,queryText)
  # # Extracted data
  # df <- qd$results
 # filename="test.csv"
  # destfile=paste(getwd(),"Api",sep = "/")
  
  # filename="Api/test1.csv"
  # destfile=paste(getwd(),filename,sep = "/")
  # 
  # 
  # if(file.exists(destfile))
  # {
  # 
  #   ddf<- read.csv(destfile,header = T)
  #   
  #   ddf<- rbind(ddf,df)
  #   
  #   
  # }else{
  #   
  #   ddf<-df
  #   # write.csv(ddf , file = destfile ,row.names = T)
  # }
  # # write.csv(dbp_min_card,"C:/Users/rifat/Desktop/R_milan/KB_Integrity_Constraints/dbp-min-card.csv",row.names =   FALSE)
  # 
  # write.csv(ddf , destfile,row.names = FALSE)
  # rm(ddf)
  # list(result="success")
}

