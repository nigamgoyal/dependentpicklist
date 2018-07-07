public class ContactFactory {
    public static Integer count = 0;
    public static List<Contact> contacts;
    public static Contact con;
    
    public static List<Contact> generateContactsWithDiffAcc(Integer genNo, Boolean isAmount){
        contacts = new List<Contact>();
        AccountFactory.generateAccounts(10);
        for(Account acc: [Select Id from Account]){
            con = new Contact();
            con.LastName = 'Test Contact'+String.valueOf(Integer.valueof((math.random() * 100)));
            if(isAmount){
                con.AccountId = acc.Id;
            }
            contacts.add(con);
        }
        insert contacts;
        return contacts;
    }
    public static List<Contact> generateContactsWithSameAcc(Integer genNo, Boolean isAmount){
        contacts = new List<Contact>();
        AccountFactory.generateAccounts(1);
        Account acc = [Select Id from Account Limit 1];
        //issue - cannot update more than 10000 records in single transaction
        do{
            count = count +1;
            con = new Contact();
            con.LastName = 'Test Contact'+String.valueOf(Integer.valueof((math.random() * 100)));
            if(isAmount)
                con.AccountId = acc.Id;
            contacts.add(con);
        }while(genNo > count);
        insert contacts;
        return contacts;
    }
    public static Account generateContact(){
        Account acc = new Account();
        acc.Name = 'TestWithoutBillingAddress';
        insert acc;
        return acc;
    }
}