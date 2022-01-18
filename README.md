# evaluation-api

A REST API providing access to different evaluation functions implemented in Python and R. Each function/ API call returns a score that a participant achieved for a specific task. Further, a more detailed answer category might be returned and, and in case of probabilistic coding approaches like those based on machine learning models, it also returns a probability for the correctness of the estimated score.

In order to use the API and test new function implmentations it is necessary to provide access to a database from an instance of a LUCA Office simulation. Access to a local installation for developing and testing new functions is currently only available on request.

## Installation
(1) Copy the file `config_template.yml` given in the repositories main folder and rename it to `config.yml`  
(2) Adjust the content of the `config.yml` according to the LUCA database you want to connect to. The settings included in the template file correspond to the standard settings of a local development installation.  


## Example API Calls

The IP and and port number have to adapted, and the three hash IDs have to be changed according to the values in the considered study.
Additionally, a value for the verbosity of the call can be passed on:  
`verbose=0`: Only ERROR will be logged  
`verbose=1`: ERROR and INFO will be logged  
`verbose=2`: ERROR, INFO, and WARNING will be logged  
The standard verbose value is 1

### Curl
curl -X GET "http://127.0.0.1:5876/evaluate?functionId=p_answer_001_mail_politeness&invitationId=cf23f8fe-6a5e-439d-bfe6-33973e9f0092&scenarioId=ed6ea5c0-eb93-4690-b6b8-1ff83ad5e74f&surveyID=f9a8d003-e015-4969-bbdc-3f81298a8b94&verbose=1" -H  "accept: */*"

### Request URL
http://127.0.0.1:5876/evaluate?functionId=p_answer_001_mail_politeness&invitationId=cf23f8fe-6a5e-439d-bfe6-33973e9f0092&scenarioId=ed6ea5c0-eb93-4690-b6b8-1ff83ad5e74f&surveyID=f9a8d003-e015-4969-bbdc-3f81298a8b94&verbose=1

### Response Format
{ "score":[0],  
  "category":[0],  
  "probability":[0.9931]  
}  
