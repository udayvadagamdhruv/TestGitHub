public class ApprovalJobTaskExt {
    
    @AuraEnabled
    public static list<UserRole> getRolesAppro(){
        
        list<UserRole> rolelist = new list<UserRole>(); //new list for holding all of the picklist options
        //options.add(new selectOption('', '---- None ----')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        rolelist=[SELECT Id,Name FROM UserRole  ORDER BY Name];//WITH SECURITY_ENFORCED
        return rolelist;  //return the picklist options
    } 
    
   /* @AuraEnabled
    public static List<Tool_Tip__c> getHelpTextrecordsAppro() {
        List <Tool_Tip__c> lsthelptxt = [Select Id, Approval_Tasks__c from Tool_Tip__c WITH SECURITY_ENFORCED];
        return lsthelptxt;
    }*/
    
    
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
        isAccessList.add(Schema.sObjectType.Approval_Job_Task__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Approval_Job_Task__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Approval_Job_Task__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Approval_Job_Task_Roles__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Approval_Job_Task_Roles__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Approval_Job_Task_Roles__c.isUpdateable());

        return isAccessList;
    }
    
    
    
  /*  
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
    }*/
    
    @AuraEnabled
    public static Date todaySystemDate(){  
        return System.today();
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

    /******************************* Get the job Approval Files ********************************************/
    @AuraEnabled
    public static  Map < Id, String > getApprovalFiles(String recordId){
        try {
            Map < Id, String > cvMap = new Map < Id, String > ();
            cvMap.put(null, '--None--');
            for(Approval_Job_Task__c appJobTask:[SELECT id, name, File_ID__c, Job__c, File_Name__c FROM Approval_Job_Task__c WHERE Job__c = :recordId ])
            {
                cvMap.put(appJobTask.File_ID__c, appJobTask.File_Name__c);
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
    
    
    /******************************* Get the Job Approval Task (Lightning data table) ********************************************/
    @AuraEnabled
    public static List <Approval_Job_Task__c> getListofAprJobTasks1(Id jobId) {
        List <Approval_Job_Task__c> lstJT =new  List <Approval_Job_Task__c>();
        lstJT=[Select Id,(Select Id,User__c,Email__c From Approval_Job_Task_Roles__r),Name,Status__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.Status__c,Task_Order__c,Assigned_Users__c,Revised_Due_Date__c,Number_of_Submissions__c from Approval_Job_Task__c where Job__c =: jobId WITH SECURITY_ENFORCED Order By Task_Order__c];
        return  lstJT;
        
    }
    
    /****************************************** This Method is used for Group by the tasks by it's File name **************************************/
    @AuraEnabled
    public static map < string, list<Approval_Job_Task__c>> getListofAprJobTasks(Id jobId) {
        
        system.debug(jobId);
        List < Approval_Job_Task__c > lstJT = [Select Id,File_ID__c,(Select Id,User__c,Email__c From Approval_Job_Task_Roles__r),Name,Status__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.Status__c,Task_Order__c,Assigned_Users__c,Revised_Due_Date__c,File_Name__c,Number_of_Submissions__c,Approver_By__c,Approved_Date__c from Approval_Job_Task__c where Job__c =: jobId WITH SECURITY_ENFORCED Order By Task_Order__c];
        system.debug(lstJT);
        
        map < string, list < Approval_Job_Task__c >> MapApprovalTask = new map < string, list < Approval_Job_Task__c >> ();
        //File_Name__c
        for (Approval_Job_Task__c JS: lstJT) {
            if (MapApprovalTask.containsKey(js.File_Name__c)) {
                
                List < Approval_Job_Task__c > ApproveTasklist = MapApprovalTask.get(js.File_Name__c);
                ApproveTasklist.add(js);
                MapApprovalTask.put(js.File_Name__c, ApproveTasklist);
                
            } else {
                MapApprovalTask.put(js.File_Name__c, new List <Approval_Job_Task__c> {js});
            }
            
        }
        system.debug('=====get record===' + MapApprovalTask);


        /*Set<string> keySet = MapApprovalTask.keySet();
        List<string> keyList = new List<string>();
        keyList.addAll(keySet);
        system.debug('=====keyList===' + keyList);
        keyList.sort();
        system.debug('=====keyList Sort===' + keyList);
        for (Integer i = 0; i < keyList.size(); i++){
            MapApprovalTask.put(keyList[i], MapApprovalTask.get(keyList[i]));
        }
        system.debug('=====get record List===' + MapApprovalTask);*/
		
        return MapApprovalTask;
        
    }


    /******************************* Get the job Files Id for the Approval Process Groupby ********************************************/
    @AuraEnabled
    public static List<String> getJobFileIds(String recordId){
        try {
            List<String> jobFileIds = new List<String> ();
            List<Id> ContentDocIds = new List<Id> ();
            List<Id> ContentVerDocIds = new List<Id> ();
            for(ContentDocumentLink cdl:[select id,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId])
            {
                ContentDocIds.add(cdl.ContentDocumentId);
            }

            for(ContentVersion cdl:[SELECT Id, ContentDocumentId, VersionNumber, Title, FileExtension, FileType FROM ContentVersion where ContentDocumentId IN : ContentDocIds])
            {
                if(ContentVerDocIds.contains(cdl.ContentDocumentId)){

                }
                else{
                    ContentVerDocIds.add(cdl.ContentDocumentId);
                    jobFileIds.add(cdl.Title+'.'+cdl.FileExtension);
                   //jobFileIds.add(cdl.ContentDocumentId);
                }
                
            }


            return jobFileIds;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /****************************************** This Method is used for Delete All Approval Process based on the file selection **************************************/
   
    @AuraEnabled
    public static string DeleteFileApprovalTask(String jobId,String TaskFileId)
    {
        List<Approval_Job_Task__c> lstJT=new List<Approval_Job_Task__c>();
        List<Approval_Job_Task__c> lstJTStatus=new List<Approval_Job_Task__c>();
        lstJT=[Select Id,Status__c from Approval_Job_Task__c where Job__c =: jobId and File_ID__c=:TaskFileId  WITH SECURITY_ENFORCED];
        List<ContentDocument> contentDoc=[select id FROM ContentDocument where id=:TaskFileId limit 1];

        system.debug('>>>>>>>>>>>>Delete contentDoc>>>>>>>>>>>>'+contentDoc);
        try{
            if(lstJT.size()>0)
            {
                if(contentDoc.size()==0){
                    if(Schema.sObjectType.Approval_Job_Task__c.isDeletable()){ 
                        delete lstJT;   
                        return 'OK';
                    }else{
                        return 'Error, Approval Taks have insufficient access to Delete';
                    }
                }
                else{
          
                    for(Approval_Job_Task__c Ajtsk:lstJT){
                        if(Ajtsk.Status__c!='Pending')
                        {
                            lstJTStatus.add(Ajtsk);
                        }
                    }

                    if(lstJTStatus.size()==0)
                    {
                        if(Schema.sObjectType.Approval_Job_Task__c.isDeletable()){ 
                            delete lstJT;   
                            return 'OK';
                        }else{
                            return 'Error, Approval Taks have insufficient access to Delete';
                        }
                    }
                    else{
                        return 'Task Status pending';
                    }
                }
            }
            else{
                return 'No Records';
            }
        }  
        catch(Exception e){
            return e.getMessage();
        }
        
    }
    
    /******************************* To create Approval Job Task ********************************************/
    @AuraEnabled
    public static string createApprovalTask(String jobId, String TaskFileId, String AppSchedTemp)
    {
        Set<Id> stAprScheduleTaskId = new Set<Id>(); 
        List<Approval_Job_Task__c> lstJT=new List<Approval_Job_Task__c>();
        Map<String,Id> mp1 = new Map<String,Id>();
        Map<Id,Id> mp2 = new Map<Id,Id>();
        lstJT=[Select Id from Approval_Job_Task__c where Job__c =: jobId and File_ID__c=:TaskFileId  WITH SECURITY_ENFORCED];
        
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
        Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__c, Schedule_Calc__c from Job__c where Id=:jobId WITH SECURITY_ENFORCED];
        
        List<Approval_Schedule_Task__c> lstAprScheduleTask=new List<Approval_Schedule_Task__c>();          
        List<Approval_Job_Task__c> lstAprJobTask=new List<Approval_Job_Task__c>();
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
                return 'You have already created an approval process for this File.';
            }
            Boolean blnFroward = true;
            if(objJob.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }
            
            Date std;
            
            if(blnFroward)
            {
                std=Date.newInstance(objJob.Start_Date__c.Year(),objJob.Start_Date__c.month(),objJob.Start_Date__c.Day());
                lstAprScheduleTask=[Select Name,Days__c,Task_Order__c,Roles__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c =: AppSchedTemp WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
            }
            else
            {
                std=Date.newInstance(objJob.Due_Date__c.Year(),objJob.Due_Date__c.month(),objJob.Due_Date__c.Day());
                lstAprScheduleTask=[Select Name,Days__c,Task_Order__c,Roles__c,(select id, name from Approval_Schedule_Task_Role__r) from Approval_Schedule_Task__c where Approval_Schedule_Template__c =: AppSchedTemp WITH SECURITY_ENFORCED ORDER BY Task_Order__c desc];
            }
            System.debug('==========std is==========:'+std);
            
            
            if(lstAprScheduleTask.size()==0){
                return 'There is no tasks for Approval Schedule Template';
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
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Job__c.isCreateable()) {
                        jt.Job__c=jobId;
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
                    return 'Error, Approval Taks have insufficient access to insert';
                }
                
                for(Approval_Job_Task__c jt:lstAprJobTask)
                {
                    mp2.put(mp1.get(jt.Name),jt.Id);
                }        
                
                List<Approval_Schedule_Task_Role__c> lstAprScheduleTaskRole=new List<Approval_Schedule_Task_Role__c>();
                
                lstAprScheduleTaskRole=[Select Id,Name,Approval_Schedule_Task__c,Approval_Schedule_Task__r.Approval_Schedule_Template__c,Approval_Schedule_Task__r.Name from Approval_Schedule_Task_Role__c where Approval_Schedule_Task__c IN : stAprScheduleTaskId WITH SECURITY_ENFORCED];
                
                List<Approval_Job_Task_Roles__c> lstAprJobTaskRole=new List<Approval_Job_Task_Roles__c>();
                
                Job_Team__c[] objJobTeam=[Select Staff__c,Email__c,Role__c from Job_Team__c where Job__c=:jobId WITH SECURITY_ENFORCED];
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
                        return 'Error, Approval Taks Roles have insufficient access to insert';
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
    
    /******************************* Edit Approval Job Task ********************************************/
    
    @AuraEnabled
    public static String ApprTaskEditSuccess(String TaskId,Boolean UpdateRestDays, Boolean UpdateRestDates){
        try
        {   
            //Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c
            Approval_Job_Task__c objJobTask = [select Id,Name,Days__c,File_ID__c,File_Name__c,Start_Date__c,Due_Date__c,Revised_Due_Date__c,Job__r.Schedule_Calc__c,Job__r.id,Job__r.Name, Task_Order__c from Approval_Job_Task__c where  id =: TaskId  WITH SECURITY_ENFORCED limit 1];
            system.debug('Old value' + objJobTask );
            
            
            Set<Date> holidaysNew=new Set<Date>();
            
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
            {
                holidaysNew.add(hc.Date__c);
            }


           /* if(!UpdateRestDays && !UpdateRestDates)
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
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                        objJobTask.Revised_Due_Date__c = afterDaysUpdate;  
                    }
                    
                }
                else
                {
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                        objJobTask.Start_Date__c = afterDaysUpdate; 
                    }
                }
                if(Approval_Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                    update objJobTask; 
                }
                else{
                    return 'Error, Approval Task has Insufficient access to update';
                }

            }*/

            
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
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                        objJobTask.Revised_Due_Date__c = afterDaysUpdate;  
                    }
                    
                }
                else
                {
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                        objJobTask.Start_Date__c = afterDaysUpdate; 
                    }
                }
                if(Approval_Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                    update objJobTask; 
                }
                else{
                    return 'Error, Approval Task has Insufficient access to update';
                }
                
                
                //code for the update of the below and above task respectively  
                List<Approval_Job_Task__c> lstTaskBelow ;
                
                if(blnFroward)
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Task_Order__c from Approval_Job_Task__c where Job__c = :objJobTask.Job__r.Id and Id !=: objJobTask.Id and File_Name__c=:objJobTask.File_Name__c and Task_Order__c >=: objJobTask.Task_Order__c WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];   
                }
                else
                {
                    lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Task_Order__c from Approval_Job_Task__c where Job__c = :objJobTask.Job__r.Id and Id !=: objJobTask.Id and File_Name__c=:objJobTask.File_Name__c and Task_Order__c <=: objJobTask.Task_Order__c WITH SECURITY_ENFORCED Order BY Task_Order__c DESC]; 
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
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                            }
                        }
                        else
                        {
                            //dtStartDate3= startDateForNextTask;
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
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
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = d4; 
                            }
                        }
                        else
                        {
                            //dtStartDate3=d4;
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
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
                    
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Days__c.isUpdateable()){
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
                        if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstTaskBelow[i].Revised_Due_Date__c=d1;
                        }
                    }
                    else
                    {
                        if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
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
                if(Approval_Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                    update objJobTask;    
                }
                else{
                    return 'Error, Insufficient access to update this record Job Approval Task';
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
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                        objJobTask.Start_Date__c = afterDaysUpdate;
                    }
                    System.debug('afterDaysUpdate value '+afterDaysUpdate);
                    if(Approval_Job_Task__c.sObjectType.getDescribe().isUpdateable()){
                        update objJobTask;
                    } else{
                        return 'Error, Approval Task has Insufficient access to update ';
                    }  
                    
                }
                
                System.debug('Update current Job Approval Task : '+objJobTask);
                
                
                Date startDateForNextTask ;
                //Id idTask = 
                Approval_Job_Task__c objJobTaskNew = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c ,Job__r.id from Approval_Job_Task__c where id =: objJobTask.id WITH SECURITY_ENFORCED limit 1];
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objJobTaskNew.Revised_Due_Date__c.Year(),objJobTaskNew.Revised_Due_Date__c.month(),objJobTaskNew.Revised_Due_Date__c.Day());
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objJobTaskNew.Start_Date__c.Year(),objJobTaskNew.Start_Date__c.month(),objJobTaskNew.Start_Date__c.Day());
                }
                
                List<Approval_Job_Task__c> lstJobTasks ;//= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                
                if(blnFroward)
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Approval_Job_Task__c where Task_Order__c >=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and File_Name__c=:objJobTask.File_Name__c WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
                }
                else
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Approval_Job_Task__c where Task_Order__c <=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and File_Name__c=:objJobTask.File_Name__c WITH SECURITY_ENFORCED Order BY Task_Order__c DESC];
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
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                        }
                        else
                        {
                            //dtStartDate3= startDateForNextTask;
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            //dtStartDate3 = d4;
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = d4; 
                            }
                        }
                        else
                        {
                            //dtStartDate3 =d4;
                            if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = d4; 
                            }
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
                    if(Schema.sObjectType.Approval_Job_Task__c.fields.Days__c.isUpdateable()){
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
                        if(Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstJobTasks[i].Revised_Due_Date__c=d1;}
                    }
                    else
                    {
                        if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c=d1;}
                    }    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Schema.sObjectType.Approval_Job_Task__c.isUpdateable()){ 
                    update lstJobTasks;
                }
                else{
                    return 'Approval Task has insufficient access to update';
                }
                System.debug('Updated List : '+lstJobTasks);
                
            }
        }
        catch(System.DMLException e)
        {
            return e.getMessage();
        }      
        
        return 'OK';
        
    }
    
    /*************************************** Insert Above Approval Task ******************************************************/
    @AuraEnabled
    public static  List<Object> ApproveInsertAboveLoad(String taskid, Double days, String RolesList){
        List<Object> datalist=new List<Object>();
        
        Double task_order_no; 
        string FileName,FileID;
        Approval_Job_Task__c  objJobTask1=[Select Job__c,Task_Order__c,Days__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c,File_ID__c,File_Name__c from Approval_Job_Task__c where Id=: taskid WITH SECURITY_ENFORCED]; 
        task_order_no=objJobTask1.Task_Order__c;
        FileName=objJobTask1.File_Name__c;
        FileID=objJobTask1.File_ID__c;
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
            datalist.add(FileName);
            datalist.add(FileID);
        }
        else
        {
            //objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no,Due_Date__c=d,Revised_Due_date__c=d,GL_Code__c=strGLCode,Schedule_Roles__c=Roleslist3);
            datalist.add(task_order_no);
            datalist.add(d1);
            datalist.add(d);
            datalist.add(Roleslist3);
            datalist.add(FileName);
            datalist.add(FileID);
        }
        
        
        return datalist;          
    }  
    
    @AuraEnabled
    public static String ApproveInsertAboveSucess(String Oldtaskid,String NewTaskId,String strid){
        
        Approval_Job_Task__c  AppJobTsk=[Select Job__c,Task_Order__c,File_Name__c,File_ID__c  from Approval_Job_Task__c where Id=: Oldtaskid WITH SECURITY_ENFORCED]; 
        string FileID=AppJobTsk.File_ID__c;
        Double task_order_no; 
        Boolean isFirst=true;
        Approval_Job_Task__c  objJobTask1=[Select Job__c,Task_Order__c,Days__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c  from Approval_Job_Task__c where Id=: Oldtaskid and File_ID__c=:FileID WITH SECURITY_ENFORCED]; 
        task_order_no=objJobTask1.Task_Order__c;
        
        Approval_Job_Task__c  objJobTask=[Select Job__c,Task_Order__c,Days__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c,Email__c  from Approval_Job_Task__c where Id=: NewTaskId and File_ID__c=:FileID WITH SECURITY_ENFORCED]; 
        
        Double days=objJobTask.Days__c;
        List<Approval_Job_Task__c> lst=new List<Approval_Job_Task__c>();
        
        Set<Date> holidays=new Set<Date>();
        list<Job_Team__c> listjobteam=new  list<Job_Team__c>();
        listjobteam =[select id,name, Role__c,staff__c,Email__c from Job_Team__c where job__c =:strid WITH SECURITY_ENFORCED];
        
        // Add Holiday Dates to Set, so that holidays will be skipped while calculating Schedule dates
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        
        Boolean blnFroward = true;
        if(objJobTask1.Job__r.Schedule_Calc__c == 'End Date')
        {
            blnFroward = false;
        }
        
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
            lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c from Approval_Job_Task__c where Job__c=:strid and File_ID__c=:FileID and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
        }
        else
        {
            lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c from Approval_Job_Task__c where Job__c=:strid and File_ID__c=:FileID and Task_Order__c <=: task_order_no-1 AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC ];
        }
        
        System.debug('Size of lst '+lst.size());
        
        List<Approval_Job_Task__c> lstJobTask=new List<Approval_Job_Task__c>();
        Date NTSD1;
        
        Double a=task_order_no+1;
        
        for(Approval_Job_Task__c jt1:lst)
        {
            //if() start date 
            if(blnFroward)
            {
                if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) { 
                    jt1.Task_Order__c=a;
                }
                a++;
            }
            
            if(isFirst)
            {
                System.debug('This is First');
                
                
                if(blnFroward)
                {
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()) { 
                        jt1.Start_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
                }
                else
                {
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) { 
                        jt1.Revised_Due_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
                }
                isFirst=false;
            }
            else
            {
                
                if(blnFroward)
                {
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()) { 
                        jt1.Start_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
                }
                else
                {
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                        jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
                }
            }
            
            System.debug('task Name'+jt1.Name);
            System.debug('ST Date'+jt1.Start_Date__c);
            Datetime dtStartDate1;
            if(blnFroward)
            {
                dtStartDate1 =Datetime.newInstance(jt1.Start_Date__c.Year(),jt1.Start_Date__c.Month(),jt1.Start_Date__c.Day());
            }
            else
            {
                
                dtStartDate1=Datetime.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
            }
            System.debug('Start Date is :'+dtStartDate1);
            Integer jCount1=0;
            System.debug('jCount value'+jCount1);
            
            while(true)
            {
                Date d4=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                
                if((dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!='Sun')&&(!holidays.contains(d4)))
                {
                    jCount1=jCount1 +1;
                    if(jCount1>jt1.Days__c)
                    {
                        break;
                    }
                    system.debug('jCount======' + jCount1);
                    system.debug('==========' + dtStartDate1);
                    
                    system.debug('===========' + dtStartDate1.format('E'));
                    if(blnFroward)
                    {
                        dtStartDate1=dtStartDate1.addDays(1);
                    }
                    else
                    {
                        dtStartDate1=dtStartDate1.addDays(-1);
                    }
                    system.debug('after adding 1 day==========' + dtStartDate1);
                    
                }
                else
                {
                    system.debug('==========' + dtStartDate1);
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
            System.debug('D5 is as follows : '+d5);
            if(blnFroward)
            {
                if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) { 
                    jt1.Revised_Due_Date__c=d5;}
            }
            else
            {
                if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                    jt1.Start_Date__c=d5;}
            }
            NTSD1=d5;
            system.debug('NTSD '+NTSD1);
            lstJobTask.add(jt1);
            // update jt1;
        }
        
        try{
            if(Schema.sObjectType.Approval_Job_Task__c.isUpdateable()){ 
                update lstJobTask;
            }
            else{
                return 'Approval Task has insufficient access to update';
            }
            //update the task order of the below tasks
            List<Approval_Job_Task__c> lstbelow =new List<Approval_Job_Task__c>();
            //if(end date do desc)
            lstbelow=[Select Id,Name,Task_Order__c,Email__c from Approval_Job_Task__c where Job__c=:strid and File_ID__c=:FileID and Task_Order__c >=: task_order_no AND Id !=: NewTaskId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
            //if(!blnFroward)
            // {
            for(Approval_Job_Task__c jt1:lstbelow)
            {
                //if() start date 
                if(!blnFroward)
                {
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                        jt1.Task_Order__c=a;
                    }
                    a++;
                }
                
                // jt1.Task_Order__c=a;
                //  a++;
            }
            if(Schema.sObjectType.Approval_Job_Task__c.isUpdateable()){ 
                update lstbelow;
            }
            else{
                return 'Approval Task has insufficient access to update';
            }
            
        }
        catch(DMLException e)
        {
            //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
            return e.getMessage();
        } 
        
        
        List<Approval_Job_Task__c> listtasks=[select id,name,Schedule_Roles__c,Email__c from Approval_Job_Task__c where id=:NewTaskId WITH SECURITY_ENFORCED];
        List<Approval_Job_Task_Roles__c> JobTaskRoleNew  = new List<Approval_Job_Task_Roles__c>();
        
        for(Job_Team__c Jteam :listjobteam ){
            
            for(Approval_Job_Task__c Jtask :listtasks){
                
                if(Jtask.Schedule_Roles__c!=NULL && Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
                    
                    Approval_Job_Task_Roles__c J2 = new Approval_Job_Task_Roles__c();
                    if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Email__c.isCreateable()) { 
                        J2.Email__c =Jteam.Email__c; 
                    }
                    if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.User__c.isCreateable()) { 
                        J2.User__c=Jteam.Staff__c;
                    }
                    if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Name.isCreateable()) { 
                        J2.Name=Jteam.Role__c;
                    }
                    if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Approval_Job_Task__c.isCreateable()) { 
                        J2.Approval_Job_Task__c = NewTaskId;
                    }
                    JobTaskRoleNew.add(J2);
                    
                }
                
                
            }
        }
        if(Schema.sObjectType.Approval_Job_Task_Roles__c.isCreateable()){ 
            insert JobTaskRoleNew;
        }
        else{
            return 'Approval Task role has insufficient access to create';
        }
        return 'OK';
        
    }
    
    /******************************* Insert Below Approval Job Task ********************************************/
    
    /*`@AuraEnabled
Public static string FileOnChangeTskBelowMethod(String TskFileId)
{

system.debug('>>FileID>>>'+TskFileId);
ContentVersion cv=[SELECT Id, Title,FileExtension, VersionData FROM ContentVersion WHERE Id=:TskFileId];
system.debug('>>CV>>>'+cv.Id);
string TskFileIdN=cv.Title+'.'+cv.FileExtension;
return TskFileIdN;
}*/
    
    @AuraEnabled
    Public static List<Object>  ApproveInsertBelowLoad(String jobid,Double days,String RolesList, String FileId)
    {
        ContentVersion cv=[SELECT Id, Title,FileExtension, VersionData,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId=:FileId /*AND IsLatest = true*/ Order by CreatedDate ASC Limit 1];
        string FileName=cv.Title+'.'+cv.FileExtension;
        
        List<Object> belowdata=new  List<Object>();
        
        system.debug('Roles======' + RolesList);
        String  Roleslist1=RolesList.replaceAll(',',';');
        String  Roleslist2=RolesList1.replaceAll('\\[','');
        String  Roleslist3=RolesList2.replaceAll('\\]','');
        
        system.debug('Roleslist3======' + Roleslist3);
        Double task_order_no;
        string tskStatus,submitterName,submitterEmail;
        Date submittedDate;
        integer NumberofSubmissions;
        boolean undo;
        Set<Date> holidays=new Set<Date>();
        
        // Add Holiday Dates to Ser, so that holidays will be skipped while calculating Schedule dates
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        
        
        List<Approval_Job_Task__c> lstJTNew=[Select id,File_ID__c,File_Name__c from Approval_Job_Task__c where Job__c=: jobid and File_ID__c=:FileId  WITH SECURITY_ENFORCED];
        
        if(!lstJTNew.isEmpty())
        {
            Approval_Job_Task__c objjobTask1=[Select id,File_ID__c,Status__c,File_Name__c,Name,Task_Order__c,Job__c,Job__r.Schedule_Calc__c,Email__c from Approval_Job_Task__c where Job__c=:jobid and File_Name__c=:FileName and File_ID__c=:FileId WITH SECURITY_ENFORCED order by Task_Order__c DESC limit 1];
            task_order_no=objjobTask1.Task_Order__c;
            if(objjobTask1.Status__c=='Approved'){
                tskStatus = 'In Progress';	
                submitterEmail = UserInfo.getUserEmail();
                submitterName = UserInfo.getName();
                submittedDate = system.today();
                NumberofSubmissions=1;
                undo=false;
            }
            else{
                tskStatus = 'Pending';
            }
        }
        else
        {
            task_order_no=0;
        }    
        
        
        List<Approval_Job_Task__c> lstJobTask=[Select Id,File_ID__c,File_Name__c,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c from Approval_Job_Task__c where Job__c =: jobid and File_Name__c=:FileName and File_ID__c=:FileId WITH SECURITY_ENFORCED Order BY Revised_Due_Date__c DESC limit 1];
        
        if(lstJobTask.size()>0){
            /*******Check for the value for schedule calc *************/
            if(lstJobTask[0].Job__r.Schedule_Calc__c == 'Start Date' || lstJobTask[0].Job__r.Due_Date__c == null)
            {
                Date d1=Date.newInstance(lstJobTask[0].Revised_Due_Date__c.Year(),lstJobTask[0].Revised_Due_Date__c.Month(),lstJobTask[0].Revised_Due_Date__c.Day());
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
                belowdata.add(FileName);
                belowdata.add(tskStatus);
                belowdata.add(submitterName);
                belowdata.add(submitterEmail);
                belowdata.add(submittedDate);
                belowdata.add(NumberofSubmissions);
                belowdata.add(undo);
            } 
            else
            {
                Date d1=Date.newInstance(lstJobTask[0].Job__r.Due_Date__c.Year(),lstJobTask[0].Job__r.Due_Date__c.Month(),lstJobTask[0].Job__r.Due_Date__c.Day());
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
                system.debug('Start Date============' +d6);
                system.debug('End Date============' +d1);
                
                belowdata.add(task_order_no+1);
                belowdata.add(d6);
                belowdata.add(d1);
                belowdata.add(Roleslist3);
                belowdata.add(FileName);
                belowdata.add(tskStatus);
                belowdata.add(submitterName);
                belowdata.add(submitterEmail);
                belowdata.add(submittedDate);
                belowdata.add(NumberofSubmissions);
                belowdata.add(undo);
            }
            
            return belowdata;
        }
        else{
            belowdata.add('No Records');
            return belowdata;
        }
    }
    
    
    @AuraEnabled
    public static String ApproveInsertBlowSucess(string Taskid,String strid,Double task_order_no,Date d6, String FileName, String FileId, String tskSts){
        Boolean isFirst=true; 
        Set<Date> holidays=new Set<Date>();
        for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
        {
            holidays.add(hc.Date__c );
        }
        
        Approval_Job_Task__c lstJobTask=[Select Id,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Email__c,File_ID__c,File_Name__c from Approval_Job_Task__c where Job__c =: strid WITH SECURITY_ENFORCED  Order BY Revised_Due_Date__c DESC  limit 1];
        
        if(lstJobTask.Job__r.Schedule_Calc__c != 'Start Date' && lstJobTask.Job__r.Due_Date__c != null){
            
            try{
                List<Approval_Job_Task__c> lst1=new List<Approval_Job_Task__c>();
                
                lst1=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c,Email__c from Approval_Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no AND Id !=: Taskid and File_Name__c=:FileName and File_ID__c=:Fileid WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC];
                
                System.debug('Size of lst '+lst1.size());
                
                List<Approval_Job_Task__c> lstJobTask1=new List<Approval_Job_Task__c>();
                Date NTSD1;
                
                Double a=task_order_no-1;
                
                for(Approval_Job_Task__c jt1:lst1)
                {
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) { 
                        jt1.Task_Order__c = a;}
                    a--;
                    
                    if(isFirst)
                    {
                        System.debug('This is First');
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) { 
                            jt1.Revised_Due_Date__c=Date.newInstance(d6.Year(),d6.Month(),d6.Day());}
                        isFirst=false;
                    }
                    else
                    {
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
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
                    if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                        jt1.Start_Date__c=d5;
                    }
                    NTSD1=d5;
                    system.debug('NTSD '+NTSD1);
                    lstJobTask1.add(jt1);
                    // update jt1;
                }
                if(Schema.sObjectType.Approval_Job_Task__c.isUpdateable()){ 
                    update lstJobTask1;
                }
                else{
                    return 'Approval Task has insufficient access to update';
                }
            }     
            
            catch(DMLException e)
            {
                return e.getMessage();
            } 
            
        }   
        
        List<Job_Team__c> listjobteam=new  List<Job_Team__c>();
        listjobteam=[select id,name, Role__c,staff__c,Email__c from Job_Team__c  where job__c =:strid WITH SECURITY_ENFORCED];
        
        List<Approval_Job_Task__c> listtasks=[select id,name,Schedule_Roles__c,Email__c from Approval_Job_Task__c  where id=:Taskid WITH SECURITY_ENFORCED];
        System.debug('===listtasks====='+listtasks);
        System.debug('===List of Task Roles====='+listtasks[0].Schedule_Roles__c);
        
        List<Approval_Job_Task_Roles__c> JobTaskRoleNew  = new List<Approval_Job_Task_Roles__c>();
        
        for(Job_Team__c Jteam :listjobteam ){
            for(Approval_Job_Task__c  Jtask :listtasks){
                if(Jtask.Schedule_Roles__c!=NULL ){
                    if(Jtask.Schedule_Roles__c.contains(''+Jteam.role__c)){
                        Approval_Job_Task_Roles__c J2 = new Approval_Job_Task_Roles__c();
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Email__c.isCreateable()) { 
                            J2.Email__c =Jteam.Email__c; 
                        }
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.User__c.isCreateable()) {
                            J2.User__c=Jteam.Staff__c;
                        }
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Name.isCreateable()) {
                            J2.Name=Jteam.Role__c;
                        }
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Approval_Job_Task__c.isCreateable()) {
                            J2.Approval_Job_Task__c = Taskid;
                        }
                        JobTaskRoleNew.add(J2);
                    }
                }
            }
        }
        if(Schema.sObjectType.Approval_Job_Task_Roles__c.isCreateable()){ 
            insert JobTaskRoleNew;
        }
        else{
            return 'Approval Task role has insufficient access to create';
        }
        
        return 'OK';
    }
    /********************************** Submit a Task in the task lightning data table quick action ************************************/
    @AuraEnabled
    public Static String SubmitApproveTask(String tskid)
    {  
        string TskIdUpdate;
        try
        {  
            Approval_Job_Task__c objCurrentJobTask =  [Select id,Undo__c,Number_of_Submissions__c,Submitter_Name__c,Submitted_Date__c,Marked_Done__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c from Approval_Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
            objCurrentJobTask.Status__c='In Progress';
            objCurrentJobTask.Submitter_Email__c=UserInfo.getUserEmail();
            objCurrentJobTask.Submitter_Name__c=UserInfo.getName();
            objCurrentJobTask.Submitted_Date__c=system.today();
            objCurrentJobTask.Number_of_Submissions__c=1;
            objCurrentJobTask.Undo__c=false;
            update objCurrentJobTask;
            TskIdUpdate = objCurrentJobTask.Id;
            
            /************* Update Task roles for sending email through email alert **********************/
            list<Approval_Job_Task_Roles__c> RoleList=new  list<Approval_Job_Task_Roles__c>();
            list<Approval_Job_Task_Roles__c> tskRoleList=[SELECT Id,Approval_Task_Inprogress__c FROM Approval_Job_Task_Roles__c where Approval_Job_Task__c =: TskIdUpdate WITH SECURITY_ENFORCED];
            if(tskRoleList.size()>0){
                for(Approval_Job_Task_Roles__c ApprovalTskRole:tskRoleList){
                    ApprovalTskRole.Approval_Task_Inprogress__c=true;
                    RoleList.add(ApprovalTskRole);
                }
                update RoleList;     
            }
        }
        catch(System.DMLException e){
            return e.getMessage();
        } 
        return 'OK';
    }


     /********************************** Re-Submit a Task in the task lightning data table quick action ************************************/
     @AuraEnabled
     public Static String ReSubmitApproveTask(String tskid)
     {  
         string TskIdUpdate;
         try
         {  
             Approval_Job_Task__c objCurrentJobTask =  [Select id,Undo__c,Number_of_Submissions__c,Submitter_Name__c,Submitted_Date__c,Marked_Done__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c from Approval_Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
             objCurrentJobTask.Status__c='In Progress';
             objCurrentJobTask.Submitter_Email__c=UserInfo.getUserEmail();
             objCurrentJobTask.Submitter_Name__c=UserInfo.getName();
             objCurrentJobTask.Submitted_Date__c=system.today();
             objCurrentJobTask.Number_of_Submissions__c=objCurrentJobTask.Number_of_Submissions__c+1;
             objCurrentJobTask.Undo__c=false;
             update objCurrentJobTask;
             TskIdUpdate = objCurrentJobTask.Id;
             
             /************* Update Task roles for sending email through email alert *********************/
             list<Approval_Job_Task_Roles__c> RoleList=new  list<Approval_Job_Task_Roles__c>();
             list<Approval_Job_Task_Roles__c> tskRoleList=[SELECT Id,Approval_Task_Inprogress__c FROM Approval_Job_Task_Roles__c where Approval_Job_Task__c =: TskIdUpdate WITH SECURITY_ENFORCED];
             if(tskRoleList.size()>0){
                 for(Approval_Job_Task_Roles__c ApprovalTskRole:tskRoleList){
                     ApprovalTskRole.Approval_Task_Inprogress__c=true;
                     RoleList.add(ApprovalTskRole);
                 }
                 update RoleList;     
             }
         }
         catch(System.DMLException e){
             return e.getMessage();
         } 
         return 'OK';
     }

    /********************************** Undo a Task in the task lightning data table quick action ************************************/
    @AuraEnabled
    public Static String UndoApproveTask(String tskid)
    { 
        string TskIdUpdate;
        try
        {  
            Approval_Job_Task__c objCurrentJobTask =  [Select id,Number_of_Submissions__c,Submitted_Date__c,Marked_Done__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c from Approval_Job_Task__c where id=: tskid WITH SECURITY_ENFORCED];
            
            if(objCurrentJobTask.Number_of_Submissions__c>1)
            {
                objCurrentJobTask.Status__c='Changes Needed';
                objCurrentJobTask.Number_of_Submissions__c=objCurrentJobTask.Number_of_Submissions__c-1;
                objCurrentJobTask.Undo__c=true;
            }
            else{
                objCurrentJobTask.Status__c='Pending';
                objCurrentJobTask.Undo__c=true;
            }
            
            update objCurrentJobTask;
            TskIdUpdate = objCurrentJobTask.Id;
            
            /************* Update Task roles for sending email through email alert ********************/
            list<Approval_Job_Task_Roles__c> RoleList=new  list<Approval_Job_Task_Roles__c>();
            list<Approval_Job_Task_Roles__c> tskRoleList=[SELECT Id,Approval_Task_Inprogress__c FROM Approval_Job_Task_Roles__c where Approval_Job_Task__c =: TskIdUpdate WITH SECURITY_ENFORCED];
            if(tskRoleList.size()>0){
                for(Approval_Job_Task_Roles__c ApprovalTskRole:tskRoleList){
                    ApprovalTskRole.Approval_Task_Inprogress__c=false;
                    RoleList.add(ApprovalTskRole);
                }
                update RoleList;     
            }
        }
        catch(System.DMLException e){
            return e.getMessage();
        } 
        return 'OK';
    }
    
    /********************************* Approved Task Quick on the task detail page **************************************************/
    @AuraEnabled
    public static String ApprovedTsk(String TskId) {
        string JobId,FileName,TskIdUpdate,NxtTskIdUpdate,TaskId;
        boolean activeCreateProcess;
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        activeCreateProcess=setting.Job_Task_Level__c;
        
        try
        {  
            Approval_Job_Task__c objCurrentJobTask =  [Select id,Approved_Date__c,Task__c ,Approver_By__c,Login_User__c,Job__c,Submitter_Email__c,Status__c,Task_Order__c,File_ID__c,File_Name__c from Approval_Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
            string tskrcdid = objCurrentJobTask.Task__c;
            if(objCurrentJobTask.Status__c=='Pending' || objCurrentJobTask.Status__c=='Changes Needed')// || objCurrentJobTask.Login_User__c!=true)
            {
                return 'Not Ready';
            }
            else if(objCurrentJobTask.Status__c=='Approved')// || objCurrentJobTask.Login_User__c!=true)
            {
                return 'already Approved';
            }
            else
            {
                JobId=objCurrentJobTask.Job__c;
                FileName=objCurrentJobTask.File_Name__c;
                TaskId=objCurrentJobTask.Task__c;
                objCurrentJobTask.Status__c='Approved';
                objCurrentJobTask.Marked_Done__c=true;//Approved
                objCurrentJobTask.Approved_Date__c=system.today();
                objCurrentJobTask.Approver_By__c= UserInfo.getName();
                update objCurrentJobTask;
                TskIdUpdate = objCurrentJobTask.Id;
                
                List<Approval_Job_Task__c> objCurrentJobTask1;
                if(activeCreateProcess){
                    objCurrentJobTask1 =  [Select id,name,Submitted_Date__c,Number_of_Submissions__c,Submitter_Name__c,Submitter_Email__c,Status__c,Task_Order__c,File_ID__c,File_Name__c,Marked_Done__c from Approval_Job_Task__c where Task__c=: TaskId and Marked_Done__c!=true and File_Name__c=:FileName WITH SECURITY_ENFORCED Order BY Task_Order__c Limit 1];
                    
                }
                else{
                    objCurrentJobTask1 =  [Select id,name,Submitted_Date__c,Number_of_Submissions__c,Submitter_Name__c,Submitter_Email__c,Status__c,Task_Order__c,File_ID__c,File_Name__c,Marked_Done__c from Approval_Job_Task__c where Project__c=: JobId and Marked_Done__c!=true and File_Name__c=:FileName WITH SECURITY_ENFORCED Order BY Task_Order__c Limit 1];
                    
                }
                
                //objCurrentJobTask1 =  [Select id,name,JobSuite__Submitted_Date__c,JobSuite__Number_of_Submissions__c,JobSuite__Submitter_Name__c,Submitter_Email__c,Status__c,Task_Order__c,File_ID__c,File_Name__c,Marked_Done__c from Approval_Job_Task__c where JobSuite__Project__c=: JobId and Marked_Done__c!=true and File_Name__c=:FileName WITH SECURITY_ENFORCED Order BY Task_Order__c Limit 1];
                
                system.debug('objCurrentJobTask1 === '+objCurrentJobTask1+'\n');
                
				  if(objCurrentJobTask1.size()>0){
                    objCurrentJobTask1[0].Status__c='In Progress';
                    objCurrentJobTask1[0].Submitter_Email__c=objCurrentJobTask.Submitter_Email__c;
                    objCurrentJobTask1[0].Submitter_Name__c=UserInfo.getName();
                    objCurrentJobTask1[0].Submitted_Date__c=system.today();
                    objCurrentJobTask1[0].Number_of_Submissions__c=objCurrentJobTask1[0].Number_of_Submissions__c+1;
                    update objCurrentJobTask1;
                    
                    NxtTskIdUpdate = objCurrentJobTask1[0].Id;
                    
                    list<Approval_Job_Task_Roles__c> RoleList=new  list<Approval_Job_Task_Roles__c>();
                    list<Approval_Job_Task_Roles__c> tskRoleList=[SELECT Id,Approval_Task_Inprogress__c FROM Approval_Job_Task_Roles__c where Approval_Job_Task__c =: NxtTskIdUpdate WITH SECURITY_ENFORCED];
                    if(tskRoleList.size()>0){
                        for(Approval_Job_Task_Roles__c ApprovalTskRole:tskRoleList){
                            ApprovalTskRole.Approval_Task_Inprogress__c=true;
                            RoleList.add(ApprovalTskRole);
                        }
                        update RoleList;     
                    }
                } 
                else {
                    list<Job_Task__c> jtk = [select id,name,Status__c,Marked_Done__c,Task_Order__c,Completion_Date__c,Job__c from Job_Task__c where id =:tskrcdid WITH SECURITY_ENFORCED limit 1];
                    if(jtk.size() > 0){
                        if (Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()) {
                            jtk[0].Marked_Done__c = true;
                        }
                        if (Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()) {
                            jtk[0].Status__c = 'completed';
                        }
                        if (Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()) {
                            jtk[0].Completion_Date__c =system.today() ;
                        }
                        if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                            update jtk[0];
                        }
                        
                        list<Job_Task__c> jtkrcd = [select id,name,Status__c,Marked_Done__c,Job__c,Task_Order__c from Job_Task__c where Job__c =:jtk[0].Job__c and Task_Order__c =: integer.valueOf(jtk[0].Task_Order__c+1)  WITH SECURITY_ENFORCED limit 1];
                                                   system.debug('jtkrcd === '+jtkrcd+'\n');
                        if(jtkrcd.size() > 0 ){
                            list<Approval_Job_Task__c> objCurrentapvJobTask =  [Select id,name,Undo__c,Number_of_Submissions__c,Submitter_Name__c,Submitted_Date__c,Marked_Done__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,Task__c from Approval_Job_Task__c where Task__c =: jtkrcd[0].id WITH SECURITY_ENFORCED Order BY Task_Order__c limit 1];
                            if(objCurrentapvJobTask.size() > 0){
                                system.debug('objCurrentapvJobTask === '+objCurrentapvJobTask+'\n');
                                objCurrentapvJobTask[0].Status__c='In Progress';
                                objCurrentapvJobTask[0].Submitter_Email__c=UserInfo.getUserEmail();
                                objCurrentapvJobTask[0].Submitter_Name__c=UserInfo.getName();
                                objCurrentapvJobTask[0].Submitted_Date__c=system.today();
                                objCurrentapvJobTask[0].Number_of_Submissions__c=1;
                                objCurrentapvJobTask[0].Undo__c=false;
                                update objCurrentapvJobTask[0];
                                system.debug('objCurrentapvJobTask[0] === '+objCurrentapvJobTask[0]+'\n');
                                TskIdUpdate = objCurrentapvJobTask[0].Id;
                                  /************* Update Task roles for sending email through email alert  by manindra on 16 - 01 - 2022 **********************/
                                list<Approval_Job_Task_Roles__c> RoleList=new  list<Approval_Job_Task_Roles__c>();
                                list<Approval_Job_Task_Roles__c> tskRoleList=[SELECT Id,Approval_Task_Inprogress__c FROM Approval_Job_Task_Roles__c where Approval_Job_Task__c =: TskIdUpdate WITH SECURITY_ENFORCED];
                                if(tskRoleList.size()>0){
                                    for(Approval_Job_Task_Roles__c ApprovalTskRole:tskRoleList){
                                        ApprovalTskRole.Approval_Task_Inprogress__c=true;
                                        RoleList.add(ApprovalTskRole);
                                    }
                                    update RoleList; 
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                return TskIdUpdate;
            }
        }
        catch(System.DMLException e){
            return e.getMessage();
        } 
    }
    
    /******************************** Approval ChangesNeeded **********************************************/   
    @AuraEnabled
    public static String taskChangesNeeded(String TskId) {
        string JobId,FileName,TskIdUpdate;
        try
        {  
            Approval_Job_Task__c objCurrentJobTask =  [Select id,Job__c,Submitter_Email__c,Status__c,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c,File_Name__c from Approval_Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
            if(objCurrentJobTask.Status__c=='Pending')
            {
                return 'Not Ready';
            }
            else if(objCurrentJobTask.Status__c=='Approved')// || objCurrentJobTask.Login_User__c!=true)
            {
                return 'already Approved';
            }
            else
            {
                objCurrentJobTask.Status__c='Changes Needed';
               
                update objCurrentJobTask;
                TskIdUpdate = objCurrentJobTask.Id;
                return TskIdUpdate;
            }
        }
        catch(System.DMLException e){
            return e.getMessage();
        } 
    }
    
    /******************************* Delete Approval Job Task ********************************************/
    
    @AuraEnabled
    public Static String DeleteApproveTask(String tskid){  
        try
        {  
            Id JobId = [Select Id, Job__c from Approval_Job_Task__c where Id =:tskid WITH SECURITY_ENFORCED limit 1].Job__c; 
            
            Approval_Job_Task__c objCurrentJobTask =  [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c,File_ID__c from Approval_Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
            string Fileid=objCurrentJobTask.File_ID__c;
            
            Double Task_Order_No= [Select Id, Task_Order__c from Approval_Job_Task__c where Id =:tskid and File_ID__c=:Fileid WITH SECURITY_ENFORCED limit 1].Task_Order__c;
            
            if(Approval_Job_Task__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objCurrentJobTask);
            }
            else{
                return 'Approval Task has insufficient access to delete';
            } 
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
            
            List<Approval_Job_Task__c> lstTaskBelow;
            System.debug('Below Task records after deletion : '+lstTaskBelow);
            if(blnFroward)
            {
                lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Approval_Job_Task__c where Job__c=: JobId and File_ID__c=:Fileid AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
            }
            else
            {
                lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Approval_Job_Task__c where Job__c=: JobId and File_ID__c=:Fileid AND Task_Order__c <: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c desc];
            }
            
            
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
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                                lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                            }
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                                lstTaskBelow[i].Task_Order__c = Task_Order_No;
                            }
                        }
                        else
                        {
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                                lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;
                            }
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            //  dtStartDate3 = lstTaskBelow[i].Start_Date__c = d4; 
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()) {
                                lstTaskBelow[i].Start_Date__c = d4; 
                            }
                            
                            dtStartDate3 =DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) {                            
                                lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;
                            }
                        }
                        else
                        {
                            if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {   
                                lstTaskBelow[i].Revised_Due_Date__c = d4; 
                            }
                            
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
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()) {
                            lstTaskBelow[i].Revised_Due_Date__c=d1;
                        }
                    }
                    else {
                        if(Schema.sObjectType.Approval_Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstTaskBelow[i].Start_Date__c=d1;
                        } 
                    }
                    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Schema.sObjectType.Approval_Job_Task__c.isUpdateable()){ 
                    update lstTaskBelow;
                }
                else{
                    return 'Approval Task has insufficient access to update';
                }
                
                //update the task order for the backward calcuation for the tasks below.
                
                
            }
            if(!blnFroward)
            {
                lstTaskBelow = [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Approval_Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
                for(Integer i=0;i<lstTaskBelow.size();i++)
                {
                    if(i==0)
                    {
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                            lstTaskBelow[i].Task_Order__c = Task_Order_No;
                        }
                    }
                    else
                    {    
                        if (Schema.sObjectType.Approval_Job_Task__c.fields.Task_Order__c.isUpdateable()) {
                            lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;
                        }
                    }
                    //updateTask.add(lstTaskAbove[i]);
                }    
                if(Schema.sObjectType.Approval_Job_Task__c.isUpdateable()){ 
                    update lstTaskBelow;
                }
                else{
                    return 'Approval Task has insufficient access to update';
                }
            }
            
        }
        
        catch(System.DMLException e){
            return e.getMessage();
        } 
        return 'OK';
    }
    
    
    
    
    /****************************************** Add/Edit Staff Quick action ****************************************************************/
    
    
    public class ApprTskStaffWrappers{
        @AuraEnabled
        public Job_Team__c staff {get;set;}
        @AuraEnabled
        public boolean selection {get;set;}
        
        public ApprTskStaffWrappers(Job_Team__c staff){
            this.staff = staff;
            selection = False;
        }
    } 
    
    
    @AuraEnabled
    public static List<ApprTskStaffWrappers> getStaffWrapperMembers(String TaskId){
        system.debug('>>>>>>>>>>TskId>>>>>>>>>>>>'+TaskId);
        List<ApprTskStaffWrappers> AllstaffWrappers=new  List<ApprTskStaffWrappers>();
        list<Job_Team__c> staffs = new List<Job_Team__c>();
        List<Approval_Job_Task_Roles__c> lstJTR=new List<Approval_Job_Task_Roles__c>();
        Map<String,Approval_Job_Task_Roles__c> staffTaskRoleMap = new Map<String,Approval_Job_Task_Roles__c>();
        Set<String> StaffNameTaskRole =new Set<String>();
        String JobId=[select Id,Job__c From Approval_Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED].Job__c;
        String SchTskJobId=[select Id,Task__r.Job__c From Approval_Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED].Task__r.Job__c;
        Boolean createdfromJobTask=[select Id,Name,Created_From_Job_Task__c From Approval_Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED].Created_From_Job_Task__c;
        String query;
        if(createdfromJobTask){
             query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: SchTskJobId and Staff__c!=null WITH SECURITY_ENFORCED';
        }else{
            query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: JobId and Staff__c!=null WITH SECURITY_ENFORCED';
        }
           
        lstJTR=[Select Id,Name,User__c from Approval_Job_Task_Roles__c where Approval_Job_Task__c =: TaskId WITH SECURITY_ENFORCED order by CreatedDate ];
        staffs = Database.query(query);
        
        if(!staffs.isEmpty()){
            Set<string> staffNameSet = new Set<String>();
            for(Approval_Job_Task_Roles__c jtr : lstJTR){
                staffNameSet.add(jtr.User__c);
                staffTaskRoleMap.put(jtr.User__c,jtr);
            }
            
            for(Job_Team__c s:staffs){
                
                if(! staffNameSet.contains(s.Staff__c))
                {
                    AllstaffWrappers.add(new ApprTskStaffWrappers(s));
                    
                }
                
                else{ 
                    ApprTskStaffWrappers w =new ApprTskStaffWrappers(s);
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
        
        List<ApprTskStaffWrappers> AllstaffWrappers = (List<ApprTskStaffWrappers>)JSON.deserialize(selectedStaff, List<ApprTskStaffWrappers>.class);            
        
        //List<staffWrappers> AllstaffWrappers =new  List<staffWrappers>();
        
        System.debug('========Selected AllstaffWrappers members========'+AllstaffWrappers);
        
        list<Job_Team__c> staffs = new List<Job_Team__c>();
        List<Approval_Job_Task_Roles__c> lstJTR=new List<Approval_Job_Task_Roles__c>();
        Map<String,Approval_Job_Task_Roles__c> staffTaskRoleMap = new Map<String,Approval_Job_Task_Roles__c>();
        Set<String> StaffNameTaskRole =new Set<String>();
        String JobId=[select Id,Job__c From Approval_Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED ].Job__c;
        String SchTskJobId=[select Id,Task__r.Job__c From Approval_Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED].Task__r.Job__c;
        Boolean createdfromJobTask=[select Id,Created_From_Job_Task__c From Approval_Job_Task__c Where Id=:TaskId WITH SECURITY_ENFORCED].Created_From_Job_Task__c;
        String query;
        if(createdfromJobTask){
            query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: SchTskJobId and Staff__c!=null WITH SECURITY_ENFORCED ';
        }
        else{
            query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: JobId and Staff__c!=null WITH SECURITY_ENFORCED ';
        }
        
        //String query ='Select Staff__c,Role__c,Email__c from Job_Team__c where Job__c=: JobId and Staff__c!=null WITH SECURITY_ENFORCED ';
        
        
        lstJTR=[Select Id,Name,User__c from Approval_Job_Task_Roles__c where Approval_Job_Task__c =: TaskId WITH SECURITY_ENFORCED order by CreatedDate];
        staffs = Database.query(query);
        
        if(!staffs.isEmpty()){
            Set<string> staffNameSet = new Set<String>();
            for(Approval_Job_Task_Roles__c jtr : lstJTR){
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
            List<Approval_Job_Task_Roles__c> AddTaskRole = new List<Approval_Job_Task_Roles__c>();
            List<Approval_Job_Task_Roles__c> deleteTaskRole = new List<Approval_Job_Task_Roles__c>();
            
            for(ApprTskStaffWrappers apw:AllstaffWrappers){
                boolean existing = StaffNameTaskRole.contains(apw.staff.Staff__c); 
                
                
                if(apw.selection == True){
                    if(!existing){
                        Approval_Job_Task_Roles__c trole=new Approval_Job_Task_Roles__c();                      
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Name.isCreateable()) { 
                            trole.Name=apw.staff.Role__c;}
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.User__c.isCreateable()) { 
                            trole.User__c=apw.staff.Staff__c;}
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Approval_Job_Task__c.isCreateable()) { 
                            trole.Approval_Job_Task__c=TaskId;}
                        if (Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Email__c.isCreateable()) { 
                            trole.Email__c=apw.staff.Email__c;}
                        AddTaskRole.add(trole);
                    }
                    
                }
                else if(existing){
                    if(staffTaskRoleMap.containsKey(apw.staff.Staff__c)){
                        Approval_Job_Task_Roles__c objJTR = staffTaskRoleMap.get(apw.staff.Staff__c);
                        system.debug('HERE1'+objJTR );
                        deleteTaskRole.add(objJTR);
                    }
                }
                
            }
            if(!AddTaskRole.isEmpty()){
                if (!Approval_Job_Task_Roles__c.sObjectType.getDescribe().isCreateable()){
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                    return 'Approval Task Role has Insufficient Access to create';
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
                if (!Approval_Job_Task_Roles__c.sObjectType.getDescribe().isDeletable()){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                    return 'Approval Task role has Insufficient Access to delete';
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
    
    /******************************************Log Time**************************************************************** */
    
    
    // *************** Display today's date in New TS page *************************/
    @AuraEnabled 
    public static date gettodaydate() 
    {
        return system.today();
    }
    
    // *************** Display login user id in New TS page *************************/
    @AuraEnabled 
    public static List<String> getUserName()
    {
        List<String> usedetails=new List<String>();
        usedetails.add(UserInfo.getUserId());
        usedetails.add(UserInfo.getname());
        return usedetails;
    }
    
    @AuraEnabled
    public Static Approval_Job_Task__c getTaskInformation(String taskId){
        Approval_Job_Task__c JobApprovalTask=[Select Id,Name,Email__c,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Job__c,Job__r.Name From Approval_Job_Task__c where Id=:taskId WITH SECURITY_ENFORCED];
        return JobApprovalTask;  
    }
    
    
    /******************************************************* Calculate Time from Start watch and End Watch Fields ****************************************************/
    
    @AuraEnabled
    public Static decimal calcTimeDiff(DateTime StWatch,DateTime EndWatch){
        decimal stime;
        string hours;
        string minutes;
        If(StWatch!=null && EndWatch!= null){
            if(StWatch.getTime() <= EndWatch.getTime() ){
                decimal var = ((EndWatch.getTime() - StWatch.getTime()) / (1000.0*60.0*60.0));
                stime=(var-Math.Floor(var))*60;
                hours= string.valueof(Math.Floor(var));
                minutes =string.valueof(stime.setScale(0,System.RoundingMode.HALF_EVEN));
                If(integer.valueof(minutes) == 60){
                    hours = string.valueof(integer.valueof(hours)+1);
                    minutes='00';
                    
                }
                
                return (Decimal.valueof(hours)+((Decimal.valueof(minutes))/60)).setScale(2);
            }
            else{
                
                return 0.01;
            }
        }
        else return 0;
    }
    
    
}