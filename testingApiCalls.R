library(httr)

endpoint<-"https://dbpedia.org/sparql"

schedulerName="scheduler_owl"
endpoint<-"https://dbpedia.org/sparql"

className<-"<http://www.w3.org/2002/07/owl#Class>"
className<-gsub("#", "%23", className)

graph<-"<http://dbpedia.org/resource/classes#>"
graph<-gsub("#", "%23", graph)

filename="test"
#130.192.85.247

parm<-paste0("http://datascience.ismb.it:9500/","runQuery?filename=",filename,"&endpoint=",endpoint,"&graph=",
             graph,"&className=",className)

r<-GET(parm)

#http://datascience.ismb.it:9500/readSchedulerIndex

r

dt<-content(r)

schedulerName= "scheduler_event"

parm<-paste("http://178.62.126.59:8500/","readCSV?filename=",schedulerName,".csv",sep = "")

r<-GET("http://datascience.ismb.it:9500/readSchedulerIndex")

r<-GET(parm)

dt<-content(r)

json_data <- fromJSON(dt[[1]]) 



# Create Scheduler Index

st=data.frame(filename=c("lode:Event"))


write.csv(st,"/srv/shiny-server/KBDataObservetory/schedulerIndex/schedulerList.csv",row.names = F)



