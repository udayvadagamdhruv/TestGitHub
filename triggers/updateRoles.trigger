// This trigger code is used to update Roles field on Schedule Task. It contains Roles associated with Task separated by comma's
trigger updateRoles on ScheduleTaskRole__c(after insert,after update,after delete) 
{
    //Start of After_Insert event for ScheduleTaskRole__c Object
    If(Trigger.isInsert&&Trigger.isAfter)
    {
        // Gets ScheduleTaskRole__c related Schedule_Task__c ids
        Set<Id> jtIds = new Set<Id>();
        for (ScheduleTaskRole__c jtr : Trigger.new)
        {
            jtIds.add(jtr.Schedule_Task__c );
        }
        
        // Gets related Schedule_Task__c with ScheduleTaskRole__c 
        List<Schedule_Task__c > relatedJTR =[Select j.Name, (Select name From ScheduleTaskRole__r ) From Schedule_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related Schedule Tasks's Roles Field
        for(Schedule_Task__c j : relatedJTR)
        {     
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                j.Roles__c= ' '; 
            }
            
            for(ScheduleTaskRole__c jtr : j.ScheduleTaskRole__r )
            {
                if(jtr.name!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= jtr.name;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= '; ' + jtr.name; 
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.name==NULL)
                {
                    if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                        j.Roles__c+= '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Schedule_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Insert event.
    
    //Start of After_Update event.(This will be executed when ScheduleTaskRole__c is updated)  
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        // Gets Job_Task_Roles related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (ScheduleTaskRole__c jtr : Trigger.new)
        {
            jtIds.add(jtr.Schedule_Task__c );
        }
        
        // Gets related Schedule_Task__c with ScheduleTaskRole__c 
        List<Schedule_Task__c > relatedJTR =[Select j.Name, (Select name From ScheduleTaskRole__r) From Schedule_Task__c  j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Schedule_Task__c j : relatedJTR)
        { 
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                j.Roles__c = ' '; 
            }
            for(ScheduleTaskRole__c  jtr : j.ScheduleTaskRole__r )
            {
                if(jtr.Name!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= jtr.Name;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= '; ' + jtr.Name; 
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.Name==NULL)
                {
                    if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                        j.Roles__c+= '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Schedule_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Update Event.  
    
    //Start of After_Delete event for ScheduleTaskRole__c Object.(This trigger will be executed when current instance of ScheduleTaskRole__c is deleted) 
    if(Trigger.isDelete && Trigger.isAfter)
    {
        // Gets Job_Task_Roles related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (ScheduleTaskRole__c jtr : Trigger.old){
            jtIds.add(jtr.Schedule_Task__c );
        }
        
        // Gets related Job_Tasks with Job_Task_Roles
        List<Schedule_Task__c > relatedJTR =[Select j.Name, (Select Name From ScheduleTaskRole__r) From Schedule_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Schedule_Task__c j : relatedJTR)
        { 
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                j.Roles__c= ' '; 
            }
            
            for(ScheduleTaskRole__c  jtr : j.ScheduleTaskRole__r)
            {
                if(jtr.Name!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= jtr.Name;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= '; ' + jtr.Name; 
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.Name==NULL)
                {
                    if(Schema.sObjectType.Schedule_Task__c.fields.Roles__c.isUpdateable()){
                        j.Roles__c+= '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Schedule_Task__c.isUpdateable()){
            update relatedJTR;
        }
        //End of After_Delete event.  
    }
}
// End of Trigger Code