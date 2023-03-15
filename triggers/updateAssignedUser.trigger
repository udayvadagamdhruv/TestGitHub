// This trigger code is used to update Staff field on Job_Task. It contains Staff associated with Task separated by comma's
trigger updateAssignedUser on Job_Task_Role__c (after insert,after update,after delete) 
{
    //Start of After_Insert event for Job_Task_Role Object
    If(Trigger.isInsert&&Trigger.isAfter)
    {
        // Gets Job_Task_Roles related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (Job_Task_Role__c jtr : Trigger.new)
        {
            jtIds.add(jtr.Job_Task__c);
        }
        
        // Gets related Job_Tasks with Job_Task_Roles
        List<Job_Task__c> relatedJTR =[Select j.Name, (Select User__c From Job_Task_Roles__r) From Job_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Job_Task__c j : relatedJTR)
        {     
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                j.Assigned_Users__c = ' '; 
            }
            
            for(Job_Task_Role__c jtr : j.Job_Task_Roles__r)
            {
                if(jtr.User__c!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                            j.Assigned_Users__c += jtr.User__c;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                            j.Assigned_Users__c += ', ' + jtr.User__c;
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.User__c==NULL)
                {
                    if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                        j.Assigned_Users__c += '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Insert event.
    
    //Start of After_Update event.(This will be executed when Job_Task_Role is updated)  
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        // Gets Job_Task_Roles related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (Job_Task_Role__c jtr : Trigger.new)
        {
            jtIds.add(jtr.Job_Task__c);
        }
        
        // Gets related Job_Tasks with Job_Task_Roles
        List<Job_Task__c> relatedJTR =[Select j.Name, (Select User__c From Job_Task_Roles__r) From Job_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Job_Task__c j : relatedJTR)
        { 
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                j.Assigned_Users__c = ' '; 
            }
            
            for(Job_Task_Role__c jtr : j.Job_Task_Roles__r)
            {
                if(jtr.User__c!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                            j.Assigned_Users__c += jtr.User__c;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                            j.Assigned_Users__c += ', ' + jtr.User__c;
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.User__c==NULL)
                {
                    if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                        j.Assigned_Users__c += '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Update Event.  
    
    //Start of After_Delete event for Job_Task_Role Object.(This trigger will be executed when current instance of Job_Task_Role is deleted) 
    if(Trigger.isDelete && Trigger.isAfter)
    {
        // Gets Job_Task_Roles related Job_Tasks ids
        Set<Id> jtIds = new Set<Id>();
        for (Job_Task_Role__c jtr : Trigger.old){
            jtIds.add(jtr.Job_Task__c);
        }
        
        // Gets related Job_Tasks with Job_Task_Roles
        List<Job_Task__c> relatedJTR =[Select j.Name, (Select User__c From Job_Task_Roles__r) From Job_Task__c j where id in: jtIds WITH SECURITY_ENFORCED];
        
        // set each related JobTasks's AssignedUser Field
        for(Job_Task__c j : relatedJTR)
        { 
            // Used to not add ',' on first user
            Boolean isFirst = true;
            if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                j.Assigned_Users__c = ' '; 
            }
            
            for(Job_Task_Role__c jtr : j.Job_Task_Roles__r)
            {
                if(jtr.User__c!=NULL)
                {
                    if(isFirst)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                            j.Assigned_Users__c += jtr.User__c;
                        }
                        isFirst = false;
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                            j.Assigned_Users__c += ', ' + jtr.User__c;
                        }
                        //isFirst = true;
                    }
                }
                if(jtr.User__c==NULL)
                {
                    if(Schema.sObjectType.Job_Task__c.fields.Assigned_Users__c.isUpdateable()){
                        j.Assigned_Users__c += '';
                    }
                    // isFirst=true;
                }
            } 
        }
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            update relatedJTR;
        }
    }
    //End of After_Delete event.  
    
}
// End of Trigger Code