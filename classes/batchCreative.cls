global class batchCreative implements Database.Batchable<sObject> {
 public string query;
 /*
public batchCreative()
{
  query = 'SELECT Id, Status_Notes__c, Creative_Overview__c FROM Job__c';   
}
public batchCreative(integer records)
{   
  query = 'SELECT Id, Status_Notes__c, Creative_Overview__c FROM Job__c limit 90';   
}*/

    global Database.QueryLocator start(Database.BatchableContext BC) {
       
        return Database.getQueryLocator('SELECT Id, Status_Notes__c, Creative_Overview__c FROM WITH SECURITY_ENFORCED Job__c');
    }
   
    global void execute(Database.BatchableContext BC, List<Job__c> scope) {
         list<Job__c> job=new list<Job__c>();
         
        for(Job__c j : scope)
        {
            if(j.Status_Notes__c!=null)
            {           
                if(schema.SobjectType.Job__c.Fields.Creative_Overview__c.isUpdateable()){
                    j.Creative_Overview__c = j.Status_Notes__c.replaceAll('\n', '<br/>');
                }
                job.add(j);
            }
        }
        if(Schema.sObjectType.Job__c.isUpdateable()) {
            update job;
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}