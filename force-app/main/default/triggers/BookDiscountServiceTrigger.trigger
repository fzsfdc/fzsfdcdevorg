trigger BookDiscountServiceTrigger on Book__c (before insert) {
    
    Book__c[] books = Trigger.new;
    BookDiscountService.applyDiscount(books);
    
}