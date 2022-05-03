/*
* Mastering Salesforce Integration: Novice to Professional
* Ch.5/28 
* Endpoint (GET and POST implemented) - Postman: https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v1/Welcome
*/
@RestResource(urlMapping='/v1/Welcome/*')
global with sharing class WelcomeClass {
    
    global final static string WELCOME_MSG = 'Welcome to SfdcPanther Integration Tutorial';

    @HttpGet
    global static string greetingMessage() {
        return 'get: ' + WELCOME_MSG;
    }

/* 
    Does not work: Compile Error: Only one method per type can be defined with: HttpGet at line 6 column 27   
    @HttpGet
    global static string greetingMessage_1() {
        return WELCOME_MSG;
    }
*/

    // POST
    @HttpPost
    global static string postGreetingMessage_1() {
        return 'post: ' + WELCOME_MSG;
    }
    
    @HttpPatch
    global static string patchGreetingMessage_1() {
        return 'patch: ' + WELCOME_MSG;
    }
}