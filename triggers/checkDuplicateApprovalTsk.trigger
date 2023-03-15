// This trigger is used to check duplicate Approval_Job_Tasks
trigger checkDuplicateApprovalTsk on Approval_Job_Task__c(before insert,before update,after insert, after update,after delete) 
{
    
    // Check for duplicate Job Approval Task under one file
    If((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate))
    {
        Set<Id> stTemp=new Set<Id>();  
        Set<Id> JobTaskId=new Set<Id>();
        for(Approval_Job_Task__c st:Trigger.New)  
        {  
            stTemp.add(st.Job__c);           
        }
        
        for(Approval_Job_Task__c st1:Trigger.New){
            
            if(st1.Task_Order__c==1){
                if(Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isCreateable() || Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isUpdateable()) {
                    st1.Next_Task_Due__c=True;
                }
                
            }
            
        }
        
        MAP<String,Approval_Job_Task__c>  inDb = new MAP<String,Approval_Job_Task__c>(); 
        MAP<String,Approval_Job_Task__c> inBatch = new MAP<String,Approval_Job_Task__c>();
        
        MAP<String,Approval_Job_Task__c>  JobTaskNameWithApprovalTask = new MAP<String,Approval_Job_Task__c>();
        for(Approval_Job_Task__c st:Trigger.New)
        {   
            stTemp.add(st.Job__c);
            JobTaskId.add(st.Task__c);
        }
        
        for(Approval_Job_Task__c t : [Select Id,Name,Job__c,File_Name__c,File_ID__c,Task__c,Created_From_Job_Task__c from Approval_Job_Task__c where Job__c IN : stTemp WITH SECURITY_ENFORCED])
        {
            inDb.put(t.Name+t.Job__c+t.File_Name__c,t);
        }  
        
        for(Approval_Job_Task__c t : [Select Id,Name,Job__c,File_Name__c,File_ID__c,Task__c,Created_From_Job_Task__c from Approval_Job_Task__c where Job__c IN : JobTaskId WITH SECURITY_ENFORCED])
        {
            JobTaskNameWithApprovalTask.put(t.Name+t.Task__c+t.File_Name__c,t);
        }  
        
        for(Approval_Job_Task__c t : Trigger.New)
        {
            
            if(t.Created_From_Job_Task__c==true){
                If (JobTaskNameWithApprovalTask.containsKey(t.Name+t.Task__c+t.File_Name__c)) 
                {
                    If(Trigger.isInsert || t.id!=JobTaskNameWithApprovalTask.get(t.Name+t.Task__c+t.File_Name__c).Id) //if update then ignore itself as a dup
                        t.AddError('Task Name already Exists for this Task Aproval process');
                }
                Else If (inBatch.containsKey(t.Name+t.Task__c+t.File_Name__c))
                {
                    t.AddError('Duplicate in batch....');
                }
                Else
                {
                    inBatch.put(t.Name+t.Task__c+t.File_Name__c,t);
                }
            }   
            else{
                If (inDb.containsKey(t.Name+t.Job__c+t.File_Name__c)) 
                {
                    If(Trigger.isInsert || t.id!=inDb.get(t.Name+t.Job__c+t.File_Name__c).Id) //if update then ignore itself as a dup
                        t.AddError('Task Name already Exists for this Job Aproval process');
                }
                Else If (inBatch.containsKey(t.Name+t.Job__c+t.File_Name__c))
                {
                    t.AddError('Duplicate in batch....');
                }
                Else
                {
                    inBatch.put(t.Name+t.Job__c+t.File_Name__c,t);
                }
            }
        }
    }// End of Checking for Duplicates
    
    if(Trigger.IsAfter &&  Trigger.IsUpdate)
    {
        //Id  userId = userinfo.getUserId();
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        list<string> Tskids=new list<string>();
        Set <String> JobTaskID = New Set <String> (); 
        for(Approval_Job_Task__c objJT:Trigger.New)
        {
            if (objJT.Task__c != Null ) { 
                JobTaskID.add (objJT.Task__c); 
            } 
            If (JobTaskID.size ()> 0) { 
                List <Job_Task__c> upJobTaskList = new List <Job_Task__c> (); 
                For (Job_Task__c jobTsk: [SELECT Id, Has_Approval_steps__c FROM Job_Task__c WHERE id in: JobTaskID AND Has_Approval_steps__c != True]) { 
                         jobTsk.Has_Approval_steps__c = true; 
                         upJobTaskList.add (jobTsk); 
                     } 
                If (upJobTaskList.size ()> 0) 
                    update upJobTaskList; 
            } 
            system.debug('>>>>>>>>>> After Trigger Fires >>>>>>>>>>>>>>>>');
            if (setting.Custom_Notification__c == true)
            {
                if((Trigger.oldMap.get(objJT.Id).Status__c=='Pending' || Trigger.oldMap.get(objJT.Id).Status__c=='Changes Needed')  && Trigger.NewMap.get(objJT.Id).Status__c=='In Progress'){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.InprogressEmailNotification(Tskids);
                }
                if((Trigger.oldMap.get(objJT.Id).Status__c=='In Progress' && Trigger.NewMap.get(objJT.Id).Status__c=='pending') || (Trigger.oldMap.get(objJT.Id).Undo__c==false && Trigger.NewMap.get(objJT.Id).Undo__c==true)){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.UndoEmailNotification(Tskids);
                }
                if(Trigger.oldMap.get(objJT.Id).Status__c=='In Progress' && Trigger.NewMap.get(objJT.Id).Status__c=='Changes Needed' && Trigger.NewMap.get(objJT.Id).Undo__c==false){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.ChangesNeededNotification(Tskids);
                }
                if(Trigger.oldMap.get(objJT.Id).Status__c=='In Progress' && Trigger.NewMap.get(objJT.Id).Status__c=='Approved'){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.ApprovedNotification(Tskids);
                }
            }
        }
    }
    if(Trigger.IsAfter && Trigger.IsDelete)
    {
        system.debug('>>>>>>>>>After Delete Fires>>>>>>>>>>>>');
		Set <String> JobTaskID = New Set <String> (); 
        for(Approval_Job_Task__c objJT:Trigger.old)
        {
            if (objJT.Task__c != Null ) { 
                JobTaskID.add (objJT.Task__c); 
            } 
            If (JobTaskID.size ()> 0) { 
                List <Job_Task__c> upJobTaskList = new List <Job_Task__c> (); 
                List <Job_Task__c> JobTaskList = [SELECT Id, Has_Approval_steps__c,(select id,name from Job_Approval_Tasks__r) FROM Job_Task__c WHERE id in: JobTaskID]; 
                system.debug('>>>>>>>>>After Delete Fires JobTaskList.size()>>>>>>>>>>>>'+JobTaskList.size());
                for(Job_Task__c tsks : JobTaskList)
                {
                    if(tsks.Job_Approval_Tasks__r.size()==0){
                        tsks.Has_Approval_steps__c = false;
                        upJobTaskList.add (tsks);
                    } 
                    else{
                        tsks.Has_Approval_steps__c = true;
                        upJobTaskList.add (tsks);
                    }
                }
                    
                If (upJobTaskList.size ()> 0) 
                    update upJobTaskList; 
            }   
        }
    }
    
}// ENd of Trigger