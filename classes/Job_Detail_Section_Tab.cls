public With Sharing class Job_Detail_Section_Tab {
    
    @AuraEnabled
    public static List<Approval_Job_Task__c> viewApprovalStepsrelTask(String TskId)
    {
        return [select id,name,task__c,Status__c,Assigned_Users__c,File_Name__c,Revised_Due_Date__c,Submitter_Name__c from Approval_Job_Task__c where task__c=:TskId and status__c='In Progress' order by Revised_Due_Date__c];
    }
    
    @AuraEnabled
    public static List<boolean> CreateAppStepAtTaskJobTskSetting() {  
        List<boolean> csList=new List<boolean>();
        // boolean activeCreateProcess;
        // boolean activeFileAttach;
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        //  activeCreateProcess=setting.Job_Task_Level__c;
        //  activeFileAttach=setting.File_Attach_at_Task_Level__c;
        
        csList.add(setting.Job_Task_Level__c);//enable approval process steps at task level
        csList.add(setting.File_Attach_at_Task_Level__c);
        return csList;
    }
    
    
    /******************************* Get the job Related Files ********************************************/
    @AuraEnabled
    public static  Map < Id, String > getAttachments(String recordId){
        try {
            Map < Id, String > cvMap = new Map < Id, String > ();
            List<String> cdIdList = new List<String> ();
            
            Set<String> fileFormats = new Set<String> { 
                'pdf', 
                    'docx', 
                    'xlsx',
                    'pptx',
                    'jpg',
                    'jpeg',
                    'png',
                    'tif',
                    'xlsx'
                    };
                        
                        for(ContentDocumentLink cdl : [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ]) {
                            cdIdList.add(cdl.ContentDocumentId);
                            System.debug('ContentDocumentLink List: ' + cdIdList);
                        }
            //Use links to get attachments
            cvMap.put(null, '--None--');
            for(ContentVersion cv : [SELECT Id, Title,FileExtension,ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId IN :cdIdList/* AND IsLatest = true*/ Order by CreatedDate ASC ]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    if(!cvMap.containsKey(cv.ContentDocumentId)){
                        cvMap.put(cv.ContentDocumentId, cv.Title+'.'+cv.FileExtension);
                    }
                    
                }
            }
            
            system.debug(cvMap);
            return cvMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /******************************* Get the Approval Schedule Templates ********************************************/
    @AuraEnabled
    public static Map < Id, String > getApprovalSchTemplates() {
        Map < Id, String > ApprovalSchTempMap = new Map < Id, String > ();
        List < Approval_Schedule_Template__c > ApprovaltempLst = [SELECT Id, name FROM Approval_Schedule_Template__c where Active__c =:True  WITH SECURITY_ENFORCED ORDER BY Name];
        ApprovalSchTempMap.put(null, '--None--');
        for (Approval_Schedule_Template__c Aschtemp: ApprovaltempLst) {
            ApprovalSchTempMap.put(Aschtemp.Id, Aschtemp.Name);
        }
        return ApprovalSchTempMap;
    }
    
    /************************************** Selected file updated in the Task for annotation **********************************************/ 
    @AuraEnabled
    public static string updateFiletoTask(String jobTskId, String TaskFileId)
    {
        try{
            system.debug('>>>>>>jobTskId>>>>>>>>'+jobTskId);
            system.debug('>>>>>>TaskFileId>>>>>>>>'+TaskFileId);
            string FileName;
            ContentVersion cv=[SELECT Id, Title,FileExtension, ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId=:TaskFileId order by CreatedDate ASC limit 1];//AND IsLatest = true Order by LastModifiedDate DESC Limit 1];
            FileName=cv.Title+'.'+cv.FileExtension;
            
            Job_Task__c objjobTask=[select id,Name,Job__c From Job_Task__c where Id=:jobTskId WITH SECURITY_ENFORCED];
            objjobTask.File_Name__c=FileName;
            objjobTask.Content_Document_ID__c=cv.ContentDocumentId;
            update objjobTask;
        }
        catch(exception e)
        {
            system.debug('The exception is '+e.getMessage()+ '' + '' + 'The reason is '+e.getCause()+ '' + '' + 'The line number is '+e.getLineNumber());
        } 
        
        return 'OK';
    }
    
    /******************************* To create Approval Job Task ********************************************/
    @AuraEnabled
    public static string createApprovalTask(String jobTskId, String TaskFileId, String AppSchedTemp)
    {
        system.debug('>>>>>>jobTskId>>>>>>>>'+jobTskId);
        system.debug('>>>>>>TaskFileId>>>>>>>>'+TaskFileId);
        system.debug('>>>>>>AppSchedTemp>>>>>>>>'+AppSchedTemp);
        Set<Id> stAprScheduleTaskId = new Set<Id>(); 
        List<Approval_Job_Task__c> lstJT=new List<Approval_Job_Task__c>();
        Map<String,Id> mp1 = new Map<String,Id>();
        Map<Id,Id> mp2 = new Map<Id,Id>();
        lstJT=[Select Id from Approval_Job_Task__c where Task__c =: jobTskId and File_ID__c=:TaskFileId  WITH SECURITY_ENFORCED];
        
        string FileName;
        
        ContentVersion cv=[SELECT Id, Title,FileExtension, ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId=:TaskFileId order by CreatedDate ASC limit 1];//AND IsLatest = true Order by LastModifiedDate DESC Limit 1];
        FileName=cv.Title+'.'+cv.FileExtension;
        System.debug('==========FileName==========:'+FileName);
        
        Set<Date> holidaysNew= new Set<Date>();
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
        {
            holidaysNew.add(hc.Date__c);
        } 
        
        Set<Id> stAprScheduleTemplateId = new Set<Id>();
        // Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__c, Schedule_Calc__c from Job__c where Id=:jobId WITH SECURITY_ENFORCED];
        
        Job_Task__c objjobTask=[select id,Name,Job__c,Job__r.Name,Job__r.Job_Auto_Number__c,Job__r.Schedule_Template__c,Job__r.Start_Date__c,Job__r.Due_Date__c,Job__r.Schedule_Calc__c From Job_Task__c where Id=:jobTskId WITH SECURITY_ENFORCED];
        
        
        List<Approval_Schedule_Task__c> lstAprScheduleTask=new List<Approval_Schedule_Task__c>();          
        List<Approval_Job_Task__c> lstAprJobTask=new List<Approval_Job_Task__c>();
        Datetime NTSD;
        // Dateerror=false;
        if(objjobTask.Job__r.Schedule_Calc__c=='Start Date' && objjobTask.Job__r.Start_Date__c==null){
            return 'You must enter Start Date value in job';
        }
        else if(objjobTask.Job__r.Schedule_Calc__c=='End Date' && objjobTask.Job__r.Due_Date__C==null){
            return 'You must enter End Date value in job';
        }
        else
        {
            
            if(lstJT.size() > 0) // To check Schedule Is not Created yet
            { 
                return 'You have already created an approval process for this File.';
            }
            Boolean blnFroward = true;
            if(objjobTask.Job__r.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }
            
            Date std;
            
            if(blnFroward)
            {
                std=Date.newInstance(objjobTask.Job__r.Start_Date__c.Year(),objjobTask.Job__r.Start_Date__c.month(),objjobTask.Job__r.Start_Date__c.Day());
                lstAprScheduleTask=[Select Name,Days__c,Task_Order__c,Roles__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c =: AppSchedTemp WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
            }
            else
            {
                std=Date.newInstance(objjobTask.Job__r.Due_Date__c.Year(),objjobTask.Job__r.Due_Date__c.month(),objjobTask.Job__r.Due_Date__c.Day());
                lstAprScheduleTask=[Select Name,Days__c,Task_Order__c,Roles__c,(select id, name from Approval_Schedule_Task_Role__r) from Approval_Schedule_Task__c where Approval_Schedule_Template__c =: AppSchedTemp WITH SECURITY_ENFORCED ORDER BY Task_Order__c desc];
            }
            System.debug('==========std is==========:'+std);
            
            
            if(lstAprScheduleTask.size()==0){
                return 'There is no Steps for this Approval Process Template';
            }   
            
            else{
                
                for(Integer i=0;i<lstAprScheduleTask.size();i++)
                {
                    stAprScheduleTaskId.add(lstAprScheduleTask[i].Id); 
                    Approval_Job_Task__c jt=new Approval_Job_Task__c();
                    system.debug('Value of i : '+i);
                    if(i==0)
                    {
                        if(blnFroward)
                        {
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isCreateable()) {
                                jt.Start_Date__c=std;
                            }
                        }
                        else
                        {
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Due_Date__c.isCreateable()) { 
                                jt.Due_Date__c=std;
                            }
                        }
                    }
                    else
                    {
                        Date d2 = Date.newInstance(NTSD.Year(),NTSD.Month(),NTSD.Day());
                        if(blnFroward)
                        {
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isCreateable()) {
                                jt.Start_Date__c = d2;
                            }
                        }
                        else
                        {
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Due_Date__c.isCreateable()) {
                                jt.Due_Date__c=d2;
                            }
                        }
                    }
                    Datetime dtStartDate;
                    if(blnFroward)
                    {
                        dtStartDate = DateTime.newInstance(jt.Start_Date__c.Year(),jt.Start_Date__c.Month(),jt.Start_Date__c.Day());
                    }
                    else
                    {
                        dtStartDate = DateTime.newInstance(jt.Due_Date__c.Year(),jt.Due_Date__c.Month(),jt.Due_Date__c.Day());
                    }
                    system.debug('Start Date is : ' +dtStartDate);
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Days__c.isCreateable()) {
                        jt.Days__c=lstAprScheduleTask[i].Days__c;
                    }
                    Integer jCount=0;
                    
                    // To calculate Due Date, Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                        
                        // Skip Holiday and Sat-Sun while calulation Due Date & Revised Due Date
                        if((dtStartDate.format('E')!='Sat'&& dtStartDate.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount=jCount+1;
                            if(jCount>jt.Days__c)
                            {
                                break;
                            }
                            system.debug('jCount======' + jCount);
                            system.debug('==========' + dtStartDate);
                            system.debug('===========' + dtStartDate.format('E'));
                            if(blnFroward)
                            {
                                dtStartDate=dtStartDate.addDays(1);
                            }
                            else
                            {
                                dtStartDate=dtStartDate.addDays(-1);
                            }
                            system.debug('After adding 1 day : ' +dtStartDate);
                            
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate);
                            
                            if(blnFroward)
                            {
                                dtStartDate=dtStartDate.addDays(1);
                            }
                            else
                            {
                                dtStartDate=dtStartDate.addDays(-1);
                            }
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate);
                    
                    Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                    system.debug('D1============' +dtStartDate);
                    
                    if(blnFroward)
                    {
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Due_Date__c.isCreateable()) {
                            jt.Due_Date__c=d1;
                        }
                    }
                    else
                    {
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isCreateable()) { 
                            jt.Start_Date__c=d1;
                        }
                    }
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isCreateable()) {
                        jt.Revised_Due_Date__c=jt.Due_Date__c;
                    }
                    System.debug('Due Date : '+jt.Due_Date__c);
                    
                    NTSD=DateTime.valueOf(dtStartDate);
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Name.isCreateable()) 
                    {
                        jt.Name=lstAprScheduleTask[i].Name;
                    }
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Schedule_Roles__c.isCreateable()) { 
                        jt.Schedule_Roles__c=lstAprScheduleTask[i].Roles__c;
                    }
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isCreateable()) {
                        jt.Task_Order__c=lstAprScheduleTask[i].Task_Order__c;
                    }
                    System.Debug('Task Order @@@@@@@@@@@@@@@@@@@@@@@@@'+jt.Task_Order__c);
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Task__c.isCreateable()) {
                        jt.Task__c=jobTskId;
                    }
                    /* if (Schema.sObjectType.Approval_Job_Task__c.fields.Job__c.isCreateable()) {
jt.Job__c=objjobTask.Job__c;
}*/
                    /*if (Schema.sObjectType.Approval_Job_Task__c.fields.Job_Name_and_Num__c.isCreateable()) {
jt.Job_Name_and_Num__c=objjobTask.Job__r.Name +' (#'+objjobTask.Job__r.Job_Auto_Number__c+')';
}*/
                    
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Created_From_Job_Task__c.isCreateable()) {
                        jt.Created_From_Job_Task__c=true;
                    }
                    
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.File_ID__c.isCreateable()) {
                        jt.File_ID__c=TaskFileId;
                    }
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.File_Name__c.isCreateable()) {
                        jt.File_Name__c=FileName;
                    }
                    mp1.put(lstAprScheduleTask[i].Name,lstAprScheduleTask[i].Id);
                    lstAprJobTask.add(jt);
                }
                
                if(Schema.sObjectType.Approval_Job_Task__c.isCreateable()){ 
                    insert lstAprJobTask;
                }
                else{
                    return 'Error, Approval Process have insufficient access to insert';
                }
                
                for(Approval_Job_Task__c jt:lstAprJobTask)
                {
                    mp2.put(mp1.get(jt.Name),jt.Id);
                }        
                
                List<Approval_Schedule_Task_Role__c> lstAprScheduleTaskRole=new List<Approval_Schedule_Task_Role__c>();
                
                lstAprScheduleTaskRole=[Select Id,Name,Approval_Schedule_Task__c,Approval_Schedule_Task__r.Approval_Schedule_Template__c,Approval_Schedule_Task__r.Name from Approval_Schedule_Task_Role__c where Approval_Schedule_Task__c IN : stAprScheduleTaskId WITH SECURITY_ENFORCED];
                
                List<Approval_Job_Task_Roles__c> lstAprJobTaskRole=new List<Approval_Job_Task_Roles__c>();
                
                Job_Team__c[] objJobTeam=[Select Staff__c,Email__c,Role__c from Job_Team__c where Job__c=:objjobTask.Job__c WITH SECURITY_ENFORCED];
                for(Approval_Schedule_Task_Role__c st1:lstAprScheduleTaskRole)
                {
                    //Job_Team__c[] objJobTeam=[Select Staff__c,Email__c from Job_Team__c where Role__c=: st1.Name and Job__c=:jobId ];
                    for(Job_Team__c jteam:objJobTeam){
                        if(jteam.Role__c==st1.Name){
                            Approval_Job_Task_Roles__c objAprJobTaskRole=new Approval_Job_Task_Roles__c();
                            if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Name.isCreateable()) { 
                                objAprJobTaskRole.Name=st1.Name;
                            }
                            if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Approval_Job_Task__c.isCreateable()) { 
                                objAprJobTaskRole.Approval_Job_Task__c=mp2.get(st1.Approval_Schedule_Task__c);
                            }                       
                            String strStaff=jteam.Staff__c;        
                            if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.User__c.isCreateable()) { 
                                objAprJobTaskRole.User__c=strStaff;
                            }
                            if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Email__c.isCreateable()) { 
                                objAprJobTaskRole.Email__c=jteam.Email__c;
                            }
                            lstAprJobTaskRole.add(objAprJobTaskRole);
                        }
                    }
                }  
                try{
                    if(Schema.sObjectType.Approval_Job_Task_Roles__c.isCreateable()){ 
                        insert lstAprJobTaskRole;   
                    }else{
                        return 'Error, Approval step Roles have insufficient access to insert';
                    }
                }  
                catch(Exception e){
                    return e.getMessage();
                }
                return 'OK';
                // After creating Schedule, Navigate To Schedules Tab
            }
        }          
    }
    
    
    @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName) {
        
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        
        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List < Schema.FieldSetMember > fields = fieldMap.get(fieldsetname).getFields();
        List < string > fieldsname = new List < string > ();
        
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        
        return fieldsname;
        
    }
    
    @AuraEnabled
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    @AuraEnabled
    public static string getObjectLabels(List<String> ObjNames){
        System.debug('====Team and Task ObjNames========'+ObjNames);
        return getDynamicLabelUtility.getDescribedObjects(ObjNames); 
    }
    
    
    @AuraEnabled 
    public static List<Boolean> getisAccessable()
    {
        List<boolean> isAccessList=new  List<boolean>();
        isAccessList.add(Schema.sObjectType.Job_Team__c.isAccessible() );
        isAccessList.add(Schema.sObjectType.Job_Task__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Job_Spec__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Job_Team__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Job_Spec__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Job_Spec__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Job_Task__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Job_Task__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Job_Task_Role__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Timesheet_Entries__c.isCreateable());
        return isAccessList;
    }
    
    
    
    
    @AuraEnabled
    public static List<Object> CustomSettingvalues() {
        list<Object> CS=new list<Object>();
        ProductionEstimate__c  PECustom = ProductionEstimate__c.getOrgDefaults();
        CS.add(PECustom);
        Schedule_Buttons__c SBCstom = Schedule_Buttons__c.getOrgDefaults();
        CS.add(SBCstom); 
        // if (Schema.sObjectType.Organization.fields.Address.isAccessible()==true && Schema.sObjectType.Organization.fields.Name.isAccessible()==true ){
        Organization OrgInfo=[SELECT Name, Id, Address FROM Organization Limit:1];//WITH SECURITY_ENFORCED
        CS.add(OrgInfo);//}
        
        //ShowCopySceduleButton=activeSettings.Copy_Schedule_Button__c;
        // ShowoldTimesheetflow=activeSettings.Old_Time_Sheet_Flow__c;
        return CS;
    }
    
    @AuraEnabled
    public static boolean CreateScheduleSetting() {  
        boolean isHD = true;
        Id profileId = UserInfo.getProfileId();
        //if (Schema.sObjectType.Profile.fields.Name.isAccessible()==true){
        Profile p = [Select Id, Name from Profile where Id =: profileId ];//WITH SECURITY_ENFORCED
        
        if(UserInfo.getOrganizationName() == 'Healthy Directions' && (p.Name == 'Client Contact' || p.Name == 'SP Client Contact')){
            isHD = false;  
        }
        //}
        return isHD;    
    }
    
    @AuraEnabled
    public static Date todaySystemDate(){  
        return System.today();
    }
    
    
    @AuraEnabled
    public static Decimal getAllTasksByStatus(String JobId){
        Decimal totalDays = 0;
        Decimal completedDays = 0;
        Decimal PerCompleted = 0;
        List<DataSet> dataSet = new List<DataSet>();
        List<Job_Task__c > lstJobTasks = [Select Id, Name, Status__c, Marked_Done__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Job__c =: JobId  WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
        if(lstJobTasks.size() > 0){
            for(Job_Task__c ts:lstJobTasks){
                totalDays = totalDays + ts.Days__c;
                if(ts.Marked_Done__c){
                    completedDays = completedDays + ts.Days__c;
                }
            }
            PerCompleted=(((Decimal)completedDays/(Decimal)totalDays)*100).setScale(2);
            
            //Decimal RMP=((Decimal)((totalDays-completedDays)/totalDays)).setScale(2); 
            //dataSet.add(new DataSet('Days for the Tasks that are Completed' ,CTP*100));
            //dataSet.add(new DataSet('Days for the Tasks that are not Completed' ,RMP*100)); 
        }
        else{
            // dataSet.add(new DataSet('Days for the Tasks that are Completed' ,completedDays));
            // dataSet.add(new DataSet('Days for the Tasks that are not Completed' ,totalDays-completedDays)); 
            
        } 
        
        
        // System.debug('dataSet'+dataSet);
        return PerCompleted ;
        
    }
    
    @AuraEnabled
    public static List<DataSet> getResourceWorkLoad(String UserRoleString){
        if(UserRoleString=='' || UserRoleString==null)
            UserRoleString='';
        String jobStatus = 'Active';
        List<Job_Team__c> uRolejobTeam = [select Staff__c, Role__c, Job__r.Status__c from Job_Team__c where Role__c=:UserRoleString and  Job__r.Status__c = :jobStatus WITH SECURITY_ENFORCED limit 1000];
        Map<String, Integer> StaffActiveJobsCountMap = new Map<String, Integer>();
        list<String> urstaffList = new list<String>(); 
        List<DataSet> dataSet = new List<DataSet>();
        for(Job_Team__c urjt:uRolejobTeam){
            if(StaffActiveJobsCountMap.keyset().contains(urjt.Staff__c)){
                Integer x = StaffActiveJobsCountMap.get(urjt.Staff__c)+1;
                StaffActiveJobsCountMap.put(urjt.Staff__c, x);
            }
            else{
                StaffActiveJobsCountMap.put(urjt.Staff__c, 1);
            }
        }
        
        for(String ss:StaffActiveJobsCountMap.keyset()){
            dataSet.add(new DataSet(ss ,StaffActiveJobsCountMap.get(ss)));
        }
        
        System.debug('dataSet'+dataSet);
        return dataSet ; 
    }
    
    
    public class DataSet{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public Integer  count {get;set;}
        
        public DataSet(String label ,Integer count){
            this.label  = label ; 
            this.count = count ;
        }
    }
    
    
    @AuraEnabled
    public static list<TeamWrapper> getTeamPhotos(Id recordId) {
        system.debug(recordId);
        list<TeamWrapper> teamwrappelst=new list<TeamWrapper>();
        List < Job_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c, Job__r.Name from Job_Team__c where Job__c = : recordId  WITH SECURITY_ENFORCED order by Staff__c];
        //List < Job_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c, Job__r.Name from Job_Team__c where Job__c = : recordId order by CreatedDate];
        
        List < String > staffNames = new List < String > ();
        Map<String,Job_Team__c> gg=new  Map<String,Job_Team__c>();
        for (Job_Team__c Tstaff: lstJobTeam) {
            gg.put(Tstaff.Staff__c,Tstaff);
            staffNames.add(Tstaff.Staff__c);
        }
        
        Map < SObject, String > TeamImageURlMap = new Map < SObject, String > ();
        list < User > Userlist = new list < User > ();
        
        Userlist = [Select Id, Name, SmallPhotoUrl, FullPhotoUrl From User where Name IN: staffNames and ( User_Types__c!=null OR IsClientContact__c=true OR IsVendorContact__c=true) ]; //WITH SECURITY_ENFORCED
        for (User a: Userlist) {
            if(!a.FullPhotoUrl.contains('/profilephoto/005/F')){
                teamwrappelst.add(new TeamWrapper(gg.get(a.Name),a.FullPhotoUrl));
                TeamImageURlMap.put(gg.get(a.Name), a.FullPhotoUrl);
            }
        }
        
        for (Job_Team__c Tstaff: lstJobTeam) {
            if (!TeamImageURlMap.Containskey(gg.get(Tstaff.Staff__c))) {
                teamwrappelst.add(new TeamWrapper(Tstaff,''));
                TeamImageURlMap.put(Tstaff, '');
            }
        }
        
        system.debug('=====TeamImageURlMap=====' + TeamImageURlMap);
        system.debug('==========lstJobTeam=====' + lstJobTeam);
        return teamwrappelst;
    }
    
    public class TeamWrapper{
        @AuraEnabled public Job_Team__c team {set;get;}
        @AuraEnabled public string photoUrl {set;get;}
        
        public TeamWrapper(Job_Team__c jt,String phourl ){
            this.team=jt;
            this.photoUrl=phourl;
        }
        
    }
    
    @AuraEnabled
    public static  list<StaffWrappers>  JobTeamAddEditStaffCont(String recordId) {
        system.debug('==staffwrapper=recordId===='+recordId);
        list<StaffWrappers>  AllstaffWrappers = new List<StaffWrappers>();       
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
                    AllstaffWrappers.add(new StaffWrappers(s,String.valueof(s.getSobjectType()),Srole.contains(s.role__C)));
                
                else{ 
                    StaffWrappers w =new StaffWrappers(s,String.valueof(s.getSobjectType()),Srole.contains(s.role__C));
                    w.selection = TRUE; 
                    AllstaffWrappers.add(w);
                    StaffNameJobTeam.add(s.name); 
                }
            }
        } 
        System.debug('=====AllstaffWrappers debug==='+AllstaffWrappers);
        return AllstaffWrappers;
    }
    
    //Start method  Search for staffs 
    @AuraEnabled
    public static list < StaffWrappers > SerachStaff(String jobId, String StatusString) {
        String clientid;
        list < Staff__c > staffs = new list < Staff__c > ();
        list < Client_Contact__c > CCs = new list < Client_Contact__c > ();
        list < Vendor_Contact__c > VCs = new list < Vendor_Contact__c > ();
        Map<String,Job_Team__c> staffJobTeamMap = new Map<String,Job_Team__c>();
        Set<String> StaffNameJobTeam =new Set<String>();
        list < StaffWrappers > AllstaffWrappers = new List < StaffWrappers > ();
        
        list < Job_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c, Job__c, Email__c, Job__r.Name from Job_Team__c where job__c = : jobId WITH SECURITY_ENFORCED order by Name];
        if (StatusString == 'All') {
            
            //AllstaffWrappers.clear();
            Set < string > Srole = new Set < String > ();
            Set < Id > Staskid = new Set < Id > ();
            
            Job__c jobrecord = [select id, JS_Client__c, name, Schedule_Template__c from Job__c where id = : jobId WITH SECURITY_ENFORCED];
            clientid = jobrecord.JS_Client__c;
            system.debug('ClientId' + clientid);
            
            List < Schedule_Task__c > STaskslist = [select id, name, Schedule_Template__c, (select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c = : jobrecord.Schedule_Template__c WITH SECURITY_ENFORCED];
            
            for (Schedule_Task__c st: STaskslist) {
                Staskid.add(st.id);
            }
            
            List < ScheduleTaskRole__c > STRolelist = [select id, name from ScheduleTaskRole__c where Schedule_Task__c in : Staskid WITH SECURITY_ENFORCED];
            
            for (ScheduleTaskRole__c str: STRolelist) {
                Srole.add(str.name);
                system.debug('SRoles' + Srole);
            }
            
            //Client Contact Operation Details
            
            String query1 = 'SELECT Id,Name,Active__c,First_Name__c,Last_Name__c,Email__c,Client_Contact_Role__c,Username__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true   WITH SECURITY_ENFORCED Order by Name';
            
            CCs = Database.query(query1);
            Set < string > staffNameSet = new Set < String > ();
            system.debug('cclist' + CCs);
            if (!CCs.isEmpty()) {
                
                for (Job_Team__c jt: lstJobTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Client_Contact__c c: CCs) {
                    
                    if (!staffNameSet.contains(c.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(c, String.valueof(c.getSobjectType()), Srole.contains(c.Client_Contact_Role__c)));
                    
                    else {
                        staffWrappers w = new staffWrappers(c, String.valueof(c.getSobjectType()), Srole.contains(c.Client_Contact_Role__c));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(c.name);
                    }
                }
            }
            //Client Contact  Operation Details    
            
            //Staff Operation Details
            
            String query = 'SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by name';
            
            staffs = Database.query(query);
            
            if (!staffs.isEmpty()) {
                for (Job_Team__c jt: lstJobTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Staff__c s: staffs) {
                    
                    if (!staffNameSet.contains(s.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C)));
                    
                    else {
                        staffWrappers w = new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(s.name);
                    }
                }
            }
            //End Staff Operation Details
            
            //Vendor Contact Operation Details
            
            String query2 = 'SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true  WITH SECURITY_ENFORCED order by name';
            
            VCs = Database.query(query2);
            
            if (!VCs.isEmpty()) {
                for (Job_Team__c jt: lstJobTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Vendor_Contact__c v: VCs) {
                    
                    if (!staffNameSet.contains(v.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c)));
                    
                    else {
                        staffWrappers w = new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(v.name);
                    }
                }
            } //Vendor Contact  Operation Details
            //AllstaffWrappers.sort();
        }
        if (StatusString == 'Staff') {
            AllstaffWrappers.clear();
            Set < string > Srole = new Set < String > ();
            Set < Id > Staskid = new Set < Id > ();
            
            Job__c jobrecord = [select id, JS_Client__c, name, Schedule_Template__c from Job__c where id = : jobId WITH SECURITY_ENFORCED];
            clientid = jobrecord.JS_Client__c;
            system.debug('ClientId' + clientid);
            
            List < Schedule_Task__c > STaskslist = [select id, name, Schedule_Template__c, (select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c = : jobrecord.Schedule_Template__c WITH SECURITY_ENFORCED];
            
            for (Schedule_Task__c st: STaskslist) {
                
                Staskid.add(st.id);
                
            }
            
            List < ScheduleTaskRole__c > STRolelist = [select id, name from ScheduleTaskRole__c where Schedule_Task__c in : Staskid WITH SECURITY_ENFORCED];
            
            for (ScheduleTaskRole__c str: STRolelist) {
                
                Srole.add(str.name);
                
                system.debug('SRoles' + Srole);
            }
            
            //Staff Operation Details
            Set < string > staffNameSet = new Set < String > ();
            String query = 'SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by name';
            
            staffs = Database.query(query);
            
            if (!staffs.isEmpty()) {
                
                for (Job_Team__c jt: lstJobTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Staff__c s: staffs) {
                    
                    if (!staffNameSet.contains(s.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C)));
                    
                    else {
                        staffWrappers w = new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(s.name);
                    }
                }
            }
            //End Staff Operation Details
            
        }
        if (StatusString == 'Client Contact') {
            AllstaffWrappers.clear();
            Set < string > Srole = new Set < String > ();
            Set < Id > Staskid = new Set < Id > ();
            
            Job__c jobrecord = [select id, JS_Client__c, name, Schedule_Template__c from Job__c where id = : jobId WITH SECURITY_ENFORCED];
            clientid = jobrecord.JS_Client__c;
            system.debug('ClientId' + clientid);
            
            List < Schedule_Task__c > STaskslist = [select id, name, Schedule_Template__c, (select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c = : jobrecord.Schedule_Template__c WITH SECURITY_ENFORCED];
            
            for (Schedule_Task__c st: STaskslist) {
                
                Staskid.add(st.id);
                
            }
            
            List < ScheduleTaskRole__c > STRolelist = [select id, name from ScheduleTaskRole__c where Schedule_Task__c in : Staskid WITH SECURITY_ENFORCED];
            
            for (ScheduleTaskRole__c str: STRolelist) {
                
                Srole.add(str.name);
                
                system.debug('SRoles' + Srole);
            }
            //Client Contact Operation Details
            
            String query1 = 'SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Client_Contact_Role__c,Username__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true   WITH SECURITY_ENFORCED Order by name';
            
            CCs = Database.query(query1);
            Set < string > staffNameSet = new Set < String > ();
            system.debug('cclist' + CCs);
            if (!CCs.isEmpty()) {
                
                for (Job_Team__c jt: lstJobTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Client_Contact__c c: CCs) {
                    
                    if (!staffNameSet.contains(c.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(c, String.valueof(c.getSobjectType()), Srole.contains(c.Client_Contact_Role__c)));
                    
                    else {
                        staffWrappers w = new staffWrappers(c, String.valueof(c.getSobjectType()), Srole.contains(c.Client_Contact_Role__c));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(c.name);
                    }
                }
            }
            //Client Contact  Operation Details   
            
        }
        if (StatusString == 'Vendor Contact') {
            AllstaffWrappers.clear();
            Set < string > Srole = new Set < String > ();
            Set < Id > Staskid = new Set < Id > ();
            
            Job__c jobrecord = [select id, JS_Client__c, name, Schedule_Template__c from Job__c where id = : jobId WITH SECURITY_ENFORCED];
            clientid = jobrecord.JS_Client__c;
            system.debug('ClientId' + clientid);
            
            List < Schedule_Task__c > STaskslist = [select id, name, Schedule_Template__c, (select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c = : jobrecord.Schedule_Template__c WITH SECURITY_ENFORCED];
            
            for (Schedule_Task__c st: STaskslist) {
                
                Staskid.add(st.id);
                
            }
            
            List < ScheduleTaskRole__c > STRolelist = [select id, name from ScheduleTaskRole__c where Schedule_Task__c in : Staskid WITH SECURITY_ENFORCED];
            
            for (ScheduleTaskRole__c str: STRolelist) {
                
                Srole.add(str.name);
                
                system.debug('SRoles' + Srole);
            }
            Set < string > staffNameSet = new Set < String > ();
            //Vendor Contact Operation Details
            
            String query2 = 'SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true  WITH SECURITY_ENFORCED order by name';
            
            VCs = Database.query(query2);
            
            if (!VCs.isEmpty()) {
                
                for (Job_Team__c jt: lstJobTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Vendor_Contact__c v: VCs) {
                    
                    if (!staffNameSet.contains(v.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c)));
                    
                    else {
                        staffWrappers w = new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(v.name);
                    }
                }
            } //Vendor Contact  Operation Details
            
        }
        
        return AllstaffWrappers;
    }
    //End method Search for staffs
    
    public class StaffWrappers{
        //Public Staff__c Staff{get;set;}
        @AuraEnabled public Sobject sobjet{get;set;}
        @AuraEnabled public boolean selection{get;set;}
        @AuraEnabled Public boolean Sroles{get;set;}
        //@AuraEnabled Public SObjectWrappers Sojw{get;set;}
        @AuraEnabled Public String SobjType{get;set;}
        
        //@AuraEnabled   public Staff__c staff{get;set;}
        //@AuraEnabled   public Client_Contact__c CContact{get;set;}
        //@AuraEnabled   public Vendor_Contact__c VContact{get;set;}
        @AuraEnabled   Public String  Staffname{get;set;}
        @AuraEnabled   Public String  Username{get;set;}
        @AuraEnabled   Public String  Rolename{get;set;}
        @AuraEnabled   Public Boolean Active{get;set;}
        @AuraEnabled   Public String  Email{get;set;}
        
        public StaffWrappers(Sobject sb, String st, Boolean STroles){
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
    
    //Start Adding staffs to team
    @AuraEnabled
    public static String AddstafftoJobTeam(String jobId,String selectedJobTeam) {
        
        
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
                            lstAppTskRolDelete = [Select Id, Approval_Job_Task__c, Approval_Job_Task__r.project__c from Approval_Job_Task_Roles__c where Name = : objJTR.Role__c and Approval_Job_Task__r.project__c = : objJTR.job__c AND Approval_Job_Task__r.Status__c!='Approved' AND User__c = : objJTR.Staff__c WITH SECURITY_ENFORCED];
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
    //End method Adding staffs to team
    
    /* public class SObjectWrappers{
@AuraEnabled   public Staff__c staff{get;set;}
@AuraEnabled   public Client_Contact__c CContact{get;set;}
@AuraEnabled   public Vendor_Contact__c VContact{get;set;}
@AuraEnabled   Public String  Staffname{get;set;}
@AuraEnabled   Public String  Username{get;set;}
@AuraEnabled   Public String  Rolename{get;set;}
@AuraEnabled   Public Boolean Active{get;set;}
@AuraEnabled   Public String  Email{get;set;}

public SObjectWrappers(Sobject sb, String st){
if(st=='Client_Contact__c'){
this.CContact=(Client_Contact__c)sb;
this.Staffname=CContact.Name;
this.Username=CContact.Username__c;
this.Rolename=CContact.Client_Contact_Role__c;
this.Active=CContact.Active__c;
this.Email=CContact.Email__c;
}

if(st=='Vendor_Contact__c'){
this.VContact= (Vendor_Contact__c)sb;
this.Staffname=VContact.Name;
this.Username=VContact.User_name__c;
this.Rolename=VContact.Role__c;
this.Active=VContact.Active__c;
this.Email=VContact.Email__c;
}

if(st=='Staff__c'){
this.staff=(Staff__c)sb;
this.Staffname=staff.Name;
this.Username=staff.Username__c;
this.Rolename=staff.Role__c;
this.Active=staff.Active__c;
this.Email=staff.Email__c;
}
}
}
*/  
    //End wrapper class for SobjectTypes
    
    @AuraEnabled
    public static List<Tool_Tip__c> getHelpTextrecords() {
        List <Tool_Tip__c> lsthelptxt = [Select Id, Job_Team__c,Schedule__c,Job_Specs__c from Tool_Tip__c WITH SECURITY_ENFORCED];
        return lsthelptxt;
    }
    
    @AuraEnabled
    public static List < Job_Team__c > getjobteamrecords(Id recordId) {
        system.debug(recordId);
        List < Job_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c, Job__r.Name from Job_Team__c where Job__c = : recordId  WITH SECURITY_ENFORCED order by Staff__c];
        return lstJobTeam;
    }
    
    @AuraEnabled
    public static string MarkAllSelectedTasks(List<String> taskIdList){
        System.debug('====taskIdList==='+taskIdList);
        
        List<Job_Task__c> seletedRows=[select Id,Name,Marked_Done__c,Status__c,Completion_Date__c FROM Job_Task__c where Id IN:taskIdList WITH SECURITY_ENFORCED];
        for(Job_Task__c tt:seletedRows){
            if(tt.Marked_Done__c==false){
                if (Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()) { 
                    tt.Marked_Done__c=true;}
                if (Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()) { 
                    tt.Status__c='Completed';}
                if (Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()) { 
                    tt.Completion_Date__c=System.today();}
                
            }
        }
        try{
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                update seletedRows;  }
            else{
                return 'Tasks have insufficient access to edit/update';
            }
        }
        catch(System.DmlException e){
            return ''+e.getMessage();
        }
        return 'OK';
    }
    
    
    
    @AuraEnabled
    public static List < Job_Spec__c > getjobSpecrecords(Id recordId) {
        
        List < Job_Spec__c > lstJobSpecs = [select Id, name, Sort_Order__c, Creative_Brief_Template__c, Description__c From Job_Spec__c where Job__c = : recordId WITH SECURITY_ENFORCED order by Sort_Order__c ];
        return lstJobSpecs;
    }    
    @AuraEnabled
    public static map < string, list<Job_Spec__c>> getjobSpecrecords1(Id recordId) {
        
        system.debug(recordId);
        List < Job_Spec__c > lstJobSpecs = [select Id, name, Sort_Order__c, Creative_Brief_Template__c, Description__c From Job_Spec__c where Job__c = : recordId WITH SECURITY_ENFORCED order by Sort_Order__c];
        system.debug(lstJobSpecs);
        
        map < string, list < Job_Spec__c >> MapCB = new map < string, list < Job_Spec__c >> ();
        
        for (Job_Spec__c JS: lstJobSpecs) {
            if (MapCB.containsKey(js.Creative_Brief_Template__c)) {
                
                List < Job_Spec__c > jSpeclist = MapCB.get(js.Creative_Brief_Template__c);
                jSpeclist.add(js);
                MapCB.put(js.Creative_Brief_Template__c, jSpeclist);
                
            } else {
                MapCB.put(js.Creative_Brief_Template__c, new List < Job_Spec__c > {js});
            }
            
        }
        system.debug('=====get record===' + MapCB);
        return MapCB;
        
    }
    
    @AuraEnabled
    public static string deleteJobSpec(String SpecRecId) {
        
        Job_Spec__c spec = [select id, name, Sort_Order__c, Creative_Brief_Template__c, Description__c From Job_Spec__c where Id = : SpecRecId WITH SECURITY_ENFORCED limit 1];
        
        try {
            if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                Delete spec;
                return 'OK';
            }
            else{
                return 'Spec has insufficient access to delete';
            }
        } catch (System.DMLException e) {
            return '' + e.getMessage();
        }
        
    }
    
    @AuraEnabled
    public static Map < Id, String > getJobSpecTemplates(Id recordId) {
        system.debug('recordId===='+recordId);
        Map < Id, String > JobspecTempMap = new Map < Id, String > ();
        Job__c objJob = [Select id, Specification_Template__c from Job__c where id = : recordId WITH SECURITY_ENFORCED];
        
        /* If Spec Template already added to the job then that template is not displayed in the list(Job Spec Template list in the Job spec section)
* set<String> SpecTempName =new set<String>();
List<Job_Spec__c> SpecList = [select id, name, Sort_Order__c, Creative_Brief_Template__c, Description__c,Job__c From Job_Spec__c where Job__c = : recordId WITH SECURITY_ENFORCED];
if(SpecList.size()>0){
for(Job_Spec__c spec:SpecList){
SpecTempName.add(spec.Creative_Brief_Template__c);
} 
}  and name NOT IN:SpecTempName*/
        system.debug('objJob.Specification_Template__c===='+ objJob.Specification_Template__c);
        //Id specTempId = objJob.Specification_Template__c;
        List < Specification_Template__c > jtempLst = [SELECT Id, name FROM Specification_Template__c where id != : objJob.Specification_Template__c and Active__c=true WITH SECURITY_ENFORCED ORDER BY Name];
        JobspecTempMap.put(null, '--None--');
        for (Specification_Template__c jt: jtempLst) {
            JobspecTempMap.put(jt.Id, jt.Name);
        }
        system.debug('JobspecTempMap===='+JobspecTempMap);
        return JobspecTempMap;
    }
    
    @AuraEnabled
    public static string updateSpecs(List<Job_Spec__c> editSpecsList){
        try{
            if(Schema.sObjectType.Job_Spec__c.isUpdateable()){
                update editSpecsList;
                return 'true';}
            else{
                return 'Spec has insufficient access to update';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    
    @AuraEnabled
    public static String addJobSpecTemplates(Id recordId, String selectedJSTemp) {
        list < Specification_Template__c > spectemp = [select id, Name From Specification_Template__c Where id = : selectedJSTemp WITH SECURITY_ENFORCED LIMIT 1];
        List < Job_Spec__c > lstJobSpecs = [select Id, name, Sort_Order__c, Creative_Brief_Template__c, Description__c From Job_Spec__c where Job__c = : recordId WITH SECURITY_ENFORCED order by Sort_Order__c];
        system.debug(lstJobSpecs);
        
        map < string, list < Job_Spec__c >> MapCB = new map < string, list < Job_Spec__c >> ();
        
        for (Job_Spec__c JS: lstJobSpecs) {
            if (MapCB.containsKey(js.Creative_Brief_Template__c)) {
                
                List < Job_Spec__c > jSpeclist = MapCB.get(js.Creative_Brief_Template__c);
                jSpeclist.add(js);
                MapCB.put(js.Creative_Brief_Template__c, jSpeclist);
                
            } else {
                MapCB.put(js.Creative_Brief_Template__c, new List < Job_Spec__c > {js});
            }
            
        }
        
        List < Job_Spec__c > insertJobSpecs = new List < Job_Spec__c > ();
        //  list < Specification_Template__c > spectemp = [select id, Name From Specification_Template__c Where id = : selectedJSTemp LIMIT 1];
        List < Spec_Item__c > lstSpecs = [Select id, Name, Description__c, Value__c, Lock__c, Sort_Order__c, Specification_Template__r.name, Specification_Template__r.id from Spec_Item__c where Specification_Template__c = : selectedJSTemp WITH SECURITY_ENFORCED Order By Sort_Order__c];
        
        if (selectedJSTemp == null || selectedJSTemp == '') {
            return 'Please select any Template to Import the specs';
        } else if (MapCB.ContainsKey(spectemp[0].name)) {
            return 'This Template is already existed';
        } else if (lstSpecs.size() == 0) {
            return 'There is no records to import from this template';
        } else {
            for (Spec_Item__c sp: lstSpecs) {
                Job_Spec__c js = new Job_Spec__c();
                if(Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) {  js.Name = sp.Name;}
                if(Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) { js.Description__c = sp.Description__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Value__c.isCreateable()) { js.Value__c = sp.Value__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Lock__c.isCreateable()) { js.Lock__c = sp.Lock__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Sort_Order__c.isCreateable()) { js.Sort_Order__c = sp.Sort_Order__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { js.Job__c = recordId;}
                if(Schema.sObjectType.Job_Spec__c.fields.Creative_Brief_Template__c.isCreateable()) { js.Creative_Brief_Template__c = sp.Specification_Template__r.name;}
                insertJobSpecs.add(js);
                
            }
            try {
                if(Schema.sObjectType.Job_Spec__c.isCreateable()){
                    insert insertJobSpecs;}
                else{
                    return 'Error,Specs has insufficient access to create.';
                }
            } catch (System.DMLException e) {
                return '' + e.getMessage();
            }
            
            return 'Successfully Imported Specification Template Records';
        }
    }
    @AuraEnabled
    public static List < Timesheet_Entries__c > getTimesheetRecords(Id recordId) {
        
        List < Timesheet_Entries__c > ltsrecords = [select id, name, Hours_Worked__c, GL_Code__c, Task_Name__c, Date__c, User__c from Timesheet_Entries__c where Job__c = : recordId WITH SECURITY_ENFORCED Order BY Name desc];
        return ltsrecords;
    }
    
    
    @AuraEnabled
    public static List <Job_Task__c> getListofJobTasks(Id jobId) {
        List <Job_Task__c> lstJT =new  List <Job_Task__c>();
        lstJT=[Select Id,Has_Approval_steps__c,Has_Inprogress_Approval_Steps__c,File_Name__c,(Select Id,User__c,Email__c From Job_Task_Roles__r),Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.Status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId WITH SECURITY_ENFORCED Order By Task_Order__c];
        return  lstJT;
        
    }
    
    @AuraEnabled
    public static string updateTasksinlineEdit(List <Job_Task__c> lstJT)
    {    
        System.debug('===lstJT Records====='+lstJT);
        try
        {
            List<Job_Task__c> updatelstJT=new List<Job_Task__c>();
            for(Job_task__c objJT:lstJT)
            {  
                If(objJT.Marked_Done__c==True && objJT.Completion_Date__c==NULL)
                {
                    if (Schema.sObjectType.Job_task__c.fields.Completion_Date__c.isUpdateable()) { 
                        objJT.Completion_Date__c=System.Today();}
                    if (Schema.sObjectType.Job_task__c.fields.Status__c.isUpdateable()) { 
                        objJT.Status__c='Completed';}
                }
                else if (objJT.Marked_Done__c==False){
                    if (Schema.sObjectType.Job_task__c.fields.Completion_Date__c.isUpdateable()) {  objJT.Completion_Date__c=NULL;}
                    if (Schema.sObjectType.Job_task__c.fields.Status__c.isUpdateable()) {  objJt.Status__c='Active';}
                }
                updatelstJT.add(objJT);
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                update updatelstJT;}
            else{
                return 'Task has insufficient access to update';
            }
        }
        catch(System.DMLException e)
        {
            return e.getMessage();
        }
        
        return 'true'; 
    }
    // End of method Save
    
    @AuraEnabled
    public static string updateScheduleOnDays(String jobId, String taskId1,String days1,String updateRestScheduleDays)
    {
        Set<Date> holidaysNew= new Set<Date>();
        List<Job_Task__c> lstTaskBelow ;
        List<Job_Task__c> lstTaskBelowUpdate = new  List<Job_Task__c>();
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
        {
            holidaysNew.add(hc.Date__c);
        } 
        try{
            // msg = 'Rerendered';
            System.debug('Days is : '+days1);
            System.debug('Task Id is : '+taskId1);
            System.debug('Value of updateRestScheduleDays : '+String.valueOf(updateRestScheduleDays));
            Integer newDaysValue = Integer.valueOf(days1);
            // If user clicks on Yes button then update the current task first and         
            // retrieve below task( not marked done) and update the revised date for all those tasks
            Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=:jobId WITH SECURITY_ENFORCED];
            Boolean blnFroward = true;
            if(objJob.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }
            Job_Task__c objTask1; 
            objTask1 = [Select Id, Name, Job__c, Job__r.Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Id =: taskId1 WITH SECURITY_ENFORCED LIMIT 1];
            System.debug('Job Name is : '+objTask1.Job__r.Name);
            Datetime dtStartDate1;
            // if(objJob.Schedule_calc__c == 'Start Date' )
            //  {
            if(blnFroward)
            {
                dtStartDate1  = Datetime.newInstance(objTask1.Start_Date__c,Time.newInstance(12, 0, 0, 0));
            }
            else
            {
                // dtStartDate1 = Datetime.newInstance(objTask1.Start_Date__c,Time.newInstance(12, 0, 0, 0));
                dtStartDate1 = Datetime.newInstance(objTask1.Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
            }
            System.debug('Start Date is : ' +dtStartDate1);
            Integer jCount = 0;
            System.debug('jCount value '+jCount);
            while(true)
            {
                Date d3=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                if(dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                {
                    jCount = jCount + 1;
                    if(jCount > newDaysValue)
                    {
                        break;
                    }
                    if(blnFroward)
                    {
                        dtStartDate1 = dtStartDate1.addDays(1);
                    }
                    else
                    {
                        dtStartDate1 = dtStartDate1.addDays(-1);
                    }
                    System.debug('After adding 1 day : '+dtStartDate1);
                }
                else
                {
                    System.debug('======='+dtStartDate1);
                    // dtStartDate1 =dtStartDate1.addDays(1);
                    if(blnFroward)
                    {
                        dtStartDate1 = dtStartDate1.addDays(1);
                    }
                    else
                    {
                        dtStartDate1 = dtStartDate1.addDays(-1);
                    }
                    continue;
                }
            }
            Date afterDaysUpdate = Date.newInstance(dtStartDate1.Year(), dtStartDate1.Month(), dtStartDate1.Day());
            System.debug('Date After updating days '+afterDaysUpdate);
            if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                objTask1.Days__c = newDaysValue;
            }
            if(blnFroward)
            {
                if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){objTask1.Revised_Due_Date__c = afterDaysUpdate; }  
            }
            else
            {
                if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){objTask1.Start_Date__c = afterDaysUpdate;  } 
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update objTask1;
                system.debug('objTask1 === '+objTask1+'\n');
            }
            if(String.valueOf(updateRestScheduleDays) == 'true')
            {
                // Update the current Task Revised Due Date and Days                  
                // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current Job
                //  List<Job_Task__c> lstTaskBelow ; //from here we changes to outside if loop on 12 - 12 - 2022 by manindra
                if(blnFroward)
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c >=: objTask1.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];   
                }
                else
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c <=: objTask1.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC]; 
                }
                DateTime NextTaskStartDate;
                Date startDateForNextTask;
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objTask1.Revised_Due_Date__c.Year(),objTask1.Revised_Due_Date__c.month(),objTask1.Revised_Due_Date__c.Day());   
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objTask1.Start_Date__c.Year(),objTask1.Start_Date__c.month(),objTask1.Start_Date__c.Day()); 
                }
                System.debug('Task below the updated Task : '+lstTaskBelow);
                System.debug('Size of Task Below the current Task : '+lstTaskBelow.size());
                for(Integer i = 0; i <lstTaskBelow.size(); i++)
                {
                    System.debug('Value of i' +i);
                    if(i == 0)
                    {   
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = startDateForNextTask;}
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;}
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = d4; }
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstTaskBelow[i].Revised_Due_Date__c = d4; }
                        }
                    }
                    DateTime dtStartDate3;
                    if(blnFroward)
                    {
                        dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                    }
                    else
                    {
                        dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0)); 
                    }
                    System.debug('Day is:'+dtStartDate3.format('E'));
                    system.debug('Start Date is : ' +dtStartDate3);
                    if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                        lstTaskBelow[i].Days__c = lstTaskBelow[i].Days__c;}
                    Integer jCount1 = 0;
                    // To calculate  Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount1 =jCount1+1;
                            if(jCount1 > lstTaskBelow[i].Days__c){break;}
                            system.debug('jCount======' + jCount1);
                            system.debug('==========' + dtStartDate3);
                            system.debug('===========' + dtStartDate3.format('E'));
                            if(blnFroward){
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else{ 
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);
                            // dtStartDate3=dtStartDate3.addDays(1);
                            if(blnFroward){dtStartDate3=dtStartDate3.addDays(1);}
                            else{dtStartDate3=dtStartDate3.addDays(-1);}
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                    if(blnFroward)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstTaskBelow[i].Revised_Due_Date__c=d1;}
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstTaskBelow[i].Start_Date__c=d1;}
                    }
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                // system.debug('$$$$$$$$$$$$$'+Limits.getScriptStatements());
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update lstTaskBelow;
                }
                System.debug('Updated Task : '+lstTaskBelow);
                System.debug('Size of Task : '+lstTaskBelow.size());
            }
            else{
                if(blnFroward)
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c >=: objTask1.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC limit 1];   
                    if(lstTaskBelow.size() > 0){
                        for(Integer i = 0; i <lstTaskBelow.size(); i++)
                        {
                            if(i == 0){
                                lstTaskBelow[i].Start_Date__c =  objTask1.Revised_Due_Date__c;
                                lstTaskBelowUpdate.add(lstTaskBelow[i]);
                            } 
                        }
                        update  lstTaskBelowUpdate; //here new line added by manindra on 12 - 12 - 2022
                        system.debug('lstTaskBelowUpdate === '+lstTaskBelowUpdate+'\n');
                    }
                }
                
            }
        }
        Catch(Exception e){
            return e.getMessage();
        }
        return 'OK';
    }
    // This method is called on to update Schedule when Days of particular Task has changed
    
    @AuraEnabled
    public static string updateRestSchedule(String jobId, String taskId,Date dt,String updateRestScheduleRevDt)
    {
        Set<Date> holidaysNew= new Set<Date>();
        List<Job_Task__c> lstJobTasks ; // added on 12 - 12 - 2022 by manindra
        List<Job_Task__c>lstTaskBelowUpdate = new List<Job_Task__c>();// added on 12 - 12 - 20222 by manindra
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
        {
            holidaysNew.add(hc.Date__c);
        } 
        System.debug('Due Date is : '+dt);
        dt = Date.valueOf(dt);
        System.debug('Task Id is : '+taskId);
        System.debug('Value of updateRestScheduleRevDt : '+String.valueOf(updateRestScheduleRevDt));
        
        DateTime NextTaskStartDate;
        //code for the update of the current schedule 
        Job_Task__c jobTask1,jobTask2,objJobTask;
        
        try{
            //taskId = Id.valueOf(taskId);
            jobTask1 = new Job_Task__c();
            jobTask1.Id=taskId;
            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                jobTask1.Revised_Due_Date__c = dt;
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                system.debug('jobTask1---'+jobTask1);
                update jobTask1;
            }
            objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id WITH SECURITY_ENFORCED LIMIT 1];
            Boolean blnFroward = true;
            if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }  
            if(!blnFroward )
            {
                System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                //code for updating the start date of the current task
                Integer jCount1 = 0;
                //Integer newDaysValue = objJobTask.Days__c;
                Datetime dtStartDate=DateTime.newInstance(dt.Year(),dt.Month(),dt.Day());
                System.debug('jCount value '+jCount1);
                
                while(true)
                {
                    System.debug('jCount value in while '+jCount1);
                    Date d3=Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                    if(dtStartDate.format('E')!='Sat' && dtStartDate.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                    {
                        jCount1 = jCount1 + 1;
                        if(jCount1 > objJobTask.Days__c)
                        {
                            break;
                        }
                        dtStartDate = dtStartDate.addDays(-1);
                    }
                    else
                    {
                        dtStartDate = dtStartDate.addDays(-1);
                        System.debug('=====dtStartDate ===='+dtStartDate);                                          
                        continue;
                    }
                }
                Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                system.debug('=========afterDaysUpdate =========='+afterDaysUpdate);
                if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                    objJobTask.Start_Date__c = afterDaysUpdate;
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update objJobTask;
                }
            } 
            
            System.debug('Update current Job Task : '+jobTask1);
            
            if(String.valueOf(updateRestScheduleRevDt) == 'true')
            {                        
                // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current job
                Date startDateForNextTask ;
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.month(),objJobTask.Revised_Due_Date__c.Day());
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Start_Date__c.Year(),objJobTask.Start_Date__c.month(),objJobTask.Start_Date__c.Day());
                }
                
                //List<Job_Task__c> lstJobTasks ; // commented on 12 - 12 - 2022 by manindra
                //= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                
                if(blnFroward)
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
                }
                else
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC];
                }
                System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                
                System.debug('Size of Update Tasks : '+lstJobTasks.size());
                
                for(Integer i = 0; i <lstJobTasks.size(); i++)
                {
                    System.debug('Value of i' +i);
                    DateTime dtStartDate3;
                    if(i == 0)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c = startDateForNextTask;
                        }
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                            dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = d4;}
                            dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = d4;}
                            dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                    }
                    
                    System.debug('Day is:'+dtStartDate3.format('E'));
                    
                    System.debug('Start Date is : ' +dtStartDate3);
                    if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                        lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;}
                    
                    Integer jCount=0;
                    
                    // To calculate Due Date, Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount=jCount+1;
                            if(jCount>lstJobTasks[i].Days__c)
                            {
                                break;
                            }
                            system.debug('jCount======' + jCount);
                            system.debug('==========' + dtStartDate3);
                            
                            system.debug('===========' + dtStartDate3.format('E'));
                            
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }                                   
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);                                     
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }  
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                    
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                    
                    if(blnFroward)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstJobTasks[i].Revised_Due_Date__c=d1;}
                        system.debug('Revise due============' +lstJobTasks[i].Revised_Due_Date__c); 
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c=d1;}
                    }    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update lstJobTasks;
                }
                System.debug('Updated List : '+lstJobTasks);
            }
            
            else{
                if(blnFroward)
                {
                    lstJobTasks = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objJobTask.Id and Task_Order__c >=: objJobTask.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC limit 1];   
                    // if(lstJobTasks.size() > 0){
                    for(Integer i = 0; i < lstJobTasks.size(); i++)
                    {
                        if(i == 0){
                            lstJobTasks[i].Start_Date__c =  objJobTask.Revised_Due_Date__c;
                            lstTaskBelowUpdate.add(lstJobTasks[i]);
                        } 
                    }
                    if(lstTaskBelowUpdate.size() > 0){
                        update  lstTaskBelowUpdate; //here new line added by manindra on 12 - 12 - 2022
                        system.debug('lstTaskBelowUpdate === '+lstTaskBelowUpdate+'\n');
                    }
                    //}
                }
            }            
        }
        catch(Exception e){
            return ''+e.getMessage()+e.getLineNumber();
        }
        return 'OK'; 
    }
    
    @AuraEnabled
    public static string createSchedule(String jobId)
    {
        Set<Id> stScheduleTaskId = new Set<Id>(); 
        List<Job_Task__c> lstJT=new List<Job_Task__c>();
        Map<String,Id> mp1 = new Map<String,Id>();
        Map<Id,Id> mp2 = new Map<Id,Id>();
        
        set<Id> jobTaskIdApp = new set<Id>();
        List<Approval_Job_Task__c> lstJobTaskApprovals=new List<Approval_Job_Task__c>();
        
        lstJT=[Select Id from Job_Task__c where Job__c =: jobId WITH SECURITY_ENFORCED];
        
        for(Job_Task__c jtid:lstJT){
            jobTaskIdApp.add(jtid.id);
        }
        
        lstJobTaskApprovals = [select id,name from Approval_Job_Task__c where task__c IN :jobTaskIdApp];
        if(lstJobTaskApprovals.size() > 0) // To check Schedule Is not Created yet
        { 
            if(Approval_Job_Task__c.sObjectType.getDescribe().isDeletable()){
                delete lstJobTaskApprovals;
            }
            else{
                return 'Approval Step has insufficient access to delete';
            }
        }
        
        Set<Date> holidaysNew= new Set<Date>();
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
        {
            holidaysNew.add(hc.Date__c);
        } 
        
        Set<Id> stScheduleTemplateId = new Set<Id>();
        Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__c, Schedule_Calc__c,Job_Timing_Status__c,Next_Tasks_Due__c from Job__c where Id=:jobId WITH SECURITY_ENFORCED];
        String strScheduleTemplate=objJob.Schedule_Template__c;
        
        List<Schedule_Task__c> lstScheduleTask=new List<Schedule_Task__c>();          
        List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
        Datetime NTSD;
        // Dateerror=false;
        if(objJob.Schedule_Calc__c=='Start Date' && objJob.Start_Date__c==null){
            return 'You must enter Start Date value in job';
        }
        else if(objJob.Schedule_Calc__c=='End Date' && objJob.Due_Date__C==null){
            return 'You must enter End Date value in job';
        }
        else
        {
            
            if(lstJT.size() > 0) // To check Schedule Is not Created yet
            { 
                if(Job_Task__c.sObjectType.getDescribe().isDeletable()){
                    delete lstJt;}
                else{
                    return 'Taks has insufficient access to delete';
                }
            }
            Boolean blnFroward = true;
            if(objJob.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }
            
            Date std;
            String nextjobtaskdue = '';
            Date finalduedate;
            Boolean schedulecalc = false;
            if(blnFroward)
            {
                std=Date.newInstance(objJob.Start_Date__c.Year(),objJob.Start_Date__c.month(),objJob.Start_Date__c.Day());
                lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c,Hours__c,Roles__c  from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                nextjobtaskdue = lstScheduleTask[0].name;
                schedulecalc = true;
            }
            else
            {
                std=Date.newInstance(objJob.Due_Date__c.Year(),objJob.Due_Date__c.month(),objJob.Due_Date__c.Day());
                lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c,Hours__c,Roles__c,(select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate WITH SECURITY_ENFORCED ORDER BY Task_Order__c desc];
                nextjobtaskdue = lstScheduleTask[lstScheduleTask.size()-1].name; //If due date selected for job.
                schedulecalc = false;
            }
            System.debug('==========std is==========:'+std);
            
            //List<Schedule_Task__c> lstScheduleTask=new List<Schedule_Task__c>();
            //lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate ORDER BY Task_Order__c];
            //List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
            //Datetime NTSD;
            
            if(lstScheduleTask.size()==0){
                return 'There is no tasks for Job Schedule Template';
            }
            else{
                
                if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()){
                    objJob.Next_Tasks_Due__c = nextjobtaskdue; //Logic here changed please check line 1962 and 1967
                    update objJob; // updating next task due field in job when clicked create schedule button  by manindra commeneted on 9-12-2022.
                }
            }
            
            for(Integer i=0;i<lstScheduleTask.size();i++)
            {
                stScheduleTaskId.add(lstScheduleTask[i].Id); 
                Job_Task__c jt=new Job_Task__c();
                system.debug('Value of i : '+i);
                if(i==0)
                {
                    if(blnFroward)
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {
                            jt.Start_Date__c=std;}
                    }
                    else
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) { 
                            jt.Due_Date__c=std;}
                    }
                }
                else
                {
                    Date d2 = Date.newInstance(NTSD.Year(),NTSD.Month(),NTSD.Day());
                    if(blnFroward)
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {
                            jt.Start_Date__c = d2;}
                    }
                    else
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) {
                            jt.Due_Date__c=d2;}
                    }
                }
                
                Datetime dtStartDate;
                if(blnFroward)
                {
                    dtStartDate = DateTime.newInstance(jt.Start_Date__c.Year(),jt.Start_Date__c.Month(),jt.Start_Date__c.Day());
                }
                else
                {
                    dtStartDate = DateTime.newInstance(jt.Due_Date__c.Year(),jt.Due_Date__c.Month(),jt.Due_Date__c.Day());
                }
                
                system.debug('Start Date is : ' +dtStartDate);
                if (Schema.sObjectType.Job_Task__c.fields.Days__c.isCreateable()) {
                    jt.Days__c=lstScheduleTask[i].Days__c;}
                Integer jCount=0;
                
                // To calculate Due Date, Revised Due Date
                while(true)
                {
                    Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                    
                    // Skip Holiday and Sat-Sun while calulation Due Date & Revised Due Date
                    if((dtStartDate.format('E')!='Sat'&& dtStartDate.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                    {
                        jCount=jCount+1;
                        if(jCount>jt.Days__c)
                        {
                            break;
                        }
                        system.debug('jCount======' + jCount);
                        system.debug('==========' + dtStartDate);
                        
                        system.debug('===========' + dtStartDate.format('E'));
                        
                        if(blnFroward)
                        {
                            dtStartDate=dtStartDate.addDays(1);
                        }
                        else
                        {
                            dtStartDate=dtStartDate.addDays(-1);
                        }
                        system.debug('After adding 1 day : ' +dtStartDate);
                    }
                    else
                    {
                        system.debug('==========' + dtStartDate);
                        
                        if(blnFroward)
                        {
                            dtStartDate=dtStartDate.addDays(1);
                        }
                        else
                        {
                            dtStartDate=dtStartDate.addDays(-1);
                        }
                        continue;
                    }
                }
                system.debug('Calculation============' +dtStartDate);
                
                Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                system.debug('D1============' +dtStartDate);
                
                if(blnFroward)
                {
                    if (Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) {
                        jt.Due_Date__c=d1;}
                }
                else
                {
                    if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) { 
                        jt.Start_Date__c=d1;}
                }
                if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isCreateable()) {
                    jt.Revised_Due_Date__c=jt.Due_Date__c;}
                System.debug('Due Date : '+jt.Due_Date__c);
                
                NTSD=DateTime.valueOf(dtStartDate);
                if (Schema.sObjectType.Job_Task__c.fields.Name.isCreateable()) {jt.Name=lstScheduleTask[i].Name;}
                if (Schema.sObjectType.Job_Task__c.fields.GL_Code__c.isCreateable()) {jt.GL_Code__c=lstScheduleTask[i].GL_Code__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Report__c.isCreateable()) { jt.Report__c=lstScheduleTask[i].Report__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Locked__c.isCreateable()) { jt.Locked__c=lstScheduleTask[i].Locked__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Hours__c.isCreateable()) { jt.Hours__c=lstScheduleTask[i].Hours__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Schedule_Roles__c.isCreateable()) { jt.Schedule_Roles__c=lstScheduleTask[i].Roles__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isCreateable()) {
                    jt.Task_Order__c=lstScheduleTask[i].Task_Order__c;}
                
                System.Debug('Task Order @@@@@@@@@@@@@@@@@@@@@@@@@'+jt.Task_Order__c);
                if (Schema.sObjectType.Job_Task__c.fields.Job__c.isCreateable()) {
                    jt.Job__c=jobId;}
                mp1.put(lstScheduleTask[i].Name,lstScheduleTask[i].Id);
                lstJobTask.add(jt);
            }
            if(Schema.sObjectType.Job_Task__c.isCreateable()){ 
                insert lstJobTask;
                //Here added new logic for timing status below lines
                // date finalduedate = lstJobTask[0].Revised_Due_Date__c;
                if(!schedulecalc)
                {
                    system.debug('start date ======'+lstJobTask[0].Job__r.Schedule_Calc__c);
                    finalduedate = lstJobTask[lstJobTask.size()-1].Revised_Due_Date__c;
                }
                else{
                    finalduedate = lstJobTask[0].Revised_Due_Date__c;
                    system.debug('End date ======'+lstJobTask[0].Job__r.Schedule_Calc__c);
                }
                if(Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isCreateable() || Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isUpdateable()){
                    if(finalduedate >= system.today() &&  objJob.Due_Date__c >= system.today())
                    {
                        objJob.Job_Timing_Status__c =  'On Track' ;
                    }
                    if(finalduedate < system.today() && objJob.Due_Date__c >= system.today()){
                        objJob.Job_Timing_Status__c =  'At Risk' ;  
                    }
                    if(objJob.Due_Date__c <= system.today()){
                        objJob.Job_Timing_Status__c =  'Delayed' ;  
                    }
                    /*else{
objJob.Job_Timing_Status__c =  '' ;  
}*/
                    if(Schema.sObjectType.Job__c.isUpdateable()){ 
                        update objJob;  // commented by manindra on 9-12-2022
                    }
                }//Here logic ends
            }
            else{
                return 'Error, Taks have insufficient access to insert';
            }
            
            for(Job_Task__c jt:lstJobTask)
            {
                mp2.put(mp1.get(jt.Name),jt.Id);
            }        
            
            List<ScheduleTaskRole__c> lstScheduleTaskRole=new List<ScheduleTaskRole__c>();
            
            lstScheduleTaskRole=[Select Id,Name,Schedule_Task__c,Schedule_Task__r.Schedule_Template__c,Schedule_Task__r.Name from ScheduleTaskRole__c where Schedule_Task__c IN : stScheduleTaskId WITH SECURITY_ENFORCED];
            
            List<Job_Task_Role__c> lstJobTaskRole=new List<Job_Task_Role__c>();
            
            Job_Team__c[] objJobTeam=[Select Staff__c,Email__c,Role__c from Job_Team__c where Job__c=:jobId WITH SECURITY_ENFORCED];
            for(ScheduleTaskRole__c st1:lstScheduleTaskRole)
            {
                //Job_Team__c[] objJobTeam=[Select Staff__c,Email__c from Job_Team__c where Role__c=: st1.Name and Job__c=:jobId ];
                for(Job_Team__c jteam:objJobTeam){
                    if(jteam.Role__c==st1.Name){
                        Job_Task_Role__c objJobTaskRole=new Job_Task_Role__c();
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                            objJobTaskRole.Name=st1.Name;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) { 
                            objJobTaskRole.Job_Task__c=mp2.get(st1.Schedule_Task__c);}                       
                        String strStaff=jteam.Staff__c;        
                        if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) { 
                            objJobTaskRole.User__c=strStaff;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) { 
                            objJobTaskRole.Email__c=jteam.Email__c;}
                        lstJobTaskRole.add(objJobTaskRole);
                    }
                }
            }  
            
            
            try{
                if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
                    insert lstJobTaskRole;   
                }else{
                    return 'Error, Taks Roles have insfiicient access to insert';
                }
            }  
            catch(Exception e){
                return e.getMessage();
            }
            
            
            return 'OK';
            // After creating Schedule, Navigate To Schedules Tab
            
        }          
        
    }
    
    @AuraEnabled
    public static List<Job__c> ShowMultipleScheduleCopyJobs(String Cpyid){
        list<Job__c> Jobslist=new  list<Job__c>();
        Job__c  RecJb = [SELECT id, Name, Status__c, Job_Auto_Number__c,Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c  FROM Job__c WHERE id =: Cpyid WITH SECURITY_ENFORCED];
        Jobslist=[SELECT id, Name,Job_Auto_Number__c, Status__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c FROM Job__c WHERE Schedule_Template__c=: RecJb.Schedule_Template__c AND Status__c =:'Active' AND id <>: Cpyid WITH SECURITY_ENFORCED Order By Job_Auto_Number__c];  
        return Jobslist;
    }
    
    
    @AuraEnabled
    public static List<Job__c> ShowMultipleCampScheduleCopyJobs(String Cpyid){
        list<Job__c> Jobslist=new  list<Job__c>();
        Job__c  RecJb = [SELECT id, Name, Status__c, Job_Auto_Number__c,Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c  FROM Job__c WHERE id =: Cpyid WITH SECURITY_ENFORCED];
        Jobslist=[SELECT id, Name,Job_Auto_Number__c, Status__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c FROM Job__c WHERE Campaign__c=:RecJb.Campaign__c AND Status__c =:'Active' AND id <>: Cpyid WITH SECURITY_ENFORCED Order By Job_Auto_Number__c];  
        return Jobslist;
    }
    
    
    @AuraEnabled
    public static List<Job__c> TeamCopytoJobsrelatedCamp(String Cpyid){
        list<Job__c> Jobslist=new  list<Job__c>();
        Job__c  RecJb = [SELECT id, Name, Status__c, Job_Auto_Number__c,Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c  FROM Job__c WHERE id =: Cpyid WITH SECURITY_ENFORCED];
        if(RecJb.Campaign__c!=null)
        {
            Jobslist=[SELECT id, Name,Job_Auto_Number__c, Status__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c FROM Job__c WHERE Campaign__c=: RecJb.Campaign__c  AND Status__c =:'Active' AND id <>: Cpyid WITH SECURITY_ENFORCED Order By Job_Auto_Number__c];      
        }
        
        return Jobslist;
    }
    
    @AuraEnabled
    public Static string saveCopyTeam(String Cpyid,List<SObject> selectedrecs) 
    {
        try{
            System.debug('=====selectedrecs======'+selectedrecs);  
            List<Job__c> selectedrows=(List<Job__c>)selectedrecs;
            System.debug('=====Jobs selected rows======='+selectedrows);  
            set<id> setJbId= new set<id>();
            
            //get all selected jobs
            
            for(Job__c tmpJb : selectedrows)
            {
                setJbId.add(tmpJb.Id);
            }
            
            //Get team members of selected job
            list<Job_Team__c> lstJobTeamDel=new List<Job_Team__c>();
            lstJobTeamDel = [Select Job__c,Staff__c,Email__c,Role__c from Job_Team__c where Job__c IN:setJbId WITH SECURITY_ENFORCED];
            System.debug('List of old Job team for selected job -----> ' + lstJobTeamDel);
            if(lstJobTeamDel.size() > 0){
                if(Job_Team__c.sObjectType.getDescribe().isDeletable()){
                    DELETE lstJobTeamDel;
                }else{
                    return 'Team has insufficient access to delete';
                }
            }
            
            list<Job_Task_Role__c> lstJobTskRoleDel=new List<Job_Task_Role__c>();
            lstJobTskRoleDel = [Select  id,Name,User__c,Email__c,Job_Task__c from Job_Task_Role__c where Job_Task__r.Job__c IN:setJbId WITH SECURITY_ENFORCED];
            if(lstJobTskRoleDel.size() > 0){
                if(Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){
                    DELETE lstJobTskRoleDel;}
                else{
                    return 'Task role has insufficient access to delete';
                }
            }
            
            List<Job_Team__c> lstCurrentJobTeam = new List<Job_Team__c>();
            list<Job_Team__c> lstJobTeamInsrt = new list<Job_Team__c>();
            Job_Team__c tmpJobTeam = new Job_Team__c();
            
            lstCurrentJobTeam = [Select Job__c,Staff__c,Email__c,Role__c from Job_Team__c where Job__c =:Cpyid WITH SECURITY_ENFORCED];
            
            
            //Copy current job team members to selected jobs
            for(id varid : setJbId)
            {
                for(Job_Team__c varJbTeam : lstCurrentJobTeam)
                {
                    tmpJobTeam=new Job_Team__c();
                    
                    if (Schema.sObjectType.Job_Team__c.fields.Job__c.isCreateable()) { 
                        tmpJobTeam.Job__c = varid;
                    }
                    if (Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()) {
                        tmpJobTeam.Role__c= varJbTeam.Role__c;
                    }
                    if (Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()) {
                        tmpJobTeam.Staff__c= varJbTeam.Staff__c;
                    }
                    if (Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()) {  
                        tmpJobTeam.Email__c= varJbTeam.Email__c;
                    }
                    //insert new copied instance in list of tasks
                    lstJobTeamInsrt.add(tmpJobTeam);    
                }
            }
            
            //Insert new copied job team for selected jobs.
            if(lstJobTeamInsrt.size() > 0)
            {
                
                if(Schema.sObjectType.Job_Team__c.isCreateable()){ 
                    INSERT lstJobTeamInsrt;
                    return 'success';
                }else{
                    return 'Team has insufficient access to insert';
                }
                
            }
        }
        catch(Exception e){
            return e.getMessage();
        }
        return 'OK';
        
    }
    
    @AuraEnabled
    public Static string saveRsc(String Cpyid,List<SObject> selectedrecs) 
    {
        System.debug('=====selectedrecs======'+selectedrecs);  
        List<Job__c> selectedrows=(List<Job__c>)selectedrecs;
        System.debug('=====Jobs selected rows======='+selectedrows);
        
        Set<String> ClientNames=new set<String>();
        Set<String> VendorNames=new set<String>();
        Set<String> staffNames=new set<String>();
        
        list<Staff__c> staffs=new  list<Staff__c>();
        list<Client_Contact__c> CCs=new list<Client_Contact__c>();
        list<Vendor_Contact__c> VCs=new list<Vendor_Contact__c>();
        
        
        String query ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by name';
        staffs = Database.query(query); 
        for(Staff__c s:staffs)
        {
            staffNames.add(s.name);
        }
        
        String query1 ='SELECT id,name,Active__c from Client_Contact__c Where Active__c=true   WITH SECURITY_ENFORCED Order by name';
        CCs= Database.query(query1);   
        for(Client_Contact__c  s:CCs)
        {
            ClientNames.add(s.name);
        }   
        
        String query2 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true  WITH SECURITY_ENFORCED order by name';
        VCs= Database.query(query2);
        for(Vendor_Contact__c  s:VCs)
        {
            VendorNames.add(s.name);
        } 
        
        set<id> setJbId = new set<id>();
        list<Job_Task__c> lstJbTskDel = new list<Job_Task__c>();
        list<Job_Task__c> lstJbTask = new list<Job_Task__c>();
        list<Job_Task__c> lstJbTskInsrt = new list<Job_Task__c>();
        Job_Task__c tmpJbTsk = new Job_Task__c();
        List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
        
        //get all selected jobs
        
        for(Job__c tmpJb : selectedrows)
        {
            setJbId.add(tmpJb.id);
        }
        //code ends here
        
        //get all tasks of selected jobs
        //lstJbTskDel = [SELECT Id, Name, Job__c, Schedule_Roles__c,Hours__c,Completion_Date__c, Days__c, GL_Code__c, Locked__c, Marked_Done__c, Due_Date__c, Report__c, Revised_Due_Date__c, Assigned_Users__c, Start_Date__c, Status__c, Task_Order__c FROM Job_Task__c WHERE Job__c IN : setJbId];
        
        
        //Get tasks of current job
        
        Set<Id> OldTaskId=new Set<Id>();
        
        
        lstJbTask = [SELECT Id, Name,Next_Task_Due__c, Job__c,Schedule_Roles__c,Hours__c, Completion_Date__c, Days__c, GL_Code__c, Locked__c, Marked_Done__c, Due_Date__c, Report__c, Revised_Due_Date__c, Assigned_Users__c, Start_Date__c, Status__c, Task_Order__c FROM Job_Task__c WHERE Job__c =: Cpyid WITH SECURITY_ENFORCED];
        System.debug('List of Job tasks for current job -----> ' + lstJbTask);
        
        
        for(Job_Task__c varJbTsk : lstJbTask)
        {
            OldTaskId.add(varJbTsk.id);
        }
        
        List<Job_Task_Role__c> lstJTR=[Select id,Name,User__c,Email__c,Job_Task__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId WITH SECURITY_ENFORCED];
        
        Map<String,Id> mp1 = new Map<String,Id>();
        Map<Id,set<Id>> mp2 = new Map<Id,set<Id>>();
        
        //Copy current job tasks to selected jobs
        for(id varid : setJbId)
        {
            
            for(Job_Task__c varJbTsk : lstJbTask)
            {
                
                OldTaskId.add(varJbTsk.id);
                
                tmpJbTsk = new Job_Task__c();
                System.debug('Temporary task on instance creation ---> ' + tmpJbTsk);
                
                //Create new instace for copy task 
                if (Schema.sObjectType.Job_Task__c.fields.Job__c.isCreateable()) { 
                    tmpJbTsk.Job__c = varid;}
                if (Schema.sObjectType.Job_Task__c.fields.Name.isCreateable()) { tmpJbTsk.Name = varJbTsk.Name;}
                if (Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isCreateable()) {  tmpJbTsk.Completion_Date__c = varJbTsk.Completion_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Days__c.isCreateable()) {  tmpJbTsk.Days__c = varJbTsk.Days__c;}
                if (Schema.sObjectType.Job_Task__c.fields.GL_Code__c.isCreateable()) {  tmpJbTsk.GL_Code__c = varJbTsk.GL_Code__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Locked__c.isCreateable()) {  tmpJbTsk.Locked__c = varJbTsk.Locked__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isCreateable()) {  tmpJbTsk.Marked_Done__c = varJbTsk.Marked_Done__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) {  tmpJbTsk.Due_Date__c = varJbTsk.Due_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Report__c.isCreateable()) {  tmpJbTsk.Report__c = varJbTsk.Report__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isCreateable()) {  tmpJbTsk.Revised_Due_Date__c = varJbTsk.Revised_Due_Date__c;}
                // tmpJbTsk.Assigned_Users__c= varJbTsk.Assigned_Users__c;
                if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {  tmpJbTsk.Start_Date__c= varJbTsk.Start_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Status__c.isCreateable()) {  tmpJbTsk.Status__c= varJbTsk.Status__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Schedule_Roles__c.isCreateable()) {  tmpJbTsk.Schedule_Roles__c=varJbTsk.Schedule_Roles__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Hours__c.isCreateable()) {  tmpJbTsk.Hours__c=varJbTsk.Hours__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isCreateable()) {  tmpJbTsk.Task_Order__c= varJbTsk.Task_Order__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isCreateable()) {  tmpJbTsk.Next_Task_Due__c=varJbTsk.Next_Task_Due__c;}
                System.debug('Temporary task ---> ' + tmpJbTsk);
                
                mp1.put(varJbTsk.Name,varJbTsk.id);
                
                //insert new copied instance in list of tasks
                lstJbTskInsrt.add(tmpJbTsk);
                
            }
        }
        
        //Delete existing job tasks for selected jobs
        lstJbTskDel = [SELECT Id, Name, Job__c, Schedule_Roles__c,Hours__c,Completion_Date__c, Days__c, GL_Code__c, Locked__c, Marked_Done__c, Due_Date__c, Report__c, Revised_Due_Date__c, Assigned_Users__c, Start_Date__c, Status__c, Task_Order__c FROM Job_Task__c WHERE Job__c IN : setJbId WITH SECURITY_ENFORCED];
        if(lstJbTskDel.size() > 0){
            if(Job_Task__c.sObjectType.getDescribe().isDeletable()){
                DELETE lstJbTskDel;}
            else{
                return 'Taks has insufficient access to delete';
            }
        }
        //Insert new copied job tasks for selected jobs.
        if(lstJbTskInsrt.size() > 0)
        {
            try{
                if(Schema.sObjectType.Job_Task__c.isCreateable()){  
                    INSERT lstJbTskInsrt;}
                else{
                    return 'Taks has insufficient access to create';
                }
            }
            catch(System.DmlException e){
                return e.getMessage();
            }
            
            for(Job_Task__c jt : lstJbTskInsrt)
            {
                //mp2.put(mp1.get(jt.Name),jt.Id);
                if(mp2.containskey((mp1.get(jt.Name))))
                {
                    set<id> tmpset = mp2.get(mp1.get(jt.Name));
                    tmpset.add(jt.id);
                    mp2.put(mp1.get(jt.Name),tmpset );
                }
                else
                {
                    set<id> tmpset = new set<id>();
                    tmpset.add(jt.id);
                    mp2.put(mp1.get(jt.Name),tmpset );
                }
            }
            
            
            //To Insert TaskRoles
            
            for(Job_Task_Role__c taskRole:lstJTR)
            {
                if(staffNames.contains(taskRole.User__c) || ClientNames.contains(taskRole.User__c) || VendorNames.contains(taskRole.User__c))
                {
                    
                    for(Id tmpid: mp2.get(taskRole.Job_Task__c))
                    {
                        Job_Task_Role__c objJTR=new Job_Task_Role__c();
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                            objJTR.Name=taskRole.Name;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) { 
                            objJTR.Email__c=taskRole.Email__c;}// added by sugunakar.
                        if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) { 
                            objJTR.User__c=taskRole.User__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) { 
                            objJTR.Job_Task__c= tmpid;}
                        insertJTR.add(objJTR);
                    }
                    
                }
            }
            if(insertJTR.size() > 0)
            { 
                try{
                    if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
                        insert insertJTR;  }
                    else{
                        return 'Task role has insufficient access to create';
                    }
                }
                catch(System.DmlException e){
                    return e.getMessage();
                }
                
            }
            
        }
        return 'OK';
        
    }
    
    /*  @AuraEnabled
public Static String DeleteTask1234(String tskid){  

Job_Task__c jtask=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where id =:tskid LIMIT:1];
try{
delete jtask;
}
catch(System.DMLException e)
{
return e.getMessage();
}
return 'OK';
}
*/ 
    
    @AuraEnabled
    public Static String DeleteTask(String tskid){  
        try
        {  
            Id JobId = [Select Id, Job__c from Job_Task__c where Id =:tskid WITH SECURITY_ENFORCED limit 1].Job__c; 
            Double Task_Order_No= [Select Id, Task_Order__c from Job_Task__c where Id =:tskid WITH SECURITY_ENFORCED limit 1].Task_Order__c;
            system.debug('Task_Order_No === '+Task_Order_No);
            
            list<Job_Task__c> objCurrentJobTask2 =  [Select id,name,Task_Order__c,Job__c,Marked_Done__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId and Marked_Done__c = false  and id !=: tskid  WITH SECURITY_ENFORCED Order BY Task_Order__c limit 2];
            system.debug('objCurrentJobTask2 size  === '+objCurrentJobTask2.size());
            //Below line for timing status
            date finalduedate ;
            if(objCurrentJobTask2.size()>0){
                finalduedate = objCurrentJobTask2[0].Revised_Due_Date__c;
            }
            
            Job_Task__c objCurrentJobTask =  [Select id,name,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,Job__c from Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
            system.debug('objCurrentJobTask === '+objCurrentJobTask+'\n');
            date dnew = objCurrentJobTask.Start_Date__c; // this line added on 13 - 12 - 2022 by manindra
            //newly added below line
            Job__c objJobrcd=[Select id,name,Next_Tasks_Due__c,Job_Timing_Status__c,Due_Date__c,UpdateSchedDateFieldCheck__c from Job__c where Id=:JobId WITH SECURITY_ENFORCED limit 1];
            
            List<Approval_Job_Task__c>  ApprovalStepsJobTsk = [select id,task__c from Approval_Job_Task__c where task__c =:tskid WITH SECURITY_ENFORCED];
            
            if(ApprovalStepsJobTsk.size() > 0) 
            { 
                if(Approval_Job_Task__c.sObjectType.getDescribe().isDeletable()){
                    delete ApprovalStepsJobTsk;
                }
                else{
                    return 'Approval Step has insufficient access to delete';
                }
            }
            
            //Below logic is related to next task due and timing status
            if(Job_Task__c.sObjectType.getDescribe().isDeletable())
            {
                if(objJobrcd.Next_Tasks_Due__c == objCurrentJobTask.name && objCurrentJobTask2.size() > 1)
                {
                    
                    Job_Task__c[] nextTasks=[select id,name,Next_Task_Due__c,Email__c,Task_Order__c,Marked_Done__c,Revised_Due_Date__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.name from Job_Task__c where  Job__c =:JobId AND Marked_Done__c!=True WITH SECURITY_ENFORCED order by Task_Order__c desc limit 1];
                    if(nextTasks.size() > 0){
                        if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
                            objJobrcd.Next_Tasks_Due__c = objCurrentJobTask2[0].name; 
                            if(finalduedate >= system.today() &&  objJobrcd.Due_Date__c >= system.today())
                            {
                                objJobrcd.Job_Timing_Status__c =  'On Track' ;
                            }
                            if(finalduedate < system.today() && objJobrcd.Due_Date__c >= system.today()){
                                objJobrcd.Job_Timing_Status__c =  'At Risk' ;  
                            }
                            if(objJobrcd.Due_Date__c <= system.today() ){
                                objJobrcd.Job_Timing_Status__c =  'Delayed' ;  
                            }
                            if(Schema.sObjectType.Job__c.isUpdateable()){ 
                                update objJobrcd;       // commented by manindra on 9 - 12 - 2022
                            }
                        }
                    }
                }
                else 
                {
                    // system.debug('objCurrentJobTask2 size === '+objCurrentJobTask2.size());
                    if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
                        objJobrcd.Next_Tasks_Due__c = ''; 
                    } 
                    if(Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isCreateable() || Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isUpdateable()) {
                        objJobrcd.Job_Timing_Status__c = null;
                    }
                    if(Schema.sObjectType.Job__c.isUpdateable()){ 
                        update objJobrcd;                   // commented by manindra on 9 - 12 - 2022
                    }
                }
                
                Database.delete(objCurrentJobTask);
            }
            
            else{return 'Task has insufficient access to delete';} 
            //ends here
            
            Set<Date> holidaysNew = new Set<Date>();
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
            { 
                holidaysNew.add(hc.Date__c);
            }
            
            Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=:JobId WITH SECURITY_ENFORCED];
            
            Boolean blnFroward = true;
            if(objJob.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }
            
            List<Job_Task__c> lstTaskBelow;
            // System.debug('Below Task records after deletion : '+lstTaskBelow);
            if(blnFroward)
            {
                lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
            }
            else
            {
                lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c <: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c desc];
            }
            
            // new logic starts 09 - 12 - 2022 on manindra for recalculate schedule
            if(objJobrcd.UpdateSchedDateFieldCheck__c == false){    
                if(blnFroward)          //if() start date on 09 - 12 - 2022 by manindra
                {
                    list<Job_Task__c>lstabovenew=[Select id,name,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c asc];
                    for(Integer i=0;i<lstabovenew.size();i++)
                    {
                        system.debug('task record === '+lstabovenew[i].name+'\n');
                        if(i == 0)
                        {
                            system.debug('task name is start date === '+lstabovenew[i].name+'\n');
                            if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                lstabovenew[i].Task_Order__c = Task_Order_No;}
                            
                            if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) { // this if added on 13 - 12 - 2022 by manindra
                                lstabovenew[i].Start_Date__c = dnew;}
                        }
                        else{
                            system.debug('task name is else start date === '+lstabovenew[i].name+'\n');
                            if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {                            
                                lstabovenew[i].Task_Order__c= lstabovenew[i-1].Task_Order__c + 1;}
                        } 
                    }
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                        update lstabovenew;
                        system.debug('lstabovenew === '+lstabovenew+'\n');
                    }
                    else{
                        return 'Task has insufficient access to update task order';
                    }
                }
                // end date  on  09 - 12 - 2022 by manindra
                else{ 
                    list<Job_Task__c>lstbelownew=[Select id,name,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c asc];
                    for(Integer i=0;i<lstbelownew.size();i++)
                    {
                        if(i==0)
                        {
                            system.debug('task name is end date === '+lstbelownew[i].name+'\n');
                            if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                lstbelownew[i].Task_Order__c = Task_Order_No;}
                        }
                        else
                        {    
                            system.debug('task name is end date === '+lstbelownew[i].name+'\n');
                            if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                lstbelownew[i].Task_Order__c= lstbelownew[i-1].Task_Order__c + 1;}
                        }
                    }
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                        update lstbelownew;
                    }
                    
                    else{
                        return 'Task has insufficient access to update task order';
                    }
                }
            }  // new logic re calculate = false condition ends here manindra 09 - 12 - 2022
            
            else{ // only else open by manindra on 9 - 12 - 2022
                if(!lstTaskBelow.isEmpty())
                {
                    Date startDateForNextTask; 
                    
                    if(blnFroward)
                    {
                        startDateForNextTask = Date.newInstance(objCurrentJobTask.Start_Date__c.Year(),objCurrentJobTask.Start_Date__c.month(),objCurrentJobTask.Start_Date__c.Day());
                    }
                    else
                    {
                        startDateForNextTask = Date.newInstance(objCurrentJobTask.Revised_Due_Date__c.Year(),objCurrentJobTask.Revised_Due_Date__c.month(),objCurrentJobTask.Revised_Due_Date__c.Day());
                    }
                    
                    
                    DateTime NextTaskStartDate;
                    
                    for(Integer i=0;i<lstTaskBelow.size();i++)
                    {
                        DateTime dtStartDate3;
                        if(i == 0)
                        {
                            //lstJobTasks[i].Start_Date__c = startDateForNextTask;
                            if(blnFroward)
                            {
                                // dtStartDate3= lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                                if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                                    lstTaskBelow[i].Start_Date__c = startDateForNextTask;}
                                dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                    lstTaskBelow[i].Task_Order__c = Task_Order_No;}
                            }
                            else
                            {
                                if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                                    lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;}
                                dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                            }
                        }
                        else
                        {
                            Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                            if(blnFroward)
                            {
                                //  dtStartDate3 = lstTaskBelow[i].Start_Date__c = d4; 
                                if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                                    lstTaskBelow[i].Start_Date__c = d4; }
                                
                                dtStartDate3 =DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {                            
                                    lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;}
                            }
                            else
                            {
                                if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {   
                                    lstTaskBelow[i].Revised_Due_Date__c = d4; }
                                
                                dtStartDate3 =DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                            }
                            
                        }
                        
                        // lstTaskBelow[i].Days__c = lstTaskBelow[i].Days__c;
                        double days=lstTaskBelow[i].Days__c;
                        
                        Integer jCount=0;
                        
                        // To calculate Due Date, Revised Due Date
                        while(true)
                        {
                            Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                            
                            // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                            if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                            {
                                jCount=jCount+1;
                                if(jCount>days)
                                {
                                    break;
                                }
                                system.debug('jCount======' + jCount);
                                system.debug('==========' + dtStartDate3);
                                
                                system.debug('===========' + dtStartDate3.format('E'));
                                
                                if(blnFroward)
                                {
                                    dtStartDate3=dtStartDate3.addDays(1);
                                }
                                
                                else{ dtStartDate3=dtStartDate3.addDays(-1);}
                                
                                system.debug('After adding 1 day : ' +dtStartDate3);
                            }
                            else
                            {
                                system.debug('==========' + dtStartDate3);                                     
                                if(blnFroward)
                                {
                                    dtStartDate3=dtStartDate3.addDays(1);
                                    continue;
                                }
                                else
                                {
                                    dtStartDate3=dtStartDate3.addDays(-1);
                                    continue;
                                }  
                                
                            }
                        }
                        system.debug('Calculation============' +dtStartDate3);
                        
                        Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        system.debug('D1============' +dtStartDate3);
                        
                        if(blnFroward)
                        {
                            if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                                lstTaskBelow[i].Revised_Due_Date__c=d1;}
                        }
                        else {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c=d1;} 
                        }
                        
                        NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                    }
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                        update lstTaskBelow;      // on 08 - 12 - 2022    by manindra related to task dates once the task is deleted
                    }
                    else{
                        return 'Task has insufficient access to update';
                    }
                    
                    //update the task order for the backward calcuation for the tasks below.
                    
                    
                }
                if(!blnFroward)
                {
                    lstTaskBelow = [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
                    for(Integer i=0;i<lstTaskBelow.size();i++)
                    {
                        if(i==0)
                        {
                            if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                lstTaskBelow[i].Task_Order__c = Task_Order_No;}
                        }
                        else
                        {    
                            if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;}
                        }
                        //updateTask.add(lstTaskAbove[i]);
                    }    
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                        update lstTaskBelow;        // on 08 - 12 - 2022   by manindra related to task order 
                    }
                    else{
                        return 'Task has insufficient access to update';
                    }
                }
            }// only else close by manindra on 9 - 12 - 2022
            
        }
        
        catch(System.DMLException e){
            return e.getMessage();
        } 
        return 'OK';
    }
    
    @AuraEnabled
    public Static String ActiveTask(String tskid){
        Job_Task__c jtask=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where id =:tskid WITH SECURITY_ENFORCED LIMIT:1];
        if (Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()) { 
            jtask.Marked_Done__c=False;}
        if (Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()) { 
            jtask.Completion_Date__c=Null;}
        if (Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()) { 
            jtask.Status__c='Active';}
        try
        { 
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                update jtask;  }
            else{
                return 'Task has insufficient access to edit/update';
            }
        }
        catch(System.DMLException e)
        {
            return e.getMessage();
        }
        return 'OK';
    }
    
    @AuraEnabled
    public Static String CompleteTask(String tskid){
        list<Job_Task__c>updatetasks = new list<Job_Task__c>();
        Job_Task__c jtask=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__c,Job__r.status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where id =:tskid WITH SECURITY_ENFORCED LIMIT:1 ];
        String jobid = jtask.Job__c;
        if (Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()) { 
            jtask.Marked_Done__c=True;}
        if (Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()) { 
            jtask.Completion_Date__c=System.Today();}
        if (Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()) { 
            jtask.Status__c='Completed';}
        Job__c objJob=[Select id,name,Next_Tasks_Due__c,UpdateSchedDateFieldCheck__c from Job__c where Id=: jobid  WITH SECURITY_ENFORCED limit 1];
        try
        {  
            //update jtask; // commented on 14 - 12 - 2022 by manindra
            updatetasks.add(jtask);
            //belowline before array i.e., (Job_Task__c[] jtask2) but we changed as sobject query on 14 - 12 - 2022 by manindra
            Job_Task__c jtask2=[Select id,Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__c,Job__r.status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c  =: jobid and Marked_Done__c = false  WITH SECURITY_ENFORCED LIMIT:1 ];
            if(jtask2 != null)     
            {
                if(objJob.UpdateSchedDateFieldCheck__c == false){
                    jtask2.Start_Date__c = jtask.Revised_Due_Date__c;
                    //updatetasks.add(jtask2);
                }
            }
            else{
                if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
                    {
                        objJob.Next_Tasks_Due__c = '';
                    }
                    if(Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isCreateable() || Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isUpdateable()) {
                        objJob.Job_Timing_Status__c = '';
                    }
                    if(Schema.sObjectType.Job__c.isUpdateable())
                    {
                        update objJob;
                        system.debug('else updated job === '+objJob.Next_Tasks_Due__c);
                    }
                }    
            }
            /* system.debug('updated task job id === '+jtask.Job__c);
Job_Task__c jtasknxt=[Select id,Name,Next_Task_Due__c,Job__c,Task_Order__c,Assigned_Users__c,Marked_Done__c from Job_Task__c where Job__c =:jobid and Next_Task_Due__c = true WITH SECURITY_ENFORCED LIMIT:1 ];
system.debug('task name '+jtasknxt.name);
Job__c objJob=[Select id,name,Next_Tasks_Due__c from Job__c where Id=:jobid WITH SECURITY_ENFORCED limit 1];
objJob.Next_Tasks_Due__c = jtasknxt.Name;
if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
update objJob;
}  */ 
            if(updatetasks.size() > 0){
                if(Schema.sObjectType.Job_Task__c.isUpdateable()) {
                    update updatetasks;
                    system.debug('updatetasks === '+updatetasks+'\n');
                }
                else{
                    return 'Tasks has insufficient access to edit/update';
                }
            }
        }
        
        catch(System.DMLException e)
        {
            return e.getMessage();
        }
        return 'OK';
    }
    
    @AuraEnabled
    public static list<calEvent> getAlltasks(String jobTaskid){
        // return [SELECT Id, EndDateTime, CreatedDate,DurationInMinutes, StartDateTime, Subject FROM Event];
        Map<Integer,String> colormap=new  Map<Integer,String>();
        list<calEvent>  events = new list<calEvent>(); 
        List<Job_Task__c> jobTask= new List<Job_Task__c>();
        
        string strJobName;
        string strCampaignName;
        string strClientName;
        List<string> strstaff;
        List<string> strrole;
        string JobStatusString;
        string  soqlJobTask;
        String regExp = '["\']';
        
        
        colormap.put(0,'#000000');colormap.put(1,'#006633');colormap.put(2,'#330033');colormap.put(3,'#66CC66');colormap.put(4,'#000066');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
        colormap.put(10,'#00CC00');colormap.put(11,'#CCCCCC');colormap.put(12,'#FF0099');colormap.put(13,'#FF66CC');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
        colormap.put(20,'#33CC00');colormap.put(21,'#6666FF');colormap.put(22,'#2E8B57');colormap.put(23,'#996633');colormap.put(24,'#3399FF');colormap.put(25,'#336633');colormap.put(26,'#6666CC');colormap.put(27,'#CC0066');colormap.put(28,'#336699');colormap.put(29,'#330066');
        colormap.put(30,'#00CC99');colormap.put(31,'#3366CC');colormap.put(32,'#CC6633');colormap.put(33,'#3366FF');colormap.put(34,'#660066');colormap.put(35,'#99CC66');colormap.put(36,'#00CCCC');colormap.put(37,'#99CCCC');colormap.put(38,'#66CC33');colormap.put(39,'#CC66CC');
        colormap.put(40,'#006699');colormap.put(41,'#990033');colormap.put(42,'#666699');colormap.put(43,'#990000');colormap.put(44,'#336600');colormap.put(45,'#66CCCC');colormap.put(46,'#660033');colormap.put(47,'#9900FF');colormap.put(48,'#666666');colormap.put(49,'#FF00FF');
        colormap.put(50,'#330000');colormap.put(51,'#66CCFF');colormap.put(52,'#9900CC');colormap.put(53,'#33CCFF');colormap.put(54,'#990099');colormap.put(55,'#0066CC');colormap.put(56,'#33CC66');colormap.put(57,'#66CC00');colormap.put(58,'#00CC33');colormap.put(59,'#99CCFF');
        colormap.put(60,'#666600');colormap.put(61,'#CC0099');colormap.put(62,'#99CC99');colormap.put(63,'#6600FF');colormap.put(64,'#CCCC66');colormap.put(65,'#FF6699');colormap.put(66,'#CCCC99');colormap.put(67,'#FF6666');colormap.put(68,'#9966CC');colormap.put(69,'#CC66FF');
        colormap.put(70,'#990066');colormap.put(71,'#99CC33');colormap.put(72,'#FF6600');colormap.put(73,'#CC6699');colormap.put(74,'#FF66FF');colormap.put(75,'#3300FF');colormap.put(76,'#CCCCFF');colormap.put(77,'#006666');colormap.put(78,'#CC00CC');colormap.put(79,'#996666');
        colormap.put(80,'#99CC00');colormap.put(81,'#FFCC99');colormap.put(82,'#33CC33');colormap.put(83,'#FF00CC');colormap.put(84,'#33CC99');colormap.put(85,'#FF0066');colormap.put(86,'#660099');colormap.put(87,'#0000CC');colormap.put(88,'#CC00CC');colormap.put(89,'#006600');
        colormap.put(90,'#FF0000');colormap.put(91,'#3300CC');colormap.put(92,'#996699');colormap.put(93,'#FFCC00');colormap.put(94,'#00CCFF');colormap.put(95,'#66CC99');colormap.put(96,'#00CC66');colormap.put(97,'#9966FF');colormap.put(98,'#330099');colormap.put(99,'#FFCCFF');
        
        
        Date myDate = system.today();
        String completed = 'completed';
        soqlJobTask='Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c';
        
        if(jobTaskid !=Null )
            soqlJobTask+=' where Job__c=:jobTaskid WITH SECURITY_ENFORCED';
        
        jobTask=Database.query(soqlJobTask);
        
        if(jobTask.size() > 0)
        {
            for(Job_Task__c  jobt: jobTask)
            {
                strCampaignName = jobt.Job__r.campaign__r.name;
                JobStatusString  = jobt.Job__r.status__c;
                strClientName  = jobt.Job__r.JS_Client__r.name;
                strJobName  = jobt.Job__r.Name;
                DateTime strDT = jobt.Start_Date__c+1;
                DateTime endDT = jobt.Revised_Due_Date__c+2;
                //  DateTime endDT = jobt.Revised_Due_Date__c+1;
                
                System.debug('=========Revised_Due_Date__c========='+jobt.Revised_Due_Date__c);
                System.debug('=========Revised_Due_Date__c Adeed 1 day========'+jobt.Revised_Due_Date__c);
                System.debug('=========endDT ========='+endDT);
                System.debug('=========startString ========='+endDT.format());
                System.debug('=========endstring========='+endDT.format());
                
                calEvent J= new calEvent();
                
                string strTaskName =jobt.Name;
                // string strJobName = jobt.Job__r.Name;
                String Taskname = jobt.Name; 
                //String regExp = '["\']';
                if(Taskname  != NULL)
                    Taskname = Taskname .replaceAll(regExp, '\\ ');
                J.title = Taskname +', Job - # '+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                J.titleNew = Taskname +' - '+jobt.Job__r.Job_Auto_Number__c;
                J.allDay = true;
                J.startString = strDT.format();//jobt.Start_Date__c;
                J.endString = endDT.format();//jobt.Revised_Due_Date__c;
                J.TaskId=jobt.id;
                //  J.url = '/' + jobt.Job__c;
                //J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                if(UserInfo.getUiTheme() == 'Theme4d'){
                    //J.url = '/apex/JobdetailpageLightening07?id='+jobt.Job__c+'&section=schedules';
                    //J.url=jobt.id;
                }
                else{
                    //J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                    //J.url=jobt.id;
                }
                String TaskCampname = jobt.Job__r.campaign__r.name; 
                if(TaskCampname != NULL)
                    TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                else 
                    TaskCampname='';
                
                String TaskJobname = jobt.Job__r.Name; 
                if(TaskJobname != NULL)
                    TaskJobname = TaskJobname .replaceAll(regExp, '\\ ');
                
                j.JN1 = TaskCampname +' : '+TaskJobname +'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                if(TaskJobCliname != NULL)
                    TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                else
                    TaskJobCliname='';
                j.client1 = TaskJobCliname ;
                J.Tstatus=jobt.Status__c;
                // j.color=colormap.get(15);
                //j.color = 'green';
                
                string TaskStatus=jobt.Status__c;
                if(TaskStatus=='Active'){
                    j.color = 'green';
                }
                else if(TaskStatus=='Completed'){
                    j.color = 'blue';
                }   
                else if(TaskStatus=='Requested'){
                    j.color = 'darkgray';
                }
                else{
                    j.color = 'darkgray';
                }
                
                
                String TaskUsersname = jobt.Assigned_Users__c; 
                //String regExp = '["\']';
                if(TaskUsersname != NULL)
                    TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                else{
                    TaskUsersname='';
                }
                j.Staff= TaskUsersname ;
                J.className = 'event-Jobs';
                events.add(J);
                system.debug('=======events====='+events);
                
            }
        }
        return events;
        // return [Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c];
        
    }
    
    public class calEvent{
        @AuraEnabled    public string titleNew {get;set;}
        @AuraEnabled    public String title {get;set;}
        @AuraEnabled    public Boolean allDay {get;set;}
        @AuraEnabled    public String startString {get;set;}
        @AuraEnabled    public String endString {get;set;}
        @AuraEnabled    public String url {get;set;}
        @AuraEnabled    public string color {get;set;}
        @AuraEnabled    public String JN1 {get;set;} //jobnumber
        @AuraEnabled    public String client1 {get;set;}
        @AuraEnabled    public String Staff {get;set;} // used for assigning task staff and used for assigning campaign of the job
        @AuraEnabled    public string TaskId {set;get;}
        @AuraEnabled    public string Tstatus {set;get;}
        @AuraEnabled    public String className {get;set;}
        
    }
    
    @AuraEnabled
    public static List<String> getStatusList() 
    {
        List<String> optionList = new  List<String>();
        Schema.DescribeFieldResult field = Job_Task__c.Status__c.getDescribe();
        //optionList.add('All'); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(a.getLabel());  
        }
        
        return optionList;  
    }
    
    @AuraEnabled
    public static string TaskDueDateUpdate(String DCalTaskId,String DcalStartDate,String DcalDueDate ){
        //String DCalTaskId=Apexpages.CurrentPage().getParameters().get('DCalTaskId');
        //String DcalDueDate=Apexpages.CurrentPage().getParameters().get('DcalDueDate');
        
        integer startyear = integer.valueof(DcalStartDate.substring(0,4));
        integer startmonth = integer.valueof(DcalStartDate.substring(5,7));
        integer startday = integer.valueof(DcalStartDate.substring(8,10));
        Date StartDate = Date.newInstance(startyear,startmonth,startday);
        System.debug('===SDate==='+StartDate);
        
        System.debug('========Due date for the event Drip=========='+DcalDueDate);
        integer syear = integer.valueof(DcalDueDate.substring(0,4));
        integer smonth = integer.valueof(DcalDueDate.substring(5,7));
        integer sday = integer.valueof(DcalDueDate.substring(8,10));
        Date DueDate = Date.newInstance(syear,smonth,sday)-1;
        System.debug('===SDate==='+DueDate);
        
        try{
            Job_Task__c DueDateUpdate=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:DCalTaskId WITH SECURITY_ENFORCED];
            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                DueDateUpdate.Start_Date__c=StartDate;}
            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                DueDateUpdate.Revised_Due_Date__c=DueDate;}
            // CalDD= DateTime.newInstance(DueDateUpdate.Revised_Due_Date__c.year(),DueDateUpdate.Revised_Due_Date__c.month(),DueDateUpdate.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update DueDateUpdate;}
        }
        
        catch(System.DMLException e){
            return e.getMessage();
        }
        return 'OK';
    }
    
    @AuraEnabled
    public static string statusChangeUpdate(String DTaskId,String DTaskStatus){
        
        try{
            Job_Task__c JStatusUpdate=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:DTaskId WITH SECURITY_ENFORCED];
            
            if(JStatusUpdate.Status__c=='Completed' && JStatusUpdate.Completion_Date__c!=null ){
                if(Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()){
                    JStatusUpdate.Status__c='Active';}
                if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){
                    JStatusUpdate.Completion_Date__c=null;}
                if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){
                    JStatusUpdate.Marked_Done__c=false;}
            }
            
            else{
                if(Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()){ JStatusUpdate.Status__c='Completed';}
                if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){JStatusUpdate.Completion_Date__c=System.Today();}
                if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){JStatusUpdate.Marked_Done__c=true;}
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update JStatusUpdate;}
            //CalDD=DateTime.newInstance(JStatusUpdate.Revised_Due_Date__c.year(), JStatusUpdate.Revised_Due_Date__c.month(), JStatusUpdate.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
        }
        
        Catch(System.DMLException e){
            return e.getmessage();
        }
        return 'OK';
    }
    
    
    @AuraEnabled
    public static String TaskEditSuccess(String TaskId,Boolean UpdateRestDays, Boolean UpdateRestDates){
        try
        {   
            //Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c
            Job_Task__c objJobTask = [select Id,Name,Days__c,Start_Date__c,Due_Date__c,Revised_Due_Date__c,Job__r.Schedule_Calc__c,Job__r.id,Job__r.Name, Marked_Done__c,Task_Order__c from Job_Task__c where  id =: TaskId  WITH SECURITY_ENFORCED limit 1];
            system.debug('Old value' + objJobTask );
            
            Set<Date> holidaysNew=new Set<Date>();
            
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
            {
                holidaysNew.add(hc.Date__c);
            }
            
            if(UpdateRestDays)
            {  
                
                System.debug('Not matched');
                Boolean blnFroward = true;
                if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
                {
                    blnFroward = false;
                }
                
                //code for the update of the current task
                Datetime dtStartDate1;
                
                if(blnFroward)
                {
                    dtStartDate1  = Datetime.newInstance(objJobTask.Start_Date__c,Time.newInstance(12, 0, 0, 0));
                }
                else
                {
                    // dtStartDate1 = Datetime.newInstance(objTask1.Start_Date__c,Time.newInstance(12, 0, 0, 0));
                    dtStartDate1 = Datetime.newInstance(objJobTask.Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                }
                
                System.debug('Start Date is : ' +dtStartDate1);
                
                Integer jCount = 0;
                
                System.debug('jCount value '+jCount);
                
                while(true)
                {
                    Date d3=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                    if(dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                    {
                        jCount = jCount + 1;
                        if(jCount > objJobTask.Days__c)
                        {
                            break;
                        }
                        
                        if(blnFroward)
                        {
                            dtStartDate1 = dtStartDate1.addDays(1);
                        }
                        else
                        {
                            dtStartDate1 = dtStartDate1.addDays(-1);
                        }
                        
                        System.debug('After adding 1 day : '+dtStartDate1);
                        
                    }
                    else
                    {
                        System.debug('======='+dtStartDate1);
                        // dtStartDate1 =dtStartDate1.addDays(1);
                        if(blnFroward)
                        {
                            dtStartDate1 = dtStartDate1.addDays(1);
                        }
                        else
                        {
                            dtStartDate1 = dtStartDate1.addDays(-1);
                        }
                        
                        continue;
                    }
                }
                Date afterDaysUpdate = Date.newInstance(dtStartDate1.Year(), dtStartDate1.Month(), dtStartDate1.Day());
                
                System.debug('Date After updating days '+afterDaysUpdate);
                
                //objJobTask.Days__c = newDaysValue ;
                
                
                
                if(blnFroward)
                {
                    if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                        objJobTask.Revised_Due_Date__c = afterDaysUpdate;  
                    }
                    
                }
                else
                {
                    if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                        objJobTask.Start_Date__c = afterDaysUpdate; 
                    }
                }
                if(Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                    update objJobTask; 
                }
                else{
                    return 'Error, Task has Insufficient access to update';
                }
                
                //code adding for Timing status
                date finalduedate = objJobTask.Revised_Due_Date__c;
                Job__c objJob=[Select id,name,Next_Tasks_Due__c,Job_Timing_Status__c,Due_Date__c from Job__c where Id=:objJobTask.Job__r.id WITH SECURITY_ENFORCED limit 1];
                if(Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isCreateable() || Schema.sObjectType.Job__c.fields.Job_Timing_Status__c.isUpdateable()){
                    if(finalduedate >= system.today() &&  objJob.Due_Date__c >= system.today())
                    {
                        objJob.Job_Timing_Status__c =  'On Track' ;
                    }
                    if(finalduedate < system.today() && objJob.Due_Date__c >= system.today()){
                        objJob.Job_Timing_Status__c =  'At Risk' ;  
                    }
                    if(objJob.Due_Date__c <= system.today() ){
                        objJob.Job_Timing_Status__c =  'Delayed' ;  
                    }
                }
                if(Schema.sObjectType.Job__c.isUpdateable()){
                    update objJob;
                }//code ends here
                
                //code for the update of the below and above task respectively  
                List<Job_Task__c> lstTaskBelow ;
                
                if(blnFroward)
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :objJobTask.Job__r.Id and Id !=: objJobTask.Id and Task_Order__c >=: objJobTask.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED  Order BY Task_Order__c ASC];   
                }
                else
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :objJobTask.Job__r.Id and Id !=: objJobTask.Id and Task_Order__c <=: objJobTask.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED   Order BY Task_Order__c DESC]; 
                }
                
                DateTime NextTaskStartDate;
                
                Date startDateForNextTask;
                
                
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.month(),objJobTask.Revised_Due_Date__c.Day());   
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Start_Date__c.Year(),objJobTask.Start_Date__c.month(),objJobTask.Start_Date__c.Day()); 
                }
                
                System.debug('Task below the updated Task : '+lstTaskBelow);
                
                System.debug('Size of Task Below the current Task : '+lstTaskBelow.size());
                
                for(Integer i = 0; i <lstTaskBelow.size(); i++)
                {
                    System.debug('Value of i' +i);
                    DateTime dtStartDate3;
                    if(i == 0)
                    {   
                        if(blnFroward)
                        {
                            // dtStartDate3= startDateForNextTask;
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                            }
                        }
                        else
                        {
                            //dtStartDate3= startDateForNextTask;
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;
                            }
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        
                        if(blnFroward)
                        {
                            //dtStartDate3= d4;
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = d4; 
                            }
                        }
                        else
                        {
                            //dtStartDate3=d4;
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstTaskBelow[i].Revised_Due_Date__c = d4; 
                            }
                        }
                    }
                    
                    
                    if(blnFroward)
                    {
                        dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                    }
                    else
                    {
                        dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0)); 
                    }
                    
                    System.debug('Day is:'+dtStartDate3.format('E'));
                    
                    system.debug('Start Date is : ' +dtStartDate3);
                    
                    if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                        lstTaskBelow[i].Days__c = lstTaskBelow[i].Days__c;
                    }
                    
                    Integer jCount1 = 0;
                    
                    // To calculate  Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount1 =jCount1+1;
                            if(jCount1 > lstTaskBelow[i].Days__c)
                            {
                                break;
                            }
                            system.debug('jCount======' + jCount1);
                            system.debug('==========' + dtStartDate3);
                            
                            system.debug('===========' + dtStartDate3.format('E'));
                            
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);
                            // dtStartDate3=dtStartDate3.addDays(1);
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                    
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                    
                    if(blnFroward)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstTaskBelow[i].Revised_Due_Date__c=d1;
                        }
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstTaskBelow[i].Start_Date__c=d1;
                        }
                    }
                    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                    update lstTaskBelow;
                }
                else{
                    return 'Error, Insufficient access to update this record';
                }
                
            }
            else if(UpdateRestDates || test.isRunningTest())
            {
                System.debug('Matched');
                DateTime NextTaskStartDate;
                ///update the current task start date and then update the revised due date of all the rest of the schedule 
                
                System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                //code for updating the start date of the current task
                Integer jCount = 0;
                //Integer newDaysValue = objJobTask.Days__c;
                // Datetime dtStartDate=DateTime.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.Month(),objJobTask.Revised_Due_Date__c.Day());
                System.debug('jCount value '+jCount);
                if(Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                    update objJobTask;    
                }
                else{
                    return 'Error, Insufficient access to update this record Job Task';
                }
                Datetime dtStartDate;
                Boolean blnFroward = true;
                if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
                {
                    blnFroward = false;
                } 
                if(!blnFroward)
                {
                    dtStartDate = DateTime.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.Month(),objJobTask.Revised_Due_Date__c.Day());
                }
                
                
                System.debug('dtStartDate  value '+dtStartDate );
                System.debug('new value '+DateTime.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.Month(),objJobTask.Revised_Due_Date__c.Day()));
                if(!blnFroward)        
                {   
                    while(true)
                    {
                        Date d3=Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                        if(dtStartDate.format('E')!='Sat' && dtStartDate.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                        {
                            jCount = jCount + 1;
                            if(jCount > objJobTask.Days__c)
                            {
                                break;
                            }
                            dtStartDate = dtStartDate.addDays(-1);
                        }
                        else
                        { 
                            dtStartDate = dtStartDate.addDays(-1);
                            continue;
                        }
                    }
                    Date afterDaysUpdate = Date.newInstance(dtStartDate.Year(), dtStartDate.Month(), dtStartDate.Day());
                    if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                        objJobTask.Start_Date__c = afterDaysUpdate;
                    }
                    System.debug('afterDaysUpdate value '+afterDaysUpdate);
                    if(Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                        update objJobTask;
                    } else{
                        return 'Error, Task has Insufficient access to update ';
                    }  
                    
                }
                
                System.debug('Update current Job Task : '+objJobTask);
                
                
                Date startDateForNextTask ;
                //Id idTask = 
                Job_Task__c objJobTaskNew = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c ,Job__r.id from Job_Task__c where id =: objJobTask.id WITH SECURITY_ENFORCED limit 1];
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objJobTaskNew.Revised_Due_Date__c.Year(),objJobTaskNew.Revised_Due_Date__c.month(),objJobTaskNew.Revised_Due_Date__c.Day());
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objJobTaskNew.Start_Date__c.Year(),objJobTaskNew.Start_Date__c.month(),objJobTaskNew.Start_Date__c.Day());
                }
                
                List<Job_Task__c> lstJobTasks ;//= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                
                if(blnFroward)
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
                }
                else
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC];
                }
                System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                
                System.debug('Size of Update Tasks : '+lstJobTasks.size());
                
                for(Integer i = 0; i <lstJobTasks.size(); i++)
                {
                    System.debug('Value of i' +i);
                    DateTime dtStartDate3;
                    if(i == 0)
                    {
                        //lstJobTasks[i].Start_Date__c = startDateForNextTask;
                        if(blnFroward)
                        {
                            // dtStartDate3= startDateForNextTask;
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                        }
                        else
                        {
                            //dtStartDate3= startDateForNextTask;
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            //dtStartDate3 = d4;
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = d4; }
                        }
                        else
                        {
                            //dtStartDate3 =d4;
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = d4; }
                        }
                        
                    }
                    
                    
                    if(blnFroward)
                    {
                        dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                    }
                    else{
                        
                        dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                        
                    }
                    
                    
                    
                    System.debug('Day is:'+dtStartDate3.format('E'));
                    
                    System.debug('Start Date is : ' +dtStartDate3);
                    if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                        lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;
                    }
                    jCount=0;
                    
                    // To calculate Due Date, Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount=jCount+1;
                            if(jCount>lstJobTasks[i].Days__c)
                            {
                                break;
                            }
                            system.debug('jCount======' + jCount);
                            system.debug('==========' + dtStartDate3);
                            
                            system.debug('===========' + dtStartDate3.format('E'));
                            
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }                                   
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);                                     
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }  
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                    
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                    
                    if(blnFroward)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstJobTasks[i].Revised_Due_Date__c=d1;}
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c=d1;}
                    }    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                    update lstJobTasks;}
                else{
                    return 'Task has insufficient access to update';
                }
                System.debug('Updated List : '+lstJobTasks);
                //  }
                // } commented for gl code change
            }
        }
        catch(System.DMLException e)
        {
            return e.getMessage();
        }      
        
        return 'OK';
        
    }
    
    @AuraEnabled
    public static  List<Object> InsertAboveLoad(String taskid, Double days, String RolesList){
        List<Object> datalist=new List<Object>();
        
        Double task_order_no; 
        Job_Task__c  objJobTask1=[Select Job__c,Task_Order__c,Days__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c  from Job_Task__c where Id=: taskid WITH SECURITY_ENFORCED]; 
        task_order_no=objJobTask1.Task_Order__c;
        
        system.debug('Roles======' + RolesList);
        String Roleslist1=RolesList.replaceAll(',',';');
        String Roleslist2=RolesList1.replaceAll('\\[','');
        String Roleslist3=RolesList2.replaceAll('\\]','');
        
        system.debug('Roleslist3======' + Roleslist3);
        System.debug('tId1@@@@'+taskid);
        
        Datetime NTSD;
        Set<Date> holidays=new Set<Date>();
        
        // Add Holiday Dates to Set, so that holidays will be skipped while calculating Schedule dates
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        
        Boolean blnFroward = true;
        /**** check for the schedule calc  to change the remaing tasks**************/
        if(objJobTask1.Job__r.Schedule_Calc__c == 'End Date')
        {
            blnFroward = false;
        }
        
        
        Date d;
        
        d=Date.newInstance(objJobTask1.Start_date__c.Year(),objJobTask1.Start_date__c.Month(),objJobTask1.Start_date__c.Day());
        
        //for the new value the revised due date will be the stsrt date of the below value
        Datetime dtStartDate=DateTime.newInstance(d.Year(),d.Month(),d.Day());
        Integer jCount=0;
        // To Calculate Due Date, Revised Due Date
        while(true)
        {
            Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
            // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
            if((dtStartDate.format('E')!='Sat'&&dtStartDate.format('E')!='Sun') && ! (holidays.contains(d3)))
            {
                jCount=jCount+1;
                if(jCount>days)
                {
                    break;
                }
                system.debug('jCount======' + jCount);
                system.debug('==========' + dtStartDate);
                
                system.debug('===========' + dtStartDate.format('E'));
                //if end calulate by -
                if(blnFroward)
                {
                    dtStartDate=dtStartDate.addDays(1);
                }
                else
                {
                    dtStartDate=dtStartDate.addDays(-1);
                }
                system.debug('After adding 1 day : ' +dtStartDate);
                
            }
            else
            {
                system.debug('==========' + dtStartDate);
                //if end calulate by -
                if(blnFroward)
                {
                    dtStartDate=dtStartDate.addDays(1);
                }
                else
                {
                    dtStartDate=dtStartDate.addDays(-1);
                }
                continue;
            }
        }
        system.debug('Calculation============' +dtStartDate);
        
        Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
        system.debug('D1============' +dtStartDate);
        
        
        
        if(blnFroward)
        {
            
            // objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d,Task_Order__c=task_order_no,Due_Date__c=d1,Revised_Due_date__c=d1,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
            datalist.add(task_order_no);
            datalist.add(d);
            datalist.add(d1);
            datalist.add(Roleslist3);
            
        }
        else
        {
            //objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no,Due_Date__c=d,Revised_Due_date__c=d,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
            datalist.add(task_order_no);
            datalist.add(d1);
            datalist.add(d);
            datalist.add(Roleslist3);
        }
        
        
        return datalist;          
    }  
    
    @AuraEnabled
    public static String InsertAboveSucess(String Oldtaskid,String NewTaskId,String strid){
        Double task_order_no; 
        Boolean isFirst=true;
        Job_Task__c  objJobTask1=[Select id,name,Job__c,Task_Order__c,Days__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c  from Job_Task__c where Id=: Oldtaskid WITH SECURITY_ENFORCED]; 
        system.debug('below objJobTask1 === '+objJobTask1+'\n');
        task_order_no=objJobTask1.Task_Order__c;
        system.debug('inserted task_order_no === '+task_order_no+'\n');
        Job_Task__c  objJobTask=[Select id,name,Job__c,Task_Order__c,Days__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c  from Job_Task__c where Id=: NewTaskId WITH SECURITY_ENFORCED]; 
        system.debug('current inserted objJobTask === '+objJobTask+'\n');
        Job__c jrcd = [select id,name,UpdateSchedDateFieldCheck__c from Job__c where id =:objJobTask.Job__c WITH SECURITY_ENFORCED];
        Boolean blnFroward = true; 
        if(objJobTask1.Job__r.Schedule_Calc__c == 'End Date')
        {
            blnFroward = false;
        }
        Double c=task_order_no+1;    // enddate by manindra
        Double dnew=task_order_no+1;// start date  by manindra
        
        Double days=objJobTask.Days__c;
        system.debug('days == '+objJobTask.Days__c);
        List<Job_Task__c> lst=new List<Job_Task__c>();
        Set<Date> holidays=new Set<Date>();
        list<Job_Team__c> listjobteam=new  list<Job_Team__c>();
        listjobteam =[select id,name, Role__c,staff__c,Email__c from Job_Team__c  where job__c =:strid WITH SECURITY_ENFORCED];
        // Add Holiday Dates to Set, so that holidays will be skipped while calculating Schedule dates
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        
        if(jrcd.UpdateSchedDateFieldCheck__c == false){    // new logic starts 08 - 12 - 2022 on manindra
            
            if(!blnFroward)          //if() end date // 08 - 12 - 2022 on manindra
            {
                list<Job_Task__c>lstbelownew=[Select Id,Name,Task_Order__c,Email__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                for(Job_Task__c jt1new:lstbelownew)
                {
                    system.debug('if due date === '+jt1new.Name+'\n');
                    if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                        jt1new.Task_Order__c=c;
                    }
                    c++;
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                    update lstbelownew;
                }
            }
            
            else{     
                // start date          // 08 - 12 - 2022 on manindra
                list<Job_Task__c>lstabovenew=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c  from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                for(Job_Task__c jt11new:lstabovenew)
                {
                    system.debug('jt11new === '+jt11new+'\n');//if() start date
                    if(days > 0){
                        if(jt11new.id == lstabovenew[0].id){           // here added on 14 - 12 - 2022 by manindra
                            system.debug('jt11new === '+jt11new+'\n');
                            if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) { 
                                jt11new.Start_Date__c=objJobTask.Revised_Due_Date__c; // assigning iserted task revise date to next task start date only when nserted task days field is greater than zero
                            }
                        }
                    }
                    if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) { 
                        jt11new.Task_Order__c=dnew;
                    }
                    dnew++;
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                    update lstabovenew;
                    system.debug('lstabovenew === '+lstabovenew+'\n');
                }
                
                //jobteams
                List<Job_Task__c > listtasks=[select id,name,Schedule_Roles__c,Email__c from Job_Task__c  where id=:NewTaskId WITH SECURITY_ENFORCED];
                List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
                
                for(Job_Team__c Jteam :listjobteam ){
                    for(Job_Task__c  Jtask :listtasks){
                        if(Jtask.Schedule_Roles__c!=NULL && Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
                            Job_Task_Role__c J2 = new Job_Task_Role__c ();
                            if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) { 
                                J2.Email__c =Jteam.Email__c; }
                            if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) { 
                                J2.User__c=Jteam.Staff__c;}
                            if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                                J2.Name=Jteam.Role__c;}
                            if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) { 
                                J2.Job_Task__c = NewTaskId;}
                            JobTaskRoleNew.add(J2);
                        }
                    }
                }
                if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
                    insert JobTaskRoleNew;
                }
                else{
                    return 'Task role has insufficient access to create';
                }
                //New logic on 13 - 12 -2022 by manindra
                /*  date startdatenew;
list<Job_Task__c>lstabovenew=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c  from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c asc];
if(lstabovenew.size() > 0){
for(integer i = 0 ; i < lstabovenew.size() ; i++){
system.debug('task reccords === '+lstabovenew[i]+'\n');

}
if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
// update lstabovenew;
system.debug('lstabovenew === '+lstabovenew+'\n');
}
}*/
            } 
        }
        // new logic ends here manindra 12 - 12 - 2022
        
        
        /***********************   ***************************************/
        
        else{
            Date d;
            // if(blnFroward)
            // {
            d=Date.newInstance(objJobTask1.Start_date__c.Year(),objJobTask1.Start_date__c.Month(),objJobTask1.Start_date__c.Day());
            // }
            //  else{
            //   d=Date.newInstance(objJobTask1.Revised_Due_date__c.Year(),objJobTask1.Revised_Due_date__c.Month(),objJobTask1.Revised_Due_date__c.Day());
            // }            
            // Date db = Date.newInstance(objJobTask1.Revised_Due_date__c.Year(),objJobTask1.Revised_Due_date__c.Month(),objJobTask1.Revised_Due_date__c.Day()); 
            //for the new value the revised due date will be the stsrt date of the below value
            Datetime dtStartDate=DateTime.newInstance(d.Year(),d.Month(),d.Day());
            system.debug('dtStartDate == '+dtStartDate);
            Integer jCount=0;
            // To Calculate Due Date, Revised Due Date
            while(true)
            {
                Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                system.debug('d3 == '+d3);
                // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
                if((dtStartDate.format('E')!='Sat'&&dtStartDate.format('E')!='Sun') && ! (holidays.contains(d3)))
                {
                    system.debug('if condition dtStartDate == '+dtStartDate);   
                    jCount=jCount+1;
                    system.debug('jCount == '+jCount+'and days === '+days);  
                    if(jCount>days)
                    {
                        system.debug('if condition jCount == '+jCount+'and days === '+days);  
                        break;
                    }
                    system.debug('jCount======' + jCount+'\n');
                    system.debug('==========' + dtStartDate+'\n');
                    system.debug('===========' + dtStartDate.format('E')+'\n');
                    //if end calulate by -
                    if(blnFroward)
                    {
                        dtStartDate=dtStartDate.addDays(1);
                        system.debug('if 3909 condition dtStartDate == '+dtStartDate);  
                    }
                    else
                    {
                        dtStartDate=dtStartDate.addDays(-1);
                        system.debug('else 3914 condition dtStartDate == '+dtStartDate);  
                        
                    }
                    system.debug('After adding 1 day : '+dtStartDate+'\n');
                }
                else
                {
                    system.debug('==========' +dtStartDate+'\n');
                    //if end calulate by -
                    if(blnFroward)
                    {
                        dtStartDate=dtStartDate.addDays(1);
                        system.debug('if 3927 condition dtStartDate == '+dtStartDate);  
                        
                    }
                    else
                    {
                        dtStartDate=dtStartDate.addDays(-1);
                        system.debug('else 3933 condition dtStartDate == '+dtStartDate);  
                    }
                    continue;
                }
            }
            system.debug('Calculation============' +dtStartDate+'\n');
            Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
            system.debug('D1============' +dtStartDate+'\n');
            if(blnFroward)
            {
                lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c  from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                system.debug('blnFroward === '+lst+'\n');
            }
            else
            {
                lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c  from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no-1 AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC ];
                system.debug('else blnFroward === '+lst+'\n');
            }
            System.debug('Size of lst '+lst.size()+'\n');
            List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
            Date NTSD1;
            Double a=task_order_no+1;
            for(Job_Task__c jt1:lst)
            {
                system.debug('task record === '+jt1);
                //if() start date 
                if(blnFroward)
                {
                    system.debug('blnFroward task record === '+jt1);
                    if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) { 
                        jt1.Task_Order__c=a;}
                    a++;
                }
                
                if(isFirst)
                {
                    System.debug('This is First'+jt1+'\n');
                    if(blnFroward)
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) { 
                            jt1.Start_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
                        System.debug('if This is First'+jt1+'\n');
                    }
                    else
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) { 
                            jt1.Revised_Due_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
                        System.debug('else This is First'+jt1+'\n');
                        
                    }
                    isFirst=false;
                }
                else
                {
                    if(blnFroward)
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) { 
                            jt1.Start_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
                        System.debug('if This is not First'+jt1+'\n');
                    }
                    else
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                            jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
                        System.debug('else This is not First'+jt1+'\n');
                    }
                }
                
                System.debug('task Name'+jt1.Name+'\n');
                System.debug('ST Date'+jt1.Start_Date__c+'\n');
                Datetime dtStartDate1;
                if(blnFroward)
                {
                    dtStartDate1 =Datetime.newInstance(jt1.Start_Date__c.Year(),jt1.Start_Date__c.Month(),jt1.Start_Date__c.Day());
                    system.debug('dtStartDate1 === '+dtStartDate1+'\n');
                }
                else
                {
                    dtStartDate1=Datetime.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
                    system.debug('dtStartDate1 === '+dtStartDate1+'\n');
                    
                }
                System.debug('Start Date is :'+dtStartDate1+'\n');
                Integer jCount1=0;
                System.debug('jCount value'+jCount1+'\n');
                
                while(true)
                {
                    Date d4=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                    system.debug('d4 == '+d4);
                    
                    if((dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!='Sun')&&(!holidays.contains(d4)))
                    {
                        jCount1=jCount1 +1;
                        if(jCount1>jt1.Days__c)
                        {
                            break;
                        }
                        system.debug('jCount======' + jCount1+'\n');
                        system.debug('==========' + dtStartDate1+'\n');
                        system.debug('===========' + dtStartDate1.format('E')+'\n');
                        if(blnFroward)
                        {
                            dtStartDate1=dtStartDate1.addDays(1);
                        }
                        else
                        {
                            dtStartDate1=dtStartDate1.addDays(-1);
                        }
                        system.debug('after adding 1 day==========' + dtStartDate1+'\n');
                    }
                    else
                    {
                        system.debug('==========' + dtStartDate1+'\n');
                        //system.debug('===========' + dtStartDate.format('E'));
                        if(blnFroward)
                        {
                            dtStartDate1=dtStartDate1.addDays(1);
                        }
                        else
                        {
                            dtStartDate1=dtStartDate1.addDays(-1);
                        }
                        continue;
                    }
                }   
                
                Date  d5 = Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                System.debug('D5 is as follows : '+d5+'\n');
                if(blnFroward)
                {
                    if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) { 
                        jt1.Revised_Due_Date__c=d5;}
                }
                else
                {
                    if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                        jt1.Start_Date__c=d5;}
                }
                NTSD1=d5;
                system.debug('NTSD '+NTSD1+'\n');
                lstJobTask.add(jt1);
                // update jt1;
            }
            try{
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                    update lstJobTask;
                }
                else{
                    return 'Task has insufficient access to update';
                }
                //update the task order of the below tasks
                List<Job_Task__c> lstbelow =new List<Job_Task__c>();
                //if(end date do desc)
                lstbelow=[Select Id,Name,Task_Order__c,Email__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                //if(!blnFroward)
                // {
                for(Job_Task__c jt1:lstbelow)
                {
                    //if() start date 
                    if(!blnFroward)
                    {
                        if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                            jt1.Task_Order__c=a;
                        }
                        a++;
                    }
                    // jt1.Task_Order__c=a;
                    //  a++;
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                    update lstbelow;
                }
                else{
                    return 'Task has insufficient access to update';
                }
            }
            catch(DMLException e)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
                return e.getMessage();
            } 
            List<Job_Task__c > listtasks=[select id,name,Schedule_Roles__c,Email__c from Job_Task__c  where id=:NewTaskId WITH SECURITY_ENFORCED];
            List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
            
            for(Job_Team__c Jteam :listjobteam ){
                for(Job_Task__c  Jtask :listtasks){
                    if(Jtask.Schedule_Roles__c!=NULL && Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
                        Job_Task_Role__c J2 = new Job_Task_Role__c ();
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) { 
                            J2.Email__c =Jteam.Email__c; }
                        if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) { 
                            J2.User__c=Jteam.Staff__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                            J2.Name=Jteam.Role__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) { 
                            J2.Job_Task__c = NewTaskId;}
                        JobTaskRoleNew.add(J2);
                    }
                }
            }
            if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
                insert JobTaskRoleNew;
            }
            else{
                return 'Task role has insufficient access to create';
            }
            
        }
        return 'OK';
    }
    
    @AuraEnabled
    public static list<UserRole> getRoles(){
        
        list<UserRole> rolelist = new list<UserRole>(); //new list for holding all of the picklist options
        //options.add(new selectOption('', '---- None ----')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        rolelist=[SELECT Id,Name FROM UserRole  ORDER BY Name];//WITH SECURITY_ENFORCED
        return rolelist;  //return the picklist options
    } 
    
    
    @AuraEnabled
    Public static List<Object>  InsertBelowLoad(String jobid,Double days,String RolesList)
    {
        List<Object> belowdata=new  List<Object>();
        system.debug('Roles======' + RolesList);
        String  Roleslist1=RolesList.replaceAll(',',';');
        String  Roleslist2=RolesList1.replaceAll('\\[','');
        String  Roleslist3=RolesList2.replaceAll('\\]','');
        system.debug('Roleslist3======' + Roleslist3);
        Double task_order_no;
        Set<Date> holidays=new Set<Date>();
        // Add Holiday Dates to Ser, so that holidays will be skipped while calculating Schedule dates
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        
        List<Job_Task__c> lstJTNew=[Select id,Job__r.UpdateSchedDateFieldCheck__c from Job_task__c where Job__c=: jobid WITH SECURITY_ENFORCED];
        if(!lstJTNew.isEmpty())
        {
            Job_Task__c objjobTask1=[Select id,Name,Task_Order__c,Job__c,Job__r.Schedule_Calc__c,Email__c,Job__r.UpdateSchedDateFieldCheck__c from Job_Task__c where Job__c=:jobid WITH SECURITY_ENFORCED order by Task_Order__c DESC limit 1];
            task_order_no=objjobTask1.Task_Order__c;
            system.debug('last record objjobTask1 === '+objjobTask1+'\n');
        }
        else
        {
            task_order_no=0;
        } 
        
        //The below if conditions are added on 14 - 12 - 2022 by manindra otherwise only lstJobTask query will be there like below line which is commented and if and else is not there
        //Job_Task__c lstJobTask=[Select Id,name,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c from Job_Task__c where Job__c =: jobid WITH SECURITY_ENFORCED Order BY Revised_Due_Date__c DESC limit 1];
        Job_Task__c lstJobTask;
        if(lstJTNew[0].Job__r.UpdateSchedDateFieldCheck__c == true){
            lstJobTask=[Select Id,name,Start_Date__c,Due_Date__c,Task_Order__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c from Job_Task__c where Job__c =: jobid WITH SECURITY_ENFORCED Order BY Revised_Due_Date__c DESC limit 1];
            system.debug('if  record on load lstJobTask === '+lstJobTask+'\n');
        }
        else{
            lstJobTask=[Select Id,name,Start_Date__c,Due_Date__c,Task_Order__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c from Job_Task__c where Job__c =: jobid WITH SECURITY_ENFORCED Order BY Task_Order__c DESC limit 1];
            system.debug('else  record on load lstJobTask === '+lstJobTask+'\n');
        }
        
        /*******Check for the value for schedule calc *************/
        if(lstJobTask.Job__r.Schedule_Calc__c == 'Start Date' || lstJobTask.Job__r.Due_Date__c == null)
        {
            Date d1=Date.newInstance(lstJobTask.Revised_Due_Date__c.Year(),lstJobTask.Revised_Due_Date__c.Month(),lstJobTask.Revised_Due_Date__c.Day());
            System.debug('Due Date of Last Task : '+d1);
            Datetime dtStartDate=DateTime.newInstance(d1.Year(),d1.Month(),d1.Day());
            Integer jCount=0;
            // Calculate Due Date, Revised Due Date
            while(true)
            {
                Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                
                // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
                if((dtStartDate.format('E')!='Sat'&&dtStartDate.format('E')!='Sun') && ! (holidays.contains(d3)))
                {
                    jCount=jCount+1;
                    if(jCount>days)
                    {
                        break;
                    }
                    system.debug('jCount======' + jCount);
                    system.debug('==========' + dtStartDate);
                    system.debug('===========' + dtStartDate.format('E'));
                    dtStartDate=dtStartDate.addDays(1);
                    system.debug('After adding 1 day : ' +dtStartDate);
                }
                else
                {
                    system.debug('==========' + dtStartDate);
                    dtStartDate=dtStartDate.addDays(1);
                    continue;
                }
            }
            system.debug('Calculation============' +dtStartDate);
            
            Date d6 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
            system.debug('D1============' +dtStartDate);
            belowdata.add(task_order_no+1);
            belowdata.add(d1);
            belowdata.add(d6);
            belowdata.add(Roleslist3); 
            system.debug('if task_order_no+1 === '+task_order_no+1+'\n');
            system.debug('if d1 === '+d1+'\n');
            system.debug('if d6 === '+d6+'\n');
            system.debug('if Roleslist3 === '+Roleslist3+'\n');
        } 
        else
        {
            Date d1=Date.newInstance(lstJobTask.Job__r.Due_Date__c.Year(),lstJobTask.Job__r.Due_Date__c.Month(),lstJobTask.Job__r.Due_Date__c.Day());
            System.debug('Due Date of Last Task : '+d1);
            Datetime dtDueDate=DateTime.newInstance(d1.Year(),d1.Month(),d1.Day());
            Integer jCount=0;
            // Calculate Due Date, Revised Due Date
            while(true)
            {
                Date d3 = Date.newInstance(dtDueDate.Year(),dtDueDate.Month(),dtDueDate.Day());
                
                // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
                if((dtDueDate.format('E')!='Sat'&&dtDueDate.format('E')!='Sun') && ! (holidays.contains(d3)))
                {
                    jCount=jCount+1;
                    if(jCount>days)
                    {
                        break;
                    }
                    system.debug('jCount======' + jCount);
                    system.debug('==========' + dtDueDate);
                    
                    system.debug('===========' + dtDueDate.format('E'));
                    dtDueDate=dtDueDate.addDays(-1);
                    system.debug('After adding 1 day : ' +dtDueDate);
                    
                }
                else
                {
                    system.debug('==========' + dtDueDate);
                    //system.debug('===========' + dtStartDate.format('E'));
                    dtDueDate=dtDueDate.addDays(-1);
                    continue;
                }
            }
            system.debug('Calculation============' +dtDueDate);
            
            Date d6 = Date.newInstance(dtDueDate.Year(),dtDueDate.Month(),dtDueDate.Day());
            system.debug('D1============' +dtDueDate);
            belowdata.add(task_order_no+1);
            belowdata.add(d6);
            belowdata.add(d1);
            belowdata.add(Roleslist3); 
            system.debug('else task_order_no+1 === '+task_order_no+1+'\n');
            system.debug('else d1 === '+d6+'\n');
            system.debug('else d6 === '+d1+'\n');
            system.debug('else Roleslist3 === '+Roleslist3+'\n');
        }
        system.debug('belowdata === '+belowdata+'\n');
        return belowdata;
        
    }
    
    @AuraEnabled
    public static String InsertBlowSucess(string Taskid,String strid,Double task_order_no,Date d6){
        Boolean isFirst=true; 
        Set<Date> holidays=new Set<Date>();
        
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        Job_Task__c lstJobTask=[Select Id,name,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c,Task_Order__c from Job_Task__c where Job__c =: strid WITH SECURITY_ENFORCED  Order BY Revised_Due_Date__c DESC  limit 1];
        system.debug(' lstJobTask rcd === '+lstJobTask+'\n');
        
        //custom code below line for timing status and next task due added here 
        list<Job_Task__c> jtk = [Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c,Marked_Done__c from Job_Task__c where Job__c=:strid and Marked_Done__c = false  WITH SECURITY_ENFORCED ORDER BY Task_Order__c asc limit 1];
        // system.debug('jtk === '+jtk[0].name);
        Job__c jjrcd = [select id,name,Next_Tasks_Due__c,Job_Timing_Status__c,Due_Date__c,UpdateSchedDateFieldCheck__c from Job__c where id =: strid];
        if(jtk.size() < 0)
        {
            jjrcd.Next_Tasks_Due__c = lstJobTask.name ;
            if(lstJobTask.Revised_Due_Date__c >= system.today() &&  jjrcd.Due_Date__c >= system.today())
            {
                jjrcd.Job_Timing_Status__c =  'On Track' ;
            }
            if(lstJobTask.Revised_Due_Date__c < system.today() && jjrcd.Due_Date__c >= system.today()){
                jjrcd.Job_Timing_Status__c =  'At Risk' ;  
            }
            if(jjrcd.Due_Date__c <= system.today() ){
                jjrcd.Job_Timing_Status__c =  'Delayed' ;  
            }
            if(Schema.sObjectType.Job__c.isUpdateable()){ 
                update jjrcd;        //added this line on 9-12-2022 by manindra for recalculate schedule
                //  system.debug('job rcd is updated '+jjrcd);   
            }
        }
        else{
            jjrcd.Next_Tasks_Due__c = jtk[0].name ;
            if(jtk[0].Revised_Due_Date__c >= system.today() &&  jjrcd.Due_Date__c >= system.today())
            {
                jjrcd.Job_Timing_Status__c =  'On Track' ;
            }
            if(jtk[0].Revised_Due_Date__c < system.today() && jjrcd.Due_Date__c >= system.today()){
                jjrcd.Job_Timing_Status__c =  'At Risk' ;  
            }
            if(jjrcd.Due_Date__c <= system.today() ){
                jjrcd.Job_Timing_Status__c =  'Delayed' ;  
            }
            if(Schema.sObjectType.Job__c.isUpdateable()){ 
                update jjrcd;//added this line on 9-12-2022 by manindra for recalculate schedule
                // system.debug('else job rcd is updated '+jjrcd);   
            }
        }
        //ends here
        
        if(lstJobTask.Job__r.Schedule_Calc__c != 'Start Date' && lstJobTask.Job__r.Due_Date__c != null){
            try{
                List<Job_Task__c> lst1=new List<Job_Task__c>();
                
                lst1=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c,Marked_Done__c from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no AND Id !=: Taskid WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC];
                System.debug('Size of lst '+lst1.size()+'lst1 === '+lst1[0].name);
                
                List<Job_Task__c> lstJobTask1=new List<Job_Task__c>();
                Date NTSD1;
                
                Double a=task_order_no-1;
                //New recalculate schedule added by manindra on 9 - 12 - 2022 this if executes only when schedule calc is due date
                if(jjrcd.UpdateSchedDateFieldCheck__c == false){
                    for(Job_Task__c jt1:lst1)
                    {
                        System.debug('first task  === '+jt1+'\n');
                        if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) { 
                            jt1.Task_Order__c = a;
                        }
                        a--; 
                        lstJobTask1.add(jt1);
                    }
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                        update lstJobTask1;
                        system.debug('lstJobTask1 === '+lstJobTask1+'\n');
                    }
                    else{
                        return 'Task has insufficient access to update';
                    }    
                }//ends here
                else{
                    for(Job_Task__c jt1:lst1)
                    {
                        System.debug('first task  === '+jt1+'\n');
                        if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()) { 
                            jt1.Task_Order__c = a;}
                        a--;
                        
                        if(isFirst)
                        {
                            System.debug('This is First');
                            if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) { 
                                jt1.Revised_Due_Date__c=Date.newInstance(d6.Year(),d6.Month(),d6.Day());}
                            isFirst=false;
                        }
                        else
                        {
                            if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                                jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
                        }
                        System.debug('task Name'+jt1.Name);
                        System.debug('ST Date'+jt1.Revised_due_Date__c);
                        
                        Datetime dtDueDate1=Datetime.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
                        System.debug('Revised Due Date is :'+dtDueDate1);
                        Integer jCount1=0;
                        System.debug('jCount value'+jCount1);
                        while(true)
                        {
                            Date d4=Date.newInstance(dtDueDate1.Year(),dtDueDate1.Month(),dtDueDate1.Day());
                            
                            if((dtDueDate1.format('E')!='Sat' && dtDueDate1.format('E')!='Sun')&&(!holidays.contains(d4)))
                            {
                                jCount1=jCount1 +1;
                                if(jCount1>jt1.Days__c)
                                {
                                    break;
                                }
                                system.debug('jCount======' + jCount1);
                                system.debug('==========' + dtDueDate1);
                                system.debug('===========' + dtDueDate1.format('E'));
                                dtDueDate1=dtDueDate1.addDays(-1);
                                system.debug('after adding 1 day==========' + dtDueDate1);
                            }
                            else
                            {
                                system.debug('==========' + dtDueDate1);
                                //system.debug('===========' + dtStartDate.format('E'));
                                dtDueDate1=dtDueDate1.addDays(-1);
                                continue;
                            }
                        }   
                        Date  d5 = Date.newInstance(dtDueDate1.Year(),dtDueDate1.Month(),dtDueDate1.Day());
                        System.debug('D5 is as follows : '+d5);
                        if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                            jt1.Start_Date__c=d5;}
                        NTSD1=d5;
                        system.debug('NTSD '+NTSD1);
                        lstJobTask1.add(jt1);
                        // update jt1;
                    }
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                        update lstJobTask1;
                    }
                    else{
                        return 'Task has insufficient access to update';
                    }
                }
            }     
            catch(DMLException e)
            {
                return e.getMessage();
            } 
        }  
        
        //insert below logic adds on 13 - 12 - 2022 by manindra
        /*   if(lstJobTask.Job__r.Schedule_Calc__c == 'Start Date'){
if(jjrcd.UpdateSchedDateFieldCheck__c == false){
list<Job_Task__c>updateetask = new list<Job_Task__c>();
list<Job_Task__c> lstJobTaskAboveRcd = [Select Id,name,Start_Date__c,Due_Date__c,Task_Order__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c from Job_Task__c where Job__c =: strid  WITH SECURITY_ENFORCED  Order BY Task_Order__c DESC  limit 2];
if(lstJobTaskAboveRcd.size() > 0){
// System.debug(' task  === '+lstJobTaskAboveRcd+'\n');
for(integer i = 0 ; i < lstJobTaskAboveRcd.size();i++){
system.debug('lstJobTaskAboveRcd === '+lstJobTaskAboveRcd[i]+'\n');
if(i==0){
if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()) {
//lstJobTaskAboveRcd[i].Start_Date__c =   lstJobTaskAboveRcd[i+1].Revised_Due_Date__c;
}
updateetask.add(lstJobTaskAboveRcd[i]);
system.debug('updateetask === '+updateetask+'\n');
}
}
if(updateetask.size() > 0 ){
if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
update updateetask;
system.debug('updateetask === '+updateetask+'\n');
}
}
else{
return 'Task has insufficient access to update';
}
}
}
}*/
        
        
        List<Job_Team__c> listjobteam=new  List<Job_Team__c>();
        listjobteam=[select id,name, Role__c,staff__c,Email__c from Job_Team__c  where job__c =:strid WITH SECURITY_ENFORCED];
        
        List<Job_Task__c > listtasks=[select id,name,Schedule_Roles__c,Email__c from Job_Task__c  where id=:Taskid WITH SECURITY_ENFORCED];
        System.debug('===listtasks====='+listtasks);
        System.debug('===List of Task Roles====='+listtasks[0].Schedule_Roles__c);
        
        List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
        
        for(Job_Team__c Jteam :listjobteam ){
            for(Job_Task__c  Jtask :listtasks){
                if(Jtask.Schedule_Roles__c!=NULL){
                    if(Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
                        Job_Task_Role__c J2 = new Job_Task_Role__c ();
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) { 
                            J2.Email__c =Jteam.Email__c; }
                        if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) {  J2.User__c=Jteam.Staff__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) {   J2.Name=Jteam.Role__c;}
                        if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) {  J2.Job_Task__c = Taskid;}
                        JobTaskRoleNew.add(J2);
                    }
                }
            }
        }
        if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
            insert JobTaskRoleNew;}
        else{
            return 'Task role has insufficient access to create';
        }
        
        return 'OK';
    }
    
    @AuraEnabled
    public Static boolean orgdetails(){
        boolean istestorg = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
        return istestorg;
    }
    
    //The below getCustomFieldData() completely related to asana api due to test classes coverage we placed here currently
    @AuraEnabled
    public Static String getCustomFieldData(){
        try{
            Asana_Creds__c ac = Asana_Creds__c.getInstance('Assana Account');
            if(ac!=null){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://app.asana.com/api/1.0/projects/1201746669791009/custom_field_settings');
                req.setMethod('GET');
                req.setHeader('Authorization','Bearer '+ac.Access_Token__c);
                HttpResponse res = h.send(req);
                Respdata respdataWrap =(Respdata)JSON.deserialize(res.getBody(), Respdata.class);
                List<CustomField> liscust = new List<CustomField>();
                for(DataWrapper r : respdataWrap.data){
                    liscust.add(r.custom_field);
                }
                return JSON.serialize(liscust);
            }
            return 'Error';
        }
        Catch(Exception ex){
            return ex.getMessage();
        }
        
    } 
    
    public class RespData{
        public List<DataWrapper> data;
    }
    
    public class DataWrapper{
        public String gid;
        public CustomField custom_field;
        public Boolean is_important;
    }
    
    public class CustomField{
        public String gid;
        public String name;
        public String resource_subtype;
        public String type;
        public List<LookUp>  multi_enum_values;
        public List<LookUp> enum_options;
    }
    
    public class LookUp{
        public String gid;
        public String name;
    }
}