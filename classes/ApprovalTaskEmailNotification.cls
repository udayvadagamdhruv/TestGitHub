public class ApprovalTaskEmailNotification {
    
    public static Map<Id,List<Approval_Job_Task_Roles__c>> getMapTaskwithTaskRoles(list<string> Tskids){
        
        Map<Id,List<Approval_Job_Task_Roles__c>> mapTskIdwithTskRoles = new Map<Id,List<Approval_Job_Task_Roles__c>>();
        for(Approval_Job_Task_Roles__c tskRoles:[SELECT Id,Name,Approval_Job_Task__c,Email__c,Approval_Job_Task__r.Task__r.Job__r.Name,Approval_Job_Task__r.Task__r.Name, User__c,Task_Final_Due__c,Approval_Job_Task__r.File_ID__c,Approval_Job_Task__r.Task__r.Job__r.Job_Auto_Number__c,Approval_Job_Task__r.Approver_By__c,Approval_Job_Task__r.Submitter_Name__c,Approval_Job_Task__r.Name,Approval_Job_Task__r.Due_Date__c,Approval_Job_Task__r.Job__r.Name,Approval_Job_Task__r.Job__r.Job_Auto_Number__c,Approval_Job_Task__r.File_Name__c,Approval_Job_Task__r.Created_From_Job_Task__c FROM Approval_Job_Task_Roles__c where Approval_Job_Task__c IN : Tskids WITH SECURITY_ENFORCED])
        {
            if(mapTskIdwithTskRoles.containsKey(tskRoles.Approval_Job_Task__c))
            {
                List<Approval_Job_Task_Roles__c> AppJobTskRoles = mapTskIdwithTskRoles.get(tskRoles.Approval_Job_Task__c);
                AppJobTskRoles.add(tskRoles);
                mapTskIdwithTskRoles.put(tskRoles.Approval_Job_Task__c,AppJobTskRoles);
            }
            else{
                mapTskIdwithTskRoles.put(tskRoles.Approval_Job_Task__c, new List<Approval_Job_Task_Roles__c>{tskRoles});
            }
        }
        
        return mapTskIdwithTskRoles;
    }
    
    public static void InprogressEmailNotification(list<string> Tskids){
        system.debug('>>>>>>>>>> InprogressEmailNotification >>>>>>>>>>>>>>>>');
        Map<Id,List<Approval_Job_Task_Roles__c>> mapTskIdwithTskRoles = getMapTaskwithTaskRoles(Tskids);
        
        CustomNotificationType TskInproNoti= [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Task_Inprogress_Notification' LIMIT 1];
        
        for(Id tskId: mapTskIdwithTskRoles.keyset())
        {
            List<String> userNames=new list<String>();
            Messaging.CustomNotification customNotify;
            Set<String> addressee = new Set<String>();
            List<Approval_Job_Task_Roles__c> AppJobTskRolesList = mapTskIdwithTskRoles.get(tskId);
            for(Approval_Job_Task_Roles__c JobtskRoles:AppJobTskRolesList)
            {
                String dueDate = JobtskRoles.Approval_Job_Task__r.Due_Date__c.format();
                system.debug('>>>>>>>>>> dueDate >>>>>>>>>>>>>>>>'+dueDate);
                String body;
                if(JobtskRoles.Approval_Job_Task__r.Created_From_Job_Task__c==true)
                {
                     body =  'Job Name: ' +JobtskRoles.Approval_Job_Task__r.Task__r.Job__r.Name+' (#'+ JobtskRoles.Approval_Job_Task__r.Task__r.Job__r.Job_Auto_Number__c +') \\n'+
                         	 'Schedule Task Name: '  +JobtskRoles.Approval_Job_Task__r.Task__r.Name +'\\n'+
                             'File Name: ' +JobtskRoles.Approval_Job_Task__r.File_Name__c+'\\n'+
                             'Approval Step: ' +JobtskRoles.Approval_Job_Task__r.Name +'\\n'+
                             'Due Date: '  +dueDate; 
                }
                else{
                     body =  'Job Name: '  +JobtskRoles.Approval_Job_Task__r.Job__r.Name+'\\n'+
                             'File Name: ' +JobtskRoles.Approval_Job_Task__r.File_Name__c+'\\n'+
                             'Approval Task: ' +JobtskRoles.Approval_Job_Task__r.Name +'\\n'+
                             'Due Date: '  +dueDate; 
                }
                
                
                customNotify = new Messaging.CustomNotification(TskInproNoti.Id, null, 'The following approval step has been submitted for your approval', body, JobtskRoles.Approval_Job_Task__r.Id, null);
                userNames.add(JobtskRoles.User__c);
                
                
            }
            if(userNames.size()>0){
                for(User uName:[SELECT Id,Email FROM User where Name IN :userNames LIMIT 150])
                {
                    addressee.add(uName.Id);
                }
            }
            try {
                customNotify.send(addressee);
              
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }
    
    public static void UndoEmailNotification(list<string> Tskids){
        system.debug('>>>>>>>>>> UndoEmailNotification >>>>>>>>>>>>>>>>');
        Map<Id,List<Approval_Job_Task_Roles__c>> mapTskIdwithTskRoles = getMapTaskwithTaskRoles(Tskids);
        
        CustomNotificationType TskInproNoti= [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Task_Inprogress_Notification' LIMIT 1];
        
        for(Id tskId: mapTskIdwithTskRoles.keyset())
        {
            

            List<String> userNames=new list<String>();
            Messaging.CustomNotification customNotify;
            Set<String> addressee = new Set<String>();
            List<Approval_Job_Task_Roles__c> AppJobTskRolesList = mapTskIdwithTskRoles.get(tskId);
            for(Approval_Job_Task_Roles__c JobtskRoles:AppJobTskRolesList)
            {
                String dueDate = JobtskRoles.Approval_Job_Task__r.Due_Date__c.format();
                system.debug('>>>>>>>>>> dueDate >>>>>>>>>>>>>>>>'+dueDate);
                
                String body;
                if(JobtskRoles.Approval_Job_Task__r.Created_From_Job_Task__c==true)
                {
                     body =  'Job Name: ' +JobtskRoles.Approval_Job_Task__r.Task__r.Job__r.Name+' (#'+ JobtskRoles.Approval_Job_Task__r.Task__r.Job__r.Job_Auto_Number__c +') \\n'+
                         	 'Schedule Task Name: '  +JobtskRoles.Approval_Job_Task__r.Task__r.Name +'\\n'+
                             'File Name: ' +JobtskRoles.Approval_Job_Task__r.File_Name__c+'\\n'+
                             'Approval Step: ' +JobtskRoles.Approval_Job_Task__r.Name +'\\n'+
                             'Due Date: '  +dueDate; 
                }
                else{
                     body =  'Job Name: '  +JobtskRoles.Approval_Job_Task__r.Job__r.Name+'\\n'+
                             'File Name: ' +JobtskRoles.Approval_Job_Task__r.File_Name__c+'\\n'+
                             'Approval Step: ' +JobtskRoles.Approval_Job_Task__r.Name +'\\n'+
                             'Due Date: '  +dueDate; 
                }
                
                
                /*
                String body =   'Job Name: '  +JobtskRoles.Approval_Job_Task__r.Job__r.Name+'\\n'+
                                'File Name: ' +JobtskRoles.Approval_Job_Task__r.File_Name__c+'\\n'+
                                'Approval Task: ' +JobtskRoles.Approval_Job_Task__r.Name +'\\n'+
                                'Due Date: '  +dueDate; */
                
                customNotify = new Messaging.CustomNotification(TskInproNoti.Id, null, 'This approval step has been retracted', body, JobtskRoles.Approval_Job_Task__r.Id, null);
                userNames.add(JobtskRoles.User__c);
                
                
                
            }
            if(userNames.size()>0){
                for(User uName:[SELECT Id FROM User where Name IN :userNames LIMIT 150])
                {
                    addressee.add(uName.Id);
                }
            }
            try {
                customNotify.send(addressee);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }
    
    public static void ChangesNeededNotification(list<string> Tskids){
        system.debug('>>>>>>>>>> ChangesNeededNotification >>>>>>>>>>>>>>>>');
        
        CustomNotificationType TskInproNoti= [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Task_Inprogress_Notification' LIMIT 1];
        
        system.debug('>>>>>>>>Tskids>>>>>>>>>>>'+Tskids);
        
        list<Approval_Job_Task__c> ApproavalTaskList=[select id,name,Submitter_Name__c,Task__r.Name,Job__r.Name,task__r.Job__r.Name,task__r.Job__r.Job_Auto_Number__c,Due_Date__c,File_Name__c,Created_From_Job_Task__c FROM Approval_Job_Task__c WHERE Id IN :Tskids ];
        
        for(Approval_Job_Task__c tsk: ApproavalTaskList)
        {
            List<String> userNames=new list<String>();
            Messaging.CustomNotification customNotify;
            Set<String> addressee = new Set<String>();
            String dueDate = tsk.Due_Date__c.format();
            system.debug('>>>>>>>>>> dueDate >>>>>>>>>>>>>>>>'+dueDate);
            /*String body =   'Job Name: '  +tsk.Job__r.Name+'\\n'+
                            'File Name: ' +tsk.File_Name__c+'\\n'+
                            'Approval Task: ' +tsk.Name +'\\n'+
                            'Due Date: '  +dueDate; */
            
            String body;
            if(tsk.Created_From_Job_Task__c==true)
            {
                body =  'Job Name: ' +tsk.task__r.Job__r.Name+' (#'+ tsk.task__r.Job__r.Job_Auto_Number__c +') \\n'+
                    	'Schedule Task Name: '  +tsk.Task__r.Name +'\\n'+
                        'File Name: ' +tsk.File_Name__c+'\\n'+
                        'Approval Step: ' +tsk.Name +'\\n'+
                        'Due Date: '  +dueDate; 
            }
            else{
                body =  'Job Name: '  +tsk.Job__r.Name+'\\n'+
                        'File Name: ' +tsk.File_Name__c+'\\n'+
                        'Approval Step: ' +tsk.Name +'\\n'+
                        'Due Date: '  +dueDate;
            }
                
            
            
                        
            customNotify = new Messaging.CustomNotification(TskInproNoti.Id, null, 'Approval process step - Changes Needed', body, tsk.Id, null);
            userNames.add(tsk.Submitter_Name__c);

            if(userNames.size()>0){
                for(User uName:[SELECT Id FROM User where Name IN :userNames LIMIT 150])
                {
                    addressee.add(uName.Id);
                }
            }
            try {
                customNotify.send(addressee);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }  
    }
    
    public static void ApprovedNotification(list<string> Tskids){
        
        CustomNotificationType TskInproNoti= [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Task_Inprogress_Notification' LIMIT 1];
        list<Approval_Job_Task__c> ApproavalTaskList=[select id,name,Submitter_Name__c,Job__r.Name,Task__r.Name,task__r.Job__r.Name,task__r.Job__r.Job_Auto_Number__c,Due_Date__c,File_Name__c,Created_From_Job_Task__c FROM Approval_Job_Task__c WHERE Id IN :Tskids ];
        
        for(Approval_Job_Task__c tsk: ApproavalTaskList)
        {
            List<String> userNames=new list<String>();
            Messaging.CustomNotification customNotify;
            Set<String> addressee = new Set<String>();

            String dueDate = tsk.Due_Date__c.format();
            system.debug('>>>>>>>>>> dueDate >>>>>>>>>>>>>>>>'+dueDate);
            /*String body =   'Job Name: '  +tsk.Job__r.Name+'\\n'+
                            'File Name: ' +tsk.File_Name__c+'\\n'+
                            'Approval Task: ' +tsk.Name +'\\n'+
                            'Due Date: '  +dueDate; */
            
            
            
            String body;
            if(tsk.Created_From_Job_Task__c==true)
            {
                body =  'Job Name: ' +tsk.task__r.Job__r.Name+' (#'+ tsk.task__r.Job__r.Job_Auto_Number__c +') \\n'+
                    	'Schedule Task Name: '  +tsk.Task__r.Name +'\\n'+
                        'File Name: ' +tsk.File_Name__c+'\\n'+
                        'Approval Step: ' +tsk.Name +'\\n'+
                        'Due Date: '  +dueDate; 
            }
            else{
                body =  'Job Name: '  +tsk.Job__r.Name+'\\n'+
                        'File Name: ' +tsk.File_Name__c+'\\n'+
                        'Approval Step: ' +tsk.Name +'\\n'+
                        'Due Date: '  +dueDate;
            }

            customNotify = new Messaging.CustomNotification(TskInproNoti.Id, null, 'This approval step has Approved', body, tsk.Id, null);
            userNames.add(tsk.Submitter_Name__c);

            if(userNames.size()>0){
                for(User uName:[SELECT Id FROM User where Name IN :userNames LIMIT 150])
                {
                    addressee.add(uName.Id);
                }
            }
            try {
                customNotify.send(addressee);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
        
    }
    
}