/**
* AccountManager
* Based on: Udemy - Mastering Salesforce Integration: Novice to Professional
* Test: Workbench or Postman
* 1.) Canvas App,  Consumer Key/Secret, OAuth2 Password Flow to get Get Bearer Access Token
* 2.) https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v1/Account/0015f00000AO38YAAT (use Bearer Access Token)
*/

@RestResource(urlMapping='/v1/Account/*')
global with sharing class AccountManagerSimple {
  
   @HttpGet
   global static AccountWrapper accountInformation() {
       RestRequest req = RestContext.request;
       String requestUri = req.requestURI;
       String accountId = requestUri.substringAfterLast('/');

       List<Account> accList = [SELECT Id,Name,Rating,Industry,Description,Phone,Fax FROM Account WHERE Id =: accountId];
      
       List<Contact> ctcList = [SELECT Id,Name,FirstName,LastName,Email,Phone FROM Contact WHERE AccountId =: accountId];

       List<Case> csList = [SELECT Id,CaseNumber,Subject,Description,Status,Owner.Name FROM Case WHERE AccountId =: accountId];

       AccountWrapper wrp = new AccountWrapper();
       // check if account exist respectively returns result
       if(!accList.isEmpty()) {
        wrp.accountRecord = accList.get(0);
        wrp.contactList = ctcList;
        wrp.caseList = csList;
       }

       return wrp;

   }

   global class AccountWrapper {
       global Account accountRecord;
       global List<Contact> contactList;
       global List<Case> caseList;
   }
}