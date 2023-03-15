Public with sharing class  MassUpdateBatchController implements Database.Batchable<job_task__c>,Database.AllowsCallouts,database.stateful
{
     public List<job_task__c> jtaskslist = new List<job_task__c>();
    // public list<Production_Estimate__c> PElist = new list<Production_Estimate__c>();
     
     public MassUpdateBatchController(List<job_task__c> jtasks)
     {
        // PElist = PEli;
         jtaskslist = jtasks;
     }
    
    
    
    public Iterable <job_task__c> start(Database.Batchablecontext bc)
     {

        return jtaskslist;
     }
   
    Public void execute(Database.BatchableContext BC, List<job_task__c> scope) 
    {
        List<job_task__c> taskstobeupdated = new List<job_task__c>();
        taskstobeupdated = scope;
         if(Schema.sObjectType.job_task__c.isUpdateable()){
        update taskstobeupdated;
         }
    }
    
    Public void finish(Database.BatchableContext BC) 
    {
        
    }


}