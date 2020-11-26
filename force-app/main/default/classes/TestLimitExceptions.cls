public class TestLimitExceptions {
    
    public static void test10001DMLRows() {
        
        List<Account> accs = new List<Account>();
        
        for (Integer i = 0; i < 10001; i++) {
            accs.add(new Account(name='Acc #'+i));
        }
                     
                     try {
                         insert accs;
                     }
                     catch (Exception e) {
                         System.debug(e.getMessage());
                     }
    }
    
    public static void test5000Rows() {
        
        LimitsWatcher.caller = 'TestLimitException.test5000Rows()';
        LimitsWatcher.snapshotLabel = 'Run ' + String.valueOf(Date.today());
        
        List<Account> accs = new List<Account>();
        
        LimitsWatcher.snapshot(true);
        
        for (Integer i = 0; i < 5000; i++) {
            accs.add(new Account(name='Acc #'+i, BillingCity = 'TestRun'));
        }
                     
                     try {
                         insert accs;
                         LimitsWatcher.snapshot();
                     }
                     catch (Exception e) {
                         System.debug(e.getMessage());
                         LimitsWatcher.snapshot();
                     }
        List<Account> accs2 = [SELECT Id, Name, BillingCity FROM Account WHERE BillingCity = 'TestRun' LIMIT 5000 ];
        LimitsWatcher.snapshot(true);
        delete accs2;
        LimitsWatcher.snapshot(true);
    }

}