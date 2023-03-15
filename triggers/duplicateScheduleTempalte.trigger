// This trigger is used fo checking duplicate and it will avoid deleting Schedule Template if it is associated with ant\y Job record
trigger duplicateScheduleTempalte on Schedule_Template__c (before insert,before update,after insert,after update,before delete,after delete) 
{
    if((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    { 
        Map<String,Schedule_Template__c> STMap = new Map<String,Schedule_Template__c>();
        for (Schedule_Template__c st : System.Trigger.new) 
         {
        
            // Make sure we don't treat an Name that  
    
            // isn't changing during an update as a duplicate.  
    
            If ((st.Name != null) && (System.Trigger.isInsert || (st.Name != System.Trigger.oldMap.get(st.Id).Name))) 
            {
        
                // Make sure another new Account isn't also a duplicate  
    
                If (STMap.containsKey(st.Name)) 
                {
                    st.Name.addError('Another new Schedule Template has the '+'same Name.');
                } 
                Else 
                {
                    STMap.put(st.Name,st);
                }
           }
        }
    
        // Using a single database query, find all the Schedule Templates in  
    
        // the database that have the same Name as any  
    
        // of the Schedule Template being inserted or updated.  
        for(Schedule_Template__c si1:Trigger.New)
        {
             for (Schedule_Template__c a : [SELECT Name FROM Schedule_Template__c WHERE Name IN :STMap.KeySet() WITH SECURITY_ENFORCED]) 
             {
                If(si1.Name == a.Name)
                    si1.Name.addError('A Schedule Template with Name '+a.Name+' already exists.');
             }
        }
    } 

    // Trigger code will be executed before Schedule Template gets deleted
    Set<Id> STIds = new Set<Id> (); 

    If(Trigger.isDelete && Trigger.isBefore)
    {
           List<Id> Jobids = new List<Id>();
           STIds = trigger.oldMap.keyset(); 
           
            //check jobs associated
           for(Job__c a: [SELECT Id,Name,Schedule_Template__c FROM Job__c WHERE Schedule_Template__c IN :STIds WITH SECURITY_ENFORCED])
           {        
              Jobids.add(a.Schedule_Template__c);
        
            // get the object from the Trigger Context
            Schedule_Template__c errorObj = Trigger.oldMap.get(a.Schedule_Template__c);
        
            If(errorObj != null)
            {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('you cannot delete "'+errorObj.Name+'" Template.Because,');
            
                for(Job__c job:[select id,Name,Schedule_Template__c from Job__c where schedule_template__c =: errorObj.id WITH SECURITY_ENFORCED])
                {
                    errorObj.addError('Job "'+job.Name+'" is associated.');
                }
            } 
           Else 
           {
                System.debug('Somehow, Trigger.oldMap does not contain a Schedule Template that is linked to Job, even though that Schedule templates ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Job: ' + a);
           }
        }
       //Remove STIDs from delete list that has Job association
       STIds.removeAll(Jobids);             
   } // End of code to be executed before Schedule Template gets deleted 
}// End of Trigger Code