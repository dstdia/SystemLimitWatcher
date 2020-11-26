trigger LimitsWatcherTrigger on LimitWatcherEvent__e (after insert) {

    LimitsWatcher.doPersist(Trigger.new);
}