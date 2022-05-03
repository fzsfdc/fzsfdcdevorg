@isTest
private class BookDiscountServiceTest {
    
    @isTest
    static void validateBookDiscounts() {

        Book__c b = new Book__c(Name='Behind the Cloud', Price__c=100);
        System.debug('Price before inserting new book: ' + b.Price__c);

        // insert book
        insert b;

        b = [SELECT Id, Name, Price__c FROM Book__c WHERE ID = :b.Id];

        System.debug('Price after trigger fired: ' + b.Price__c);

        System.assertEquals(90, b.Price__c);
    }
}