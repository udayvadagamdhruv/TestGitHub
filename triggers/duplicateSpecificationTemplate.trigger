// This trigger is used to avoid duplicate Specification_Template/Creative_Brief_Template.
trigger duplicateSpecificationTemplate on Specification_Template__c (before insert,before update,after insert,after update,before delete,after delete) 
 {
 
 //Start of Before_Insert of Before_Update event. (This event will be executed before record inserttion or before record updation) 
 if((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
 {
    Map<String,Specification_Template__c> STMap = new Map<String,Specification_Template__c>();
    for (Specification_Template__c st : System.Trigger.new) 
     {
        
        // Make sure we don't treat an Name that isn't changing during an update as a duplicate.  
    
        if ((st.Name != null) && (System.Trigger.isInsert || (st.Name != System.Trigger.oldMap.get(st.Id).Name))) 
        {
            // Make sure another new creative Brief Template isn't also a duplicate  
            if (STMap.containsKey(st.Name)) 
             {
                 st.Name.addError('Another new Specification Template has the '+'same Name.');
             } 
            else 
             {
                 STMap.put(st.Name,st);
             }
        }
     }
    
    /* Using a single database query, find all the Creative Brief Templates in the database that have the same Name as any  
    of the Creative Brief Template being inserted or updated. */ 
    
    for(Specification_Template__c si1:Trigger.New)
     {
      for (Specification_Template__c a : [SELECT Name FROM Specification_Template__c WHERE Name IN :STMap.KeySet() WITH SECURITY_ENFORCED]) 
       {
         if(si1.Name == a.Name)
         si1.Name.addError('A Creative Brief Template with Name '+a.Name+' already exists.');
       }
     }
 }
//End of Before_Insert of Before_Update event.
 

// If Any Job is associated with Specification Template then it should not be deleted.
 Set<Id> STIds = new Set<Id> (); 

//Start of Before_Delete event.
 if(Trigger.isDelete && Trigger.isBefore)
  {
               
       List<Id> Jobids = new List<Id>();
       STIds = trigger.oldMap.keyset(); 
           
      //check jobs associated
       for(Job__c a: [SELECT Id,Name,Specification_Template__c FROM Job__c WHERE Specification_Template__c IN :STIds WITH SECURITY_ENFORCED])
       {        
          Jobids.add(a.Specification_Template__c);
        
        // get the object from the Trigger Context
        Specification_Template__c errorObj = Trigger.oldMap.get(a.Specification_Template__c);
        
        if(errorObj != null)
        {
            // add an error to the object which will prevent this object from being deleted
            errorObj.addError('You cannot delete "'+errorObj.Name+'" Template.because,');
            for(Job__c job: [SELECT Id,Name,Specification_Template__c FROM Job__c WHERE Specification_Template__c =: errorObj.id WITH SECURITY_ENFORCED])
             {
              errorObj.addError('Job "'+job.Name+'" is associated.');
             }
            
        } 
        
        else 
        {
            System.debug('Somehow, Trigger.oldMap does not contain a Specification Template that is linked to Job, even though that Specification templates ID is in the Trigger.oldMap keyset');
            System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
            System.debug('-- Job: ' + a);
        }
       }
       //Remove STIDs from delete list that has Job association
       STIds.removeAll(Jobids);             
  }
 //End of Before Delete event.         
}
//End of Trigger.