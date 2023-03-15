public  with sharing class taskstabcontroller {
    
    
    @AuraEnabled
    public static string getObjectFieldLabels(list<String> ObjNames){
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);  
    }
    
    @AuraEnabled
    public static boolean CustomSettingvalues() {
        Approval_Task_CS__c cs = Approval_Task_CS__c.getInstance();
        return cs.File_Attach_at_Task_Level__c;
    }
    
    @AuraEnabled
    public static filterwrapper getfiltervals(){
        filterwrapper fw = new filterwrapper();
        set<string>stffset = new set<string>();
        set<string>roleset = new set<string>();
        set<string>clientset = new set<string>();
        set<string>jobidset = new set<string>();
        
        list<Staff__c>stfvals = [select id,Name,Active__c from Staff__c where Active__c = true WITH SECURITY_ENFORCED order by Name asc limit 1000];
        for(Staff__c vals : stfvals){
            stffset.add(vals.Name);
        }
        /*list<Job_Task_Role__c>rolevals = [select id,name from Job_Task_Role__c WITH SECURITY_ENFORCED order by Name asc limit 50000];
*/
        list<userrole>rolevals = [select id,name from userrole  order by name asc limit 1000];
        for(userrole vals : rolevals){
            roleset.add(vals.name);
        }
        list<Client__c >clientvals = [select id,name from Client__c  WITH SECURITY_ENFORCED order by Name asc limit 1000];
        for(Client__c  vals : clientvals){
            clientset.add(vals.name);
        }
        /* list<Job_Task__c>jobtaskvals = [select id,name,Status__c, Marked_Done__c, Job__r.id,Job__r.name,Job__r.Job_Auto_Number__c from Job_Task__c  where Status__c = 'Active'  and Job__r.Status__c= 'Active' and Marked_Done__c = false WITH SECURITY_ENFORCED order by Job__r.Job_Auto_Number__c desc limit 50000];
for(Job_Task__c vals : jobtaskvals){
jobidset.add(vals.Job__r.id);  
}*/
        list<Job__c>result = [select id,Name,Job_Auto_Number__c,Status__c from Job__c where Status__c = 'active' WITH SECURITY_ENFORCED order by name  asc limit 500];
        list<Job_Task__c>jobtaskvalsrcds = [select id,name,Status__c, Marked_Done__c, Job__r.id,Job__r.name,Job__r.Job_Auto_Number__c from Job_Task__c  where Status__c = 'Active'  and Job__r.Status__c=: 'Active' WITH SECURITY_ENFORCED order by Job__r.Job_Auto_Number__c desc limit 3];
        
        fw.stfwrp = stffset;
        fw.rolewrp = roleset;
        fw.clientwrp = clientset;
        fw.jobwrp = result;
        fw.jbtkwrp = jobtaskvalsrcds;
        return fw;
    }
    
    public class filterwrapper{
        @AuraEnabled public set<string>stfwrp{get;set;}
        @AuraEnabled public set<string>rolewrp{get;set;}
        @AuraEnabled public set<string>clientwrp{get;set;}
        @AuraEnabled public list<Job__c>jobwrp{get;set;}
        @AuraEnabled public list<Job_Task__c>jbtkwrp{get;set;}
    }
    
    @AuraEnabled
    public static List<Job_Task_Role__c> getMyTaskDatafortablevals()
    {
        String str;
        String strJTID;
        String strJTID2;
        String strGetName;
        List<Job__c> lstJob=new List<Job__c>();
        List<Job_Task__c> lstJT;
        List<Job_Task__c> lstJT1;
        List<Job_Task_Role__c> lstJTR;
        Set<Id> stJobId=new Set<Id>();
        Set<Id> stJobTaskId=new Set<Id>();
        Set<Id> stJobTaskRoleId=new Set<Id>();
        Boolean ShowTsEntryButton;
        map<string,List<Job_Task_Role__c>>tkrmap = new map<string,List<Job_Task_Role__c>>();
        
        // list<taskWrapper> taskroleWrap =new list<taskWrapper>();
        String strColor;
        
        lstJob=new List<Job__c>();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowTsEntryButton=activeSettings.TS_Entry_Button__c;
        
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName limit 1];//WITH SECURITY_ENFORCED
        String strName=u.Name;
        lstJob=[Select Id,Name,createddate from Job__c where Status__c=: 'Active' WITH SECURITY_ENFORCED order by createddate desc limit 500];
        for(Job__c j:lstJob)
        {
            stJobId.add(j.id);
        }
        lstJT=[Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c from Job_Task__c where Job__c in : stJobId and Status__c='Active' and Marked_Done__c= False   WITH SECURITY_ENFORCED Order by Revised_Due_Date__c limit 500];
        
        for(Job_Task__c jt: lstJT)
        {
            stJobTaskId.add(jt.id);
        }
        
        lstJTR=Database.query('Select Id,Name,Job_Task__c,Job_Task__r.Name,Job_Task__r.Job__r.Name,Job_Task__r.Revised_Due_Date__c,Job_Task__r.Next_Task_Due__c,Job_Task__r.Status__c,Job_Task__r.Task_Order__c,Job_Task__r.Job__r.Job_Auto_Number__c,User__c,Job_Task__r.Job__r.Next_Tasks_Due__c,Job_Task__r.Job__r.Campaign__c,Job_Task__r.Job__r.Campaign__r.Name,Job_Task__r.Job__r.JS_Client__c,Job_Task__r.Job__r.JS_Client__r.Name from Job_Task_Role__c where Job_Task__c IN : stJobTaskId  WITH SECURITY_ENFORCED order by Job_Task__r.Revised_Due_Date__c  asc limit 500'); //Job_Task__r.Revised_Due_Date__c'+' '+ sortDirection + ',' + sortFullExp);
        return  lstJTR;
        /*  for(Job_Task_Role__c tk:lstJTR){
tkrmap.put(tk.User__c,new list<Job_Task_Role__c>{tk});  
}
return tkrmap;*/
    }
    
    @AuraEnabled
    public static  List<Job_Task_Role__c> getfiltervalsrcd(String tkselection,string stf,string rol,string clnt,string jobrcdval){
        set<string>tkroleids = new set<string>();
        String val = 'Active';
        boolean bool = false;
        date tdy = system.today();
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName limit 1];//WITH SECURITY_ENFORCED
        String strName=u.Name;
        map<string,string>mpvals = new map<string,string>();
        List<Job_Task_Role__c> lstJTR = new list<Job_Task_Role__c>();
        List<Job_Task_Role__c> lstJTRval = new list<Job_Task_Role__c>();
        string tkrolercd = 'Select Id,Name,Job_Task__c,Job_Task__r.Name,Job_Task__r.Job__r.Name,Job_Task__r.Revised_Due_Date__c,Job_Task__r.Next_Task_Due__c,Job_Task__r.Status__c,Job_Task__r.Task_Order__c,Job_Task__r.Job__r.Job_Auto_Number__c,User__c,Job_Task__r.Assigned_Users__c,Job_Task__r.Job__r.JS_Client__c,Job_Task__r.Job__r.JS_Client__r.Name,Job_Task__r.Job__r.Status__c,Job_Task__r.Job__r.Next_Tasks_Due__c,Job_Task__r.Job__r.Campaign__c,Job_Task__r.Job__r.Campaign__r.Name from Job_Task_Role__c where Job_Task__r.Status__c =:val and Job_Task__r.Marked_Done__c =:bool and Job_Task__r.Job__r.Status__c =:val';
        if(String.isNotBlank(tkselection) && tkselection == 'MyTasks'){
            tkrolercd+=' And User__c =: strName';
        }
        if(String.isNotBlank(tkselection) && tkselection == 'MyNextTasks'){
            tkrolercd+=' And User__c =: strName';
        }
        if(String.isNotBlank(tkselection) && tkselection == 'MyTasksPastDue'){
            tkrolercd+=' And User__c =: strName';
        }
        if(String.isNotBlank(stf)){
            tkrolercd+=' And User__c =: stf';
        }    
        if(String.isNotBlank(rol)){
            tkrolercd+=' And Name=: rol';
        }
        if(String.isNotBlank(clnt)){
            tkrolercd+=' And Job_Task__r.Job__r.JS_Client__r.Name=: clnt';
        }
        if(String.isNotBlank(jobrcdval)){
            tkrolercd+=' And Job_Task__r.Job__r.Name=: jobrcdval';
        }
        if(String.isNotBlank(tkselection) && (tkselection == 'NextAll' || tkselection=='MyNextTasks')){
            tkrolercd+=' And Job_Task__r.Revised_Due_Date__c >=:tdy';
        }
        if(String.isNotBlank(tkselection) && (tkselection == 'AllTasksPastDue' || tkselection=='MyTasksPastDue')){
            tkrolercd+=' And Job_Task__r.Revised_Due_Date__c <: tdy';
        }
        tkrolercd+=' WITH SECURITY_ENFORCED order by Job_Task__r.Revised_Due_Date__c  asc limit 500';
        lstJTR =(Database.query(tkrolercd));
        system.debug('lstJTR === '+lstJTR.size());
        if(String.isNotBlank(tkselection) && tkselection == 'NextAll'){
            lstJTRval.clear();
            for(integer i = 0 ; i <  lstJTR.size() ; i++){
                if(mpvals.containskey(lstJTR[i].User__c)){
                    system.debug('contains key === '+lstJTR[i].User__c);
                }
                else{
                    mpvals.put(lstJTR[i].User__c,lstJTR[i].User__c);
                    lstJTRval.add(lstJTR[i]);
                    system.debug('not contains key === '+lstJTR[i].User__c);
                    
                }
            }
            return lstJTRval;
        }
        else if(String.isNotBlank(tkselection) && tkselection == 'AllTasksPastDue'){
            lstJTRval.clear();
            for(integer i = 0 ; i <  lstJTR.size() ; i++){
                if(mpvals.containskey(lstJTR[i].User__c)){
                    system.debug('contains key === '+lstJTR[i].User__c);
                }
                else{
                    mpvals.put(lstJTR[i].User__c,lstJTR[i].User__c);
                    lstJTRval.add(lstJTR[i]);
                    system.debug('not contains key === '+lstJTR[i].User__c);
                    
                }
            }
            return lstJTRval;
        }
        else if(String.isNotBlank(tkselection) && tkselection == 'MyTasksPastDue')
        {
            lstJTRval.clear();
            for(integer i = 0 ; i <  lstJTR.size() ; i++){
                if(mpvals.containskey(lstJTR[i].User__c)){}                
                else{
                    mpvals.put(lstJTR[i].User__c,lstJTR[i].User__c);
                    lstJTRval.add(lstJTR[i]);
                }
            }
            return lstJTRval;
        }
        else if(String.isNotBlank(tkselection) && tkselection == 'AllTasksDue')
        {
            lstJTRval.clear();
            return lstJTR;    
        }
        else if(String.isNotBlank(tkselection) && tkselection == 'MyNextTasks')
        {
            lstJTRval.clear();
            for(integer i = 0 ; i <  lstJTR.size() ; i++){
                if(mpvals.containskey(lstJTR[i].User__c)){}                
                else{
                    mpvals.put(lstJTR[i].User__c,lstJTR[i].User__c);
                    lstJTRval.add(lstJTR[i]);
                }
            }
            return lstJTRval;
        }
        return lstJTR;  
    }
    
    
    /******************************* Get the job Related Files ********************************************/
    @AuraEnabled
    public static  Map < Id, String > getAttachments(String tkid){
        Job_Task__c objJobTask = [select Id,Name,Days__c,Start_Date__c,Due_Date__c,Revised_Due_Date__c,Job__r.Schedule_Calc__c,Job__r.id,Job__r.Name, Marked_Done__c,Task_Order__c from Job_Task__c where  id =: tkid  WITH SECURITY_ENFORCED limit 1];
        String recordId = objJobTask.Job__r.id;
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
            //cvMap.put(null, '--None--');
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
        catch(exception e)        {
            system.debug('The exception is '+e.getMessage()+ '' + '' + 'The reason is '+e.getCause()+ '' + '' + 'The line number is '+e.getLineNumber());
        }
        return 'OK';
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
    public static string dltetk(string taskid){
        Job_Task__c objJobTask = [select Id,Name,Days__c,Start_Date__c,Due_Date__c,Revised_Due_Date__c,Job__r.Schedule_Calc__c,Job__r.id,Job__r.Name, Marked_Done__c,Task_Order__c from Job_Task__c where  id =: taskid  WITH SECURITY_ENFORCED limit 1];
        system.debug('Old value' + objJobTask );  
        if(Job_Task__c.sObjectType.getDescribe().isDeletable()){
            delete objJobTask;
            return 'ok';
        }
        else{
            return 'Job Task has insufficient access to delete';
        }
    }
    
    @AuraEnabled
    public static List<Tool_Tip__c> getHelpTextrecords() {
        List <Tool_Tip__c> lsthelptxt = [Select Id, Job_Team__c,Schedule__c,Job_Specs__c from Tool_Tip__c WITH SECURITY_ENFORCED];
        return lsthelptxt;
    }
    
    /*************************** Wrapper Class *******************************************/
    /*  Class taskWrapper
{
@AuraEnabled public string color {get;set;}
@AuraEnabled public Job_Task_Role__c jobTaskrole{get;set;}

public taskWrapper(string str,Job_Task_Role__c taskrole)
{
color = str;
jobTaskrole = taskrole ;    
}

@TestVisible public taskWrapper()
{
if(jobTaskrole== NULL)
{
jobTaskrole = new Job_Task_Role__c();
}
if(color == NULL)
{
}

}
}*/
    
    
    
    // This method is called on to marked Done the task
    @AuraEnabled
    public static string assignMarkedDone(String strJTID)
    {
        System.debug('strJTID is'+strJTID);
        Job_Task__c objJT=[Select id,Marked_Done__c,Completion_Date__c,Status__c,Job__c from Job_Task__c where id =:strJTID WITH SECURITY_ENFORCED];
        if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){objJT.Marked_Done__c=True;}
        if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){objJT.Completion_Date__c=System.Today();}
        if(Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()){ objJT.Status__c='Completed';}
        try
        {
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update objJT;
                return 'OK';
            }
            else{
                return 'Tasks has insufficient access to update';
            }
        }
        catch(Exception e){
            return ''+e.getMessage();
        }
    }
    // End of method assignMarkedDone
    
    
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
    public static string updateScheduleOnDays(String jobId, String taskId1,String days1,String updateRestScheduleDays)
    {
        Set<Date> holidaysNew= new Set<Date>();
        
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
                objTask1.Days__c = newDaysValue;}
            
            if(blnFroward)
            {
                if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){objTask1.Revised_Due_Date__c = afterDaysUpdate; }  
            }
            else
            {
                if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){objTask1.Start_Date__c = afterDaysUpdate;  }
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update objTask1;}
            if(String.valueOf(updateRestScheduleDays) == 'true')
            {
                
                // Update the current Task Revised Due Date and Days                  
                
                // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current Job
                List<Job_Task__c> lstTaskBelow ;
                
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
                    update lstTaskBelow;}
                System.debug('Updated Task : '+lstTaskBelow);
                System.debug('Size of Task : '+lstTaskBelow.size());
                
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
                
                List<Job_Task__c> lstJobTasks ;//= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                
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
                            lstJobTasks[i].Start_Date__c = startDateForNextTask;}
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
                    update lstJobTasks;}
                System.debug('Updated List : '+lstJobTasks);
            }
        }
        catch(Exception e){
            return ''+e.getMessage();
        }
        return 'OK';
    }
    
}