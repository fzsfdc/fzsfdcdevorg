global without sharing class SOQLUtil {

    // SOQL keywords
    private static FINAL String QUERY_SELECT = 'SELECT ';
    private static FINAL String QUERY_WHERE  = ' WHERE ';
    private static FINAL String QUERY_FROM   = ' FROM ';
    private static FINAL String QUERY_LIMIT  = ' LIMIT ';
    private static FINAL String SECURITY_ENFORCED = ' WITH SECURITY_ENFORCED';
    
    /*
     * Prepare the SOQL by retrieving the sObject and filters in corresponding format
     **/
    global static String buildSOQLQuery(String objName, String filter){
    
        Schema.sObjectType sobj = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objectDescribe = sobj.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
        
        String whereClause = 'Masterlabel ='+'\''+filter+'\'';
        // Call the actual SOQL query method
        String query = buildQueryAllString(fieldMap.values(),objectDescribe, whereClause, 1);
        
        // return the complete results based on the request
        return query;
    }
    
    /**
     * Build SOQL query out of the sObject and filter
     */
    private static String buildQueryAllString(List<Schema.SObjectField> allFields, DescribeSObjectResult obj, 
                        String filter, Integer rLimit) {
        
        String query = QUERY_SELECT;
        for(Schema.SObjectField dfr : allFields){
            query = query + dfr.getDescribe().getName() + ',';
        }
        query = query.subString(0,query.length() - 1);
        query = query + QUERY_FROM;
        query = query + obj.getName();
        if(!String.isBlank(filter)){
            query = query + QUERY_WHERE;
            query = query + filter;
        }
        query = query + SECURITY_ENFORCED;
        query = query + QUERY_LIMIT;
        query = query + rLimit;
        
        // return the query result from sObject using filters
        return query;
        
    }
}