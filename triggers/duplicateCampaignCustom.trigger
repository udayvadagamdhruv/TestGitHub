// This trigger is used to avoid duplicate Campaigns and avoid deletion of Campaign if jobs are associated
trigger duplicateCampaignCustom on Campaign__c (before insert,before update,before delete,after delete)
{

    If((Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))){
     for (Campaign__c caName : System.Trigger.new) 
      {
        if(caName.Name==null || caName.Name==''){
        caName.Name.addError('Campaign Name is required');
        }
      }
    
    }

  If((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    {
      Map<String,Campaign__c> cMap = new Map<String,Campaign__c>();
      for (Campaign__c camp : System.Trigger.new) 
      {
          if ((camp.Name != null) && (System.Trigger.isInsert || (camp.Name != System.Trigger.oldMap.get(camp.Id).Name))) 
          {
           
              // Make sure another new Campaign isn't also a duplicate 
       
              if (cMap.containsKey(camp.Name)) 
              {
                  camp.Name.addError('Another Campaign has the '+'same Name.');
              } 
              else
              {
                  cMap.put(camp.Name,camp);
              }
         }  
      }
      
      for (Campaign__c c1 : [SELECT Name FROM Campaign__c WHERE Name IN :cMap.KeySet() WITH SECURITY_ENFORCED]) 
      {
          Campaign__c obj = cMap.get(c1.Name);
          obj.Name.addError('A Campaign with '+obj.Name+' already exists.');
      }
   }   
      
     
      
   // Campaign will not be deleted if any Job is associated with this.
    SET<Id> Job_Ids = new SET<Id> ();
    
    If(Trigger.isDelete && Trigger.isBefore)
    {
         List<Id> Jobids = new List<Id>();
         Job_Ids = trigger.oldMap.keyset(); 
           
         //check Job associated
         for(Job__c j: [SELECT Id,Name,Campaign__c FROM Job__c WHERE Campaign__c IN :Job_Ids WITH SECURITY_ENFORCED])
          {        
               Jobids.add(j.Campaign__c);
          
               // get the object from the Trigger Context
               Campaign__c errorObj = Trigger.oldMap.get(j.Campaign__c);
        
               If(errorObj != null)
               {
                    // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You have jobs assigned to this Campaign. It cannot be deleted.');
                    for(Job__c job: [SELECT Id,Name,Campaign__c FROM Job__c WHERE Campaign__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                          errorObj.addError('Job "'+job.Name+'"');
                    }
               } 
               Else 
               {
                   System.debug('Somehow, Trigger.oldMap does not contain a Campaign that is linked to Job, even though that Campaign ID is in the Trigger.oldMap keyset');
                   System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                   System.debug('-- Job: ' + j);
               }
          }
         
         //Remove Jobids from delete list that has Job association
         Job_Ids.removeAll(Jobids);  
       }  
   // End of Before Delete event. 
       
}// End of Trigger