@RestResource(urlMapping='/Account/*')
global with sharing class AccountService {

    /**
     * Account Service (simple) to return Account on HTTP GET request
     */
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id,Name,Phone,Website FROM Account WHERE Id = :accountId];
        return result;
    }
}