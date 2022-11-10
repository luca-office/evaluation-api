# evaluation-api

A REST API for the LUCA Office application providing access to different evaluation functions implemented in Python and R. Each function/ API call returns a score that a participant achieved for a specific task. In addition a more detailed answer category might be returned; for machine learning models, for example, a probability for the correctness of an estimated score might be returned.

An introduction into the general idea of the API, the technical implementation, and info on how to add you self-implemented functions to LUCA office is given in the PDF [here](https://github.com/LucaOffice/evaluation-api/blob/main/documentation/221109_Workshop.pdf).

In order to use the API and test function implementations, you may want to connect to a database from a running instance of the LUCA Office simulation. Access to the LUCA Office application source code for local deployment and developing and testing purposes is currently only available on request.

If you are interested in developing a function evaluating the student's email answer, the evaluation API includes a testing mechanism that allows you to test it locally without database access. In this case the name of the function must start with `p_answer_` in case of a Python function or `r_answer_` in case of an R function. Further, you must set `invitationId=00000`. The used email text is defined [here](https://github.com/LucaOffice/evaluation-api/blob/62ec7614ad0369102effee4a12d776d062c421d6/src/runtime_functions/r/database_utils.R#L64), and you can adjust it by changing the value for `answer_mail` according to your needs.

If you want to test functions for other data than the students' answer email, feel free to contact the LUCA Office team, and we will try to provide you with corresponding testing options.


## Connection of Your Local Evaluation API to a LUCA Office Database
(1) Copy the file `config_template.yml` given in the repositories main folder and rename it to `config.yml`  
(2) Adjust the content of the `config.yml` according to the LUCA database you want to connect to. The settings included in the template file correspond to the standard settings of a local development installation.  


## Example API Calls

The IP and and port number have to adapted, and the three hash IDs have to be changed according to the values in the considered study.
Additionally, a value for the verbosity of the call can be passed on:  
`verbose=0`: Only ERROR will be logged  
`verbose=1`: ERROR and INFO will be logged  
`verbose=2`: ERROR, INFO, and WARNING will be logged  
The standard verbose value is 1

### Example Curl without connected database
curl -X GET "http://127.0.0.1:5876/evaluate?functionId=p_answer_001_mail_politeness_c1&invitationId=00000&verbose=1" -H  "accept: */*"
### Example Curl with connected LUCA Office database
curl -X GET "http://127.0.0.1:5876/evaluate?functionId=p_answer_001_mail_politeness_c1&invitationId=cf23f8fe-6a5e-439d-bfe6-33973e9f0092&scenarioId=ed6ea5c0-eb93-4690-b6b8-1ff83ad5e74f&surveyID=f9a8d003-e015-4969-bbdc-3f81298a8b94&verbose=1" -H  "accept: */*"

### Example Request URL without connected database
http://127.0.0.1:5876/evaluate?functionId=p_answer_001_mail_politeness_c1&invitationId=000004&verbose=1
### Example Request URL with connected LUCA Office database
http://127.0.0.1:5876/evaluate?functionId=p_answer_001_mail_politeness_c1&invitationId=cf23f8fe-6a5e-439d-bfe6-33973e9f0092&scenarioId=ed6ea5c0-eb93-4690-b6b8-1ff83ad5e74f&surveyID=f9a8d003-e015-4969-bbdc-3f81298a8b94&verbose=1

### Response Format
{ "function_name": String,  
  "criterion_no": Int,  
  "criterion_prediction": "fulfilled" | "not_fulfilled" | "undefined",  
  "criterion_probability": BigDecimal,  
  "criterion_threshold": BigDecimal,  
  "data": String  
}  
