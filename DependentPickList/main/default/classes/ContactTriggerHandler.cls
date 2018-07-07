/*
Developer Name: Gorisha Mehrotra
Description: Trigger Handler on Contact Obj 
*/
public class ContactTriggerHandler {
    
    //updateContactsAddresses - Update Contact Mailing Address with associated Account's Billing Address
    public static void updateContactsAddresses(List<Contact> newContactList){
        //List of contacts to perform bulk dml
        List<Contact> contacts = new List<Contact>();
        for(Contact newContact : [Select AccountId,Account.BillingAddress From Contact Where Id IN :newContactList]){
            if(newContact.AccountId != null && newContact.Account.BillingAddress != null){
                //addr attribute used to map account address to contact address
                Address addr = (Address) newContact.Account.BillingAddress;
                Contact con = new Contact();
                con.Id = newContact.Id;
                con.MailingCity = addr.getCity();
                con.MailingCountry =  addr.getCountry();
                con.MailingStreet = addr.getStreet();
                con.MailingState = addr.getState();
                con.MailingPostalCode = addr.getPostalCode();
                contacts.add(con);
            }
        }
        try{
        	update contacts;
        }catch(System.DmlException e){
            // Process exception here
            for(Integer i = 0; i < e.getNumDml(); i++) {
				System.debug(e.getDmlMessage(i)+' at line -> '+e.getLineNumber());
            }
        }
    }
}