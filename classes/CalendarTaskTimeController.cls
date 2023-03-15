global with sharing class CalendarTaskTimeController
{
/*    
   // public list<String> mts = new list<String>();
    public Boolean includeMyJobs {get;set;}
    public list<calEvent> events {get;set;}
    transient Public List<string> strJobName{get;set;}
    public list<string> strCampaignName{get;set;}
    transient public List<string> strClientName{get;set;}
    Public string StatusString {get;set;}
    public List<string> strstaff{get;set;}
    public List<string> strstafftemp{get;set;}
    public List<string> strrole{get;set;}
    public List<string> strroletemp{get;set;}
    public List<string> strmediatype{get;set;}
    public List<string> strscheduletemp{get;set;}
    Public string JobStatusString {get;set;}

    transient Public list<Job__C> joblist{get;set;}
  
    transient Public list<Job_Task__c> jobTaskTime{get;set;}
   
    Public string  soqlJobTaskTime{get;set;}
    Public map<integer,string> colormap{get;set;}
    public boolean Jscampaign{get;set;}
    public boolean Jobs{get;set;}
    public boolean Task{get;set;}
    public boolean TaskTime{get;set;}
    Public String regExp = '["\']';
 
     
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE- yyyy d MMM HH:mm:ss z';
     
    // moment().format();
     
    //constructor
    public CalendarTaskTimeController() 
    {
        StatusString='Active';
        JobStatusString ='Active';
        colormap=new map<integer,string>();
        Jscampaign=false;
        Jobs=false;
        Task=false;
        TaskTime=true;
        JobTaskTime();
        
        includeMyJobs = false;
    }
    
    // This method is used to retrieve all Campaigns into dropdown list
     public List<selectOption> getCampaigns() 
     {    
         system.debug('-----------selected value----------------->'+StatusString );
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Campaign__c  a : [SELECT Id, name FROM Campaign__c where status__c=:StatusString WITH SECURITY_ENFORCED order by Name limit 10000]) 
          {  
            optionList.add(new selectOption(a.name, a.Name ));    
          }
          return optionList;  
     }   
     // End of method getCampaigns
     
     
       // This method is used to retrieve all Mediatype into dropdown list
     public List<selectOption> getMediatype() 
     {    
         system.debug('-----------selected value----------------->'+StatusString );
          List<selectOption> optionListmedia = new List<selectOption>();
          optionListmedia.add(new selectOption('', '- None -'));  
          for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c WITH SECURITY_ENFORCED order by Name limit 10000]) 
          {  
            optionListmedia.add(new selectOption(a.name, a.Name ));    
          }
          return optionListmedia;  
     }   
     // End of method Mediatype
     
      // This method is used to retrieve all scheduletemp into dropdown list
     public List<selectOption> getscheduletemp() 
     {    
         system.debug('-----------selected value----------------->'+StatusString );
          List<selectOption> optionListsched = new List<selectOption>();
          optionListsched.add(new selectOption('', '- None -'));  
          for (Schedule_Template__c a : [SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True WITH SECURITY_ENFORCED order by Name limit 10000]) 
          {  
            optionListsched.add(new selectOption(a.name, a.Name ));    
          }
          return optionListsched;  
     }   
     // End of method scheduletemp
     
     
     
    // This method is used to retrieve all Clients into dropdown list
    public List<selectOption> getClients() 
     {    
          List<selectOption> optionList = new List<selectOption>();
         // optionList.add(new selectOption('', '- None -'));  
          for (Client__c a : [SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true WITH SECURITY_ENFORCED order by Name limit 10000]) 
          {  
            optionList.add(new selectOption(a.name, a.Name ));    
          }
          return optionList;  
     }   
     // End of method getClients
    
    // This method is used to get Campaign Status Picklist values 
    public List<SelectOption> getCampStatus()
    {
        List<SelectOption> CampstatusoptionList = new List<selectOption>();
       
        for(schema.picklistEntry p : Campaign__c.Status__c.getDescribe().getPicklistValues())
        {
            CampstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return CampstatusoptionList;
    } 
    
    
    // This method is used to get Staff Records 
    public List<SelectOption> getStaff()
    {
        List<SelectOption> StaffoptionList = new List<selectOption>();
       
         // StaffoptionList.add(new selectOption('', '- None -'));  
          for (Staff__c a : [SELECT Id, name FROM Staff__c where Active__c=:true WITH SECURITY_ENFORCED]) 
          {  
            StaffoptionList.add(new selectOption(a.name, a.Name ));    
          }
          
          for (Vendor_Contact__c a : [SELECT Id, name FROM Vendor_Contact__c where Active__c=:true WITH SECURITY_ENFORCED]) 
          {  
            StaffoptionList.add(new selectOption(a.name, a.Name ));    
          }
          
          for (Client_Contact__c a : [SELECT Id, name FROM Client_Contact__c where Active__c=:true WITH SECURITY_ENFORCED]) 
          {  
            StaffoptionList.add(new selectOption(a.name, a.Name ));    
          }
          
           StaffoptionList.sort();
          
          return StaffoptionList;  
     }   
     // End of method getStaff
     
     
   // This method is used to get Roles Records 
    public List<SelectOption> getRole()
    {
        List<SelectOption> RoleoptionList = new List<selectOption>();
       
        //  RoleoptionList .add(new selectOption('', '- None -'));  
          for (UserRole a : [SELECT Id, name FROM UserRole order by Name limit 10000]) 
          {  
                RoleoptionList.add(new selectOption(a.name, a.Name ));    
          }
          return RoleoptionList;  
     }   
     // End of method getRloes
     
    // This method is used to get Job Records 
    public List<SelectOption> getJobNames()
    {
        List<SelectOption> JoboptionList = new List<selectOption>();
       
       
          for (Job__c a : [SELECT Id, name FROM Job__c where Status__c=:JobStatusString  WITH SECURITY_ENFORCED order by Name limit 10000]) 
          {  
                JoboptionList.add(new selectOption(a.name, a.Name ));
             //   mts.add(a.Name);
             //   System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+mts);    
          }
          return JoboptionList;  
     }   
     // End of method getRloes
     
    
    // This method is used to get JobStatus picklist Values
    public List<SelectOption> getjobStatus()
    {
        List<SelectOption> jobstatusoptionList = new List<selectOption>();
       
        for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
        {
             jobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return jobstatusoptionList;
    } 
    
    
    
   public PageReference JobTaskTime() 
   {
         Jscampaign=false;
         Jobs=false;
         Task=false;
         TaskTime=true;
         strstafftemp = new list<String>();
         strroletemp = new list<string>();
         
         
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
        
       // joblist = [select id,Dummy_Text_6__c,status__c from job__C where status__C != 'completed'];
        
        jobTaskTime = new List<Job_Task__c>();
        Date myDate = system.today();
        String active = 'Active';
        
       soqlJobTaskTime='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Start_Date__c,Job__r.Job_Auto_Number__c,Job__r.Media_Types__r.name,Job__r.Schedule_Template__r.name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__r where  Marked_Done__c!=True';
       
              if(strCampaignName!=Null && strCampaignName.size()>0)
                soqlJobTaskTime+=' And Job__r.campaign__r.name=:strCampaignName';
               
              if(JobStatusString !=Null)
                soqlJobTaskTime+=' And Job__r.status__c=:JobStatusString ';
                
              if(strmediatype!=null && strmediatype.size()>0)
                soqlJobTaskTime+=' And Job__r.Media_Types__r.name=:strmediatype';    
               
              if(strscheduletemp!=null && strscheduletemp.size()>0)
                soqlJobTaskTime+=' And Job__r.Schedule_Template__r.name=:strscheduletemp';  
           
              if(strClientName !=Null && strClientName.size()>0)
                soqlJobTaskTime+=' And Job__r.JS_Client__r.name =:strClientName';
             
              if(strstaff !=null && strstaff.size()>0)
              {
                   for(String str : strstaff )
                   {
                       strstafftemp.add('%'+str+'%');
                   }
                   soqlJobTaskTime+=' And Assigned_Users__c  like :strstafftemp';
              }
               if(strrole!=null && strrole.size()>0)
              {
                  for(String role: strrole)
                  {
                      //strroletemp.add(role);
                      strroletemp.add('Schedule_Roles__c includes (\''+String.escapeSingleQuotes(role)+'\' )');
                  
                  }
                  String strroletempstring = String.join(strroletemp,' or ');
                   System.debug('---------------------strroletempstring ---------------------'+strroletempstring );        
                  //soqlJobTask+=' And Schedule_Roles__c includes (:strroletempstring )';
                  soqlJobTaskTime+=' And ( strroletempstring )';
                  System.debug('---------------------soqlJobTaskTime---------------------'+soqlJobTaskTime);
                  soqlJobTaskTime= soqlJobTaskTime.replace('strroletempstring',strroletempstring);
              }
              
              
              if(strJobName !=null && strJobName .size()>0)
                soqlJobTaskTime+=' And Job__r.Name =:strJobName';
               
           //   jobTaskTime =Database.query(soqlJobTaskTime);
              
              String completed = 'completed';
           String qStr = 'select id,Dummy_Text_6__c,status__c,('+String.escapeSingleQuotes(soqlJobTaskTime)+') from job__C where status__C =:JobStatusString limit 3000';
           joblist =Database.query(qStr);
            
            
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>joblist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1'+joblist );
            
            
            
               if(joblist.size() >0)
               {
                       for(Job__c job : joblist)
                       {
                                   
                        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>jobTaskTime>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+jobTaskTime);
                        
                               for(Job_Task__c  jobt: job.Job_Task__r)
                                {
                                     system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>3'+jobTaskTime);
                                    
                                         
                                           DateTime startDT = jobt.Start_Date__c+1;
                                           DateTime endDT = jobt.Revised_Due_Date__c+1;
                                           
                                               calEvent J= new calEvent();
                                               
                                               string strTaskName =jobt.Name;
                                               string strJobName = jobt.Job__r.Name;
                                               
                                                   String Taskname = jobt.Name; 
                                                        //String regExp = '["\']';
                                                        if(Taskname  != NULL)
                                                            Taskname = Taskname .replaceAll(regExp, '\\ ');
                                                   
                                                    String TaskUsersname = jobt.Assigned_Users__c; 
                                                    //String regExp = '["\']';
                                                    if(TaskUsersname != NULL)
                                                    TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                                                    
                                               J.title = 'Task - '+Taskname   +' , Staff - '+TaskUsersname +', Job - #'+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                                               J.allDay = false;
                                               
                                               String[] strstDT = startDT.format().split(' ');
                                               String[] strendDT = endDT.format().split(' ');
                                               
                                               system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;strendDT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+strendDT[0]);
                                               
                                               string dts= strstDT[0]+' '+jobt.Task_Start_Time_Text__c;  // start time string
                                               
                                               system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+dts);
                                               
                                               String ets = strendDT[0]+' '+jobt.Task_End_Time_Text__c;  // end time string
                                               system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+ets);
                                               
                                               J.startString = dts;
                                                system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;startString;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+J.startString );
                                                
                                               J.endString = ets;
                                                system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;endString;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+J.endString );
                                                
                                               J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                                                    String TaskCampname = jobt.Job__r.campaign__r.name; 
                                                    //String regExp = '["\']';
                                                    if(TaskCampname != NULL)
                                                        TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                                                    
                                                    String TaskJobname = jobt.Job__r.Name; 
                                                    //String regExp = '["\']';
                                                    if(TaskJobname != NULL)
                                                        TaskJobname = TaskJobname .replaceAll(regExp, '\\ '); 
                                               j.JN1 = TaskCampname +' : '+TaskJobname+'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                                                       String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                                                        //String regExp = '["\']';
                                                        if(TaskJobCliname != NULL)
                                                            TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                                               j.client1 = TaskJobCliname;
                                               j.color=colormap.get(i);
                                               j.Staff= TaskUsersname ;
                                               j.slotEventOverlap=false;
                                               J.className = 'event-Jobs';
                                               events.add(J);
                                               system.debug('>>>>>>>>>>>>>>>>>>>>////////////////////////////////////////////////'+events);
                                                 
                                      
                                 }
                                   if(i == 100)
                                      i=0;
                                   else
                                      i++;
                                   
                          }
                     }
                     else
                     {
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No Tasks to display from this criteria'));
                     }
                     return null;      
     } 
    
    public PageReference JobTaskTimeTest() 
   {
         Jscampaign=false;
         Jobs=false;
         Task=false;
         TaskTime=true;
         strstafftemp = new list<String>();
         strroletemp = new list<string>();
         
         
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
        
       // joblist = [select id,Dummy_Text_6__c,status__c from job__C where status__C != 'completed'];
        
        jobTaskTime = new List<Job_Task__c>();
        Date myDate = system.today();
        String active = 'Active';
        
       soqlJobTaskTime='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Start_Date__c,Job__r.Job_Auto_Number__c,Job__r.Media_Types__r.name,Job__r.Schedule_Template__r.name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__r where  Marked_Done__c!=True';
       
              if(strCampaignName!=Null && strCampaignName.size()>0)soqlJobTaskTime+=' And Job__r.campaign__r.name=:strCampaignName';
               
              if(JobStatusString !=Null)soqlJobTaskTime+=' And Job__r.status__c=:JobStatusString ';
                
              if(strmediatype!=null && strmediatype.size()>0)soqlJobTaskTime+=' And Job__r.Media_Types__r.name=:strmediatype';    
               
              if(strscheduletemp!=null && strscheduletemp.size()>0)soqlJobTaskTime+=' And Job__r.Schedule_Template__r.name=:strscheduletemp';  
           
              if(strClientName !=Null && strClientName.size()>0)soqlJobTaskTime+=' And Job__r.JS_Client__r.name =:strClientName';
             
              
               
              
              
              if(strJobName !=null && strJobName .size()>0) soqlJobTaskTime+=' And Job__r.Name =:strJobName';
               
           //   jobTaskTime =Database.query(soqlJobTaskTime);
              
              String completed = 'completed';
           String qStr = 'select id,Dummy_Text_6__c,status__c,('+soqlJobTaskTime+') from job__C where status__C =:JobStatusString limit 3000';
           joblist =Database.query(qStr);
            
            
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>joblist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1'+joblist );
            
            
            
               if(joblist.size() >0)
               {
                       for(Job__c job : joblist)
                       {
                                   
                        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>jobTaskTime>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+jobTaskTime);
                        
                               for(Job_Task__c  jobt: job.Job_Task__r)
                                {
                                     system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>3'+jobTaskTime);
                                    
                                         
                                           DateTime startDT = jobt.Start_Date__c+1;
                                           DateTime endDT = jobt.Revised_Due_Date__c+1;
                                           
                                               calEvent J= new calEvent();
                                               
                                               string strTaskName =jobt.Name;
                                               string strJobName = jobt.Job__r.Name;
                                               
                                                   String Taskname = jobt.Name; 
                                                        //String regExp = '["\']';
                                                        if(Taskname  != NULL)
                                                            Taskname = Taskname .replaceAll(regExp, '\\ ');
                                                   
                                                    String TaskUsersname = jobt.Assigned_Users__c; 
                                                    //String regExp = '["\']';
                                                    if(TaskUsersname != NULL) TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                                                    
                                               J.title = 'Task - '+Taskname   +' , Staff - '+TaskUsersname +', Job - #'+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                                               J.allDay = false;
                                               
                                               String[] strstDT = startDT.format().split(' ');
                                               String[] strendDT = endDT.format().split(' ');
                                               
                                               system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;strendDT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+strendDT[0]);
                                               
                                               string dts= strstDT[0]+' '+jobt.Task_Start_Time_Text__c;  // start time string
                                               
                                               system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+dts);
                                               
                                               String ets = strendDT[0]+' '+jobt.Task_End_Time_Text__c;  // end time string
                                               system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+ets);
                                               
                                               J.startString = dts;
                                                system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;startString;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+J.startString );
                                                
                                               J.endString = ets;
                                                system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;endString;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+J.endString );
                                                
                                               J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                                                    String TaskCampname = jobt.Job__r.campaign__r.name; 
                                                    //String regExp = '["\']';
                                                    if(TaskCampname != NULL)
                                                        TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                                                    
                                                    String TaskJobname = jobt.Job__r.Name; 
                                                    //String regExp = '["\']';
                                                    if(TaskJobname != NULL)
                                                        TaskJobname = TaskJobname .replaceAll(regExp, '\\ '); 
                                               j.JN1 = TaskCampname +' : '+TaskJobname+'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                                                       String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                                                        //String regExp = '["\']';
                                                        if(TaskJobCliname != NULL)
                                                            TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                                               j.client1 = TaskJobCliname;
                                               j.color=colormap.get(i);
                                               j.Staff= TaskUsersname ;
                                               j.slotEventOverlap=false;
                                               J.className = 'event-Jobs';
                                               events.add(J);
                                               system.debug('>>>>>>>>>>>>>>>>>>>>////////////////////////////////////////////////'+events);
                                                 
                                      
                                 }
                                   if(i == 100) i=0;
                                   else
                                      i++;
                                   
                          }
                     }
                     
                     return null;      
     } 
  /*          
   public PageReference toggleMyJobs() 
   {
        if(includeMyJobs)
        {
            includeMyJobs = false;
        }
        else
        {
            includeMyJobs = true;
        }
        return null;
    }
   
   public PageReference printcal() 
   {
       PageReference pageRef = new PageReference('/apex/calendarTaskTimeprint');
       return pageref;
   }
   */
  
 
 // Start of Remote Action
    @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate,string jn) 
    {
       
         /*  list<Campaign__c> campList = new list<Campaign__c>();
           list<job__c> jobList = new  list<job__c>();
           String id1 = cntid.Substring(cntid.length()-18,cntid.length());
           String name2 = name.Substring(0,2);
           Campaign__c cam = new Campaign__c();
           String name1 = '%'+name2+'%';
           integer eyear = integer.valueof(endate.substring(0,4));
           integer emonth = integer.valueof(endate.substring(5,7));
           integer eday = integer.valueof(endate.substring(8,10));
           integer etime = integer.valueof(endate.substring(11,13));
           integer etimesec = integer.valueof(endate.substring(14,16));
           integer syear = integer.valueof(stdate.substring(0,4));
           integer smonth = integer.valueof(stdate.substring(5,7));
           integer sday = integer.valueof(stdate.substring(8,10));
           integer stime = integer.valueof(stdate.substring(11,13));
           integer stimesec = integer.valueof(stdate.substring(14,16));
         //  Date ed = Date.newInstance(eyear,emonth,eday-1);
          // Date sd = Date.newInstance(syear,smonth,sday-1);
          System.debug('::::::::::::::Hello before IF::::::::::::::::::::'+name.substring(0, 11));
          
           if(name.substring(0, 11) == 'JS Campaign')
           {
               Date ed = Date.newInstance(eyear,emonth,eday-1);
               Date sd = Date.newInstance(syear,smonth,sday);
               
               cam = [select Id, Name, Start_Date__c, End_Date__c from Campaign__c where id = :id1];
               if(schema.SobjectType.Campaign__c.Fields.End_Date__c.isUpdateable()){
                   cam.End_Date__c = ed;
               }
               if(schema.SobjectType.Campaign__c.Fields.Start_Date__c.isUpdateable()){
                   cam.Start_Date__c = sd;
               }
               if(Schema.sObjectType.Campaign__c.isUpdateable() ){
                   update cam;
               }
           }
           else if(name.Substring(0,3) == 'Job')
           {
               Date ed = Date.newInstance(eyear,emonth,eday-1);
               Date sd = Date.newInstance(syear,smonth,sday);
           
               Job__c job = new Job__C();
               job = [select Id, Name, Job_Description__c,Start_Date__c,Due_Date__c from Job__c where id = :id1];
               if(schema.SobjectType.Job__c.Fields.Start_Date__c.isUpdateable()){
                   job.Start_Date__c = sd;
               }
               if(schema.SobjectType.Job__c.Fields.Due_Date__c.isUpdateable()){
                   job.Due_Date__c = ed;
               }
               if(Schema.sObjectType.Job__c.isUpdateable()){
                   update job; 
               }
           }
                  
           else
           {
                System.debug(':::::::::::::Entered:::::::::::::::'+name.substring(0, 11));
                Date sd = Date.newInstance(syear,smonth,sday);
                Date ed = Date.newInstance(eyear,emonth,eday);
                
                String taskID = jn.Substring(jn.indexof('id')+3,jn.indexof('id')+3+18);
                system.debug('<<<<<<<<<Task ID is>>>>>>>>>>>>>>>>>>>'+taskID);
                Job_Task__c jobTask= new Job_Task__c();
               jobTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Start_Date__c,Task_Start_Time_Text__c,Task_End_Time_Text__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID WITH SECURITY_ENFORCED];
               if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){
                   jobTask.Start_Date__c= sd;
               }
               if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                   jobTask.Revised_Due_Date__c = ed;
               }
               // jobtask
                String sam = 'AM';
                String eam = 'AM';
                String stimestring = stdate.substring(11,13);
                if(stime >= 12)
                {
                    stime = stime-12;
                    if(stime == 0)
                        stime = 12;
                    sam = 'PM';
                }
                
                if(etime >= 12)
                {
                    etime = etime-12;
                    if(etime == 0)
                        etime = 12;
                    eam = 'PM';
                }
                     
                system.debug('-----etime ::::'+etime+'-------------Stime::::::'+stime);
               // system.debug('--------etimesec size ::::'+etimesec.length);
                
               if(schema.SobjectType.Job_Task__c.Fields.Task_Start_Time_Text__c.isUpdateable()){ 
                   jobtask.Task_Start_Time_Text__c= string.valueof(stime+':'+stdate.substring(14,16)+' '+sam);
               }
               if(schema.SobjectType.Job_Task__c.Fields.Task_End_Time_Text__c.isUpdateable()){
                   jobtask.Task_End_Time_Text__c= string.valueof(etime+':'+endate.substring(14,16)+' '+eam);
               }
               if(Schema.sObjectType.Job_Task__c.isUpdateable() ){ 
                   update jobtask;
               }
           }*/
       
           return true;
    }
 // End of Remote Action
     
     
 /*     public PageReference clearForm() 
      {
          
            if(strstaff!=null && strstaff.size()>0 ){strstaff.clear();JobTaskTime(); }
            
            if(strscheduletemp!=null && strscheduletemp.size()>0 ){strscheduletemp.clear();JobTaskTime();}
            
            if(strmediatype!=null && strmediatype.size()>0 ){strmediatype.clear();JobTaskTime(); }
            
            if(strrole!=null && strrole.size()>0 ){strrole.clear();JobTaskTime(); }
            if(strClientName!=null && strClientName.size()>0){strClientName.clear();JobTaskTime();}
            if(strJobName!=null && strJobName.size()>0 ){strJobName.clear();JobTaskTime();}
            
            if(strCampaignName!=null && strCampaignName.size()>0 ){strCampaignName.clear();JobTaskTime();}
          
        	return null;
      } 
    
  
  //Class to hold calendar event data
    public class calEvent
    {
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
        public Boolean slotEventOverlap{get;set;}
    }*/
}