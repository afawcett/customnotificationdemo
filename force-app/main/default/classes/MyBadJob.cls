/**
  * Emulate a failing Batch Apex job
  *
  Database.executeBatch(new MyBadJob());
  */
public class MyBadJob implements Database.Batchable<sObject>, Database.RaisesPlatformEvents {

    public Database.QueryLocator start(Database.BatchableContext BC){
        throw new MyException('This is an error from MyBadBatchJob');
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) { }

    public void finish(Database.BatchableContext BC) { }

    public class MyException extends Exception { }
}