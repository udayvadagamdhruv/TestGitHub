//This Trigger is used to avoid duplicate value for Spec Item under any particular Specification_Template/Creative_brief_template.

trigger DuplicateSpecItem on Spec_Item__c (before insert,before update) 
 {
   //Start of Before Insert event.
    if(Trigger.isBefore && Trigger.isInsert)
    {
        SET<string> inDb = new SET<string>();
        SET<Id> stTemp=new SET<Id>();
 
        MAP<string,Spec_Item__c> inBatch = new MAP<string,Spec_Item__c>();
        for(Spec_Item__c st:Trigger.New)
        {   
            stTemp.add(st.Specification_Template__c);
        }
        
        for ( Spec_Item__c t : [Select Id,Name,Specification_Template__c from Spec_Item__c where Specification_Template__c IN : stTemp WITH SECURITY_ENFORCED])
        inDb.add(t.Name+t.Specification_Template__c);
       //inBatch.put(t.Name+t.Specification_Template__c,t);
       
        for ( Spec_Item__c t : Trigger.New)
        {
            if (inDb.contains(t.Name+t.Specification_Template__c))
                t.AddError('Spec Temp Name already Exists For this Template');
    
           else if (inBatch.containsKey(t.Name+t.Specification_Template__c))
           {
                t.AddError('Duplicate in batch....');
              //inBatch.get(t.Name+t.Specification_Template__c).AddError('Dup in Batch'); 
           }
           
           else
           {
                inBatch.put(t.Name+t.Specification_Template__c,t);
           }
        }
    }
  //End of Before insert Event.  

  //Start of Before Update Event.(This trigger will be executed when current instance of Spec_Item is updated)
    If(Trigger.isBefore && Trigger.isUpdate)
    {
        String strTask1,strTask2;
        Set<Id> stTemp=new Set<Id>();
    
        for(Spec_Item__c st:Trigger.New)
        {
            Spec_Item__c oldTask=Trigger.oldMap.get(st.id);
            strTask1=oldTask.Name;
            strTask2=st.Name;
            stTemp.add(st.Specification_Template__c);
         }
        If(strTask1!=strTask2)
        {
            Map<String,Spec_Item__c> inDB=new Map<String,Spec_Item__c>();
            for(Spec_Item__c t:[Select Id,Name,Specification_Template__c from Spec_Item__c where Specification_Template__c In:stTemp WITH SECURITY_ENFORCED])
            inDB.put(t.Name+t.Specification_Template__c,t);

            for(Spec_Item__c s:Trigger.New)
            {    
                If(inDB.containsKey(s.Name+s.Specification_Template__c))
                {
                     s.AddError('Spec Temp Name already Exists For this Template');
                }
            }
        }
    }
   //End of Before update event. 
}
// End of Trigger