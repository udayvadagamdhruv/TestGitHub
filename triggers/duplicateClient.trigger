// This trigger is used to avoid Duplicate Clients record based on their Name and It also avoid deletion of client if any Job is associated with them
trigger duplicateClient on Client__c (before insert,before update,after insert,after update,before delete,after delete) 
{
    if((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    {            
        Map<String,Client__c> AccountMap = new Map<String,Client__c>();
        for (Client__c a : System.Trigger.new) 
        {
        
            // Make sure we don't treat an Name that  
    
            // isn't changing during an update as a duplicate.  
    
               if ((a.Name != null) && (System.Trigger.isInsert || (a.Name != System.Trigger.oldMap.get(a.Id).Name))) 
               {
        
                    // Make sure another new Client isn't also a duplicate  
    
                if (AccountMap.containsKey(a.Name)) 
                {
                    a.Name.addError('Another new Client has the '+'same Name.');
                } 
                else 
                {
                    AccountMap.put(a.Name,a);
                }
               }
        }
    
        // Using a single database query, find all the Clients in  
    
        // the database that have the same Name as any  
    
        // of the Clients being inserted or updated.  
        for(Client__c si1:Trigger.New)
        {
             for (Client__c a : [SELECT Name FROM Client__c WHERE Name IN :AccountMap.KeySet() WITH SECURITY_ENFORCED]) 
             {
                if(si1.Name == a.Name)
                si1.Name.addError('A Client with Name '+a.Name+' already exists.');
             }
        }
    }    
     
    // If any Job is associated with Client then it should not be deleted 
    Set<Id> AccountIds = new Set<Id> (); 
    if(Trigger.isDelete && Trigger.isBefore)
    {
           List<Id> Jobids = new List<Id>();
           AccountIds = trigger.oldMap.keyset(); 
           
            //check jobs associated
           for(Job__c a: [SELECT Id,Name,JS_Client__c FROM Job__c WHERE JS_Client__c IN :AccountIds WITH SECURITY_ENFORCED])
           {        
              Jobids.add(a.JS_Client__c);
        
             // get the object from the Trigger Context
              Client__c errorObj = Trigger.oldMap.get(a.JS_Client__c);
        
              if(errorObj != null)
              {
                    // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You cannot delete "'+errorObj.Name+'".Because,');
                    for(Job__c job: [select id,Name,JS_Client__c from job__c where JS_client__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                        errorObj.addError('Job "'+job.Name+'" is associated. ');
                    }
              } 
              else 
              {
                    System.debug('Somehow, Trigger.oldMap does not contain a Client that is linked to Job, even though that Client ID is in the Trigger.oldMap keyset');
                    System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                    System.debug('-- Job: ' + a);
              }
           }
           //Remove AccountIDs from delete list that has Job association
            AccountIds.removeAll(Jobids);             
    
     }// End of Deletion Part of Trigger
}// End of Trigger