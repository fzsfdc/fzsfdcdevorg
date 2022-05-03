public class FreshdeskUtil {

    public static final string TICKETENDPOINT = 'https://self6718.freshdesk.com/api/v2/tickets';
    public static final string CONTACTENDPOINT = 'https://self6718.freshdesk.com/api/v2/contacts';

	/*
	 * Get all contacts from Freshdesk
	 * curl from Freshdesk: curl -v -u wgIEWUOiXFcaUmrG4vH:X -X GET 'https://self6718.freshdesk.com/api/v2/contacts'
	 * Test: FreshdeskUtil.listAllContacts();
	 */
    public static void listAllContacts() {
        
        String errMsg = '';
        String ctcEp = CONTACTENDPOINT;
	    String baCred = System.Label.FreshDeskApiKeyPwd; // base64Encode(username:password)
  
        Http http = new Http();
        HttpRequest HttpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(ctcEp);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(baCred)));
        HttpResponse httpRes = new HttpResponse();
        
        try {
            httpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 200) {
                String body = httpRes.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Response from Server: ' + body);
                
                List<FreshdeskContactWrapper> fdCtcs = (List<FreshdeskContactWrapper>)System.JSON.deserialize(body, List<FreshdeskContactWrapper>.class);
                for(FreshdeskContactWrapper fdCtc : fdCtcs) {
                    System.debug(System.LoggingLevel.DEBUG, ' Contact name ' + fdCtc.name);
                }
            } else {
                errMsg = 'Unexpected error communicating with Freshdesk API.  Status: ' +httpRes.getStatus()+ ' Status code: ' +httpRes.getStatusCode();
                System.debug(System.LoggingLevel.DEBUG, ' Exception Err: ' + errMsg);
            }
        }
        catch (System.Exception e) {
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized Endpoint')) {
                errMsg = 'Unauthorized endpoint: An admin must go to Setup -> Administrator -> Security Control -> '
                        + ' Remote Site Setting and add ' + ' ' + ctcEp + ' Endpoint';
            } else {
                errMsg = 'Unexpected Error while communicating with Freshdesk API. ' + 'Status ' + httpRes.getStatus() 
                        + ' and Status code: ' + httpRes.getStatusCode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exception executed ' + errMsg);
        }

    }

    /**
     * Create a new contact in Freshdesk
     * curl from Freshdesk: curl -v -u wgIEWUOiXFcaUmrG4vH:X -H 'Content-Type: application/json' -X POST -d '{ "name":"Super Man", "email":"superman@freshdesk.com", "other_emails": ["lex@freshdesk.com", "louis@freshdesk.com"] }' 'https://self6718.freshdesk.com/api/v2/contacts'
     * Test: FreshdeskUtil.createContact('Super Man3', 'superman3@freshdesk.com', '+1415123456789', '+1415123456789');
     * Note for testing: Freshdesk requires always a unique ID on POST/CREATE, use Patch or PUT if update the same record
	*/
    public static void createContact(String name, String email, String phone, String mobile) {
        String errMsg = '';
        String ctcEp = CONTACTENDPOINT;
	   String baCred = System.Label.FreshDeskApiKeyPwd; // base64Encode(username:password)
        String reqBody = '{' +
                                    '"name": "' +name+ '",' +
                                    '"email": "' +email+ '",' +
                                    '"phone": "' + phone+ '",' +
                                    '"mobile": "' +mobile+ '"' +
                                '}';

        Http http = new Http();
        HttpRequest HttpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndpoint(ctcEp);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(baCred)));
        httpReq.setBody(reqBody);
        HttpResponse httpRes = new HttpResponse();
        
        try {
            httpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 201) {
                String body = httpRes.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Response from Server: ' + body);
            } else {
                errMsg = 'Unexpected error communicating with Freshdesk API.  Status: ' +httpRes.getStatus()+ ' Status code: ' +httpRes.getStatusCode();
                System.debug(System.LoggingLevel.DEBUG, ' Exception Err: ' + errMsg);
            }
        }
        catch (System.Exception e) {
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized Endpoint')) {
                errMsg = 'Unauthorized endpoint: An admin must go to Setup -> Administrator -> Security Control -> '
                        + ' Remote Site Setting and add ' + ' ' + ctcEp + ' Endpoint';
            } else {
                errMsg = 'Unexpected Error while communicating with Freshdesk API. ' + 'Status ' + httpRes.getStatus() 
                        + ' and Status code: ' + httpRes.getStatusCode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exception executed ' + errMsg);
        }
  }

    /**
     * Create a ticket 
     * curl from Freshdesk: curl -v -u wgIEWUOiXFcaUmrG4vH:X -H "Content-Type: application/json" -d '{ "description": "Details about the issue...", "subject": "Support Needed...", "email": "tom@outerspace.com", "priority": 1, "status": 2, "cc_emails": ["ram@freshdesk.com","diana@freshdesk.com"] }' -X POST 'https://self6718.freshdesk.com/api/v2/tickets'
     * Test: FreshdeskUtil.createTicket('Broken screen', 'superman3@freshdesk.com', 'This is a broken screnn desc....', 2, 2, 2);
     */
    public static void createTicket(String sub, String email, String descr, Integer prio, Integer status, Integer source) {
        String errMsg = '';
        String tktEp = TICKETENDPOINT;
	    String baCred = System.Label.FreshDeskApiKeyPwd; // base64Encode(username:password)
        String reqBody = '{' +
            			'"description": "' +descr+ '",' +
            			'"subject": "' +sub+ '",' +
            			'"email": "' +email+ '",' +
            			'"priority": ' +prio+ ',' +
            			'"status": ' +status+ ',' +
            			'"source": ' +source+
            		   '}';

        Http http = new Http();
        HttpRequest HttpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setEndpoint(tktEp);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(baCred)));
        httpReq.setBody(reqBody);
        HttpResponse httpRes = new HttpResponse();
        
        try {
            httpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 201) {
                String body = httpRes.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Response from Server: ' + body);
            } else {
                errMsg = 'Unexpected error communicating with Freshdesk API.  Status: ' +httpRes.getStatus()+ ' Status code: ' +httpRes.getStatusCode();
                System.debug(System.LoggingLevel.DEBUG, ' Exception Err: ' + errMsg);
            }
        }
        catch (System.Exception e) {
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized Endpoint')) {
                errMsg = 'Unauthorized endpoint: An admin must go to Setup -> Administrator -> Security Control -> '
                        + ' Remote Site Setting and add ' + ' ' + tktEp + ' Endpoint';
            } else {
                errMsg = 'Unexpected Error while communicating with Freshdesk API. ' + 'Status ' + httpRes.getStatus() 
                        + ' and Status code: ' + httpRes.getStatusCode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exception executed ' + errMsg);
        }

    }
    
   	/*
	 * Get all tickets from Freshdesk
	 * curl from Freshdesk: curl -v -u wgIEWUOiXFcaUmrG4vH:X -X GET 'https://self6718.freshdesk.com/api/v2/tickets'
	 * Test: FreshdeskUtil.listAllTickets();
	 */
    public static void listAllTickets() {
        
        String errMsg = '';
        String tktEp = TICKETENDPOINT;
	    String baCred = System.Label.FreshDeskApiKeyPwd; // base64Encode(username:password)
  
        Http http = new Http();
        HttpRequest HttpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(tktEp);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(baCred)));
        HttpResponse httpRes = new HttpResponse();
        
        try {
            httpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 200) {
                String body = httpRes.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Response from Server: ' + body);
                              
                List<FreshdeskTicketWrapper> fdTkts = (List<FreshdeskTicketWrapper>)System.JSON.deserialize(body, List<FreshdeskTicketWrapper>.class);
                for(FreshdeskTicketWrapper fdTkt : fdTkts) {
                    System.debug(System.LoggingLevel.DEBUG, ' Ticket subject ' + fdTkt.subject);
                }
				
            } else {
                errMsg = 'Unexpected error communicating with Freshdesk API.  Status: ' +httpRes.getStatus()+ ' Status code: ' +httpRes.getStatusCode();
                System.debug(System.LoggingLevel.DEBUG, ' Exception Err: ' + errMsg);
            }
        }
        catch (System.Exception e) {
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized Endpoint')) {
                errMsg = 'Unauthorized endpoint: An admin must go to Setup -> Administrator -> Security Control -> '
                        + ' Remote Site Setting and add ' + ' ' + tktEp + ' Endpoint';
            } else {
                errMsg = 'Unexpected Error while communicating with Freshdesk API. ' + 'Status ' + httpRes.getStatus() 
                        + ' and Status code: ' + httpRes.getStatusCode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exception executed ' + errMsg);
        }

    }

    /*
	 * Get all tickets from Freshdesk related to a customer
	 * curl from Freshdesk: curl -v -u wgIEWUOiXFcaUmrG4vH:X -X GET 'https://self6718.freshdesk.com/api/v2/tickets'
	 * Test: FreshdeskUtil.listAllTickets();
	 */
    public static void listCustomerTickets(String email) {
        
        String errMsg = '';
        String tktEp = TICKETENDPOINT+'?email='+EncodingUtil.urlEncode(email, 'UTF-8');
	    String baCred = System.Label.FreshDeskApiKeyPwd; // base64Encode(username:password)
  
        Http http = new Http();
        HttpRequest HttpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(tktEp);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(baCred)));
        HttpResponse httpRes = new HttpResponse();
        
        try {
            httpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 200) {
                String body = httpRes.getBody();
                System.debug(System.LoggingLevel.DEBUG, ' Response from Server: ' + body);
                
                List<FreshdeskTicketWrapper> fdTkts = (List<FreshdeskTicketWrapper>)System.JSON.deserialize(body, List<FreshdeskTicketWrapper>.class);
                for(FreshdeskTicketWrapper fdTkt : fdTkts) {
                    System.debug(System.LoggingLevel.DEBUG, ' Ticket subject ' + fdTkt.subject);
                }
            } else {
                errMsg = 'Unexpected error communicating with Freshdesk API.  Status: ' +httpRes.getStatus()+ ' Status code: ' +httpRes.getStatusCode();
                System.debug(System.LoggingLevel.DEBUG, ' Exception Err: ' + errMsg);
            }
        }
        catch (System.Exception e) {
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized Endpoint')) {
                errMsg = 'Unauthorized endpoint: An admin must go to Setup -> Administrator -> Security Control -> '
                        + ' Remote Site Setting and add ' + ' ' + tktEp + ' Endpoint';
            } else {
                errMsg = 'Unexpected Error while communicating with Freshdesk API. ' + 'Status ' + httpRes.getStatus() 
                        + ' and Status code: ' + httpRes.getStatusCode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exception executed ' + errMsg);
        }

    }
    
}