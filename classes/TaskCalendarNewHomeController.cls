global with sharing class TaskCalendarNewHomeController{
/*
   transient public list<String> mts = new list<String>();
   transient public list<calEvent> events {get;set;}
   transient Public string strJobName{get;set;}
   transient public string strCampaignName{get;set;}
   transient public string strClientName{get;set;}
   transient public List<string> strstaff{get;set;}
   transient public List<string> strrole{get;set;}
   transient Public string JobStatusString {get;set;}
   transient Public list<Job_Task__c> jobTask{get;set;}
   transient Public string  soqlJobTask{get;set;}
   transient Public map<integer,string> colormap{get;set;}
   transient public boolean Task{get;set;}
   public String strGetUserName,strName;
   public map<id,integer> jobcolormap{get;set;}
   Public String regExp = '["\']';
 
     
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE- yyyy d MMM HH:mm:ss z';
     
    // moment().format();
     
    //constructor
    public TaskCalendarNewHomeController() 
    {
        strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];
        strName=u.Name;
    
         colormap=new map<integer,string>();
         jobcolormap = new map<id,integer>();
        strstaff = new List<string>();
        strrole= new List<string>();
        jobtask();
        
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
   public PageReference JobTask() 
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
      
      integer i=0;
        
      
         jobTask= new List<Job_Task__c>();
         Date myDate = system.today();
         String Active= 'Active';
         String Fal='false';
         string jobTaskid = ApexPages.currentPage().getParameters().get('id');
         string namecheck = '%'+strName+'%';
          soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Next_Task_Due__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where Job__r.status__c=:Active and marked_done__c=false and Assigned_Users__c like :namecheck ';
       
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
            
        
       // integer i=0;
        
        
     Map<Id,String> jobStringMap=new Map<Id,String>(); 
       
       if(jobTask.size() > 0)
       {
           
            for(Job_Task__c  jobt: jobTask)
            {
                if(jobt.Assigned_Users__c.containsignorecase(strName))
                {
                 
                    strCampaignName  = jobt.Job__r.campaign__r.name;
                    JobStatusString  = jobt.Job__r.status__c;
                    strClientName  = jobt.Job__r.JS_Client__r.name;
                    strJobName  = jobt.Job__r.Name;
                   
                   DateTime endDT = jobt.Revised_Due_Date__c+1;
                   
                       calEvent J = new calEvent();
                       
                       string strTaskName = jobt.Name;
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
                     //  J.url = '/' + jobt.Job__c;
                       if(UserInfo.getUiTheme() == 'Theme4d'){
                           J.url = '/one/one.app#/alohaRedirect/apex/JobdetailpageLightening07?id='+jobt.Job__c+'&section=schedules';
                       }
                       else{
                           J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                       }
                           String TaskCampname = jobt.Job__r.campaign__r.name; 
                                //String regExp = '["\']';
                                if(TaskCampname != NULL)
                                    TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                                
                                String TaskJobname = jobt.Job__r.Name; 
                                //String regExp = '["\']';
                                if(TaskJobname != NULL)
                                    TaskJobname = TaskJobname .replaceAll(regExp, '\\ ');
                       
                       j.JN1 = TaskCampname  +' : '+TaskJobname +'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                      
                               String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                                    //String regExp = '["\']';
                                    if(TaskJobCliname != NULL)
                                    TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                       j.client1 = TaskJobCliname ;
                       
                       //j.color=colormap.get(i);
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
                                    //String regExp = '["\']';
                                    if(TaskUsersname != NULL)
                                    TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                       j.Staff= TaskUsersname;
                       J.className = 'event-Jobs';
                       
                       
                       
                      //if(!jobStringMap.containsKey(jobt.Job__c) && jobt.Next_Task_Due__c==true){
                      //  jobStringMap.put(jobt.job__c,jobt.Job__r.Name);
                         events.add(J);
                     //}
           
           }
           if(i == 100)
                   i=0;
                else
                   i++;
         }
       }
       else
       {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'There are no Tasks to display on Calendar'));
       }
       return null;      
   } 
    
     
   
    
   public PageReference printcal() 
   {
       PageReference pageRef = new PageReference('/apex/calendarprint');
       return pageref;

   
   }
 
*/ 
 @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate,string jn) 
    {
       
      /* list<Campaign__c> campList = new list<Campaign__c>();
       list<job__c> jobList = new  list<job__c>();
       String id1 = cntid.Substring(cntid.length()-18,cntid.length());
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
    
       // if(Schema.sObjectType.Job_Task__c.isCreateable() && Schema.sObjectType.Job_Task__c.isUpdateable() ){ 
      
            if(Schema.sObjectType.Job_Task__c.isUpdateable()) {
                //upsert jobtask; 
                update   jobtask;
            }
       */
       
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
        public String className {get;set;}
    }*/
}