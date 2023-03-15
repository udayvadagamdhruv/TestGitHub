// This trigger code is used to update Roles field on Approval Schedule Task. It contains Roles associated with Task separated by comma's
trigger updateApprovalRoles on Approval_Schedule_Task_Role__c (after insert,after update,after delete) 
{
    //Start of After_Insert event for Approval_Schedule_Task_Role__c Object
    If(Trigger.isInsert&&Trigger.isAfter)
    {
        // Gets Approval_Schedule_Task_Role__c related Approval_Schedule_Task__c ids
        Set<Id> jtIds = new Set<Id>();
        for (Approval_Schedule_Task_Role__c jtr : Trigger.new)
        {
            jtIds.add(jtr.Approval_Schedule_Task__c);
        }
        
        // Gets related Approval_Schedule_Task__c with ScheduleTaskRole__c 
        List<Approval_Schedule_Task__c> relatedJTR =[Select j.Name, (Select name From Approval_Schedule_Task_Role__r) From Approval_Schedule_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related Approval Schedule Tasks's Roles Field
        for(Approval_Schedule_Task__c j : relatedJTR)
        {     
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                j.Roles__c= ' '; 
            }
            
            for(Approval_Schedule_Task_Role__c  jtr : j.Approval_Schedule_Task_Role__r)
            {
                if(jtr.name!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= jtr.name;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= '; ' + jtr.name; 
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.name==NULL)
                {
                    if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                        j.Roles__c+= '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Approval_Schedule_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Insert event.
    
    //Start of After_Update event.(This will be executed when Approval_Schedule_Task_Role is updated)  
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        // Gets Approval_Schedule_Task_Role__c related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (Approval_Schedule_Task_Role__c jtr : Trigger.new)
        {
            jtIds.add(jtr.Approval_Schedule_Task__c);
        }
        
        // Gets related Approval_Schedule_Task__c with ScheduleTaskRole__c 
        List<Approval_Schedule_Task__c> relatedJTR =[Select j.Name, (Select name From Approval_Schedule_Task_Role__r) From Approval_Schedule_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Approval_Schedule_Task__c j : relatedJTR)
        { 
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                j.Roles__c = ' '; 
            }
            for(Approval_Schedule_Task_Role__c jtr : j.Approval_Schedule_Task_Role__r)
            {
                if(jtr.Name!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= jtr.Name;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= '; ' + jtr.Name; 
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.Name==NULL)
                {
                    if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                        j.Roles__c+= '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Approval_Schedule_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Update Event.  
    
    //Start of After_Delete event for Approval_Schedule_Task_Role__c Object.(This trigger will be executed when current instance of Approval_Schedule_Task_Role__c is deleted) 
    if(Trigger.isDelete && Trigger.isAfter)
    {
        // Gets Job_Task_Roles related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (Approval_Schedule_Task_Role__c jtr : Trigger.old){
            jtIds.add(jtr.Approval_Schedule_Task__c);
        }
        
        // Gets related Job_Tasks with Job_Task_Roles
        List<Approval_Schedule_Task__c > relatedJTR =[Select j.Name, (Select Name From Approval_Schedule_Task_Role__r) From Approval_Schedule_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Approval_Schedule_Task__c j : relatedJTR)
        { 
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                j.Roles__c= ' '; 
            }
            
            for(Approval_Schedule_Task_Role__c jtr : j.Approval_Schedule_Task_Role__r)
            {
                if(jtr.Name!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= jtr.Name;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                            j.Roles__c+= '; ' + jtr.Name; 
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.Name==NULL)
                {
                    if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Roles__c.isUpdateable()){
                        j.Roles__c+= '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Approval_Schedule_Task__c.isUpdateable()){
            update relatedJTR;
        }
        //End of After_Delete event.  
    }
}
// End of Trigger Code