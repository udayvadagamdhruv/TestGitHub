//This Trigger is on Job Team Object,used for Update Staff on Job Task of same job.

trigger updateStaff on Job_Team__c (after insert)
{
    List<Job_Task_Role__c> lstJTRDelete=new List<Job_Task_Role__c>();
    List<Job_Task_Role__c> lstJTRInsert=new List<Job_Task_Role__c>();
    List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
    set<Id> JobIDS= new set<id>();
    
    //Start of Job Team update event.
    If(Trigger.isInsert)
    {
        Boolean blnFlag = false;
        
        for(Job_Team__c jt:Trigger.New)
        {
            
            JobIDS.add(jt.Job__c );
            
        }
        
        Map<Id,List<Job_Task__c >> jobIdToJobTaskMap = new Map<Id,List<Job_Task__c >>();
        Map<String,Job_Task__c > JobRoleToJobTaskMap = new Map<String,Job_Task__c>();
        for(Job_Task__c jobtask :[Select id,name ,Job__c ,Schedule_Roles__c from Job_Task__c  where Job__c IN : JobIDS and Marked_Done__c=false AND Schedule_Roles__c != NULL WITH SECURITY_ENFORCED])
        {
            if(jobIdToJobTaskMap.containsKey(jobTask.Job__c)){
                List<Job_Task__c> tempList = jobIdToJobTaskMap.get(jobTask.Job__c);
                tempList.add(jobtask);
                jobIdToJobTaskMap.put(jobTask.Job__c, tempList);
            }
            else{
                jobIdToJobTaskMap.put(jobTask.Job__c, new List<Job_Task__c>{jobtask});
            }
            /*for( string s : Schedule_Roles__c.split(';')){
JobRoleToJobTaskMap.put(
}*/
        }
        
        for(Job_Team__c jt:Trigger.New)
        {
            
            //for(Job_Task__c jobtask :[Select id,name  from Job_Task__c j where Job__c=:jt.Job__c and Marked_Done__c=false and Schedule_Roles__c INCLUDES(:jt.role__c)  ])
            if(jobIdToJobTaskMap.containsKey(jt.Job__c))
                for(Job_Task__c jobtask :jobIdToJobTaskMap.get(jt.Job__c) )
            {
                if(jobtask.Schedule_Roles__c!=NULL && jt.role__c != NULL)
                { 
                    if(jobtask.Schedule_Roles__c.contains(jt.role__c))
                    {
                        system.debug('jobtasklist'+jobtask.name);
                        
                        Job_Task_Role__c J2 = new Job_Task_Role__c ();
                        if(Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()){
                            J2.User__c=jt.Staff__c;
                        }
                        if(Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()){
                            J2.Name=jt.Role__c;
                        }
                        if(Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()){
                            J2.Job_Task__c = jobtask.id;
                        }
                        JobTaskRoleNew.add(J2);
                    } 
                }
            }   
            
        }              
        if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){
            insert JobTaskRoleNew ;
        }
        
    }     
    
}    

//End of Trigger.