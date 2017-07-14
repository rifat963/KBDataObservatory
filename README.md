# Observing KB dynamics 
R project for monitoring KB changes. Data extraction has been perfom based on any KB sparql endpoint. 

Example APIs are deployed in http://178.62.126.59:8500/. Following we present short summary of the API used in the tool.

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
