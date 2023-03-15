// This trigger is used to avoid duplicate Media Type and Media Type should not be deleted if they are associated with Job
trigger avoidDuplicateMediaType on Media_Type__c (before insert,before update,after insert,after update,before delete,after delete)
{
    // To check for Duplicate Jobs
    If((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    {
          Map<String,Media_Type__c> MTMap = new Map<String,Media_Type__c>();
          for (Media_Type__c MT : System.Trigger.new) 
         {
        
            // Make sure we don't treat an Name that isn't changing during an update as a duplicate. 
    
            if ((MT.Name != null) && (System.Trigger.isInsert || (MT.Name != System.Trigger.oldMap.get(MT.Id).Name))) 
            {
        
                // Make sure another new creative Brief Template isn't also a duplicate  
    
                if (MTMap.containsKey(MT.Name)) 
                {
                    MT.Name.addError('Another new Medai Type has the '+'same Name.');
                } 
                else 
                {
                    MTMap.put(MT.Name,MT);
                }
           }
        }
    
        // Using a single database query, find all the Media Types in the database that have the same Name as any of the Media Type being inserted or updated. */ 
    
        for(Media_Type__c NewMT:Trigger.New)
        {
             for (Media_Type__c MT : [SELECT Name FROM Media_Type__c WHERE Name IN :MTMap.KeySet() WITH SECURITY_ENFORCED]) 
             {
                if(NewMT.Name == MT.Name)
                    NewMT.Name.addError('A Media Type with Name '+MT.Name+' already exists.');
             }
        }
    }

    // If Any Job is associated with Media Type then it should not be deleted
    Set<Id> MTIds = new Set<Id> (); 
    If(Trigger.isDelete && Trigger.isBefore)
    {
           List<Id> Jobids = new List<Id>();
           MTIds = trigger.oldMap.keyset(); 
           
            //check jobs associated
           for(Job__c a: [SELECT Id,Name,Media_Types__c FROM Job__c WHERE Media_Types__c IN :MTIds WITH SECURITY_ENFORCED])
           {        
              Jobids.add(a.Media_Types__c);
        
              // get the object from the Trigger Context
              Media_Type__c errorObj = Trigger.oldMap.get(a.Media_Types__c);
        
             if(errorObj != null)
            {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "'+errorObj.Name+'" media type.Because,');
            
                for(Job__c job: [SELECT Id,Name,Media_Types__c FROM Job__c WHERE Media_Types__c =: errorObj.id WITH SECURITY_ENFORCED])
                {
                    errorObj.addError('Job "'+job.Name+'" is associated.');
                }
            } 
           else 
           {
                System.debug('Somehow, Trigger.oldMap does not contain a Media Type that is linked to Job, even though that Media Type ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Job: ' + a);
           }
      }
       //Remove MTIDs from delete list that has Job association
       MTIds.removeAll(Jobids);             
    }// End of Before Delete part of trigger

}// End of trigger