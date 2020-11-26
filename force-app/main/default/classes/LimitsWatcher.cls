public class LimitsWatcher {
    
    public static String caller;
    public static String snapshotLabel;
    
    public static void snapshot() {
        snapshot(false);
    }
    
    public static void snapshot(Boolean persist) {
        
        Request reqInfo = Request.getCurrent();
 		LimitWatcherEvent__e event = getEvent(persist);
        event.Transaction__c = reqInfo.getRequestId();
		event.Quiddity__c = String.valueOf(reqInfo.getQuiddity());        
        
        if (System.Limits.getLimitPublishImmediateDML() - System.Limits.getPublishImmediateDML() == 1 ) {
            event.isPersisted__c = true;
        }
        
        EventBus.publish(event);
    }
    
    public static void doPersist(List<LimitWatcherEvent__e> events) {
        
        List<LimitWatcherLog__c> logEntries = new List<LimitWatcherLog__c>();
            
            for (LimitWatcherEvent__e ev : events) {
                
                if (!ev.isPersisted__c) {
                    continue;
                }
                
                logEntries.add(createSObject(ev));
            }
        
        insert logEntries;
        
    }
    
    private static LimitWatcherEvent__e getEvent(Boolean persist) {
        
        return new LimitWatcherEvent__e(
            AggregateQueries__c	= System.Limits.getAggregateQueries(),
			AsyncCalls__c = System.Limits.getAsyncCalls(),
			CallContext__c = caller,
			Callouts__c	= System.Limits.getCallouts(),
			CpuTime__c	= System.Limits.getCpuTime(),
			DMLRows__c = System.Limits.getDMLRows(),
			DMLStatements__c = System.Limits.getDMLStatements(), 
			EmailInvocations__c = System.Limits.getEmailInvocations(),
            FutureCalls__c = System.Limits.getFutureCalls(),
            HeapSize__c = System.Limits.getHeapSize(),
            MobilePushApexCalls__c = System.Limits.getMobilePushApexCalls(),
            isPersisted__c = persist,
            PublishImmediateDML__c = System.Limits.getPublishImmediateDML(),
            Queries__c	= System.Limits.getQueries(),
            QueryLocatorRows__c	= System.Limits.getQueryLocatorRows(),
            QueryRows__c = System.Limits.getQueryRows(),
            QueueableJobs__c = System.Limits.getQueueableJobs(),
            Quiddity__c = '',
            SnapshotLabel__c = snapshotLabel,
            SoslQueries__c = System.Limits.getSoslQueries(),
            Transaction__c = ''
       );
    }
    
    private static LimitWatcherLog__c createSObject(LimitWatcherEvent__e ev) {
        
        return new LimitWatcherLog__c(
            AggregateQueries__c	= ev.AggregateQueries__c,
            AsyncCalls__c = ev.AsyncCalls__c,
			CallContext__c = ev.CallContext__c,
			Callouts__c	= ev.Callouts__c,
			CpuTime__c	= ev.CpuTime__c,
			DMLRows__c = ev.DMLRows__c,
			DMLStatements__c = ev.DMLStatements__c, 
			EmailInvocations__c = ev.EmailInvocations__c,
            FutureCalls__c = ev.FutureCalls__c,
            HeapSize__c = ev.HeapSize__c,
            MobilePushApexCalls__c = ev.MobilePushApexCalls__c,
            PublishImmediateDML__c = ev.PublishImmediateDML__c,
            Queries__c	= ev.Queries__c,
            QueryLocatorRows__c	= ev.QueryLocatorRows__c,
            QueryRows__c = ev.QueryRows__c,
            QueueableJobs__c = ev.QueueableJobs__c,
            OperationType__c = ev.Quiddity__c,
            SnapshotLabel__c = ev.SnapshotLabel__c,
            SoslQueries__c = ev.SoslQueries__c,
            Transaction__c = ev.Transaction__c
        );
    }
    
}