# Observing KB dynamics 

R project for monitoring KB changes. Data extraction has been perfom based on any KB sparql endpoint.

![Architecture](https://raw.github.com/rifat963/KBDataObservatory/master/www/schedulerStructure.png)

## Instructions

To run this api locally on your machine, download R or RStudio and run the following commands once to set up the environment:

```
install.packages(c("SPARQL","jsonlite","cronR","stringr"))

```

All api source code located in plumber folder. To run the server locally you need to run execute code from run-api.R file. We used [plumber](https://github.com/trestletech/plumber) package for creating and hosting api. For hosting the API details instructions by plumber can be found via the [link](https://www.rplumber.io/docs/hosting.html#pm2).

## APIs 

Example APIs are deployed in http://178.62.126.59:9500/. Following we present short summary of the API used in the tool.




**runQury/** 

Input: Class Name, Graph, Sparql Endpoint.

Process: Extract summary statistics using sparql.

Return: Extracted data in JSON format

**getSchedulerResults/**

input: scheduler name 

Process: Get scheulering result based

Return: Extracted data in JSON format

**createCornJob/**

Input: Scheduler Name, time and frequency

Process: Create scheduling task as a corn jon in the server based on the time and frequency. 

Return: Response as success or error



#### Licence
These scripts are free software; you can redistribute it and/or modify it under the terms of the GNU General Public License published by
the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See the file Documentation/GPL3 in the original distribution for details. There is ABSOLUTELY NO warranty. 