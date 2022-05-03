@RestResource(urlMapping='/v1/FirstApexRestService/*')
global with sharing class FirstApexRestService {
    
    global final static String firstMsg = 'FirstApexRestService message';
    
    @HttpGet
    global static String returnFirstApexRestService() {
        return firstMsg;
    }
}