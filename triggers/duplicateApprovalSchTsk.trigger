//This Trigger is used to avoid duplicate value for Approval_Schedule_Task under any particular Approval Schedule Template.
trigger duplicateApprovalSchTsk on Approval_Schedule_Task__c(before insert,before update) 
{
 // To check approval Task Name for Insert oeration. (Start of Before insert event)
     if(Trigger.isBefore && Trigger.isInsert)
      {
        SET<string> inDb = new SET<string>();
        SET<Id> stTemp=new SET<Id>();
 
        MAP<string,Approval_Schedule_Task__c > inBatch = new MAP<string,Approval_Schedule_Task__c >();
        for(Approval_Schedule_Task__c st:Trigger.New)
         {   
           stTemp.add(st.Approval_Schedule_Template__c);
         }
    
        for(Approval_Schedule_Task__c t : [Select Id,Name,Approval_Schedule_Template__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c IN : stTemp WITH SECURITY_ENFORCED])
            inDb.add(t.Name+t.Approval_Schedule_Template__c );
           //inBatch.put(t.Name+t.Schedule_Template__c,t);
       

        for(Approval_Schedule_Task__c t : Trigger.New)
         {
          if(inDb.contains(t.Name+t.Approval_Schedule_Template__c))
          t.AddError('Task Name already Exists For this Template');
       
          else if (inBatch.containsKey(t.Name+t.Approval_Schedule_Template__c))
           {
             t.AddError('Duplicate in batch....');
           }
      
          else
           {
             inBatch.put(t.Name+t.Approval_Schedule_Template__c,t);
           }
         }
      }
    //End of Befor insert event.   

    // To check Task Name for update operation (Start of Before Update Event)
     If(Trigger.isBefore && Trigger.isUpdate)
      {
        String strTask1,strTask2;
        Set<Id> stTemp=new Set<Id>();
    
        for(Approval_Schedule_Task__c st:Trigger.New)
         {
            Approval_Schedule_Task__c  oldTask=Trigger.oldMap.get(st.id);
            strTask1=oldTask.Name;
            strTask2=st.Name;
            stTemp.add(st.Approval_Schedule_Template__c);
          }
        If(strTask1!=strTask2)
         {
            Map<String,Approval_Schedule_Task__c> inDB=new Map<String,Approval_Schedule_Task__c>();
            for(Approval_Schedule_Task__c  t:[Select Id,Name,Approval_Schedule_Template__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c In:stTemp WITH SECURITY_ENFORCED])
            inDB.put(t.Name+t.Approval_Schedule_Template__c,t);

            for(Approval_Schedule_Task__c s:Trigger.New)
             {    
                If(inDB.containsKey(s.Name+s.Approval_Schedule_Template__c))
                 {
                     s.AddError('Task Name already Exists For this Template');
                 }
             }
         }
      }
    //End of Before update event.
}
//End of Trigger