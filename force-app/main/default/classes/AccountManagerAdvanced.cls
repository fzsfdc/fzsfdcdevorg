/**
* AccountManager
* Based on: Udemy - Mastering Salesforce Integration: Novice to Professional
* Test: Workbench or Postman
* 1.) Canvas App,  Consumer Key/Secret, OAuth2 Password Flow to get Get Bearer Access Token
* 2.) https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v1/Account/0015f00000AO38YAAT (use Bearer Access Token)

POST https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v1/Account
Body:
{
    "accName": "Udemy",
    "accNumber": "Udemy2022",
    "ind": "Education",
    "descr": "Test account for Apex Rest Testing - Udm-Ch31"
}

PATH https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v2/Account/0015f00000JaCSdAAN
{
    "rating": "Cold",
    "accNumber": "COLDUdemy2022",
    "description": "Update based on Rating change from REQ-1234"
}
*/

@RestResource(urlMapping='/v3/Account/*')
global with sharing class AccountManagerAdvanced {

    /****************************************************************************************************
     * Patch Account
     */
    @HttpPatch
    global static AccountWrapperResponse updateAccount(String rating, String accNumber, String description) {
        RestRequest req = RestContext.request;
        String requestUri = req.requestURI;
        String accountId = requestUri.substringAfterLast('/');

        List<Account> accList = [SELECT Id FROM Account WHERE Id =: accountId];
        Account accRec;
        AccountWrapperResponse awres = new AccountWrapperResponse();

        if (accList != null && accList.size() > 0) {
            accRec = new Account(Id = accountId, Rating = rating, AccountNumber = accNumber, Description = description);
            update accRec;
            awres.accRec = accRec;
            awres.message = 'Account Record updated !';
        } else {
            awres.message = 'Account Record not found !';
        }
        
        return awres;
    }    

    /****************************************************************************************************
     * Delete Account
     */
    @HttpDelete
    global static String deleteAccount() {
        RestRequest req = RestContext.request;
        String requestUri = req.requestURI;
        String accountId = requestUri.substringAfterLast('/');

        List<Account> accList = [SELECT Id FROM Account WHERE Id =: accountId];

        if(accList != null && accList.size() > 0) {
            try {
                delete accList;
                return '{ "Status":"Account '+accountId+' successfully deleted" }';     
            } catch (System.Exception ex){
                String errMsg = ex.getMessage();
                return '{ "Status":"Account'+errMsg+' successfully deleted" }';
            }
            
        } else {
            return '{ "Status":"Account '+accountId+' not found" }';
        }
        /*
        if(accList != null && accList.size() > 0) {
            delete accList;
            return '{' + '\n
                        "Account":"' + accountId + '",
                        "Status":" Successfully deleted !"
                    }';
        } else {
            '{
                "Account":"' + accountId + '",
                "Status":" NOT FOUND. Please check Account ID in your request URL !"
            }';
        }
        */   
    }
   
   /****************************************************************************************************
    * Create Account V2
    */
/*   @HttpPost
   global static Account postAccount(String accName, String accNumber, String ind, String descr) {
        // Create a Account object
        Account accRec = new Account(Name = accName, AccountNumber = accNumber, Industry = ind, Description = descr);
        // insert ccount
        insert accRec;
        // return Account
        return accRec;
   }
*/

   /****************************************************************************************************
    * Create Account V3
    */
    @HttpPost
    global static AccountInformation postAccount(AccountInformation accInfo) {
         // Create a Account object
         Account accRec = accInfo.accRec;
         insert accRec;
         
         
         Contact conRec = accInfo.conRec;
         conRec.AccountId = accRec.Id;
         insert conRec;

         accInfo.testMessage = 'Account and Contact successfully created !';
         // return Account
         return accInfo;
    }

   /****************************************************************************************************
    * GET Accounts, Contacts, Cases
    */
   @HttpGet
   global static AccountWrapper getAccount() {
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

   /**
    * Account Wrapper class
    */
    global class AccountWrapper {
        global Account accountRecord;
        global List<Contact> contactList;
        global List<Case> caseList;
    }

   /**
    * Account Information Wrapper class;
    */
    global class AccountInformation {
        global Account accRec { get; set; }
        global Contact conRec { get; set; }
        global String testMessage { get; set; }
    }
   

   /**
    * Response Account  Wrapper
    * Note: Could have one class, but the course was sequentially build like this
    */
    global class AccountWrapperResponse {
        global Account accRec;
        global String message;
    }
}