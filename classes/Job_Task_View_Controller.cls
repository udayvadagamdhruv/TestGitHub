public with sharing class Job_Task_View_Controller {
    
    public class StaffWrappers{
        @AuraEnabled
        public Job_Team__c staff {get;set;}
        @AuraEnabled
        public boolean selection {get;set;}
        
        public StaffWrappers(Job_Team__c staff){
            this.staff = staff;
            selection = False;
        }
    } 
    
    
    @AuraEnabled
    public static String ProfileInformation(){
        String usrProfileName = [select Id,User.Profile.Name from User where Id = :Userinfo.getUserId() ].Profile.Name;//WITH SECURITY_ENFORCED
        return usrProfileName ;
    }
    
    
    @AuraEnabled
    public static List<Job_Task_Role__c> getJobTaskRoles(String TaskId){
        List<Job_Task_Role__c> lstJTR=new List<Job_Task_Role__c>();   
        lstJTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: TaskId WITH SECURITY_ENFORCED order by CreatedDate];
        return lstJTR;
    }
    
    @AuraEnabled
    public static List<staffWrappers> getStaffWrapperMembers(String TaskId){
        List<staffWrappers> AllstaffWrappers=new  List<staffWrappers>();
        list<Job_Team__c> staffs = new List<Job_Team__c>();
        List<Job_Task_Role__c> lstJTR=new List<Job_Task_Role__c>();
        Map<String,Job_Task_Role__c> staffTaskRoleMap = new Map<String,Job_Task_Role__c>();
        Set<String> StaffNameTaskRole =new Set<String>();
        String JobId=[select Id,Name,Job__c From Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED].Job__c;
        String query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: JobId and Staff__c!=null WITH SECURITY_ENFORCED';
        
        lstJTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: TaskId WITH SECURITY_ENFORCED order by CreatedDate ];
        staffs = Database.query(query);
        
        if(!staffs.isEmpty()){
            Set<string> staffNameSet = new Set<String>();
            for(Job_Task_Role__c jtr : lstJTR){
                staffNameSet.add(jtr.User__c);
                staffTaskRoleMap.put(jtr.User__c,jtr);
            }
            
            for(Job_Team__c s:staffs){
                
                if(! staffNameSet.contains(s.Staff__c))
                {
                    AllstaffWrappers.add(new staffWrappers(s));
                    
                }
                
                else{ 
                    staffWrappers w =new staffWrappers(s);
                    w.selection = TRUE;
                    AllstaffWrappers.add(w);
                    StaffNameTaskRole.add(s.Staff__c); 
                }
            }
            
        }   
        
        return AllstaffWrappers;
    }
    
    @AuraEnabled
    public static string AddStaffToTask(String TaskId, String selectedStaff ) {
        
        System.debug('========selectedStaff========'+selectedStaff);
        
        List<staffWrappers> AllstaffWrappers = (List<staffWrappers>)JSON.deserialize(selectedStaff, List<staffWrappers>.class);            
        
        //List<staffWrappers> AllstaffWrappers =new  List<staffWrappers>();
        
        System.debug('========Selected AllstaffWrappers members========'+AllstaffWrappers);
        
        list<Job_Team__c> staffs = new List<Job_Team__c>();
        List<Job_Task_Role__c> lstJTR=new List<Job_Task_Role__c>();
        Map<String,Job_Task_Role__c> staffTaskRoleMap = new Map<String,Job_Task_Role__c>();
        Set<String> StaffNameTaskRole =new Set<String>();
        String JobId=[select Id,Name,Job__c From Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED ].Job__c;
        String query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: JobId and Staff__c!=null WITH SECURITY_ENFORCED ';
        
        lstJTR=[Select Id,Name,User__c from Job_Task_Role__c where Job_Task__c =: TaskId WITH SECURITY_ENFORCED order by CreatedDate];
        staffs = Database.query(query);
        
        if(!staffs.isEmpty()){
            Set<string> staffNameSet = new Set<String>();
            for(Job_Task_Role__c jtr : lstJTR){
                staffNameSet.add(jtr.User__c);
                staffTaskRoleMap.put(jtr.User__c,jtr);
            }
            
            for(Job_Team__c s:staffs){
                
                if(! staffNameSet.contains(s.Staff__c))
                {
                    //AllstaffWrappers.add(new staffWrappers(s));
                    
                }
                
                else{ 
                    //staffWrappers w =new staffWrappers(s);
                    // w.selection = TRUE;
                    // AllstaffWrappers.add(w);
                    StaffNameTaskRole.add(s.Staff__c); 
                }
            }
            
        }   
        
        
        if(!AllstaffWrappers.isEmpty()){
            List<Job_Task_Role__c> AddTaskRole = new List<Job_Task_Role__c>();
            List<Job_Task_Role__c> deleteTaskRole = new List<Job_Task_Role__c>();
            
            for(staffWrappers apw:AllstaffWrappers){
                boolean existing = StaffNameTaskRole.contains(apw.staff.Staff__c); 
                
                
                if(apw.selection == True){
                    if(!existing){
                        Job_Task_Role__c trole=new Job_Task_Role__c();                      
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                            trole.Name=apw.staff.Role__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) { 
                            trole.User__c=apw.staff.Staff__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) { 
                            trole.Job_Task__c=TaskId;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) { 
                            trole.Email__c=apw.staff.Email__c;}
                        AddTaskRole.add(trole);
                    }
                    
                }
                else if(existing){
                    if(staffTaskRoleMap.containsKey(apw.staff.Staff__c)){
                        Job_Task_Role__c objJTR = staffTaskRoleMap.get(apw.staff.Staff__c);
                        system.debug('HERE1'+objJTR );
                        deleteTaskRole.add(objJTR);
                    }
                }
                
            }
            if(!AddTaskRole.isEmpty()){
                if (!Job_Task_Role__c.sObjectType.getDescribe().isCreateable()){
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                    return 'Task Role has Insufficient Access to create';
                }else{ 
                    try{
                        insert AddTaskRole;                       
                    }
                    catch(System.DmlException e){
                        return ''+e.getMessage();
                    }
                } 
            }
            
            
            if(!deleteTaskRole.isEmpty()){
                if (!Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                    return 'Task role has Insufficient Access to delete';
                }else{ 
                    try{
                        delete deleteTaskRole;
                    }
                    catch(System.DmlException e){
                        return ''+e.getMessage();
                    }
                    
                } 
            }
        }
        
        return 'OK';
    }
    
    @AuraEnabled
    public static String AddstafftoJobTeam(String jobtkId,String selectedJobTeam) {
        Job_Task__c  objTask1 = [Select Id, Name, Job__c, Job__r.Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Id =: jobtkId WITH SECURITY_ENFORCED LIMIT 1];
        string jobId = objTask1.Job__c; 
        
        boolean enableAppatTsk;
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        enableAppatTsk=setting.Job_Task_Level__c;
        
        System.debug('==Add Staff Json Sting===='+selectedJobTeam);
        Map<String,Job_Team__c> staffJobTeamMap = new Map<String,Job_Team__c>();
        Set < string > staffNameSet = new Set < String > ();
        list < Job_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c, Job__c, Email__c, Job__r.Name from Job_Team__c where job__c = : jobId WITH SECURITY_ENFORCED order by CreatedDate];
        //List<StaffWrappers> AllstaffWrappers = (List<StaffWrappers>)JSON.deserialize(selectedJobTeam, List<StaffWrappers>.class);
        List<Object> AllstaffWrappers = (List<Object>)JSON.deserializeUntyped(selectedJobTeam);
        System.debug('==jsonlist===='+AllstaffWrappers);
        for (Job_Team__c jt: lstJobTeam) {
            staffNameSet.add(jt.Staff__c);
            staffJobTeamMap.put(jt.Staff__c, jt);
        }
        if (!AllstaffWrappers.isEmpty()) {
            
            List <Job_Team__c>  AddJobTeam = new List < Job_Team__c > ();
            List < Job_Team__c > deleteJobteam = new List < Job_Team__c > ();
            List < Job_Task_Role__c > lstJTRDelete = new List < Job_task_Role__c > ();
            List < Approval_Job_Task_Roles__c > lstAppTskRolDelete = new List < Approval_Job_Task_Roles__c > ();
            
            for (Object apw: AllStaffWrappers) {
                Map<String,Object> mapstaff=(Map<String,Object>)apw;
                boolean existing = staffNameSet.contains(string.valueof(mapstaff.get('Staffname'))); //(apw.staff.First_Name__c+' '+apw.staff.Last_Name__c);
                
                if ( boolean.valueOf(mapstaff.get('selection')) == True) {
                    if (!existing) {
                        Job_Team__c jt1=new Job_Team__c();
                        if(Schema.sObjectType.Job_Team__c.fields.job__c.isCreateable()) {
                            jt1.job__c = Jobid;}
                        if(Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()) {
                            jt1.Role__c =string.valueof(mapstaff.get('Rolename'));}
                        if(Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()) {
                            jt1.Staff__c = string.valueof(mapstaff.get('Staffname'));}
                        if(Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()) {
                            jt1.Email__c = string.valueof(mapstaff.get('Email'));}
                        AddJobTeam.add(jt1);
                    }
                } else if (existing) {
                    
                    if (staffJobTeamMap.containsKey(string.valueof(mapstaff.get('Staffname')))) {
                        Job_Team__c objJTR = staffJobTeamMap.get(string.valueof(mapstaff.get('Staffname')));
                        system.debug('HERE1' + objJTR);
                        
                        if(enableAppatTsk){
                            lstAppTskRolDelete = [Select Id, Approval_Job_Task__c, Approval_Job_Task__r.Task__r.Job__c from Approval_Job_Task_Roles__c where Name = : objJTR.Role__c and Approval_Job_Task__r.Task__r.Job__c = : objJTR.job__c AND Approval_Job_Task__r.Status__c!='Approved' AND User__c = : objJTR.Staff__c WITH SECURITY_ENFORCED];
                        }
                        else{
                            lstAppTskRolDelete = [Select Id, Approval_Job_Task__c, Approval_Job_Task__r.Job__c from Approval_Job_Task_Roles__c where Name = : objJTR.Role__c and Approval_Job_Task__r.Job__c = : objJTR.job__c AND Approval_Job_Task__r.Status__c!='Approved' AND User__c = : objJTR.Staff__c WITH SECURITY_ENFORCED];
                        }
                        
                        if (lstAppTskRolDelete.size() > 0){
                            if(Approval_Job_Task_Roles__c.sObjectType.getDescribe().isDeletable()){
                                delete lstAppTskRolDelete;
                            }
                            else{
                                return 'Approval step role has insufficient access to delete.';
                            }
                        }
                        
                        
                        lstJTRDelete = [Select Id, Job_Task__c, Job_Task__r.Job__c from Job_Task_Role__c where Name = : objJTR.Role__c and Job_Task__r.Job__c = : objJTR.job__c AND User__c = : objJTR.Staff__c WITH SECURITY_ENFORCED];
                        
                        system.debug('HERE2' + lstJTRDelete);
                        
                        if (lstJTRDelete.size() > 0)
                            /*if (!Job_Task_Role__c.sObjectType.getDescribe().isDeletable()) {
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient access'));
return 'Insufficient access to Delete Job Task Role.';

} else {*/
                            if(Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){
                                delete lstJTRDelete;}
                        else{
                            return 'Task role has insufficient access to delete.';
                        }
                        //  }
                        deleteJobteam.add(objJTR);
                        
                    }
                }
                
            }
            
            if (!AddJobTeam.isEmpty()) {
                /* if (!Job_Team__c.sObjectType.getDescribe().isCreateable()) {
return 'Insufficient access to Create Job Team.';
} else {*/
                if(Schema.sObjectType.Job_Team__c.isCreateable()){
                    insert AddJobTeam;}
                else{
                    return 'Team has insufficient access to insert';
                }
                // }
                
            }
            
            if (!deleteJobteam.isEmpty()) {
                if (!Job_Team__c.sObjectType.getDescribe().isDeletable()) {
                    return 'Insufficient access to Delete the Job Team.';
                } else {
                    delete deleteJobteam;
                }
                
            }
            return 'OK'; 
        }
        return 'OK';
    }
    @AuraEnabled
    public static  list<StaffWrappersjobteam>  JobTeamAddEditStaffCont(String rcdId) {
        Job_Task__c  objTask1 = [Select Id, Name, Job__c, Job__r.Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Id =: rcdId WITH SECURITY_ENFORCED LIMIT 1];
        string recordId = objTask1.Job__c;
        list<StaffWrappersjobteam>  AllstaffWrappers = new List<StaffWrappersjobteam>();       
        Set<String> StaffNameJobTeam =new Set<String>();
        List<Staff__c> staffs = new List<Staff__c>();
        
        Job__c  jobrecord=[select id,JS_Client__c, name,Schedule_Template__c from Job__c where id =:recordId WITH SECURITY_ENFORCED];
        String  clientid=jobrecord.JS_Client__c;
        system.debug('ClientId'+clientid);
        list<Job_Team__c> lstJobTeam=[Select Id, Role__c,Staff__c, Job__c,Email__c, Job__r.Name from Job_Team__c where job__c =:recordId WITH SECURITY_ENFORCED order by Staff__c ];
        
        Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c=:jobrecord.Schedule_Template__c  WITH SECURITY_ENFORCED];
        
        for(Schedule_Task__c st:STaskslist){
            Staskid.add(st.id);
        }
        system.debug('=====Staskid==='+Staskid);
        
        List<ScheduleTaskRole__c> STRolelist =[select id,name from ScheduleTaskRole__c where Schedule_Task__c in:Staskid  WITH SECURITY_ENFORCED];
        for(ScheduleTaskRole__c str:STRolelist ){
            Srole.add(str.name);
        }
        system.debug('===SRoles====='+Srole);
        
        Set<string> staffNameSet = new Set<String>();
        Map<String,Job_Team__c> staffJobTeamMap = new Map<String,Job_Team__c>();
        
        String query ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by name';
        
        staffs = Database.query(query);
        
        if(!staffs.isEmpty()){
            for(Job_Team__c jt :lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Staff__c s:staffs){
                
                if(! staffNameSet.contains(s.name))//(s.First_Name__c+' '+s.Last_Name__c))
                    AllstaffWrappers.add(new StaffWrappersjobteam(s,String.valueof(s.getSobjectType()),Srole.contains(s.role__C)));
                
                else{ 
                    StaffWrappersjobteam w =new StaffWrappersjobteam(s,String.valueof(s.getSobjectType()),Srole.contains(s.role__C));
                    w.selection = TRUE; 
                    AllstaffWrappers.add(w);
                    StaffNameJobTeam.add(s.name); 
                }
            }
        } 
        System.debug('=====AllstaffWrappers debug==='+AllstaffWrappers);
        return AllstaffWrappers;
    }
    
    @AuraEnabled
    public static List<String> duplicateJob(String JobId) {
       system.debug('The jobid is '+JobId);
        List<String> resResult=new List<String>();
        String NewJobId='';
        string isError='false';
        String MTName,ClientName,CCName,ScheduleTemp,CampaignName,SpecTempName,JobName,CreatedBy,strJob_Id,clientid,oldJobId;
        boolean recalsch,ShowProductionEstimate;
        Date dtStartDate,dtDueDate;
        String UserName=UserInfo.getName();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        list<Staff__c> staffs=new list<Staff__c>();
        list<Client_Contact__c> CCs=new list<Client_Contact__c>();
        list<Vendor_Contact__c> VCs=new list<Vendor_Contact__c>();
        Set<String> ClientNames=new set<String>();
        Set<String> VendorNames=new set<String>();
        Set<String> staffNames=new set<String>();
        Map<String,Schema.SObjectField> jobFieldsMap = Schema.getGlobalDescribe().get('Job__c').getDescribe().fields.getMap();//Get object fileds apis 
        string queryFields='';
        List<String> editableFields = new List<String>();//List to store only ediatable fields of object
        //Framing dynamic query with only ediatable fields
        for(Schema.SObjectField fieldRef : jobFieldsMap.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            system.debug('The fieldresult==='+fieldResult);
            if(fieldResult.isUpdateable()) {
                editableFields.add(fieldResult.getname());
                if(queryFields=='' || queryFields==null){
                    queryFields=fieldResult.getname();
                }
                else{
                    // if(fieldResult.getname()=='Revision__c' || fieldResult.getname()=='Reprint__c'){
                    // we don't add revision and reprint field for epson customization
                    // }else{
                    queryFields +=','+fieldResult.getname();
                    // }
                }
            }
        }
        system.debug('queryFields----'+queryFields);
        string queryJob ='select '+queryFields+' From '+'Job__c'+' where id=:JobId'+'  limit 1';//WITH SECURITY_ENFORCED //Dynamic query with editable fields
        system.debug('---queryJob----'+queryJob);
        Job__c j=Database.query(queryJob);
        system.debug('---valuesQeryResult----'+j);
        //Job__c j=[select id, Name, Media_Types__c, Schedule_Template__c, Start_Date__c, Due_Date__c, JS_Client__c,JS_Client_Contact__c,UpdateSchedDateFieldCheck__c, Creative_Overview__c,Campaign__c, Client_Contact__c, Specification_Template__c, CreatedById, Client__c, Budgeted_Cost__c,  Completion_Date__c, Number_of_Days__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Estimate_Total__c, Flag__c, Job_Description__c, marked_Done__c, Schedule_Calc__c, Status__c, Status_Notes__c, Traffic_Notes__c from Job__c  where id =: JobId Limit 1];
        //[select id,Name,Media_Types__c,Schedule_Template__c,Start_Date__c,Due_Date__c,JS_Client__c,Campaign__c,Client_Contact__c,Specification_Template__c,CreatedById from Job__c  where id =: objJob.id Limit 1];
        clientid=j.JS_Client__c;
        String query ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False  WITH SECURITY_ENFORCED order by name';
        staffs = Database.query(query); 
        for(Staff__c s:staffs){
            staffNames.add(s.name);
        }
        String query1 ='SELECT id,name,Active__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true WITH SECURITY_ENFORCED Order by name';
        CCs= Database.query(query1);   
        for(Client_Contact__c  s:CCs){
            ClientNames.add(s.name);
        }   
        String query2 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true  WITH SECURITY_ENFORCED order by name';
        VCs= Database.query(query2);
        for(Vendor_Contact__c  s:VCs){
            VendorNames.add(s.name);
        }  
        OldJobId=j.Id;
        //MTName = j.Media_Types__c;
        //ScheduleTemp = j.Schedule_Template__c;
        //ClientName = j.JS_Client__c;
        //system.debug('Client ======+++'+j.JS_Client__c);
        //CCName = j.JS_Client_Contact__c;
        // CampaignName = j.Campaign__c; 
        //SpecTempName = j.Specification_Template__c;
        //recalsch =j.UpdateSchedDateFieldCheck__c;
        //JobName='Duplicate : '+' '+j.Name+' '+'Created By :'+userName;
        JobName='Dup : '+DateTime.Now()+' '+j.Name;
        if(JobName.length() > 80)
        {
            JobName = JobName.substring(0,80);
        }
        system.debug('---JobName----'+JobName);
        //CreatedBy=j.CreatedById;
        //dtStartDate=j.Start_Date__c;
        // dtDueDate=j.Due_Date__c;
        try
        {
            system.debug('Client ======'+ClientName);
            //Assign fields values to duplicate job
            Job__c dupJob = new Job__c();
            for(String fieldName:editableFields){
                system.debug('---fieldName----'+fieldName);
                if(fieldName=='name'){
                    system.debug('---fieldName---inside-'+fieldName);
                    dupJob.put(fieldName,JobName);
                }
                else if(fieldName=='OwnerId'){
                    system.debug('---fieldName---inside-'+fieldName);
                }
                else if(fieldName=='Revision__c' || fieldName=='Reprint__c'){
                    dupJob.put(fieldName,false);
                }
                else if(fieldName=='Revision_Increment__c')
                {
                    dupJob.put(fieldName,0);
                }             
                else{  
                    dupJob.put(fieldName,j.get(fieldName));
                }
                system.debug('---dup job----'+dupJob);
            }
            system.debug('---dup job----'+dupJob);
            //Job__c dupJob = new Job__c(Name=JobName,Media_Types__c=j.Media_Types__c,Schedule_Template__c=j.Schedule_Template__c,UpdateSchedDateFieldCheck__c=j.UpdateSchedDateFieldCheck__c,Specification_Template__c=j.Specification_Template__c,Start_Date__c=j.Start_Date__c,Due_Date__c=j.Due_Date__c,JS_Client__c=j.JS_Client__c,JS_Client_Contact__c=j.JS_Client_Contact__c,Campaign__c=j.Campaign__c, Budgeted_Cost__c = j.Budgeted_Cost__c,  Completion_Date__c = j.Completion_Date__c, Number_of_Days__c = j.Number_of_Days__c , Dummy_Date_1__c = j.Dummy_Date_1__c , Dummy_Date_2__c = j.Dummy_Date_2__c , Dummy_Date_3__c = j.Dummy_Date_3__c , Dummy_Date_4__c = j.Dummy_Date_4__c , Dummy_Date_5__c = j.Dummy_Date_5__c , Dummy_Date_6__c = j.Dummy_Date_6__c , Dummy_Picklist_1__c = j.Dummy_Picklist_1__c , Dummy_Picklist_2__c = j.Dummy_Picklist_2__c , Dummy_Picklist_3__c = j.Dummy_Picklist_3__c , Dummy_Picklist_4__c = j.Dummy_Picklist_4__c , Dummy_Picklist_5__c = j.Dummy_Picklist_5__c , Dummy_Picklist_6__c = j.Dummy_Picklist_6__c , Dummy_Text_1__c = j.Dummy_Text_1__c , Dummy_Text_2__c = j.Dummy_Text_2__c , Dummy_Text_3__c = j.Dummy_Text_3__c , Dummy_Text_4__c = j.Dummy_Text_4__c , Dummy_Text_5__c = j.Dummy_Text_5__c , Dummy_Text_6__c = j.Dummy_Text_6__c , Estimate_Total__c = j.Estimate_Total__c , Flag__c = j.Flag__c , Job_Description__c = j.Job_Description__c ,/* marked_Done__c = j.marked_Done__c ,*/ Schedule_Calc__c = j.Schedule_Calc__c , Status__c = j.Status__c , Status_Notes__c = j.Status_Notes__c , Traffic_Notes__c = j.Traffic_Notes__c,Creative_Overview__c = j.Creative_Overview__c);
            //new Job__c(Name=JobName,Media_Types__c=MTName,Schedule_Template__c=SCheduleTemp,Specification_Template__c= SpecTempName,Start_Date__c=dtStartDate,Due_Date__c=dtDueDate,JS_Client__c=ClientName,Client_Contact__c=CCName,Campaign__c=CampaignName);  
            if(Job__c.sObjectType.getDescribe().isCreateable()){
                insert dupJob;
            }
            NewJobId=dupJob.Id;
            // Trigger invokes JobTeam record, but we are duplicating record here.So, We will delete this records and create from retrieving from Old Job
            List<Job_Team__c> lstJobTeam=new List<Job_Team__c>();
            lstJobTeam=[Select id from Job_Team__c where Job__c=: dupJob.id WITH SECURITY_ENFORCED];
            system.debug('The job team records======='+lstJobTeam);
            if(Job_Team__c.sObjectType.getDescribe().isDeletable()){
                delete lstJobTeam;
            }
            // Trigger invokes JobSpec record, but we are duplicating record here.So, We will delete this records and re-create from retrieving from Old Job
            List<Job_Spec__c> deleteJobSpec=[Select id from Job_Spec__c where Job__c=:dupJob.id WITH SECURITY_ENFORCED];
            if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                delete deleteJobSpec; 
            }  
            // Retrieve Team records
            lstJobTeam=[Select id,Job__c, Role__c,Staff__c,Email__c from Job_Team__c where Job__c=:OldJobId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
            List<Job_Team__c> insertJobTeam=new List<Job_Team__c>();
            for(Job_Team__c jt1:lstJobTeam)
            {
                if(staffNames.contains(jt1.Staff__c) || ClientNames.contains(jt1.Staff__c) || VendorNames.contains(jt1.Staff__c))
                {
                    Job_Team__c jt=new Job_Team__c();
                    if (Schema.sObjectType.Job_Team__c.fields.Job__c.isCreateable()) { 
                        jt.Job__c=dupJob.id;}
                    if (Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()) {  jt.Role__c=jt1.Role__c;}
                    if (Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()) {  jt.Staff__c=jt1.Staff__c;}
                    if (Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()) {  jt.Email__c=jt1.Email__c;}
                    insertJobTeam.add(jt);
                }
            }
            if(Schema.sObjectType.Job_Team__c.isCreateable()){ 
                insert insertJobTeam;
            }
            System.debug('Job Team records for duplicate Job are created');
            List<Job_Task__c> insertJobTask=new List<Job_Task__c>();
            List<Job_Task__c> lstJT=new List<Job_Task__c>();
            Set<Id> OldTaskId=new Set<Id>();
            Map<String,Id> mp1 = new Map<String,Id>();
            Map<Id,Id> mp2 = new Map<Id,Id>();
            lstJT=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c,Due_Date__c,Revised_Due_Date__c, Task_Order__c,Start_Date__c from Job_Task__c where Job__c=:OldJobId WITH SECURITY_ENFORCED ORDER BY Start_Date__c];
            for(Job_Task__c task:lstJT)
            {
                OldTaskId.add(task.id);
                Job_Task__c objJT = new Job_Task__c();
                if (Schema.sObjectType.Job_Task__c.fields.Name.isCreateable()) { 
                    objJT.Name = task.Name;}
                if (Schema.sObjectType.Job_Task__c.fields.GL_Code__c.isCreateable()) { objJT.GL_Code__c = task.GL_Code__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Report__c.isCreateable()) { objJT.Report__c = task.Report__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Locked__c.isCreateable()) { objJT.Locked__c = task.Locked__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Days__c.isCreateable()) {  objJT.Days__c = task.Days__c;}
                //code added to duplicate the start date for all the tasks
                if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {  objJT.Start_Date__c = task.Start_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) { objJT.Due_Date__c = task.Due_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isCreateable()) {  objJT.Revised_Due_Date__c = task.Revised_Due_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isCreateable()) {  objJT.Task_Order__c = task.Task_Order__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Job__c.isCreateable()) { objJT.Job__c = dupJob.id;}
                mp1.put(task.Name,task.id);
                insertJobTask.add(objJT);
            }
            if(Schema.sObjectType.Job_Task__c.isCreateable()){ 
                insert insertJobTask;}
            System.debug('Schedule record are inserted');
            for(Job_Task__c jt:insertJobTask)
            {
                mp2.put(mp1.get(jt.Name),jt.Id);
            }
            List<Job_Task_Role__c> lstJTR=[Select id,Name,User__c,Job_Task__c,Email__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId WITH SECURITY_ENFORCED];
            List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
            for(Job_Task_Role__c taskRole:lstJTR)
            {
                if(staffNames.contains(taskRole.User__c) || ClientNames.contains(taskRole.User__c) || VendorNames.contains(taskRole.User__c)){
                    Job_Task_Role__c objJTR=new Job_Task_Role__c();
                    if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                        objJTR.Name=taskRole.Name;}
                    if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) {  objJTR.Email__c=taskRole.Email__c; } // added by sugunakar.
                    if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) {  objJTR.User__c=taskRole.User__c;}
                    if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) {  objJTR.Job_Task__c=mp2.get(taskRole.Job_Task__c);}
                    insertJTR.add(objJTR);
                }
            }
            if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
                insert insertJTR;}
            System.debug('Job Task Role are inserted');
            List<Job_Spec__c> insertJobSpec=new List<Job_Spec__c>();
            List<Job_Spec__c> lstJS=[Select id,Name,Description__c,Job__c,Creative_Brief_Template__c from Job_Spec__c where Job__c=: OldJobId WITH SECURITY_ENFORCED];
            for(Job_Spec__c spec:lstJS)
            {
                Job_Spec__c objJS=new Job_Spec__c();
                if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
                    objJS.Name=spec.Name;}
                if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) {   objJS.Description__c=spec.Description__c;}
                if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { objJS.Job__c=dupJob.id;}
                if (Schema.sObjectType.Job_Spec__c.fields.Creative_Brief_Template__c.isCreateable()) { objJS.Creative_Brief_Template__c=spec.Creative_Brief_Template__c;}
                insertJobSpec.add(objJS);
            }
            if(Schema.sObjectType.Job_Spec__c.isCreateable()){ 
                insert insertJobSpec;}
            System.debug('Job Spec Records are re-created');
            //sushma added code for the duplciation of the tags.
            List<Tag__c> insertJobTag=new List<Tag__c>();
            List<Tag__c> lstJTag=[Select id,Name,Job__c,Tag_Air_Date__c,Tag_Air_Time__c,Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Tag_Lengths__c,Tag_Due_Date__c,Tag_End_Date__c,Tag_Start_Date__c,Tag_Program_Title__c  from Tag__c where Job__c=: OldJobId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
            for(Tag__c tag:lstJtag)
            {
                Tag__c objJTag=new Tag__c();
                if (Schema.sObjectType.Tag__c.fields.Name.isCreateable()) { 
                    objJTag.Name=tag.Name;}
                if (Schema.sObjectType.Tag__c.fields.Job__c.isCreateable()) { 
                    objJTag.Job__c=dupJob.id;}
                if (Schema.sObjectType.Tag__c.fields.Tag_Air_Date__c.isCreateable()) {  objJTag.Tag_Air_Date__c=tag.Tag_Air_Date__c;}
                if (Schema.sObjectType.Tag__c.fields.Tag_Air_Time__c.isCreateable()) {  objJTag.Tag_Air_Time__c=tag.Tag_Air_Time__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Date_1__c.isCreateable()) { objJTag.Dummy_Date_1__c=tag.Dummy_Date_1__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Date_2__c.isCreateable()) { objJTag.Dummy_Date_2__c=tag.Dummy_Date_2__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Date_3__c.isCreateable()) { objJTag.Dummy_Date_3__c=tag.Dummy_Date_3__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Date_4__c.isCreateable()) { objJTag.Dummy_Date_4__c=tag.Dummy_Date_4__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Picklist_1__c.isCreateable()) { objJTag.Dummy_Picklist_1__c=tag.Dummy_Picklist_1__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Picklist_2__c.isCreateable()) { objJTag.Dummy_Picklist_2__c=tag.Dummy_Picklist_2__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Picklist_3__c.isCreateable()) { objJTag.Dummy_Picklist_3__c=tag.Dummy_Picklist_3__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Picklist_4__c.isCreateable()) { objJTag.Dummy_Picklist_4__c=tag.Dummy_Picklist_4__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Text_1__c.isCreateable()) { objJTag.Dummy_Text_1__c=tag.Dummy_Text_1__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Text_2__c.isCreateable()) { objJTag.Dummy_Text_2__c=tag.Dummy_Text_2__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Text_3__c.isCreateable()) {  objJTag.Dummy_Text_3__c=tag.Dummy_Text_3__c;}
                if (Schema.sObjectType.Tag__c.fields.Dummy_Text_4__c.isCreateable()) { objJTag.Dummy_Text_4__c=tag.Dummy_Text_4__c;}
                if (Schema.sObjectType.Tag__c.fields.Tag_Lengths__c.isCreateable()) { objJTag.Tag_Lengths__c=tag.Tag_Lengths__c;}
                if (Schema.sObjectType.Tag__c.fields.Tag_Due_Date__c.isCreateable()) { objJTag.Tag_Due_Date__c=tag.Tag_Due_Date__c;}
                if (Schema.sObjectType.Tag__c.fields.Tag_End_Date__c.isCreateable()) { objJTag.Tag_End_Date__c=tag.Tag_End_Date__c;}
                if (Schema.sObjectType.Tag__c.fields.Tag_Start_Date__c.isCreateable()) {  objJTag.Tag_Start_Date__c=tag.Tag_Start_Date__c;}
                if (Schema.sObjectType.Tag__c.fields.Tag_Program_Title__c.isCreateable()) {  objJTag.Tag_Program_Title__c=tag.Tag_Program_Title__c;}
                insertJobTag.add(objJTag);
            }
            if(Schema.sObjectType.Tag__c.isCreateable()){ 
                insert insertJobTag;}
            //all fields for job tags
            //Tag_Air_Date__c,Tag_Air_Time__c,Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Job__c,Tag_Lengths__c,Tag_Due_Date__c,Tag_End_Date__c,Tag_Start_Date__c,Tag_Program_Title__c   
            System.debug('Job Tag Records are re-created');
            List<Graphics_Deliverables__c> InsertGDlist=new List<Graphics_Deliverables__c>();
            List<Graphics_Deliverables__c> GDlist=[SELECT Id, Name, Job__c, Graphics_Type__c, Graphics_Description__c, Graphics_Note__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Date_2__c, Dummy_Date_1__c, Dummy_Date_3__c, Dummy_Text_1__c, Dummy_Text_3__c, Dummy_Text_2__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Dummy_Text_7__c, Dummy_Text_8__c, Dummy_Text_9__c, Dummy_Text_10__c, Dummy_Text_11__c, Dummy_Text_12__c, Dummy_Text_13__c, Dummy_Text_14__c, Dummy_Text_15__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Deliverable_Date__c FROM Graphics_Deliverables__c where Job__c=:OldJobId WITH SECURITY_ENFORCED];
            for(Graphics_Deliverables__c gde:GDlist)
            {
                Graphics_Deliverables__c ObjGd=new Graphics_Deliverables__c();
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Name.isCreateable()) { 
                    ObjGd.Name=gde.Name;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Job__c.isCreateable()) {   ObjGd.Job__c=dupJob.Id;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Type__c.isCreateable()) {  ObjGd.Graphics_Type__c=gde.Graphics_Type__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Description__c.isCreateable()) { ObjGd.Graphics_Description__c=gde.Graphics_Description__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Note__c.isCreateable()) { ObjGd.Graphics_Note__c=gde.Graphics_Note__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Deliverable_Date__c.isCreateable()) { ObjGd.Deliverable_Date__c=gde.Deliverable_Date__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_1__c.isCreateable()) { ObjGd.Dummy_Date_1__c=gde.Dummy_Date_1__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_2__c.isCreateable()) { ObjGd.Dummy_Date_2__c=gde.Dummy_Date_2__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_3__c.isCreateable()) { ObjGd.Dummy_Date_3__c=gde.Dummy_Date_3__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_4__c.isCreateable()) {  ObjGd.Dummy_Date_4__c=gde.Dummy_Date_4__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_5__c.isCreateable()) { ObjGd.Dummy_Date_5__c=gde.Dummy_Date_5__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_1__c.isCreateable()) { ObjGd.Dummy_Text_1__c=gde.Dummy_Text_1__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_2__c.isCreateable()) { ObjGd.Dummy_Text_2__c=gde.Dummy_Text_2__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_3__c.isCreateable()) { ObjGd.Dummy_Text_3__c=gde.Dummy_Text_3__c; } 
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_4__c.isCreateable()) { ObjGd.Dummy_Text_4__c=gde.Dummy_Text_4__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_5__c.isCreateable()) { ObjGd.Dummy_Text_5__c=gde.Dummy_Text_5__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_6__c.isCreateable()) { ObjGd.Dummy_Text_6__c=gde.Dummy_Text_6__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_7__c.isCreateable()) {  ObjGd.Dummy_Text_7__c=gde.Dummy_Text_7__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_8__c.isCreateable()) { ObjGd.Dummy_Text_8__c=gde.Dummy_Text_8__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_9__c.isCreateable()) { ObjGd.Dummy_Text_9__c=gde.Dummy_Text_9__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_10__c.isCreateable()) { ObjGd.Dummy_Text_10__c=gde.Dummy_Text_10__c;} 
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_11__c.isCreateable()) { ObjGd.Dummy_Text_11__c=gde.Dummy_Text_11__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_12__c.isCreateable()) {  ObjGd.Dummy_Text_12__c=gde.Dummy_Text_12__c;} 
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_13__c.isCreateable()) { ObjGd.Dummy_Text_13__c=gde.Dummy_Text_13__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_14__c.isCreateable()) { ObjGd.Dummy_Text_14__c=gde.Dummy_Text_14__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_15__c.isCreateable()) { ObjGd.Dummy_Text_15__c=gde.Dummy_Text_15__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_1__c.isCreateable()) { ObjGd.Dummy_Picklist_1__c=gde.Dummy_Picklist_1__c;} 
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_2__c.isCreateable()) { ObjGd.Dummy_Picklist_2__c=gde.Dummy_Picklist_2__c;}
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_3__c.isCreateable()) { ObjGd.Dummy_Picklist_3__c=gde.Dummy_Picklist_3__c; } 
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_4__c.isCreateable()) { ObjGd.Dummy_Picklist_4__c=gde.Dummy_Picklist_4__c; }
                if (Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_5__c.isCreateable()) { ObjGd.Dummy_Picklist_5__c=gde.Dummy_Picklist_5__c; }
                InsertGDlist.add(ObjGd);
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.isCreateable()){ 
                insert InsertGDlist;}
            if(ShowProductionEstimate){
                //Subhranshu added code for the duplciation of the Production Estimate.
                List<Production_Estimate__c> insertProdEstimate=new List<Production_Estimate__c>();
                List<Production_Estimate__c> lstProdEstimate=[Select id,Name,Job__c,PE_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
                                                              Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c where Job__c=: OldJobId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
                for(Production_Estimate__c p:lstProdEstimate)
                {
                    Production_Estimate__c  objJPE=new Production_Estimate__c  ();
                    if (Schema.sObjectType.Production_Estimate__c.fields.name.isCreateable()) {
                        objJPE.name=p.Name;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Job__c.isCreateable()) {objJPE.Job__c=dupJob.id;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Calc_Unit__c.isCreateable()) { objJPE.Calc_Unit__c=p.Calc_Unit__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Color__c.isCreateable()) {objJPE.Color__c=p.Color__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Commission__c.isCreateable()) { objJPE.Commission__c=p.Commission__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.GL_Department__c.isCreateable()) { objJPE.GL_Department__c=p.GL_Department__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.GL_Code__c.isCreateable()) { objJPE.GL_Code__c=p.GL_Code__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.of_Pages__c.isCreateable()) { objJPE.of_Pages__c=p.of_Pages__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Length_in_Inches__c.isCreateable()) {objJPE.Length_in_Inches__c=p.Length_in_Inches__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Material_Item__c.isCreateable()) { objJPE.Material_Item__c=p.Material_Item__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Quantity__c.isCreateable()) {objJPE.Quantity__c=p.Quantity__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Qty_Up__c.isCreateable()) {objJPE.Qty_Up__c=p.Qty_Up__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()) {objJPE.SheetQtyUpforUsed__c=p.SheetQtyUpforUsed__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.EachQtyUpforUsed__c.isCreateable()) {objJPE.EachQtyUpforUsed__c=p.EachQtyUpforUsed__c;} 
                    if (Schema.sObjectType.Production_Estimate__c.fields.Sided__c.isCreateable()) {objJPE.Sided__c=p.Sided__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Vendor__c.isCreateable()) {objJPE.Vendor__c=p.Vendor__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Width_in_Inches__c.isCreateable()) {objJPE.Width_in_Inches__c  =p.Width_in_Inches__c  ;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Equipment_Type__c.isCreateable()) {objJPE.Equipment_Type__c=p.Equipment_Type__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.PE_Template__c.isCreateable()) {objJPE.PE_Template__c=p.PE_Template__c;}
                    insertProdEstimate.add(objJPE);
                }
                if(Schema.sObjectType.Production_Estimate__c.isCreateable()){ 
                    insert insertProdEstimate;}
                //all fields for Production Estimate
            }else{
                List<Estimate_Line_Items__c > insertEstimate=new List<Estimate_Line_Items__c >();
                List<Estimate_Line_Items__c> abc = [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Estimate_Line_Items__c where Job__c=:OldJobId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
                for(Estimate_Line_Items__c es:abc) {
                    Estimate_Line_Items__c  objJEst=new Estimate_Line_Items__c ();
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.name.isCreateable()) { 
                        objJEst.name=es.Name;}
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.Job__c.isCreateable()) {  objJEst.Job__c=dupJob.id;}
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.Quantity__c.isCreateable()) { objJEst.Quantity__c=es.Quantity__c;}
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.Amount__c.isCreateable()) {  objJEst.Amount__c=es.Amount__c;}
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Code__c.isCreateable()) { objJEst.GL_Code__c=es.GL_Code__c;}
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Department__c.isCreateable()) { objJEst.GL_Department__c=es.GL_Department__c;}
                    if (Schema.sObjectType.Estimate_Line_Items__c.fields.Vendor__c.isCreateable()) { objJEst.Vendor__c =es.Vendor__c ;}
                    insertEstimate.add(objJEst);
                }
                if(Schema.sObjectType.Estimate_Line_Items__c.isCreateable()){ 
                    insert insertEstimate;}
            }
        }
        catch(Exception e)
        {
            isError = 'true';
            resResult.add(isError);
            resResult.add(NewJobId);
            resResult.add(''+e.getMessage());
            return resResult;
        }           
        resResult.add(isError);
        resResult.add(NewJobId);
        resResult.add('No Error');
        return resResult;
    }
    
    @AuraEnabled
    public static list<Job_Team__c> JobRelatedTeamlist(String JobId) {
        list<Job_Team__c> lstTeam = [select id,Name,Staff__c,Email__c,Role__c from Job_Team__c where job__c = : JobId WITH SECURITY_ENFORCED];
        return lstTeam;
    }
    
    
    @AuraEnabled
    public static string sendEmailWorkOrderToJobTeam(String JobId, string emails, String sub,String body) {
        system.debug('>>>>> emails >>>>>>'+emails);
        String addresses;
        Blob b;
        list<string> st1 = new list<string>(); 
        PageReference pdf = Page.Workorder;
        system.debug('pdf==='+pdf);
        pdf.getParameters().put('id',JobId);
        pdf.setRedirect(true);
        job__C j =[select Name,Job_Auto_Number__c,id from job__c where id =:JobId WITH SECURITY_ENFORCED];        
        // list<Job_Team__c> lstTeam = [select id,Name,Staff__c,Email__c from Job_Team__c where job__c = : JobId WITH SECURITY_ENFORCED];
        //  system.debug('****'+ lstTeam.size());
        /*  list<string> st = new list<string>();
for(string jst:emails)
{
st1.add(jst);
}
system.debug('>>>>> emails st1 >>>>>>'+st1);*/
        // Take the PDF content and Create the email attachment
        if (!Test.IsRunningTest())  b = pdf.getContent();
        system.debug('b==='+b);
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Workorder.pdf');
        efa.setBody(b);
          system.debug('efa==='+efa);
        // Loop through the whole list of contacts and their emails
        if(emails!=null)
        {
            /*addresses = st1[0];
for (Integer i = 1; i < st1.size(); i++) {
system.debug('****st1 st1 st1******'+st1);
if (st1!= null)
{ 
addresses += ':' + st1[i];
}
system.debug('**********'+addresses);
}*/
            list<string> emaillist=emails.split(',');
            system.debug('****emaillist******'+emaillist);
            //String[] toAddresses = emaillist[0].split(',');
            system.debug('&&&&&&&emaillist&&&&&&&&'+emaillist);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(emaillist);
            mail.setSubject(sub);//'Work Order for Job Name:'+j.name+', Job # :'+j.Job_Auto_Number__c);
            mail.setHtmlBody(body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa }); 
              system.debug('mail==='+mail);
            // Send the email
            try
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Mail sent Sucessfully!'));
                return 'OK';
            }
            catch(Exception e)
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Messege Sending Failed'));
                return 'Message Sending Failed.';
            }
        }
        else
        {
            //isError=true;
            // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'No Team members avaliable'));
            return 'No Team members avaliable for this Job.';
        }
    }
    
    @AuraEnabled
    public static string checkDelete(String JobId)
    {
        Job__c obj = [select id,Name from Job__c where id =: JobId WITH SECURITY_ENFORCED];   
        try
        {
            if(Job__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(obj); 
                return 'OK';}
            else{
                return 'Error';
            }
        }
        catch(System.DMLException e)
        {
            return ''+e.getMessage();
        }
    }
    
    @AuraEnabled
    public static string ContinuetoDelete(String JobId)
    {
        list<Job_Task__c> JobTaks = [SELECT Id,Name,Job__c FROM Job_Task__c WHERE Job__c =:JobId WITH SECURITY_ENFORCED];
        list<Job_Spec__c> JobSpec = [SELECT Id,Name,Job__c FROM Job_Spec__c WHERE Job__c =:JobId WITH SECURITY_ENFORCED];
        list<Quote__c> JobQuotes = [SELECT Id,Name,Job__c FROM Quote__c WHERE Job__c =:JobId WITH SECURITY_ENFORCED];
        list<Estimate_Line_Items__c> JobEstms = [SELECT Id,Name,Job__c FROM Estimate_Line_Items__c WHERE Job__c =:JobId WITH SECURITY_ENFORCED];
        list<PO_Line_Item__c> JobPOLI = [SELECT Id, Purchase_Order__c, Estimate_Line_Item__c  FROM PO_Line_Item__c where Purchase_Order__r.Job__c = :JobId or Estimate_Line_Item__r.Job__c = :JobId WITH SECURITY_ENFORCED];
        list<Purchase_Order__c> JobPO = [SELECT Id,Name,Job__c FROM Purchase_Order__c WHERE Job__c =:JobId WITH SECURITY_ENFORCED];
        list<Invoice__c> JobInv = [SELECT Id,Name,Job__c FROM Invoice__c WHERE Job__c =:JobId WITH SECURITY_ENFORCED];
        
        try{
            if(Job_Task__c.sObjectType.getDescribe().isDeletable()){ delete JobTaks;}
            if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){ delete JobSpec;}
            if(Quote__c.sObjectType.getDescribe().isDeletable()){ delete JobQuotes;}
            if(PO_Line_Item__c.sObjectType.getDescribe().isDeletable()){delete JobPOLI;}
            
            if(Estimate_Line_Items__c.sObjectType.getDescribe().isDeletable()){ delete JobEstms;}
            if(Purchase_Order__c.sObjectType.getDescribe().isDeletable()){ delete JobPO;}
            if(Invoice__c.sObjectType.getDescribe().isDeletable()){delete JobInv;}
            
            Job__c obj = [select id,Name from Job__c where id =: JobId WITH SECURITY_ENFORCED];
            if(Job__c.sObjectType.getDescribe().isDeletable()){
                delete obj;  }  
        } 
        
        catch(System.DMLException e)
        {
            return ''+e.getMessage();
        }
        
        return 'OK';
    }
    
    
    @AuraEnabled
    public static List<String> duplicateCampain(String OldcampId) {
        List<String> resResult=new List<String>();
        String campName;
        String NewCampId='';
        string isError='false';
        
        list<Job__c> jobsUnderCamp=new list<Job__c>();
        list<Job__c> DupJobsInsert=new list<Job__c>();
        list<Staff__c> staffs=new list<Staff__c>();
        list<Client_Contact__c> CCs=new list<Client_Contact__c>();
        list<Vendor_Contact__c> VCs=new list<Vendor_Contact__c>();
        Set<String> ClientNames=new set<String>();
        Set<String> VendorNames=new set<String>();
        Set<String> staffNames=new set<String>();
        Map<String,Set<String>> Client_ContactMap=new Map<String,Set<String>>();
        list<ID> Clientlist=new list<ID>();
        
        Campaign__c camp=[SELECT Id, Name,CreatedById, Active__c, Status__c, Budgeted_Cost__c, Start_Date__c, End_Date__c, Actual_Cost__c, Description__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Date_1__c, Dummy_Text_6__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Currency_1__c, Dummy_Currency_2__c, Job_Estimates__c FROM Campaign__c where Id=:OldcampId WITH SECURITY_ENFORCED];
        String Dt1=''+DateTime.Now();
        campName=Dt1.substring(11,19)+' '+Dt1.substring(0,10)+': '+camp.Name;
        if(campName.length()>45)
            campName=campName.substring(0,45);
        
        jobsUnderCamp=[select id, Name, Media_Types__c, Schedule_Template__c, Start_Date__c, Due_Date__c, JS_Client__c,JS_Client_Contact__c,UpdateSchedDateFieldCheck__c, Creative_Overview__c,Campaign__c,  Specification_Template__c, CreatedById, Budgeted_Cost__c,  Completion_Date__c, Number_of_Days__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Estimate_Total__c, Flag__c, Job_Description__c, marked_Done__c, Schedule_Calc__c, Status__c, Status_Notes__c, Traffic_Notes__c from Job__c where Campaign__c=:camp.id WITH SECURITY_ENFORCED];
        
        for(Job__c jb:jobsUnderCamp){
            if(jb.JS_Client__c!=null){
                Clientlist.add(jb.JS_Client__c);
            }
        }
        
        String query1 ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by name';
        staffs =Database.query(query1);
        for(Staff__c s:staffs){
            staffNames.add(s.name);
        }
        
        String query3 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true WITH SECURITY_ENFORCED order by name';
        VCs= Database.query(query3);
        for(Vendor_Contact__c  s:VCs){
            VendorNames.add(s.name);
        }    

        String query2 ='SELECT id,name,Active__c,Client__c  from Client_Contact__c Where Client__c IN: Clientlist AND Active__c=true WITH SECURITY_ENFORCED  Order by name';
        CCs= Database.query(query2);   
        for(Client_Contact__c  s:CCs){
            ClientNames.add(s.name);
            
            if(!Client_ContactMap.ContainsKey(s.Client__c)){
                Client_ContactMap.put(s.Client__c,new set<String>{s.name});
            }
            else{
                set<String> Ccons=new set<String>();
                Ccons=Client_ContactMap.get(s.Client__c);
                Ccons.add(s.Name);
                Client_ContactMap.put(s.Client__c,Ccons);
            }
        }   
        System.debug('=======camp======'+camp);
        System.debug('=======OldcampId======'+OldcampId);
        System.debug('=======jobsUnderCamp======'+jobsUnderCamp);
        System.debug('=======Clientlist Id ======'+Clientlist);
        System.debug('=======Client Contact Names ======'+ClientNames);
        System.debug('=======Active and Not Delted staffNames list======'+staffNames);
        System.debug('=======Active Vendor Contact Namelist======'+VendorNames);
        System.debug('=============Client_ContactMap with Client Id and Client Contact Names================'+Client_ContactMap);
        try{
            Campaign__c DupCamp=new Campaign__c();
            if(Schema.sObjectType.Campaign__c.fields.Name.isCreateable()){
                DupCamp.Name=campName;
            }
            //CreatedById=camp.CreatedById,
            if(Schema.sObjectType.Campaign__c.fields.Active__c.isCreateable()){
                DupCamp.Active__c=camp.Active__c; 
            }
            if(Schema.sObjectType.Campaign__c.fields.Status__c.isCreateable()){
                DupCamp.Status__c=camp.Status__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Budgeted_Cost__c.isCreateable()){
                DupCamp.Budgeted_Cost__c=camp.Budgeted_Cost__c; 
            }
            if(Schema.sObjectType.Campaign__c.fields.Start_Date__c.isCreateable()){
                DupCamp.Start_Date__c=camp.Start_Date__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.End_Date__c.isCreateable()){
                DupCamp.End_Date__c=camp.End_Date__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Actual_Cost__c.isCreateable()){
                DupCamp.Actual_Cost__c=camp.Actual_Cost__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Description__c.isCreateable()){
                DupCamp.Description__c=camp.Description__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Text_1__c.isCreateable()){
                DupCamp.Dummy_Text_1__c=camp.Dummy_Text_1__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Text_2__c.isCreateable()){
                DupCamp.Dummy_Text_2__c=camp.Dummy_Text_2__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Text_3__c.isCreateable()){
                DupCamp.Dummy_Text_3__c=camp.Dummy_Text_3__c; 
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Text_4__c.isCreateable()){
                DupCamp.Dummy_Text_4__c=camp.Dummy_Text_4__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Text_5__c.isCreateable()){
                DupCamp.Dummy_Text_5__c=camp.Dummy_Text_5__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Date_1__c.isCreateable()){
                DupCamp.Dummy_Date_1__c=camp.Dummy_Date_1__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Text_6__c.isCreateable()){
                DupCamp.Dummy_Text_6__c=camp.Dummy_Text_6__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Date_2__c.isCreateable()){ 
                DupCamp.Dummy_Date_2__c=camp.Dummy_Date_2__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Date_3__c.isCreateable()){
                DupCamp.Dummy_Date_3__c=camp.Dummy_Date_3__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Date_4__c.isCreateable()){
                DupCamp.Dummy_Date_4__c=camp.Dummy_Date_4__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Date_5__c.isCreateable()){
                DupCamp.Dummy_Date_5__c=camp.Dummy_Date_5__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Date_6__c.isCreateable()){
                DupCamp.Dummy_Date_6__c=camp.Dummy_Date_6__c; 
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Picklist_1__c.isCreateable()){
                DupCamp.Dummy_Picklist_1__c=camp.Dummy_Picklist_1__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Picklist_2__c.isCreateable()){
                DupCamp.Dummy_Picklist_2__c=camp.Dummy_Picklist_2__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Picklist_3__c.isCreateable()){
                DupCamp.Dummy_Picklist_3__c=camp.Dummy_Picklist_3__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Picklist_4__c.isCreateable()){
                DupCamp.Dummy_Picklist_4__c=camp.Dummy_Picklist_4__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Picklist_5__c.isCreateable()){
                DupCamp.Dummy_Picklist_5__c=camp.Dummy_Picklist_5__c; 
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Picklist_6__c.isCreateable()){
                DupCamp.Dummy_Picklist_6__c=camp.Dummy_Picklist_6__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Currency_1__c.isCreateable()){
                DupCamp.Dummy_Currency_1__c=camp.Dummy_Currency_1__c;
            }
            if(Schema.sObjectType.Campaign__c.fields.Dummy_Currency_2__c.isCreateable()){
                DupCamp.Dummy_Currency_2__c=camp.Dummy_Currency_2__c; 
            }
            if(Schema.sObjectType.Campaign__c.fields.Job_Estimates__c.isCreateable()){
                DupCamp.Job_Estimates__c=camp.Job_Estimates__c;
            }
            
            if(Schema.sObjectType.Campaign__c.isCreateable()){
                insert DupCamp;
            }
            NewCampId=DupCamp.Id;
            for(Job__c j:jobsUnderCamp){
                
                String JobName=''+DateTime.Now();
                JobName=JobName.substring(11,19)+' '+JobName.substring(0,10)+': '+j.Name;
                if(JobName.length() > 80)
                {
                    JobName = JobName.substring(0,80);
                }
                Job__c cj= new Job__c();
                if(Schema.sObjectType.Job__c.fields.Name.isCreateable()){
                    cj.Name=JobName;
                }
                if(Schema.sObjectType.Job__c.fields.Media_Types__c.isCreateable()){
                    cj.Media_Types__c=j.Media_Types__c;
                }
                if(Schema.sObjectType.Job__c.fields.Schedule_Template__c.isCreateable()){
                    cj.Schedule_Template__c=j.Schedule_Template__c;
                }
                if(Schema.sObjectType.Job__c.fields.UpdateSchedDateFieldCheck__c.isCreateable()){
                    cj.UpdateSchedDateFieldCheck__c=j.UpdateSchedDateFieldCheck__c;
                }
                if(Schema.sObjectType.Job__c.fields.Specification_Template__c.isCreateable()){
                    cj.Specification_Template__c=j.Specification_Template__c;
                }
                if(Schema.sObjectType.Job__c.fields.Start_Date__c.isCreateable()){
                    cj.Start_Date__c=j.Start_Date__c;
                }
                if(Schema.sObjectType.Job__c.fields.Due_Date__c.isCreateable()){
                    cj.Due_Date__c=j.Due_Date__c;
                }
                if(Schema.sObjectType.Job__c.fields.JS_Client__c.isCreateable()){
                    cj.JS_Client__c=j.JS_Client__c;
                }
                if(Schema.sObjectType.Job__c.fields.JS_Client_Contact__c.isCreateable()){
                    cj.JS_Client_Contact__c=j.JS_Client_Contact__c;
                }
                if(Schema.sObjectType.Job__c.fields.Campaign__c.isCreateable()){
                    cj.Campaign__c=DupCamp.id;
                }
                if(Schema.sObjectType.Job__c.fields.Budgeted_Cost__c.isCreateable()){
                    cj.Budgeted_Cost__c = j.Budgeted_Cost__c;
                }
                if(Schema.sObjectType.Job__c.fields.Completion_Date__c.isCreateable()){
                    cj.Completion_Date__c = j.Completion_Date__c;
                }
                if(Schema.sObjectType.Job__c.fields.Number_of_Days__c.isCreateable()){
                    cj.Number_of_Days__c = j.Number_of_Days__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Date_1__c.isCreateable()){
                    cj.Dummy_Date_1__c = j.Dummy_Date_1__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Date_2__c.isCreateable()){
                    cj.Dummy_Date_2__c = j.Dummy_Date_2__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Date_3__c.isCreateable()){
                    cj.Dummy_Date_3__c = j.Dummy_Date_3__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Date_4__c.isCreateable()){
                    cj.Dummy_Date_4__c = j.Dummy_Date_4__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Date_5__c.isCreateable()){
                    cj.Dummy_Date_5__c = j.Dummy_Date_5__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Date_6__c.isCreateable()){
                    cj.Dummy_Date_6__c = j.Dummy_Date_6__c;
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Picklist_1__c.isCreateable()){
                    cj.Dummy_Picklist_1__c = j.Dummy_Picklist_1__c;
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Picklist_2__c.isCreateable()){
                    cj.Dummy_Picklist_2__c = j.Dummy_Picklist_2__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Picklist_3__c.isCreateable()){
                    cj.Dummy_Picklist_3__c = j.Dummy_Picklist_3__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Picklist_4__c.isCreateable()){
                    cj.Dummy_Picklist_4__c = j.Dummy_Picklist_4__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Picklist_5__c.isCreateable()){
                    cj.Dummy_Picklist_5__c = j.Dummy_Picklist_5__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Picklist_6__c.isCreateable()){
                    cj.Dummy_Picklist_6__c = j.Dummy_Picklist_6__c;
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Text_1__c.isCreateable()){
                    cj.Dummy_Text_1__c = j.Dummy_Text_1__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Text_2__c.isCreateable()){
                    cj.Dummy_Text_2__c = j.Dummy_Text_2__c;
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Text_3__c.isCreateable()){
                    cj.Dummy_Text_3__c = j.Dummy_Text_3__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Text_4__c.isCreateable()){
                    cj.Dummy_Text_4__c = j.Dummy_Text_4__c; 
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Text_5__c.isCreateable()){
                    cj.Dummy_Text_5__c = j.Dummy_Text_5__c;
                }
                if(Schema.sObjectType.Job__c.fields.Dummy_Text_6__c.isCreateable()){
                    cj.Dummy_Text_6__c = j.Dummy_Text_6__c;
                }
                if(Schema.sObjectType.Job__c.fields.Estimate_Total__c.isCreateable()){
                    cj.Estimate_Total__c = j.Estimate_Total__c;
                }
                if(Schema.sObjectType.Job__c.fields.Flag__c.isCreateable()){
                    cj.Flag__c = j.Flag__c;
                }
                if(Schema.sObjectType.Job__c.fields.Job_Description__c.isCreateable()){
                    cj.Job_Description__c = j.Job_Description__c;
                }
                
                /* marked_Done__c = j.marked_Done__c ,*/ 
                if(Schema.sObjectType.Job__c.fields.Schedule_Calc__c.isCreateable()){
                    cj.Schedule_Calc__c = j.Schedule_Calc__c;
                }
                if(Schema.sObjectType.Job__c.fields.Status__c.isCreateable()){
                    cj.Status__c = j.Status__c;
                }
                if(Schema.sObjectType.Job__c.fields.Status_Notes__c.isCreateable()){
                    cj.Status_Notes__c = j.Status_Notes__c;
                }
                if(Schema.sObjectType.Job__c.fields.Traffic_Notes__c.isCreateable()){
                    cj.Traffic_Notes__c = j.Traffic_Notes__c;
                }
                if(Schema.sObjectType.Job__c.fields.Creative_Overview__c.isCreateable()){
                    cj.Creative_Overview__c = j.Creative_Overview__c;
                }
                DupJobsInsert.add(cj);
            }
            if(DupJobsInsert.size()>0 && Schema.sObjectType.Job__c.isCreateable()){
                insert DupJobsInsert;
                List<Job_Team__c> lstJobTeam=new List<Job_Team__c>();
                lstJobTeam=[Select id from Job_Team__c where Job__c IN:DupJobsInsert WITH SECURITY_ENFORCED];
                System.debug('======lstJobTeam new jobs======'+lstJobTeam);
                if(Schema.sObjectType.Job_Team__c.isDeletable()){
                    delete lstJobTeam;
                }
                // Trigger invokes JobSpec record, but we are duplicating record here.So, We will delete this records and re-create from retrieving from Old Job
                List<Job_Spec__c> deleteJobSpec=new  List<Job_Spec__c>();
                deleteJobSpec=[Select id from Job_Spec__c where Job__c IN:DupJobsInsert WITH SECURITY_ENFORCED];
                System.debug('======deleteJobSpec new jobs======'+deleteJobSpec);
                if(Schema.sObjectType.Job_Spec__c.isDeletable()){
                    delete deleteJobSpec;  
                }
                // Retrieve Team records
                lstJobTeam=[Select id,Job__c, Role__c,Staff__c,Email__c,Job__r.JS_Client__c from Job_Team__c where Job__c IN:jobsUnderCamp  WITH SECURITY_ENFORCED ORDER BY CreatedDate];
                System.debug('======lstJobTeam for older job jobs======'+lstJobTeam);
                List<Job_Team__c> insertJobTeam=new List<Job_Team__c>();
                Map<String,list<Job_Team__c>> jobTeamMap=new Map<String,list<Job_Team__c>>();
                for(Job_Team__c jt1:lstJobTeam)
                {
                    if(!jobTeamMap.ContainsKey(jt1.Job__c)){
                        jobTeamMap.put(jt1.Job__c,new list<Job_Team__c>{jt1});
                    }
                    else{
                        List<Job_Team__c> DlstJobTeam=new List<Job_Team__c>();
                        DlstJobTeam=jobTeamMap.get(jt1.Job__c);
                        DlstJobTeam.add(jt1);
                        jobTeamMap.put(jt1.Job__c,DlstJobTeam);
                    }
                }
                for(integer i=0;i<DupJobsInsert.size();i++)
                {
                    if(jobTeamMap.get(jobsUnderCamp[i].id)!=null)
                    {
                        for(Job_Team__c jt1:jobTeamMap.get(jobsUnderCamp[i].id))
                        {
                            system.debug('The job team is '+jt1);
                            if(staffNames.contains(jt1.Staff__c) || VendorNames.contains(jt1.Staff__c)){
                                Job_Team__c jt=new Job_Team__c();
                                if(Schema.sObjectType.Job_Team__c.fields.Job__c.isCreateable()){
                                    jt.Job__c=DupJobsInsert[i].id;
                                }
                                if(Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()){
                                    jt.Role__c=jt1.Role__c;
                                }
                                if(Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()){
                                    jt.Staff__c=jt1.Staff__c;
                                }
                                if(Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()){
                                    jt.Email__c=jt1.Email__c;
                                }
                                insertJobTeam.add(jt);
                            }
                            else if(Client_ContactMap.ContainsKey(jt1.Job__r.JS_Client__c))
                            {
                                if(Client_ContactMap.get(jt1.Job__r.JS_Client__c).contains(jt1.Staff__c))
                                {
                                    system.debug('The client contact is '+Client_ContactMap.get(jt1.Job__r.JS_Client__c).contains(jt1.Staff__c));
                                    Job_Team__c jt11=new Job_Team__c();
                                    if(Schema.sObjectType.Job_Team__c.fields.Job__c.isCreateable()){
                                        jt11.Job__c=DupJobsInsert[i].id;
                                    }
                                    if(Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()){
                                        jt11.Role__c=jt1.Role__c;
                                    }
                                    if(Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()){
                                        jt11.Staff__c=jt1.Staff__c;
                                    }
                                    if(Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()){
                                        jt11.Email__c=jt1.Email__c;
                                    }
                                    insertJobTeam.add(jt11);
                                }
                                
                            }
                        }  
                    }
                }
                if(insertJobTeam.size()>0 && Schema.sObjectType.Job_Team__c.isCreateable()){
                    insert insertJobTeam;
                }
                List<Job_Task__c> insertJobTask=new List<Job_Task__c>();
                List<Job_Task__c> lstJT=new List<Job_Task__c>();
                Set<Id> OldTaskId=new Set<Id>();
                Map<Id,Id> mp2 = new Map<Id,Id>();
                Map<Id,Map<String,id>> jttmp1 = new Map<Id,Map<String,id>>();
                Map<Id,Map<Id,id>> jttmp2 = new Map<Id,Map<Id,id>>();
                lstJT=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c,Due_Date__c,Revised_Due_Date__c, Task_Order__c,Start_Date__c,job__c,Job__r.JS_Client__c from Job_Task__c where Job__c IN:jobsUnderCamp  WITH SECURITY_ENFORCED ORDER BY Start_Date__c];
                Map<String,list<Job_Task__c>> jobTasksMap=new Map<String,list<Job_Task__c>>();
                for(Job_Task__c jtsk:lstJT){
                    if(!jobTasksMap.ContainsKey(jtsk.Job__c)){
                        jobTasksMap.put(jtsk.Job__c,new list<Job_Task__c>{jtsk});
                    }
                    else{
                        List<Job_Task__c> DlstJT=new List<Job_Task__c>();
                        DlstJT=jobTasksMap.get(jtsk.Job__c);
                        DlstJT.add(jtsk);
                        jobTasksMap.put(jtsk.Job__c,DlstJT);
                    }
                }
                for(integer i=0;i<DupJobsInsert.size();i++)
                {  
                    if(jobTasksMap.get(jobsUnderCamp[i].id)!=null)
                    {
                        Map<String,Id> mp1 = new Map<String,Id>();
                        for(Job_Task__c task:jobTasksMap.get(jobsUnderCamp[i].id))
                        {
                            OldTaskId.add(task.id);
                            Job_Task__c objJT = new Job_Task__c();
                            if(Schema.sObjectType.Job_Task__c.fields.Name.isCreateable()){
                                objJT.Name = task.Name;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.GL_Code__c.isCreateable()){
                                objJT.GL_Code__c = task.GL_Code__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Report__c.isCreateable()){
                                objJT.Report__c = task.Report__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Locked__c.isCreateable()){
                                objJT.Locked__c = task.Locked__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Days__c.isCreateable()){
                                objJT.Days__c = task.Days__c;
                            }
                            //code added to duplicate the start date for all the tasks
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()){
                                objJT.Start_Date__c = task.Start_Date__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()){
                                objJT.Due_Date__c = task.Due_Date__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isCreateable()){
                                objJT.Revised_Due_Date__c = task.Revised_Due_Date__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isCreateable()){
                                objJT.Task_Order__c = task.Task_Order__c;
                            }
                            if(Schema.sObjectType.Job_Task__c.fields.Job__c.isCreateable()){
                                objJT.Job__c = DupJobsInsert[i].id;
                            }
                            mp1.put(task.Name,task.id);
                            insertJobTask.add(objJT);
                        }
                        jttmp1.put(DupJobsInsert[i].id,mp1); 
                    }   
                }
                if(insertJobTask.size()>0 && Schema.sObjectType.Job_Task__c.isCreateable()){
                    insert insertJobTask;
                }
                System.debug('Schedule record are inserted');
                for(Job_Task__c jt:insertJobTask)
                {
                    // mp2.put(mp1.get(jt.Name),jt.Id);
                    if(!jttmp2.ContainsKey(jt.Job__c)){
                        jttmp2.put(jt.Job__c,new map<Id,Id>{jttmp1.get(jt.Job__c).get(jt.name) => jt.id});
                    }
                    else{
                        Map<Id,id> dtaskmap= new Map<Id,id>();
                        dtaskmap=jttmp2.get(jt.Job__c);
                        dtaskmap.put(jttmp1.get(jt.Job__c).get(jt.name),jt.id);
                        jttmp2.put(jt.Job__c,dtaskmap);
                    }
                }
                System.debug('============lst of Job Tasks============='+lstJT);
                System.debug('============jttmp1============='+jttmp1); 
                System.debug('============jttmp2============='+jttmp2);
                List<Job_Task_Role__c> lstJTR=new List<Job_Task_Role__c>();
                lstJTR=[Select id,Name,User__c,Email__c,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId  WITH SECURITY_ENFORCED];
                Map<String,list<Job_Task_Role__c>> taskRoleMap=new Map<String,list<Job_Task_Role__c>>();
                List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
                for(Job_Task_Role__c jtr:lstJTR){
                    if(!taskRoleMap.ContainsKey(jtr.Job_Task__c)){
                        taskRoleMap.put(jtr.Job_Task__c,new list<Job_Task_Role__c>{jtr});
                    }
                    else{
                        List<Job_Task_Role__c> DlstJTR=new List<Job_Task_Role__c>();
                        DlstJTR=taskRoleMap.get(jtr.Job_Task__c);
                        DlstJTR.add(jtr);
                        taskRoleMap.put(jtr.Job_Task__c,DlstJTR);
                    }
                }
                System.debug('============lstJTR============='+lstJTR); 
                System.debug('============taskRoleMap============='+taskRoleMap);
                for(integer i=0;i<DupJobsInsert.size();i++)
                {  
                    if(jobTasksMap.get(jobsUnderCamp[i].id)!=null)
                    {
                        for(Job_Task__c task:jobTasksMap.get(jobsUnderCamp[i].id))
                        {
                            system.debug('The task is '+task);
                            if(taskRoleMap.get(task.id)!=null){
                                System.debug('========taskRoleMap with task ids======='+taskRoleMap.get(task.id));
                                for(Job_Task_Role__c taskRole:taskRoleMap.get(task.id))
                                {
                                    if(staffNames.contains(taskRole.User__c) || VendorNames.contains(taskRole.User__c)){
                                        Job_Task_Role__c objJTR=new Job_Task_Role__c();
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()){
                                            objJTR.Name=taskRole.Name;
                                        }
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()){
                                            objJTR.Email__c=taskRole.Email__c;
                                        }
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()){
                                            objJTR.User__c=taskRole.User__c;
                                        }
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()){
                                            objJTR.Job_Task__c=jttmp2.get(DupJobsInsert[i].id).get(taskRole.Job_Task__c);
                                        }
                                        insertJTR.add(objJTR);
                                    }
                                    else if(Client_ContactMap.ContainsKey(task.Job__r.JS_Client__c))
                                    {
                                        if(Client_ContactMap.get(task.Job__r.JS_Client__c).contains(taskRole.User__c))
                                        {
                                            Job_Task_Role__c objJTR11=new Job_Task_Role__c();
                                            if(Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()){
                                                objJTR11.Name=taskRole.Name;
                                            }
                                            if(Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()){
                                                objJTR11.Email__c=taskRole.Email__c;
                                            }
                                            if(Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()){
                                                objJTR11.User__c=taskRole.User__c;
                                            }
                                            if(Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()){
                                                objJTR11.Job_Task__c=jttmp2.get(DupJobsInsert[i].id).get(taskRole.Job_Task__c);
                                            }
                                            insertJTR.add(objJTR11);
                                        }
                                    }
                                }
                            }
                        }
                    } 
                }
                System.debug('========insertion of jobtaksroles list======='+insertJTR);
                if(insertJTR.size()>0 && Schema.sObjectType.Job_Task_Role__c.isCreateable()){
                    insert insertJTR;
                }
                System.debug('Job Task Role are inserted');
                List<Job_Spec__c> insertJobSpec=new List<Job_Spec__c>();
                List<Job_Spec__c> lstJS=new List<Job_Spec__c>();
                Map<Id, List<Job_Spec__c>> jspecMap=new Map<Id, List<Job_Spec__c>> ();
                lstJS=[Select id,Name,Description__c,Job__c,Creative_Brief_Template__c from Job_Spec__c where Job__c IN:jobsUnderCamp WITH SECURITY_ENFORCED];
                for(Job_Spec__c spec:lstJS)
                {
                    if(!jspecMap.ContainsKey(spec.Job__c)){
                        jspecMap.put(spec.Job__c,new list<Job_Spec__c >{spec});
                    }
                    else{
                        List<Job_Spec__c> DlstJS=new List<Job_Spec__c>();
                        DlstJS=jspecMap.get(spec.Job__c);
                        DlstJS.add(spec);
                        jspecMap.put(spec.Job__c,DlstJS);
                    }
                }
                for(integer i=0;i<DupJobsInsert.size();i++)
                {  
                    if(jspecMap.get(jobsUnderCamp[i].id)!=null)
                    {
                        for(Job_Spec__c jspec:jspecMap.get(jobsUnderCamp[i].id))
                        { 
                            Job_Spec__c objJS=new Job_Spec__c();
                            if(Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()){
                                objJS.Name=jspec.Name;
                            }
                            if(Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()){
                                objJS.Description__c=jspec.Description__c;
                            }
                            if(Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()){
                                objJS.Job__c=DupJobsInsert[i].id;
                            }
                            if(Schema.sObjectType.Job_Spec__c.fields.Creative_Brief_Template__c.isCreateable()){
                                objJS.Creative_Brief_Template__c=jspec.Creative_Brief_Template__c;
                            }
                            insertJobSpec.add(objJS);
                        }
                    }
                }
                if(insertJobSpec.size()>0 && Schema.sObjectType.Job_Spec__c.isCreateable()){
                    insert insertJobSpec;
                }
                System.debug('Job Spec Records are re-created');
                List<Graphics_Deliverables__c> InsertGDlist=new List<Graphics_Deliverables__c>();
                List<Graphics_Deliverables__c> GDlist=new List<Graphics_Deliverables__c>();
                Map<Id,List<Graphics_Deliverables__c>> JGraphicMap=new Map<Id,List<Graphics_Deliverables__c >>();
                GDlist=[SELECT Id, Name, Job__c, Graphics_Type__c, Graphics_Description__c, Graphics_Note__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Date_2__c, Dummy_Date_1__c, Dummy_Date_3__c, Dummy_Text_1__c, Dummy_Text_3__c, Dummy_Text_2__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Dummy_Text_7__c, Dummy_Text_8__c, Dummy_Text_9__c, Dummy_Text_10__c, Dummy_Text_11__c, Dummy_Text_12__c, Dummy_Text_13__c, Dummy_Text_14__c, Dummy_Text_15__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Deliverable_Date__c FROM Graphics_Deliverables__c where Job__c IN:jobsUnderCamp WITH SECURITY_ENFORCED];
                for(Graphics_Deliverables__c jgd:GDlist){
                    if(!JGraphicMap.ContainsKey(jgd.Job__c)){
                        JGraphicMap.put(jgd.Job__c,new List<Graphics_Deliverables__c>{jgd});
                    }
                    else{
                        List<Graphics_Deliverables__c> DGDlist=new List<Graphics_Deliverables__c>();
                        DGDlist=JGraphicMap.get(jgd.Job__c);
                        DGDlist.add(jgd);
                        JGraphicMap.put(jgd.Job__c,DGDlist);
                    }
                }
                for(integer i=0;i<DupJobsInsert.size();i++)
                {  
                    if(JGraphicMap.get(jobsUnderCamp[i].id)!=null)
                    {
                        for(Graphics_Deliverables__c gde:JGraphicMap.get(jobsUnderCamp[i].id))
                        {
                            Graphics_Deliverables__c ObjGd=new Graphics_Deliverables__c();
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Name.isCreateable()){
                                ObjGd.Name=gde.Name;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Job__c.isCreateable()){
                                ObjGd.Job__c=DupJobsInsert[i].id;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Type__c.isCreateable()){
                                ObjGd.Graphics_Type__c=gde.Graphics_Type__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Description__c.isCreateable()){
                                ObjGd.Graphics_Description__c=gde.Graphics_Description__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Note__c.isCreateable()){
                                ObjGd.Graphics_Note__c=gde.Graphics_Note__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Deliverable_Date__c.isCreateable()){
                                ObjGd.Deliverable_Date__c=gde.Deliverable_Date__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_1__c.isCreateable()){
                                ObjGd.Dummy_Date_1__c=gde.Dummy_Date_1__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_2__c.isCreateable()){
                                ObjGd.Dummy_Date_2__c=gde.Dummy_Date_2__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_3__c.isCreateable()){
                                ObjGd.Dummy_Date_3__c=gde.Dummy_Date_3__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_4__c.isCreateable()){
                                ObjGd.Dummy_Date_4__c=gde.Dummy_Date_4__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_5__c.isCreateable()){
                                ObjGd.Dummy_Date_5__c=gde.Dummy_Date_5__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_1__c.isCreateable()){
                                ObjGd.Dummy_Text_1__c=gde.Dummy_Text_1__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_2__c.isCreateable()){
                                ObjGd.Dummy_Text_2__c=gde.Dummy_Text_2__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_3__c.isCreateable()){
                                ObjGd.Dummy_Text_3__c=gde.Dummy_Text_3__c;  
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_4__c.isCreateable()){
                                ObjGd.Dummy_Text_4__c=gde.Dummy_Text_4__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_5__c.isCreateable()){
                                ObjGd.Dummy_Text_5__c=gde.Dummy_Text_5__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_6__c.isCreateable()){
                                ObjGd.Dummy_Text_6__c=gde.Dummy_Text_6__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_7__c.isCreateable()){
                                ObjGd.Dummy_Text_7__c=gde.Dummy_Text_7__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_8__c.isCreateable()){
                                ObjGd.Dummy_Text_8__c=gde.Dummy_Text_8__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_9__c.isCreateable()){
                                ObjGd.Dummy_Text_9__c=gde.Dummy_Text_9__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_10__c.isCreateable()){
                                ObjGd.Dummy_Text_10__c=gde.Dummy_Text_10__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_11__c.isCreateable()){
                                ObjGd.Dummy_Text_11__c=gde.Dummy_Text_11__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_12__c.isCreateable()){
                                ObjGd.Dummy_Text_12__c=gde.Dummy_Text_12__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_13__c.isCreateable()){
                                ObjGd.Dummy_Text_13__c=gde.Dummy_Text_13__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_14__c.isCreateable()){
                                ObjGd.Dummy_Text_14__c=gde.Dummy_Text_14__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_15__c.isCreateable()){
                                ObjGd.Dummy_Text_15__c=gde.Dummy_Text_15__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_1__c.isCreateable()){
                                ObjGd.Dummy_Picklist_1__c=gde.Dummy_Picklist_1__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_2__c.isCreateable()){
                                ObjGd.Dummy_Picklist_2__c=gde.Dummy_Picklist_2__c;
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_3__c.isCreateable()){
                                ObjGd.Dummy_Picklist_3__c=gde.Dummy_Picklist_3__c;  
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_4__c.isCreateable()){
                                ObjGd.Dummy_Picklist_4__c=gde.Dummy_Picklist_4__c; 
                            }
                            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_5__c.isCreateable()){
                                ObjGd.Dummy_Picklist_5__c=gde.Dummy_Picklist_5__c; 
                            }
                            
                            InsertGDlist.add(ObjGd);
                        }
                    }
                }
                if(InsertGDlist.size()>0 && Schema.sObjectType.Graphics_Deliverables__c.isCreateable()){
                    insert InsertGDlist;
                }
            }
        }
        catch(System.DMLException e)
        {
            isError='true';
            resResult.add(isError);
            resResult.add(NewCampId);
            resResult.add(''+e.getMessage());
        }
        resResult.add(isError);
        resResult.add(NewCampId);
        resResult.add('No Error');
        return resResult; 
    }
    
    @AuraEnabled
    public static string CampaignDelete(String CampId){
        Campaign__c CampObj = [select Id,Name From Campaign__c where Id =:CampId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Campaign__c.isDeletable()){
                Database.delete(CampObj);
                return 'OK';
            }
            else{
                return 'Campaign has Insufficient access to Delete';
                // return 'Error, '+SObjectType.Campaign__c.getLabel()+' '+System.Label.Delete_Label;
            }
        }
        Catch(System.DMLException e){
            return ''+e.getMessage();
        }
    }
    
    public class StaffWrappersjobteam{
        // Public Staff__c Staff{get;set;}
        @AuraEnabled public Sobject sobjet{get;set;}
        @AuraEnabled public boolean selection{get;set;}
        @AuraEnabled Public boolean Sroles{get;set;}
        // @AuraEnabled Public SObjectWrappers Sojw{get;set;}
        @AuraEnabled Public String SobjType{get;set;}
        
        //@AuraEnabled   public Staff__c staff{get;set;}
        // @AuraEnabled   public Client_Contact__c CContact{get;set;}
        // @AuraEnabled   public Vendor_Contact__c VContact{get;set;}
        @AuraEnabled   Public String  Staffname{get;set;}
        @AuraEnabled   Public String  Username{get;set;}
        @AuraEnabled   Public String  Rolename{get;set;}
        @AuraEnabled   Public Boolean Active{get;set;}
        @AuraEnabled   Public String  Email{get;set;}
        
        public StaffWrappersjobteam(Sobject sb, String st, Boolean STroles){
            this.sobjet=sb;
            this.SobjType=st;
            selection = False;
            this.Sroles=STroles;
            // Sojw=new SObjectWrappers(sobjet,SobjType);
            if(SobjType=='Client_Contact__c'){
                Client_Contact__c CContact=(Client_Contact__c)sb;
                this.Staffname=CContact.Name;
                this.Username=CContact.Username__c;
                this.Rolename=CContact.Client_Contact_Role__c;
                this.Active=CContact.Active__c;
                this.Email=CContact.Email__c;
            }
            
            if(SobjType=='Vendor_Contact__c'){
                Vendor_Contact__c VContact =(Vendor_Contact__c)sb;
                this.Staffname=VContact.Name;
                this.Username=VContact.User_name__c;
                this.Rolename=VContact.Role__c;
                this.Active=VContact.Active__c;
                this.Email=VContact.Email__c;
            }
            
            if(SobjType=='Staff__c'){
                Staff__c staff=(Staff__c)sb;
                this.Staffname=staff.Name;
                this.Username=staff.Username__c;
                this.Rolename=staff.Role__c;
                this.Active=staff.Active__c;
                this.Email=staff.Email__c;
            }
        }
    }
}