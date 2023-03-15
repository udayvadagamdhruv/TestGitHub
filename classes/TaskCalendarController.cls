global with sharing class TaskCalendarController {
   /* 
    public list<String> mts = new list<String>();
    public list<calEvent> events {get;set;}
    Public string strJobName{get;set;}
    public string strCampaignName{get;set;}
    public string strClientName{get;set;}
    public List<string> strstaff{get;set;}
    public List<string> strrole{get;set;}
    Public string JobStatusString {get;set;}
    Public list<Job_Task__c> jobTask{get;set;}
    Public string  soqlJobTask{get;set;}
    Public map<integer,string> colormap{get;set;}
    public boolean Task{get;set;}
    Public String regExp = '["\']';
    Public string CalDD {set;get;}
    
    public Job_Task__c EditTask {set;get;} 
    public boolean isPopup {set;get;}
    
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE- yyyy d MMM HH:mm:ss z';
    
    // moment().format();
    
    
    
    
    //constructor
    public TaskCalendarController () 
    {   CalDD='';
     isPopup=false;
     EditTask=new Job_Task__c();
     colormap=new map<integer,string>();
     strstaff = new List<string>();
     strrole= new List<string>();
     JobTask();
     
     // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'loading calender'));
     
    }
    
    
    // This method is used to get Staff Records 
    /*   public List<SelectOption> getStaff()
{
string jobTaskid = ApexPages.currentPage().getParameters().get('id');
List<SelectOption> StaffoptionList = new List<selectOption>();

// StaffoptionList.add(new selectOption('', '- None -'));  
for (Job_Task__c a : [Select Id,Name,Job__c,Assigned_Users__c from Job_Task__c where Job__r.status__c<>:'completed' and Job__c=:jobTaskid ]) 
{  
StaffoptionList.add(new selectOption(a.Assigned_Users__c , a.Assigned_Users__c ));    
}
return StaffoptionList;  
}   
// End of method getStaff


// This method is used to get Roles Records 
public List<SelectOption> getRole()
{
string jobTaskid = ApexPages.currentPage().getParameters().get('id');
List<SelectOption> RoleoptionList = new List<selectOption>();

//  RoleoptionList .add(new selectOption('', '- None -'));  
for (Job_Task__c a : [Select Id,Name,Job__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c<>:'completed' and Job__c=:jobTaskid and Schedule_Roles__c <>:NULL]) 
{  
RoleoptionList.add(new selectOption(a.Schedule_Roles__c , a.Schedule_Roles__c ));    
}
return RoleoptionList;  
}   
// End of method getRloes

    //Get Task
    public void JobTask() 
    {
        Task=true;
        
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
        
        
        events = new list<calEvent>();
        
        
        
        
        
        jobTask= new List<Job_Task__c>();
        Date myDate = system.today();
        String completed = 'completed';
        string jobTaskid = ApexPages.currentPage().getParameters().get('id');
        soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c<>:completed';
        
        if(jobTaskid !=Null )
            soqlJobTask+=' And Job__c=:jobTaskid';
        /*    if(strCampaignName!=Null)
soqlJobTask+=' And Job__r.campaign__r.name=:strCampaignName';

if(JobStatusString !=Null)
soqlJobTask+=' And Job__r.status__c=:JobStatusString ';

if(strClientName !=Null && strClientName.size()>0)
soqlJobTask+=' And Job__r.JS_Client__r.name =:strClientName';

if(strstaff !=null && strstaff.size()>0)
soqlJobTask+=' And Assigned_Users__c =:strstaff';

if(strrole!=null && strrole.size()>0)
soqlJobTask+=' And Schedule_Roles__c =:strrole';

if(strJobName !=null && strJobName .size()>0)
soqlJobTask+=' And Job__r.Name =:strJobName';
  
        jobTask=Database.query(soqlJobTask);
        
        
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+jobTask);
        
        //   Joblist=Database.query('select Id, Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,('+soqlJobTask+') from Job__c where status__C<>completed');
        
        
        //  integer i=0;
        
        
        
        if(jobTask.size() > 0)
        {
            for(Job_Task__c  jobt: jobTask)
            {
                
                strCampaignName = jobt.Job__r.campaign__r.name;
                JobStatusString  = jobt.Job__r.status__c;
                strClientName  = jobt.Job__r.JS_Client__r.name;
                strJobName  = jobt.Job__r.Name;
                DateTime endDT = jobt.Revised_Due_Date__c+1;
                //DateTime staDt = jobt.Start_Date__c+1;
                
                //System.debug('=======staDt with format==TaskName'+jobt.Name+'==Date=='+staDt);
                //System.debug('=======staDt with format==TaskName'+jobt.Name+'==Date=='+staDt.format());
                //System.debug('=======staDt with format==TaskName'+jobt.Name+'==Date=='+endDt);
                //System.debug('=======staDt with format==TaskName'+jobt.Name+'==Date=='+endDt.format());
                calEvent J= new calEvent();
                
                string strTaskName =jobt.Name;
                string strJobName = jobt.Job__r.Name;
                String Taskname = jobt.Name; 
                //String regExp = '["\']';
                if(Taskname  != NULL)
                    Taskname = Taskname .replaceAll(regExp, '\\ ');
                J.title = Taskname +', Job - # '+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                J.titleNew = Taskname +' - '+jobt.Job__r.Job_Auto_Number__c;
                J.allDay = true;
                J.startString = endDT.format();
                J.endString = endDT.format();
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
                //String regExp = '["\']';
                if(TaskCampname != NULL)
                    TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                
                String TaskJobname = jobt.Job__r.Name; 
                //String regExp = '["\']';
                if(TaskJobname != NULL)
                    TaskJobname = TaskJobname .replaceAll(regExp, '\\ ');
                
                j.JN1 = TaskCampname +' : '+TaskJobname +'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                //String regExp = '["\']';
                if(TaskJobCliname != NULL)
                    TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                j.client1 = TaskJobCliname ;
                // j.color=colormap.get(15);
                //j.color = 'green';
                j.status=jobt.Status__c;
                
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
                    j.color = 'Orange';
                }
                
                String TaskUsersname = jobt.Assigned_Users__c; 
                //String regExp = '["\']';
                if(TaskUsersname != NULL)
                    TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                j.Staff= TaskUsersname ;
                J.className = 'event-Jobs';
                events.add(J);
                
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'There are no Tasks to display on Calendar'));
        }
        //return null;      
    } 
    
    
    
    
    public PageReference printcal() 
    {
        PageReference pageRef = new PageReference('/apex/calendarprint');
        return pageref;
        
        
    }
    
    
    public void calenderTaskEdit(){
        
        isPopup=true;
        String CalTaskId=Apexpages.CurrentPage().getParameters().get('CalTaskId');
        system.debug('=======CalTaskId======'+CalTaskId);
        EditTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:CalTaskId WITH SECURITY_ENFORCED];
    }
    
    public void CaleEditSave(){
        try{
            if(EditTask.Status__c=='Completed')
            {
                if(EditTask.Completion_Date__c == Null)
                {
                    if(schema.SobjectType.Job_Task__c.Fields.Completion_Date__c.isUpdateable()){ 
                        EditTask.Completion_Date__c=System.Today();}
                }
                 if(schema.SobjectType.Job_Task__c.Fields.Marked_Done__c.isUpdateable()){ 
                     EditTask.Marked_Done__c=True;}
                // objJobTask.Completion_Date__c=System.Today();
            }
            else if(EditTask.Status__c=='Active'||EditTask.Status__c=='Requested')
            {
               if(schema.SobjectType.Job_Task__c.Fields.Marked_Done__c.isUpdateable()){ 
                   EditTask.Marked_Done__c=False;}
               if(schema.SobjectType.Job_Task__c.Fields.Completion_Date__c.isUpdateable()){ 
                   EditTask.Completion_Date__c=NULL;}
            }
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){ 
                update EditTask;}
            CalDD= DateTime.newInstance(EditTask.Revised_Due_Date__c.year(),EditTask.Revised_Due_Date__c.month(),EditTask.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
            
        }
        
        
        
        catch(System.DmlException e){
            //return null;
        }
        
        JobTask();
        isPopup=false;
        //return null;
        
    }
    
    
    public void statusChangeUpdate(){
        String DTaskId=Apexpages.CurrentPage().getParameters().get('DTaskId');
        String DTaskStatus=Apexpages.CurrentPage().getParameters().get('DTaskStatus');
        
        try{
            Job_Task__c JStatusUpdate=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:DTaskId WITH SECURITY_ENFORCED];
            
            if(JStatusUpdate.Status__c=='Completed' && JStatusUpdate.Completion_Date__c!=null ){
                if(schema.SobjectType.Job_Task__c.Fields.Status__c.isUpdateable()){ 
                    JStatusUpdate.Status__c='Active';}
                if(schema.SobjectType.Job_Task__c.Fields.Completion_Date__c.isUpdateable()){ 
                    JStatusUpdate.Completion_Date__c=null;}
                if(schema.SobjectType.Job_Task__c.Fields.Marked_Done__c.isUpdateable()){ 
                    JStatusUpdate.Marked_Done__c=false;}
            }
            
            else{
                 if(schema.SobjectType.Job_Task__c.Fields.Status__c.isUpdateable()){
                     JStatusUpdate.Status__c='Completed';}
                 if(schema.SobjectType.Job_Task__c.Fields.Completion_Date__c.isUpdateable()){
                     JStatusUpdate.Completion_Date__c=System.Today();}
                if(schema.SobjectType.Job_Task__c.Fields.Marked_Done__c.isUpdateable()){
                    JStatusUpdate.Marked_Done__c=true;}
            }
            update JStatusUpdate;
            CalDD= DateTime.newInstance(JStatusUpdate.Revised_Due_Date__c.year(),JStatusUpdate.Revised_Due_Date__c.month(),JStatusUpdate.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
        }
        
        Catch(System.DMLException e){
            
        }
        JobTask();
    }
    
    
    public void TaskDueDateUpdate(){
        String DCalTaskId=Apexpages.CurrentPage().getParameters().get('DCalTaskId');
        String DcalDueDate=Apexpages.CurrentPage().getParameters().get('DcalDueDate');
        System.debug('========Due date for the event Drip=========='+DcalDueDate);
        integer syear = integer.valueof(DcalDueDate.substring(0,4));
        integer smonth = integer.valueof(DcalDueDate.substring(5,7));
        integer sday = integer.valueof(DcalDueDate.substring(8,10));
        Date sd = Date.newInstance(syear,smonth,sday);
        
        try{
            Job_Task__c DueDateUpdate=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:DCalTaskId WITH SECURITY_ENFORCED];
            if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){ 
                DueDateUpdate.Revised_Due_Date__c=sd;
            }
            CalDD= DateTime.newInstance(DueDateUpdate.Revised_Due_Date__c.year(),DueDateUpdate.Revised_Due_Date__c.month(),DueDateUpdate.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update DueDateUpdate;}
        }
        
        catch(System.DMLException e){
            
        }
        JobTask();
    }
    
    
    public void CalEditCancel(){
        JobTask();
        isPopup=false;
        //JobTask();
    }
    */
    
    
    
    @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate,string jn) 
    {
      /*  
        list<Campaign__c> campList = new list<Campaign__c>();
        list<job__c> jobList = new  list<job__c>();
        // String id1 = cntid.Substring(cntid.length()-18,cntid.length());
        //System.debug('==cntid==='+cntid);
        
        // System.debug('==Id1==='+id1);
        Campaign__c cam = new Campaign__c();
        integer eyear = integer.valueof(endate.substring(0,4));
        integer emonth = integer.valueof(endate.substring(5,7));
        integer eday = integer.valueof(endate.substring(8,10));
        
        integer syear = integer.valueof(stdate.substring(0,4));
        integer smonth = integer.valueof(stdate.substring(5,7));
        integer sday = integer.valueof(stdate.substring(8,10));
        //  Date ed = Date.newInstance(eyear,emonth,eday-1);
        // Date sd = Date.newInstance(syear,smonth,sday-1);
        
        //if(name.Substring(name.length()-8,name.length()) == 'campaign' )
        
        System.debug('::::::::::::::Hello before IF::::::::::::::::::::'+name.substring(0, 11));
        
        // name.substring(0, 11) != 'JS Campaign'
        // name.Substring(0,3) != 'Job'
        
        System.debug(':::::::::::::Entered:::::::::::::::'+name.substring(0, 11));
        Date sd = Date.newInstance(syear,smonth,sday);
        Date ed = Date.newInstance(eyear,emonth,eday-1);
        String taskID = jn.Substring(jn.indexof('id=')+3,jn.indexof('id=')+3+18);
        system.debug('<<<<<<<<<Task ID is>>>>>>>>>>>>>>>>>>>'+taskID);
        Job_Task__c jobTask= new Job_Task__c();
        jobTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID WITH SECURITY_ENFORCED];
        
        if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
            jobTask.Revised_Due_Date__c = sd;
        }
        
        if(Schema.sObjectType.Job_Task__c.isUpdateable() ){ 
            update jobtask;   
        }*/
       
        return true;
        
    }
    
    
    
    /*
    
    //Class to hold calendar event data
    public class calEvent
    {
        public string titleNew {get;set;}
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public string color{get;set;}
        public String JN1{get;set;} //jobnumber
        public String client1{get;set;}
        public String Staff{get;set;} // used for assigning task staff and used for assigning campaign of the job
        public string TaskId {set;get;}
        public string status  {set;get;}
        public String className {get;set;}
    }*/
}