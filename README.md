# evaluation-api
REST API, which allows to implement own procedures to evaluate data recorded in the LUCA office simulation.

In order to use the API and test new function implmentations it is necessary to provide access to a database from an instance of a LUCA Office simulation. Access to the software for local development is currently only available on request.

## Installation
(1) Copy the file `config_template.yml` given in the repositories main folder and rename it to `config.yml`
(2) Adjust the content of the `config.yml` according to the LUCA database you want to connect to. The settings included in the template file correspond to the standard settings of a local development installation.

## Example API Calls

(The three hash IDs have to be changed according to the values in the considered study.)

### Curl
curl -X GET "http://127.0.0.1:3086/evaluate?functionId=p_answer_001_mail_politeness&invitationId=cf23f8fe-6a5e-439d-bfe6-33973e9f0092&scenarioId=ed6ea5c0-eb93-4690-b6b8-1ff83ad5e74f&surveyID=f9a8d003-e015-4969-bbdc-3f81298a8b94" -H  "accept: */*"

### Request URL
http://127.0.0.1:3086/evaluate?functionId=p_answer_001_mail_politeness&invitationId=cf23f8fe-6a5e-439d-bfe6-33973e9f0092&scenarioId=ed6ea5c0-eb93-4690-b6b8-1ff83ad5e74f&surveyID=f9a8d003-e015-4969-bbdc-3f81298a8b94
