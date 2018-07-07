public class AccountFactory { 
	public static Integer count = 0;
    private static String generateRandom(){
        return String.valueOf(Integer.valueof((math.random() * 1000)));
    }
    public static void generateAccounts(Integer genNo){
        Account newAcc;
        List<Account> accounts = new List<Account>();
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        
        do {
            count = count +1;
            newAcc = new Account();
            newAcc.Name = 'Test Account'+generateRandom();
            newAcc.BillingStreet = 'Lawren Street'+generateRandom();
            newAcc.BillingCity = 'Lucknow'+generateRandom();
            newAcc.BillingState = 'UP'+generateRandom();
            newAcc.BillingCountry = 'India'+generateRandom();
            newAcc.BillingPostalCode = '226016'+generateRandom();
            accounts.add(newAcc);
        }while (genNo > count);
        Database.SaveResult[] srList = Database.insert(accounts, dml);
        System.debug(accounts);
    }

}