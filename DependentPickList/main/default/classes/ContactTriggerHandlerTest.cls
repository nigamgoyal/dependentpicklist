/*
Developer Name: Gorisha Mehrotra
Description: Test Class on ContactTrigger
*/
@isTest(seeAllData=false)
private class ContactTriggerHandlerTest {
    public static Boolean setAccount = true;
    public static Integer setLimit = 200;
    
    @testSetup static void generateTestData() {
        //created Generic ContactFactory class use to generate bulk test data
        ContactFactory.generateContactsWithSameAcc(setLimit, setAccount);
        ContactFactory.generateContactsWithDiffAcc(setLimit, setAccount);
    }
    //testMailingAddressOnContact - Test Positive Scenarios
    private static testmethod void runPositiveTestOnUpdatingContactAddress(){
        Test.startTest();
        	List<Contact> contactList = [Select MailingStreet,MailingCity,MailingState,
                                         MailingCountry,MailingPostalCode,AccountId,
                                         Account.BillingStreet,Account.BillingCity,
                                         Account.BillingState,Account.BillingCountry,
                                         Account.BillingPostalCode From Contact];
            for(Contact con : contactList){
                System.assertEquals(con.MailingStreet,con.Account.BillingStreet);
                System.assertEquals(con.MailingCity,con.Account.BillingCity);
                System.assertEquals(con.MailingState,con.Account.BillingState);
                System.assertEquals(con.MailingCountry,con.Account.BillingCountry);
                System.assertEquals(con.MailingPostalCode,con.Account.BillingPostalCode);
            }
        Test.stopTest();
    }
    //testFailScenarios - Test Negative Scenarios
    private static testmethod void runNegativeTestOnUpdatingContactAddress(){
        Test.startTest();
            List<Contact> contactList = [Select MailingStreet,MailingCity,MailingState,
                                             MailingCountry,MailingPostalCode,AccountId,
                                             Account.BillingStreet,Account.BillingCity,
                                             Account.BillingState,Account.BillingCountry,
                                             Account.BillingPostalCode From Contact];
            for(Contact con : contactList){
                System.assertNotEquals(con.AccountId, null);
                System.assertNotEquals(con.MailingStreet,null);
                System.assertNotEquals(con.MailingCity,null);
                System.assertNotEquals(con.MailingState,null);
                System.assertNotEquals(con.MailingCountry,null);
                System.assertNotEquals(con.MailingPostalCode,null);
            }
        Test.stopTest();
    }
    private static testmethod void testWithoutAddress(){
        Test.startTest();
        	Account acc = ContactFactory.generateContact();
        	Contact con = new Contact();
        	con.LastName = 'TestCWithoutAddress';
        	con.AccountId = acc.Id;
        	insert con;
        	Contact contact = [Select MailingStreet,MailingCity,MailingState,
                                     MailingCountry,MailingPostalCode,AccountId,
                                     Account.BillingStreet,Account.BillingCity,
                                     Account.BillingState,Account.BillingCountry,
                                     Account.BillingPostalCode From Contact Where AccountId = :acc.Id Limit 1];
        	System.assertEquals(contact.AccountId, acc.Id);
            System.assertEquals(contact.MailingStreet,null);
            System.assertEquals(contact.MailingCity,null);
            System.assertEquals(contact.MailingState,null);
            System.assertEquals(contact.MailingCountry,null);
            System.assertEquals(contact.MailingPostalCode,null);
            System.assertEquals(contact.Account.BillingStreet,null);
            System.assertEquals(contact.Account.BillingCity,null);
            System.assertEquals(contact.Account.BillingState,null);
            System.assertEquals(contact.Account.BillingCountry,null);
            System.assertEquals(contact.Account.BillingPostalCode,null);
        Test.stopTest();
    }
    private static testmethod void testDmlExceptions(){
        Test.startTest();
            try{
                ContactFactory.generateContactsWithSameAcc(1, setAccount);
            }catch (DmlException e) {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
        Test.stopTest();
    }
}