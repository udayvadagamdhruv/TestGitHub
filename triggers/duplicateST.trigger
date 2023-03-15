//This Trigger is used to avoid duplicate value for Schedule Task under any particular Schedule Template.
trigger duplicateST on Schedule_Task__c (before insert,before update) 
{
 // To check Task Name for Insert oeration. (Start of Before insert event)
     if(Trigger.isBefore && Trigger.isInsert)
      {
        SET<string> inDb = new SET<string>();
        SET<Id> stTemp=new SET<Id>();
 
        MAP<string,Schedule_Task__c> inBatch = new MAP<string,Schedule_Task__c>();
        for(Schedule_Task__c st:Trigger.New)
         {   
           stTemp.add(st.Schedule_Template__c);
         }
    
        for( Schedule_Task__c t : [Select Id,Name,Schedule_Template__c from Schedule_Task__c where Schedule_Template__c IN : stTemp WITH SECURITY_ENFORCED])
            inDb.add(t.Name+t.Schedule_Template__c);
           //inBatch.put(t.Name+t.Schedule_Template__c,t);
       

        for( Schedule_Task__c t : Trigger.New)
         {
          if(inDb.contains(t.Name+t.Schedule_Template__c))
          t.AddError('Task Name already Exists For this Template');
       
          else if (inBatch.containsKey(t.Name+t.Schedule_Template__c))
           {
             t.AddError('Duplicate in batch....');
            //inBatch.get(t.Name+t.Schedule_Template__c).AddError('Dup in Batch'); 
           }
      
          else
           {
             inBatch.put(t.Name+t.Schedule_Template__c,t);
           }
         }
      }
    //End of Befor insert event.   

    // To check Task Name for update oeration (Start of Before Update Event)
     If(Trigger.isBefore && Trigger.isUpdate)
      {
        String strTask1,strTask2;
        Set<Id> stTemp=new Set<Id>();
    
        for(Schedule_Task__c st:Trigger.New)
         {
            Schedule_Task__c oldTask=Trigger.oldMap.get(st.id);
            strTask1=oldTask.Name;
            strTask2=st.Name;
            stTemp.add(st.Schedule_Template__c);
          }
        If(strTask1!=strTask2)
         {
            Map<String,Schedule_Task__c> inDB=new Map<String,Schedule_Task__c>();
            for(Schedule_Task__c t:[Select Id,Name,Schedule_Template__c from Schedule_Task__c where Schedule_Template__c In:stTemp WITH SECURITY_ENFORCED])
            inDB.put(t.Name+t.Schedule_Template__c,t);

            for(Schedule_Task__c s:Trigger.New)
             {    
                If(inDB.containsKey(s.Name+s.Schedule_Template__c))
                 {
                     s.AddError('Task Name already Exists For this Template');
                 }
             }
         }
      }
    //End of Before update event.
}
//End of Trigger