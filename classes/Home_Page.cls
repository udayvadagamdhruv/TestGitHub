public with sharing class Home_Page {
    
    @AuraEnabled 
    public static Boolean getisAccessable()
    {
        // TS custom setting 
        boolean ShowJobTimeTab,isAccessTS;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowJobTimeTab= activeSettings.TS_Entry_Button__c;
        isAccessTS=(Schema.sObjectType.Timesheet_Entries__c.isAccessible() && ShowJobTimeTab);
        return isAccessTS;
    }
    
    @AuraEnabled 
    public static string getObjectFieldLabels(list<String> ObjNames){
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
    /************************************************** My Home page Jobs ***********************************************/
    
    @AuraEnabled
    public static list<String> fetchPicklistvalues(){
        list<String> Options=new list<String>();
        List<Schema.PicklistEntry> Picklist=Job__c.Status__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry Op:Picklist){
            Options.add(Op.getValue());
        }
        return Options;
    } 
    
    //Get Total Number of Job Records
    @AuraEnabled
    public static Integer getTotalJobRecords(String JobStatusString){
        string userName;
        userName=UserInfo.getname();
        
        list<Job_Team__c> TeamList=new list<Job_Team__c>();
        Set <Id> stJobId=new Set<Id>();
        
        TeamList = [select Name, Staff__c,Job__c from Job_Team__c where Staff__c = : userName and job__r.status__C = : jobstatusstring WITH SECURITY_ENFORCED];
        
        for( Job_Team__c jteam : TeamList)
        {
            stJobId.add(jteam.Job__c);
            system.debug('***job******'+stJobId);
        }
        
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Job__c  where Id IN:stJobId and status__C = : jobstatusstring WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    public Class jobsWrapper
    {
        @AuraEnabled  public Job__c job {get;set;}
        @AuraEnabled  public Job_Task__c task{get;set;}        
        @AuraEnabled  public string jobNo{get; set;}
        @AuraEnabled  Public string Client{get; set;}
        @AuraEnabled  public string jobId{get; set;}
        @AuraEnabled  public string jobName{get; set;}
        @AuraEnabled  public string clientDisplay{get; set;}
        @AuraEnabled  public Date jobDuedate{get; set;}
        @AuraEnabled  public Date jobtaskDuedate{get; set;} 
        @AuraEnabled  public Job_Task__c jobTasks{get;set;}
        @AuraEnabled  public string taskId{get; set;}
        @AuraEnabled  public string taskName{get; set;}        
        @AuraEnabled  public string status{get; set;}
        
        @AuraEnabled public string date1{get; set;}
        @AuraEnabled public string date2{get; set;}        
        
        public JobsWrapper()
        {
            if(jobTasks== NULL){jobTasks = new Job_Task__c();}
            if(job == NULL){job = new Job__c();}
            
        } 
    } 
    
    @AuraEnabled
    public static list<jobsWrapper> getMyJobData(String JobStatusString){
        
        
        list<Job__c> joblist=new list<Job__c>();
        list<Job_Task__c> TaskList=new list<Job_Task__c>();
        List <Job_Task__c> jobTasks=new list<Job_Task__c>();
        list<Job_Task_Role__c> RoleList=new list<Job_Task_Role__c>();
        list<Job_Team__c> TeamList=new list<Job_Team__c>();
        list<jobsWrapper> jWrapper=new list<jobsWrapper>();
        //String JobStatus;
        string userName;
        
        Set <Id> stJobId=new Set<Id>();
        userName=UserInfo.getname();
        system.debug('********'+userName);
        TeamList = [select Name, Staff__c,Job__c from Job_Team__c where Staff__c = : userName and job__r.status__C = : jobstatusstring WITH SECURITY_ENFORCED];
        
        for( Job_Team__c jteam : TeamList)
        {
            stJobId.add(jteam.Job__c);
            system.debug('***job******'+stJobId);
        }
        
        joblist = [select Name,Job_Auto_Number__c,JS_Client__c, Status__c,Due_Date__c,Start_Date__c,JS_Client__r.Name from Job__c  where Id IN:stJobId and status__C = : jobstatusstring WITH SECURITY_ENFORCED];
        
        system.debug('***job list count ******'+joblist.size());
        
        jWrapper = new List<jobsWrapper>();
        //Map <Id,List<Job_Task__c>> totalJobTasksMap = new Map<Id,List<Job_Task__c>>();
        Map <Id,Job_Task__c> mapTask = new Map<Id,Job_Task__c>();
        
        List <Job_Task__c> jTask = [select Id,Name,Revised_Due_Date__c,Job__r.Name,Job__r.Id, (SELECT Id, Name, Job_Task__c, User__c, Email__c, Task_Final_Due__c FROM Job_Task_Roles__r where User__c=:userName ) from Job_Task__c where Job__r.Id IN: stJobId and Marked_Done__c =: false WITH SECURITY_ENFORCED order by  Job__r.id, Revised_Due_Date__c,Task_order__c ];
        system.debug('******JTask********'+jTask);
        integer cnt;
        id vjobId; 
        
        /*  for(Job_Task__c objobtask:jTask)
{
if(!totalJobTasksMap.containsKey(objobtask.Job__r.Id)){
totalJobTasksMap.put(objobtask.Job__r.Id,new List<Job_Task__c>{objobtask});
}
else{
List<Job_Task__c> addedList=totalJobTasksMap.get(objobtask.Job__r.Id);
addedList.add(objobtask);
totalJobTasksMap.put(objobtask.Job__r.Id,addedList);
}
}
*/
        for(Job_Task__c objobtask:jTask)
        {
            system.debug('***Role of the Tasks***'+objobtask.Job_Task_Roles__r);
            system.debug('***mapTask***'+objobtask.Job__r.Id);
            
            if(!mapTask.containskey(objobtask.Job__r.Id))
            {  
                //if(objobtask.Job_Task_Roles__r.size()>0){
                mapTask.put(objobtask.Job__r.Id,objobtask);
                //}
            }
            
        }
        
        /* for(Job_Task__c objobtask:jTask)
{

if(!mapTask.containskey(objobtask.Job__r.Id))
{  
mapTask.put(objobtask.Job__r.Id,totalJobTasksMap.get(objobtask.Job__r.Id)[0]);
}

}
*/
        
        
        
        
        cnt = mapTask.size();
        system.debug('***Mapsize**'+cnt);
        
        jWrapper = new List<jobsWrapper>();
        for(Job__c jb:joblist)
        {
            //add the job and the task to the wrapper;
            
            Job_Task__c tsk = new Job_Task__c(); 
            
            tsk= (mapTask.get(jb.id));
            if(tsk != null){
                
                if(tsk.Revised_Due_Date__c != null){
                    
                    JobsWrapper jobWrap = new JobsWrapper();
                    jobWrap.job = jb;
                    jobWrap.task = tsk;
                    jobWrap.jobTasks= mapTask.get(jb.id);         
                    
                    jobWrap.jobId = jb.Id;//.toLowerCase();
                    jobWrap.jobName = jb.Name;//.toLowerCase();
                    jobWrap.jobNo = jb.Job_Auto_Number__c;
                    
                    if(jb.JS_Client__r.Name != null){
                        jobWrap.Client = jb.JS_Client__r.Name;
                        jobWrap.clientDisplay = jb.JS_Client__r.Name;
                    }else{
                        jobWrap.Client = 'zzzzz';
                        jobWrap.clientDisplay = '';  
                    }
                    jobWrap.status = jb.Status__c;
                    if(jb.Due_Date__c != null){
                        jobWrap.jobDuedate = jb.Due_Date__c;
                    }else{
                        //jobWrap.jobDuedate = jb.Start_Date__c.addYears(10);
                        jobWrap.jobDuedate =null;
                    }       
                    jobWrap.taskId = tsk.Id;//Name.toLowerCase();
                    jobWrap.taskName = tsk.Name;
                    jobWrap.jobtaskDuedate = mapTask.get(jb.id).Revised_Due_Date__c;//tsk.Revised_Due_Date__c;
                    jobWrap.date2 =  zConvert.ToString(mapTask.get(jb.id).Revised_Due_Date__c+1,'MM/dd/yyyy');
                    
                    
                    jobWrap.jobTasks= mapTask.get(jb.id);
                    
                    if(jb.Due_Date__c != null)
                    {
                        jobWrap.date1 =  zConvert.ToString(jb.Due_Date__c+1,'MM/dd/yyyy');
                    }           
                    jWrapper.add(jobWrap );
                }
            }
            else{
                
                JobsWrapper jobWrap = new JobsWrapper();
                jobWrap.job = jb;
                jobWrap.jobId = jb.Id;//.toLowerCase();
                jobWrap.jobName = jb.Name;//.toLowerCase();
                jobWrap.jobNo = jb.Job_Auto_Number__c;
                
                if(jb.JS_Client__r.Name != null){
                    jobWrap.Client = jb.JS_Client__r.Name;
                    jobWrap.clientDisplay = jb.JS_Client__r.Name;
                }else{
                    jobWrap.Client = 'zzzzz';
                    jobWrap.clientDisplay = '';  
                }
                jobWrap.status = jb.Status__c;
                if(jb.Due_Date__c != null){
                    jobWrap.jobDuedate = jb.Due_Date__c;
                    
                }else{
                    //jobWrap.jobDuedate = jb.Start_Date__c.addYears(10);
                    jobWrap.jobDuedate = null;
                }       
                jobWrap.taskName ='';
                
                if(jb.Due_Date__c != null)
                {
                    jobWrap.date1 =  zConvert.ToString(jb.Due_Date__c+1,'MM/dd/yyyy');
                }           
                jWrapper.add(jobWrap );
            }
        }
        return jWrapper;
    } 
    
    
    
    /************************************************************* My Approvals Due ******************************************************************************/
    
    @AuraEnabled
    public static boolean CreateAppStepAtTaskJobTskSetting() {  
        boolean activeCreateProcess;
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        activeCreateProcess=setting.Job_Task_Level__c;
        system.debug('activeCreateProcess===>'+activeCreateProcess);
        return activeCreateProcess;
    }
    
    @AuraEnabled
    public static List<Approval_Job_Task__c> getMyApproveTaskData() {
        
        boolean activeCreateProcess;
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        activeCreateProcess=setting.Job_Task_Level__c;
        
        List<Job__c> lstJob=new List<Job__c>();
        List<Approval_Job_Task__c>rcdlstJT= new List<Approval_Job_Task__c>();
        
        Set<Id> stJobId=new Set<Id>();
        // Set<string> appjbtskids=new Set<string>();
        map<string,Approval_Job_Task_Roles__c>appjbtskids = new map<string,Approval_Job_Task_Roles__c>();
        lstJob=[Select Id,Name from Job__c where Status__c=: 'Active' WITH SECURITY_ENFORCED];
        for(Job__c j:lstJob)
        {
            stJobId.add(j.id);
        }
        list<Approval_Job_Task_Roles__c>approvaltskrole= [Select Id, Name,Approval_Job_Task__c,Approval_Job_Task__r.name,User__c,Approval_Job_Task__r.Status__c from Approval_Job_Task_Roles__c where User__c=:userinfo.getName() and Approval_Job_Task__r.Status__c = 'In Progress'];
        for(Approval_Job_Task_Roles__c approvaltskids : approvaltskrole){
            appjbtskids.put(approvaltskids.Approval_Job_Task__c,approvaltskids);
        }       
        if(activeCreateProcess){
            List<Approval_Job_Task__c> lstJTasklevel=[Select Id,Name,Task__r.Job__c,Task__r.Job__r.Job_Auto_Number__c,Task__r.Job__r.Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Project__c,Project__r.Id,Project__r.Name,Project__r.Job_Auto_Number__c,Task_Order__c,File_Name__c from Approval_Job_Task__c where task__r.Job__c in : stJobId and Status__c=:'In Progress' and Login_User__c=:true WITH SECURITY_ENFORCED Order by Revised_Due_Date__c ];
            for(Approval_Job_Task__c rcd : lstJTasklevel){
                if(appjbtskids.containsKey(rcd.id)){
                    rcdlstJT.add(rcd);
                }
            }
        }
        else
        {
            List<Approval_Job_Task__c> lstJoblevel=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Project__c,Project__r.Id,Project__r.Name,Project__r.Job_Auto_Number__c,Task_Order__c,File_Name__c from Approval_Job_Task__c where Project__c in : stJobId and Status__c=:'In Progress' and Login_User__c=:true WITH SECURITY_ENFORCED Order by Revised_Due_Date__c ];
            for(Approval_Job_Task__c rcd : lstJoblevel){
                if(appjbtskids.containsKey(rcd.id)){
                    rcdlstJT.add(rcd);
                }
            }
        }
        return rcdlstJT;
    }
    
    
    /*************************** Wrapper Class *******************************************/
    /* Class approvaltaskWrapper
{
@AuraEnabled public Approval_Job_Task_Roles__c jobTaskrole{get;set;}

public approvaltaskWrapper(Approval_Job_Task_Roles__c taskrole)
{
jobTaskrole = taskrole ;     
}

@TestVisible public approvaltaskWrapper()
{
if(jobTaskrole== NULL)
{
jobTaskrole = new Approval_Job_Task_Roles__c();
}
}
}*/
    
    /************************************** Get the my Approval task Due records **************************************/
    
    
    /*  @AuraEnabled
public static List<approvaltaskWrapper> getMyApproveTaskData() 
{
String str;
String strJTID;
String strJTID2;
String strGetName;
List<Job__c> lstJob=new List<Job__c>();
List<Approval_Job_Task__c> lstJT;
List<Approval_Job_Task__c> lstJT1;
List<Approval_Job_Task_Roles__c> lstJTR;
Set<Id> stJobId=new Set<Id>();
Set<Id> stJobTaskId=new Set<Id>();
Set<Id> stJobTaskRoleId=new Set<Id>();
Boolean ShowTsEntryButton;

list<approvaltaskWrapper> taskroleWrap =new list<approvaltaskWrapper>();
String strColor;

lstJob=new List<Job__c>();
ProductionEstimate__c activeSettings = ProductionEstimate__c.getOrgDefaults();
ShowTsEntryButton=activeSettings.TS_Entry_Button__c;

String strGetUserName=UserInfo.getUserName();
User u=[Select id,Name from User where Username=: strGetUserName ];//WITH SECURITY_ENFORCED
String strName=u.Name;
lstJob=[Select Id,Name from Job__c where Status__c=: 'Active' WITH SECURITY_ENFORCED];
for(Job__c j:lstJob)
{
stJobId.add(j.id);
}
lstJT=[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c,File_Name__c from Approval_Job_Task__c where Job__c in : stJobId and Status__c=:'In Progress' WITH SECURITY_ENFORCED Order by Revised_Due_Date__c ];

for(Approval_Job_Task__c jt: lstJT)
{
stJobTaskId.add(jt.id);
} 

lstJTR=Database.query('Select Id,Name,Approval_Job_Task__r.Name,Approval_Job_Task__r.Job__r.Name,Approval_Job_Task__r.Revised_Due_Date__c,Approval_Job_Task__r.File_Name__c,Approval_Job_Task__r.Status__c,Approval_Job_Task__r.Task_Order__c,Approval_Job_Task__r.Job__r.Job_Auto_Number__c from Approval_Job_Task_Roles__c where Approval_Job_Task__c IN : stJobTaskId and User__c =: strName WITH SECURITY_ENFORCED order by Approval_Job_Task__r.Revised_Due_Date__c asc');
taskroleWrap = new List<approvaltaskWrapper>();

Map<Id,List<Approval_Job_Task__c>> taskListMap = new Map<Id,List<Approval_Job_Task__c>>(); 
Set<id>  trSet = new  set<id> ();

for(Approval_Job_Task_Roles__c jtr: lstJTR)
{
trSet.add(jtr.Approval_Job_Task__r.Job__r.id);
}

List<Approval_Job_Task__c> ltask1 = [Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,File_Name__c,Status__c,Job__c,Job__r.Name,Task_Order__c,Marked_Done__c from Approval_Job_Task__c where Status__c=:'In Progress' and Job__r.id in:trSet WITH SECURITY_ENFORCED ORDER BY Revised_Due_Date__c];

for(Approval_Job_Task__c jtask: ltask1)
{
if(taskListMap.get(jtask.Job__r.id)!= null)
{
list<Approval_Job_Task__c> lst = taskListMap.get(jtask.Job__r.Id);
lst.add(jtask);
taskListMap.put(jtask.Job__r.Id,lst);
} 
else
{
taskListMap.put(jtask.Job__r.Id,new list<Approval_Job_Task__c>{jtask});
}

}

Map<id,string> newmap=new  Map<id,string>();

for(Approval_Job_Task_Roles__c jtr:lstJTR)
{

List<Approval_Job_Task__c> lstTask = new List<Approval_Job_Task__c>();
if(taskListMap.ContainsKey(jtr.Approval_Job_Task__r.Job__r.id)){
lstTask=taskListMap.get(jtr.Approval_Job_Task__r.Job__r.id);
}

Boolean flagAbove = false;

approvaltaskWrapper taskWrap = new approvaltaskWrapper ();

if(newmap.get(jtr.Approval_Job_Task__r.Job__r.id)==null && !newmap.containskey(jtr.Approval_Job_Task__r.Job__r.id)){
taskWrap.jobTaskrole = jtr;
taskroleWrap.add(taskWrap);
newmap.put(jtr.Approval_Job_Task__r.Job__r.id,jtr.Approval_Job_Task__r.Job__r.name);
}

}
return taskrolewrap;
}*/
    
    
    
    
    /************************************************************* My Task Due ******************************************************************************/
    
    
    /*************************** Wrapper Class *******************************************/
    Class taskWrapper
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
                // color = new String;
            }
            
        }
    }
    
    /************************************** Get the my task Due records **************************************/
    
    
    @AuraEnabled
    public static List<taskWrapper> getMyTaskData(String tasksview) 
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
        
        list<taskWrapper> taskroleWrap =new list<taskWrapper>();
        String strColor;
        
        lstJob=new List<Job__c>();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowTsEntryButton=activeSettings.TS_Entry_Button__c;
        
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName ];//WITH SECURITY_ENFORCED
        String strName=u.Name;
        lstJob=[Select Id,Name from Job__c where Status__c=: 'Active' WITH SECURITY_ENFORCED];
        for(Job__c j:lstJob)
        {
            stJobId.add(j.id);
        }
        lstJT=[Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' and Marked_Done__c=: False WITH SECURITY_ENFORCED Order by Revised_Due_Date__c ];
        
        for(Job_Task__c jt: lstJT)
        {
            stJobTaskId.add(jt.id);
        } 
        
        lstJTR=Database.query('Select Id,Name,Job_Task__r.Name,Job_Task__r.Job__r.Name,Job_Task__r.Revised_Due_Date__c,Job_Task__r.Next_Task_Due__c,Job_Task__r.Status__c,Job_Task__r.Task_Order__c,Job_Task__r.Job__r.Job_Auto_Number__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strName WITH SECURITY_ENFORCED order by Job_Task__r.Revised_Due_Date__c asc'); //Job_Task__r.Revised_Due_Date__c'+' '+ sortDirection + ',' + sortFullExp);
        taskroleWrap = new List<taskWrapper>();
        
        Map<Id,List<Job_Task__c>> taskListMap = new Map<Id,List<Job_Task__c>>(); 
        Set<id>  trSet = new  set<id> ();
        
        for(Job_Task_Role__c jtr: lstJTR)
        {
            trSet.add(jtr.Job_Task__r.Job__r.id);
        }
        
        List<Job_Task__c> ltask1 = [Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c,Marked_Done__c from Job_Task__c where Status__c=:'Active' and Marked_Done__c=: False and Job__r.id in:trSet WITH SECURITY_ENFORCED ORDER BY Revised_Due_Date__c];// and  id IN(Select User__c from Job_Task_Role__c where User__c =: strName) ];
        
        for(Job_Task__c jtask: ltask1)
        {
            if(taskListMap.get(jtask.Job__r.id)!= null)
            {
                list<Job_Task__c> lst = taskListMap.get(jtask.Job__r.Id);
                lst.add(jtask);
                taskListMap.put(jtask.Job__r.Id,lst);
            } 
            else
            {
                taskListMap.put(jtask.Job__r.Id,new list<Job_Task__c>{jtask});
            }
            
        }
        
        Map<id,string> newmap=new  Map<id,string>();
        
        for(Job_Task_Role__c jtr:lstJTR)
        {
            taskWrapper taskWrap = new taskWrapper ();
            if(tasksview=='MyTaskDues'){
                List<Job_Task__c> lstTask = new List<Job_Task__c>();
                if(taskListMap.ContainsKey(jtr.Job_Task__r.Job__r.id)){
                    lstTask=taskListMap.get(jtr.Job_Task__r.Job__r.id);
                    system.debug('the lstTask === '+lstTask+'\n');
                }
                
                Boolean flagAbove = false;
                
                for(Job_Task__c t : lstTask)
                {
                    if(t.task_order__c < jtr.Job_Task__r.Task_Order__c)
                    {
                        flagAbove = true;
                        break;
                    }
                }
                if(flagAbove)
                {
                    strColor = 'Black'; 
                }
                else
                {
                    if(jtr.Job_Task__r.Revised_Due_Date__c < System.today())
                    {
                        strColor= 'Red'; 
                    }
                    else
                    {
                        strColor = 'Green';
                    }
                }
                
                
                
                if(newmap.get(jtr.Job_Task__r.Job__r.id)==null && !newmap.containskey(jtr.Job_Task__r.Job__r.id) && jtr.Job_Task__r.Next_Task_Due__c==true){
                    taskWrap.color = strColor;
                    taskWrap.jobTaskrole = jtr;
                    taskroleWrap.add(taskWrap);
                    newmap.put(jtr.Job_Task__r.Job__r.id,jtr.Job_Task__r.Job__r.name);
                }
            }
            else{
                strColor = 'black';
                taskWrap.color = strColor;
                taskWrap.jobTaskrole = jtr;
                taskroleWrap.add(taskWrap);
                newmap.put(jtr.Job_Task__r.Job__r.id,jtr.Job_Task__r.Job__r.name);
            }
            
        }
        return taskrolewrap;
    }
    
    /***************************************** Task Done Method *******************************************/
    
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
                return 'OK';}
            else{
                return 'Taks has insufficient access to update';
            }
        }
        catch(Exception e){
            return ''+e.getMessage();
        }
        
        
    }
    // End of method assignMarkedDone
    
    /****************************************************************** My Timesheet Section *********************************************************************/
    
    // *************** Display today's date in New TS page *************************/
    @AuraEnabled 
    public static date gettodaydate()
    {
        return system.today();
    }
    
    // *************** Display login user id in New TS page *************************/
    @AuraEnabled 
    public static String getUserName()
    {
        return UserInfo.getUserId();
    }
    
    //Get Total Number of TS
    @AuraEnabled
    public static Integer getTotalRecords(){
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];//WITH SECURITY_ENFORCED
        String strId=u.id;
        
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Timesheet_Entries__c  where CreatedById=:strId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
    /**********************************************Displaying records in the table***************************************************************/
    @AuraEnabled
    public static List<Timesheet_Entries__c> getTsEnty(Integer recordLimit, Integer recordOffset)
    {
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName ];//WITH SECURITY_ENFORCED
        String strId=u.id;
        List<Timesheet_Entries__c> lstTsEntry= [select id,name,Task_Name__c,GL_Code__c,Hours_Worked__c,Date__c ,Job__r.Job_Auto_Number__c,Job__r.Name,CreatedById from Timesheet_Entries__c  where CreatedById=:strId  WITH SECURITY_ENFORCED order by name DESC LIMIT :intLimit Offset :intOffset];
        return lstTsEntry;
    } 
    
    
    /******************************************************** Get the Job Name  ****************************************************************/
    @AuraEnabled
    public Static List<Job__c> getjobName(){
        
        User u=[Select Id, Name from User where id=:UserInfo.getUserID() ];//WITH SECURITY_ENFORCED 
        String strId=u.id;
        string username= '%' + u.Name + '%';
        List<Job_Task__c> objJobTasklist=[Select Id, Name,Assigned_Users__c,Job__c from Job_Task__c where Assigned_Users__c like : username WITH SECURITY_ENFORCED];
        set<id> setjodid = new set<id>();
        
        for(Job_Task__c obj : objJobTasklist){
            setjodid.add(obj.Job__c);
        }
        system.debug('>>>>>>>>>>>>>>>>>>> size >>>>>>>>>>>>>>>>>>>>>>>>>>'+setjodid.size());
        system.debug('>>>>>>>>>>>>>>>>>>> setjodid >>>>>>>>>>>>>>>>>>>>>>>>>>'+setjodid);
        
        List<Job__c> optionList = new  List<Job__c>();        
        optionList=[Select Id, Name, Job_Auto_Number__c from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' and  (CreatedById=:strId or Id In : setjodid) WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc];
        return optionList;  
    }
    
    /******************************************************** Get the Task Name from the related Job ****************************************************************/
    @AuraEnabled
    public Static List<Job_Task__c> getTaskName(Id JobId){
        List<Job_Task__c> optionList = new  List<Job_Task__c>();        
        optionList=[Select Id, Name from Job_Task__c where Job__c =:JobId WITH SECURITY_ENFORCED order by Task_Order__c,CreatedDate ];
        return optionList;  
    }
    
    /******************************************************** Get the GLCODE from the related Task ****************************************************************/
    @AuraEnabled
    public Static List<String> getGLCodeOfTask(Id JobId,string JobTaskNameStr){  
        String GLCodeVal='';string GLCodeId='';
        List<String> GlC=new List<String>();
        if(string.valueof(JobTaskNameStr) <> '' || string.valueof(JobTaskNameStr)!=null){
            
            List<Job_Task__c> objTask = [Select GL_Code__c, GL_Code__r.Name from Job_Task__c  where Name=:JobTaskNameStr and Job__c=:JobId WITH SECURITY_ENFORCED limit 1];
            if(objTask.size()>0){
                for(Job_Task__c objTemp:objTask){
                    if(string.valueof(objTemp.GL_Code__c)<>'' || string.valueof(objTemp.GL_Code__c)<>null){
                        GLCodeId = string.valueof(objTemp.GL_Code__c);
                        GLCodeVal = string.valueof(objTemp.GL_Code__r.Name);
                        
                    }
                    else{
                        GLCodeVal= '';
                    }
                }
                
            }
            else{
                GLCodeVal= '';            
            }   
        }
        else{
            GLCodeVal = '';
        }
        GlC.add(GLCodeId);GlC.add(GLCodeVal);
        return GlC;
    }
    /******************************************************* Get the Total Hours from the GLCODE related Estimate/PE ****************************************************/
    @AuraEnabled
    public Static  Decimal getTotalHours(string JobNameStr,string GLCode){  
        system.debug('gl code id -- '+GLCode);
        system.debug('job value -- '+JobNameStr );
        
        Decimal TaskTotalHr = 0.00; 
        String GLCodeVal=GLCode; 
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
        
        if(ShowProductionEstimate){
            if(String.valueof(GLCodeVal)<>'' || String.valueof(GLCodeVal)<>null){            
                List<Production_Estimate__c> objPES= [select Quantity__c from Production_Estimate__c  where Job__c=:JobNameStr and GL_Code__c=:GLCode WITH SECURITY_ENFORCED];
                system.debug('Production estimate -- '+ objPES);
                if(objPES.size()>0)
                {
                    for(Production_Estimate__c  objTemp:objPES){
                        if(objTemp.Quantity__c <> null ){
                            TaskTotalHr = TaskTotalHr + objTemp.Quantity__c; 
                        }
                        else{
                            TaskTotalHr = 0.00; 
                        }
                    }
                }
                else{
                    TaskTotalHr=0.00;
                }
            }
            else{
                TaskTotalHr=0.00;
            }
            
            return TaskTotalHr;
            
        }
        else{
            
            if(String.valueof(GLCodeVal)<>'' || String.valueof(GLCodeVal)<>null){            
                List<Estimate_Line_Items__c> objES = [select Quantity__c from Estimate_Line_Items__c where Job__c=:JobNameStr and GL_Code__c=:GLCode WITH SECURITY_ENFORCED];
                system.debug('estimate -- '+ objES);
                if(objES.size()>0)
                {
                    for(Estimate_Line_Items__c objTemp:objES){
                        if(objTemp.Quantity__c <> null ){
                            TaskTotalHr = TaskTotalHr + objTemp.Quantity__c; 
                        }
                        else{
                            TaskTotalHr = 0.00; 
                        }
                    }
                }
                else{
                    TaskTotalHr=0.00;
                }
            }
            else{
                TaskTotalHr=0.00;
            }
            return TaskTotalHr;
            
        }  
    }
    
    /******************************************************* Get the Remaining Hours ****************************************************/
    
    @AuraEnabled
    public Static Decimal getRemainHours(string JobNameStr,string GLCodeId, Decimal TaskTotalHr){ 
        Decimal dHrsRem;           
        decimal remaininghours;
        system.debug('gl code'+GLCodeId);
        dHrsRem  = 0.00;
        
        List<Timesheet_Entries__c> objTsHead  = [select id,Hours_Worked__c,GL_Code__c from Timesheet_Entries__c where Job__c =:JobNameStr and GL_Code__c=:GLCodeId WITH SECURITY_ENFORCED];
        
        system.debug('timesheet size'+objTsHead);
        
        if(objTsHead.size()>0 && TaskTotalHr!=0.00) {
            for(Timesheet_Entries__c  objTemp:objTsHead){
                
                if(objTemp.Hours_Worked__c<> null  ){
                    dHrsRem = dHrsRem +objTemp.Hours_Worked__c; 
                }
                else{
                    dHrsRem  = 0.00; 
                }
                
            }
        }
        else{
            dHrsRem = 0.00;
        }
        
        if(dHrsRem!=0.00){
            remaininghours=TaskTotalHr-dHrsRem;
            return remaininghours;
        }
        else{
            remaininghours=dHrsRem;
            return remaininghours;
        }      
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
                
                return 0.00;
            }
        }
        else return 0;
    }
    
    @AuraEnabled
    public static list<HomeEvent> getMyDueTasksOnCalender(String tasksview){
        
        
        list<HomeEvent> events=new list<HomeEvent>();
        
        User u=[Select id,Name from User where Id=:UserInfo.getUserId()];// WITH SECURITY_ENFORCED
        String strName=u.Name;
        String regExp = '["\']';
        Map<Integer,String> colormap = new Map<Integer,String>();
        Map<Id,Integer> jobcolormap = new Map<Id,Integer>();
        List<String> strstaff = new List<String>();
        List<String>  strrole= new List<String>();
        
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
        
        integer i=0;
        
        List<Job_Task__c> jobTask= new List<Job_Task__c>();
        Date myDate = system.today();
        String Active= 'Active';
        String Fal='false';
        string namecheck = '%'+strName+'%';
        String soqlJobTask='Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Next_Task_Due__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false and Assigned_Users__c like :namecheck ';
        
        if(tasksview=='MyTaskDues'){
            soqlJobTask+=' And Next_Task_Due__c=true';  
        }
        soqlJobTask +='  WITH SECURITY_ENFORCED';
        
        jobTask=Database.query(soqlJobTask);
        
        Map<Id,String> jobStringMap=new Map<Id,String>(); 
        
        if(jobTask.size() > 0)
        {
            
            for(Job_Task__c  jobt: jobTask)
            {
                if(jobt.Assigned_Users__c.containsignorecase(strName))
                {
                    
                    String strCampaignName  = jobt.Job__r.campaign__r.name;
                    String JobStatusString  = jobt.Job__r.status__c;
                    String strClientName  = jobt.Job__r.JS_Client__r.name;
                    String strJobName  = jobt.Job__r.Name;
                    DateTime StrDT = jobt.Start_Date__c+1;
                    DateTime endDT = jobt.Revised_Due_Date__c+2;
                    
                    HomeEvent J = new HomeEvent();
                    
                    string strTaskName = jobt.Name;
                    String Taskname = jobt.Name; 
                    //String regExp = '["\']';
                    if(Taskname  != NULL)
                        Taskname = Taskname .replaceAll(regExp, '\\ ');
                    
                    J.title = Taskname +', Job - # '+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                    J.titleNew = Taskname +' - '+jobt.Job__r.Job_Auto_Number__c;
                    J.allDay = true;
                    J.Url='/'+jobt.Job__r.Id;
                    J.startString = StrDT.format();
                    J.endString = endDT.format();
                    //  J.url = '/' + jobt.Job__c;
                    /*   if(UserInfo.getUiTheme() == 'Theme4d'){
J.url = '/one/one.app#/alohaRedirect/apex/JobdetailpageLightening07?id='+jobt.Job__c+'&section=schedules';
}
else{
J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
}
*/
                    String TaskCampname = jobt.Job__r.campaign__r.name; 
                    if(TaskCampname != NULL)
                        TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                    
                    String TaskJobname = jobt.Job__r.Name; 
                    if(TaskJobname != NULL)
                        TaskJobname = TaskJobname .replaceAll(regExp, '\\ ');
                    
                    j.JN1 = TaskCampname  +' : '+TaskJobname +'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                    String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                    if(TaskJobCliname != NULL)
                        TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                    j.client1 = TaskJobCliname ;
                    if(jobcolormap.containskey(jobt.job__r.id))
                    {
                        integer n = jobcolormap.get(jobt.job__r.id);
                        j.color=colormap.get(n);
                    }
                    else
                    {
                        jobcolormap.put(jobt.job__r.id,i);
                        j.color=colormap.get(i);
                    }
                    
                    String TaskUsersname = jobt.Assigned_Users__c; 
                    if(TaskUsersname != NULL)
                        TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                    j.Staff= TaskUsersname;
                    J.className = 'event-Jobs';
                    
                    events.add(J);
                }
                if(i == 100)
                    i=0;
                else
                    i++;
            }
        }
        else
        {
            return null;// there are no task on the calender.
        }
        System.debug('=========finallized events======'+events);
        return events;
    }
    
    public class HomeEvent
    {
        @AuraEnabled public string titleNew {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public string Url {get;set;} 
        @AuraEnabled public Boolean allDay {get;set;}
        @AuraEnabled public String startString {get;set;}
        @AuraEnabled public String endString {get;set;}
        @AuraEnabled  public string color{get;set;}
        @AuraEnabled  public String JN1{get;set;} //jobnumber
        @AuraEnabled public String client1{get;set;}
        @AuraEnabled public String Staff{get;set;} // used for assigning task staff and used for assigning campaign of the job
        @AuraEnabled public String className {get;set;}
    } 
    
    @AuraEnabled
    public static String TaskDueDateUpdateFromHomePage(String strdate,String enddate,String JN){
        try{
            integer eyear = integer.valueof(enddate.substring(0,4));
            integer emonth = integer.valueof(enddate.substring(5,7));
            integer eday = integer.valueof(enddate.substring(8,10));
            
            integer syear = integer.valueof(strdate.substring(0,4));
            integer smonth = integer.valueof(strdate.substring(5,7));
            integer sday = integer.valueof(strdate.substring(8,10));
            
            
            Date sd = Date.newInstance(syear,smonth,sday);
            Date ed = Date.newInstance(eyear,emonth,eday)-1;
            String taskID;
            if(!Test.isRunningTest()){ 
                taskID = JN.Substring(jn.indexof('id=')+3,jn.indexof('id=')+3+18);
            }
            else{
                taskID=JN;
            }
            
            
            system.debug('<<<<<<<<<Task ID is>>>>>>>>>>>>>>>>>>>'+taskID);
            Job_Task__c jobTask= new Job_Task__c();
            jobTask=[Select Id,Name,Start_Date__c,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID WITH SECURITY_ENFORCED];
            if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable() ){
                jobTask.Start_Date__c = sd;
            }
            if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable() ){
                jobTask.Revised_Due_Date__c = ed;
            }
            
            
            //jobTask.Name='Sugunakar';
            if(schema.SobjectType.Job_Task__c.isUpdateable() ){ 
                //upsert jobtask;
                update jobtask;return 'OK';
            }
            else{
                return 'Task has insufficient access to update';
            }
        }
        Catch(System.DmlException e){
            return ''+e.getMessage();
        }
        
    }
}