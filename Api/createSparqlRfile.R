library(SPARQL)
library(jsonlite)
library(cronR)
library(stringr)

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
  
  
  sink(paste(getwd(),"/",filename,".R",sep=""))
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
  cat("destfile=paste(getwd(),filename,sep = \"/\")")
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
