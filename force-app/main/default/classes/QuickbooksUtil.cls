public class QuickbooksUtil {
    /**
    public QuickbooksUtil() {

    }
    */

    /**
     * Get the custom metadata type: QuickbooksSandbox via a database query
     */
    public static Quickbooks__mdt quickbooksCred() {
        
        // Get the query
        String query = quickBooksQuery();
		// System.debug(System.LoggingLevel.DEBUG, ' quickbooksCred - query: ' + query);
        // SELECT Id,...,access_token__c,auth_url__c,Client_Id__c,Client_Secret__c,Company_Info__c,Create_Bill__c,... FROM Quickbooks__mdt W
        List<Quickbooks__mdt> qb_CredList = Database.query(query);
        Quickbooks__mdt qb_Cred = new Quickbooks__mdt();
        if(qb_CredList != null && !qb_CredList.isEmpty()) {
            qb_Cred = qb_CredList[0];
        }
        
        //System.debug(System.LoggingLevel.DEBUG, ' quickbooksCred - qb_Cred: ' + qb_Cred.Sandbox_Base_URL__c);
        // return the metadata object
        return qb_Cred;
    }

    /**
     * Create the SOQL query for the custom metadata
     */
    public static String quickBooksQuery() {
        
        // Get the query for the custom metadata: QuickBookSandbox
        String query = SOQLUtil.buildSOQLQuery('Quickbooks__mdt', System.Label.QuickbookSandbox);
        // return the query created
        return query;
    }

    /**
     * Check if the accessToken is still valid
     */
    public static Boolean checkTokenValidity(Quickooks__mdt token) {
        Boolean isValid = true;
        if(token.expires_in_time__c < System.now()) {
            isValid = false;
        }
        return isValid;
    }

    /**
     * Create a Customer in QuickBooks
     * Udm_MstInt - Ch53 - Make callouts to Quickbook
     */
    public static void createCustomer() {
    //public static void createCustomer(QuickBooksCustomer cust) {

        // Get custom metadata type config
        Quickbooks__mdt qb_Cred = quickbooksCred();
        if(qb_Cred!=null && String.isBlank(qb_Cred.access_token__c)) {
            // end method if qp_Cred is not null && access_token__c is empty
            return; 
        }

        String accessToken = qb_Cred.access_token__c;
        Boolean isValid = checkTokenValidity(qb_Cred);
        
        Map<String, Object> refreshTokenMap = new Map<String, Object>();

        // if token is no longer valid -> refresh token
        if(!isValid) {
            refreshTokenMap = refreshToken(qb_Cred);
            accessToken = (String)refreshTokenMap.get('access_token__c');
        }

        // Set the endpoint for QuickBook Create Customer: 
        String endPoint = qb_Cred.Environment__c == 'Sandbox'?qb_Cred.Sanbdox_Base_URL__c : qb_Cred.Prod_Base_URL__c;
        String customerUrl = qb_Cred.Create_Customer__c;

    }

}