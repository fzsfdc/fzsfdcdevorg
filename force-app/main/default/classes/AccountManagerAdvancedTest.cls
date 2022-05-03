/**
 * 
 */
@isTest
public class AccountManagerAdvancedTest {
    

    /*****************************************************************************************
     * Test: GET for AccountManagerAdvanced
     */
    @isTest
    public static void getAccountTest() {
        // Create an Account record in method and return Account Id
        String Id = createTestRecord();
        String url = '/services/apexrest/v3/Account/' + Id;
        RestRequest req = new RestRequest();
        req.requestURI = url;
        req.httpMethod = 'GET';

        // Assign prepared Request req object as the Request to the RestContext
        RestContext.request = req;
        
        Test.startTest();
            AccountManagerAdvanced.AccountWrapper accwrp = AccountManagerAdvanced.getAccount();
            System.assertNotEquals(null, accwrp);
            //System.assertEquals('TestAcc', accwrp.accountRecord.Name, 'OK - Account names are equal');
            //System.assertEquals('Test', accwrp.contactList.get(0).LastName);
            //System.assertEquals(TRUE, accwrp.accountRecord.Name = accwrp.contactList.get(0).AccountId, 'Account ID  and Contact Account Id are same -> Contact belongs to Account');
        Test.stopTest();
    }


    /*****************************************************************************************
     * Test:POST for AccountManagerAdvanced
     */
    @isTest
    public static void postAccountTest() {

        // From Postman GET: https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v2/Account/0015f00000JaCSdAAN
        String url = '/services/apexrest/v3/Account';
        RestRequest req = new RestRequest();
        req.requestURI = url;
        req.httpMethod = 'POST';

        // Create test Account
        Account acc = new Account(Name = 'Test');
        // Create test Contact
        Contact con = new Contact(LastName = 'ContactLast', FirstName='ContactFirst', Email='ContactEmail@gmail.com');

        String testMsg = 'Test message from test class';
        
        AccountManagerAdvanced.AccountInformation info = new AccountManagerAdvanced.AccountInformation();
        info.accRec = acc;
        info.conRec = con;
        info.testMessage = testMsg;

        // Assign prepared Request req object as the Request to the RestContext
        RestContext.request = req;

        Test.startTest();
            AccountManagerAdvanced.AccountInformation insRec = AccountManagerAdvanced.postAccount(info);
        //    System.assertNotEquals('Test', insRec.accRec.Name, 'Account name is the same');
        Test.stopTest();
    }   
    
    /*****************************************************************************************
     * Test: PATCH for AccountManagerAdvanced
     */
    @isTest
    public static void updateAccountTest() {
        // Create an Account record in method and return Account Id
        String Id = createTestRecord();
        // From Postman GET: https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v2/Account/0015f00000JaCSdAAN
        String url = '/services/apexrest/v3/Account/' + Id; // + ?_HttpMethod=PATCH
        RestRequest req = new RestRequest();
        req.requestURI = url;
        // req.httpMethod = 'POST';
        req.httpMethod = 'PATCH';

        // Assign prepared Request req object as the Request to the RestContext
        RestContext.request = req;

        Test.startTest();
            AccountManagerAdvanced.AccountWrapperResponse accwrp = AccountManagerAdvanced.updateAccount('Cold', 'UDEMYTESTCLASS', 'Description from Test Class');
            // System.assertEquals('Cold', accwrp.accountRecord.Rating, 'OK - Rating is cold');
        Test.stopTest();
    }

        /*****************************************************************************************
     * Test: PATCH for AccountManagerAdvanced
     */
    @isTest
    public static void updateAccountTest_ELSE() {
        // Create an Account record in method and return Account Id
        String Id = createTestRecord();
        // From Postman GET: https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v2/Account/0015f00000JaCSdAAN
        String url = '/services/apexrest/v3/Account/' + Id + '1'; // + ?_HttpMethod=PATCH
        RestRequest req = new RestRequest();
        req.requestURI = url;
        // req.httpMethod = 'POST';
        req.httpMethod = 'PATCH';

        // Assign prepared Request req object as the Request to the RestContext
        RestContext.request = req;

        Test.startTest();
            AccountManagerAdvanced.AccountWrapperResponse accwrp = AccountManagerAdvanced.updateAccount('Cold', 'UDEMYTESTCLASS', 'Description from Test Class');
            // System.assertEquals('Cold', accwrp.accountRecord.Rating, 'OK - Rating is cold');
        Test.stopTest();
    }

    /*****************************************************************************************
     * Test: DELETE for AccountManagerAdvanced
     */
    @isTest
    public static void deleteAccountTest() {
        // Create an Account record in method and return Account Id
        String Id = createTestRecord();
        // From Postman GET: https://d5f000005txrweau-dev-ed.my.salesforce.com/services/apexrest/v2/Account/0015f00000JaCSdAAN
        String url = '/services/apexrest/v3/Account/' + Id; // + ?_HttpMethod=PATCH
        RestRequest req = new RestRequest();
        req.requestURI = url;
        req.httpMethod = 'DELETE';

        // Assign prepared Request req object as the Request to the RestContext
        RestContext.request = req;

        Test.startTest();
            AccountManagerAdvanced.deleteAccount();
        Test.stopTest();
    }

    /*****************************************************************************************
     * UTILIY method: Create test Account and related contact and return Account.Id
     */
    static Id createTestRecord() {

        Account testAcc = new Account(
            Name = 'TestAcc'
        );
        insert testAcc;

        Contact testCtc = new Contact(
            LastName = 'Test',
            AccountId = testAcc.Id 
        );
        insert testCtc;

        return testAcc.Id;
    }

}