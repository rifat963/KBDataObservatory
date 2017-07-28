# Observing KB dynamics 

R project for monitoring KB changes. Data extraction has been perfom based on any KB sparql endpoint.

![Architecture](https://raw.github.com/rifat963/KBDataObservatory/master/www/schedulerStructure.png)

## Instructions

To run this api locally on your machine, download R or RStudio and run the following commands once to set up the environment:

```
install.packages(c("SPARQL","jsonlite","cronR","stringr","plumber","taskscheduleR","httr"))

```

All api source code located in plumber folder. To run the server locally you need to run execute code from run-api.R file. We used [plumber](https://github.com/trestletech/plumber) package for creating and hosting api. For hosting the API details instructions by plumber can be found via the [link](https://www.rplumber.io/docs/hosting.html#pm2).

## APIs 

Example APIs are deployed in http://178.62.126.59:8500/. Following we present short summary of the API used in the tool.

**runQury/** 

Input: Class Name, Graph, Sparql Endpoint.

Process: Extract summary statistics using sparql.

Return: Extracted data in JSON format

example:


```
# DBpedia Sparql endpoint
endpoint<-"https://dbpedia.org/sparql"

schedulerName="scheduler_owl"
endpoint<-"https://dbpedia.org/sparql"

className<-"<http://www.w3.org/2002/07/owl#Class>"
className<-gsub("#", "%23", className)

graph<-"<http://dbpedia.org/resource/classes#>"
graph<-gsub("#", "%23", graph)

parm<-paste0("http://178.62.126.59:8500/","runQuery?filename=",filename,"&endpoint=",endpoint,"&graph=",
            graph,"&className=",className)
          
r<-GET(parm)

content(r)

```

**getSchedulerResults/**

input: scheduler name 

Process: Get scheulering result based

Return: Extracted data in JSON format

Example:

```
schedulerName= "scheduler_event"

parm<-paste("http://178.62.126.59:8500/","readCSV?filename=",schedulerName,".csv",sep = "")

r<-GET(parm)

dt<-content(r)

json_data <- fromJSON(dt[[1]]) 

```


**createCornJob/**

Input: Scheduler Name, time and frequency

Process: Create scheduling task as a corn jon in the server based on the time and frequency. 

Return: Response as success or error

Example:

```
# DBpedia Sparql endpoint
endpoint<-"https://dbpedia.org/sparql"

schedulerName="scheduler_owl"
endpoint<-"https://dbpedia.org/sparql"

className<-"<http://www.w3.org/2002/07/owl#Class>"
className<-gsub("#", "%23", className)

graph<-"<http://dbpedia.org/resource/classes#>"
graph<-gsub("#", "%23", graph)


# It is necessary to create the R script before creating the Cron Job in the server

parm<-paste0("http://178.62.126.59:8500/","createRfile?filename=",schedulerName,"&className=",
                className,"&endpoint=",endpoint,"&graph=",graph)
    
responseCreateRfile<-GET(parm)
resCreateRfileContent<-content(responseCreateRfile)

# In the server duplicate scheduler will generate error. For this before createing scheduler please check current #  # available schedulers.

  parm<-"http://178.62.126.59:8500/readSchedulerIndex"
  r<-tryCatch(GET(parm), error = function(e) return(NULL))
  dt<-content(r)
  DF<-fromJSON(dt[[1]])
  DF$filename

# Now create the cron job

freq="daily"
time="14:25:00"

parm<-paste0("http://178.62.126.59:8500/","createCornJob?filename=",schedulerName,"&freq=",
            freq,"&time=",time)
r<-GET(parm)

content(r)

```

**getAllCornList/**


Input: Scheduler Name

Process: get all the current running schedulers

Return: CronJOb list

```

parm<-"http://178.62.126.59:8500/getAllCornList"

http_status(GET("http://178.62.126.59:8500/getAllCornList"))

r<-GET(parm)

content(r)

```


#### Licence
These scripts are free software; you can redistribute it and/or modify it under the terms of the GNU General Public License published by
the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See the file Documentation/GPL3 in the original distribution for details. There is ABSOLUTELY NO warranty. 