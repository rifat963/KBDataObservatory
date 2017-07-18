library(SPARQL)
library(jsonlite)
filename=TestR01.R
endpoint=http://kb.3cixty.com/sparql
className=dul:Place
graph=<http://3cixty.com/nice/places>
parm<-paste("http://178.62.126.59:8500/","runQuery?filename=",filename,"&className=",
            className,"&endpoint=",endpoint,"&graph=",graph,sep = "")
r<-GET(parm)
destfile=paste(getwd(),filename,sep = "/")
if(file.exists(destfile)){
ddf<- read.csv(destfile,header = T)
ddf<- rbind(ddf,df)}else{ddf<-df}
write.csv(ddf , destfile,row.names = FALSE)
rm(ddf)
list(result="success")