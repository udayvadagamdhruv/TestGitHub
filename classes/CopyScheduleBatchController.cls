public with sharing class CopyScheduleBatchController implements Database.Batchable<Job_Task_Role__c>,Database.AllowsCallouts,database.stateful 
{
     public List<Job_Task_Role__c> jtasksrolelist = new List<Job_Task_Role__c>();
     
     public CopyScheduleBatchController(List<Job_Task_Role__c> jtasksrole)
     {
         jtasksrolelist = jtasksrole;
     }
    
     public Iterable <Job_Task_Role__c> start(Database.Batchablecontext bc)
     {
        return jtasksrolelist;
     }
   
     Public void execute(Database.BatchableContext BC, List<Job_Task_Role__c> scope) 
     {
        List<Job_Task_Role__c> tasksroletobeupdated = new List<Job_Task_Role__c>();
        tasksroletobeupdated = scope;
         if(Schema.sObjectType.Job_Task_Role__c.isUpdateable() || Schema.sObjectType.Job_Task_Role__c.isCreateable()){
             upsert tasksroletobeupdated;}
     }
    
     Public void finish(Database.BatchableContext BC) 
     {
        
     }
   
}