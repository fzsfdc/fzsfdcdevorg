/**
 * 
 */
global class AccountPlannerWrapper {

    /**
     * Test Web-Service to take two input parameters concats this with an prefix and returns the concatendate string
     */
    webservice static String fullName(String firstName, String lastName) {
        String msg = 'Welcome ' + firstName + ' ' + lastName;
        return msg;
    }

    /**
     * Account Web-Service, create an account based on input params
     */
    webservice static AccountWrapper createAccount(AccountWrapper accWrpPara) {

        AccountWrapper accWrpResponse = new AccountWrapper();

        // Create an account from input params
        Account accRec = new Account();
        accRec.Name = accWrpPara.Name;
        accRec.Phone = accWrpPara.Phone;
        accRec.Rating = accWrpPara.Rating;
        accRec.Industry = accWrpPara.Industry;
        accRec.Site = accWrpPara.Site;
        accRec.AccountNumber = accWrpPara.AccountNumber;
        
        // Insert account
        insert accRec;

        // Create new Contact and attach to account
        Contact ctc = new Contact ();
        ctc.LastName = accWrpPara.Lastname;
        ctc.AccountId = accRec.Id;
        // Insert Contact with AccountId
        insert ctc;

        accWrpResponse = accWrpPara;
        // Return new complete account with contact
        return accWrpResponse;
    }

    global class AccountWrapper {
        webservice String Name;
        webservice String Phone;
        webservice String Rating;
        webservice String Industry;
        webservice String Site;
        webservice String AccountNumber;
        webservice String Lastname;
        /*
        webservice String Name;
        webservice String Rating;
        webservice String Industry;
        webservice String Phone;
        webservice String Site;
        webservice String AccountNumber;
        webservice String contactLastName;
        */
    }
}