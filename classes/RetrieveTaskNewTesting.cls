// This class is used as a controller to display Schedules under Schedule SubTab in Job Tab
global with sharing class RetrieveTaskNewTesting
{  
  // for calender functionality
  
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
   Public map<integer,string> colormap{get;set;}
   transient public boolean Task{get;set;}
   Public String regExp = '["\']';
   public string DDate {set;get;}
    Public string CalDD {set;get;}
   
   public Job_Task__c EditTask {set;get;} 
   public boolean isPopup {set;get;}
   public boolean isAllTasksDone {set;get;}
     
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE- yyyy d MMM HH:mm:ss z';
  
   
   
    public boolean isLtng{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                         }
     public boolean isMob{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
                         }



    public map<string, string> teamRoleMap{get;set;}
    public map<string, string> teamEmailMap{get;set;}
    public boolean islistview  {set;get;}
    
    public void addTeams() {
        String jobId1 = ApexPages.CurrentPage().getParameters().get('afJobId');  
        String TaskId = ApexPages.CurrentPage().getParameters().get('afTaskId');
        String TeamateName = ApexPages.CurrentPage().getParameters().get('afTeamateName');
        
        map<string, string> teamRoleMap1 = new map<string, string>();
        map<string, string> teamEmailMap1 = new map<string, string>();
        list<Job_Team__c> teamList1 = [select id, staff__c, role__c, email__c from Job_Team__c where job__c =:jobId1];
        for(Job_Team__c jjj:teamList1){
            teamRoleMap1.put(jjj.staff__c, jjj.role__c);
            teamEmailMap1.put(jjj.staff__c, jjj.email__c);
        }
        
        //job_Task__c jTask = [select id, Due_Date__c from job_Task__c where id =:TaskId];
        
        Job_Task_Role__c jtrole = new Job_Task_Role__c();
        jtrole.name = teamRoleMap1.get(TeamateName);
        jtrole.Email__c = teamEmailMap1.get(TeamateName); 
        jtrole.User__c = TeamateName;   
        jtrole.Job_Task__c = TaskId; 
        //jtrole.Task_Final_Due__c = jTask.Due_Date__c;
        insert jtrole;
        
        refreshTasks();
        
       // lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        //lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate]; 
        
        //return TaskId + ' ' + TeamateName + ' ' + teamRoleMap1.get(TeamateName)+ ' ' + teamEmailMap1.get(TeamateName);
    }
    
    public void removeTeam() {
        String TaskId = ApexPages.CurrentPage().getParameters().get('afTaskId1');  
        String TeamateName = ApexPages.CurrentPage().getParameters().get('afTeamateName1');
        list<Job_Task_Role__c> teamList1 = [select id, User__c , Job_Task__c from Job_Task_Role__c where Job_Task__c = :TaskId and User__c = :TeamateName ];
        delete teamList1;
        refreshTasks();
    }
    
    
    
    /*webService static String addTeam(String JobId, String TaskId, String TeamateName) {
        String jobId1 = JobId;  
        
        map<string, string> teamRoleMap1 = new map<string, string>();
        map<string, string> teamEmailMap1 = new map<string, string>();
        list<Job_Team__c> teamList1 = [select id, staff__c, role__c, email__c from Job_Team__c where job__c =:jobId1];
        for(Job_Team__c jjj:teamList1){
            teamRoleMap1.put(jjj.staff__c, jjj.role__c);
            teamEmailMap1.put(jjj.staff__c, jjj.email__c);
        }
        
        //job_Task__c jTask = [select id, Due_Date__c from job_Task__c where id =:TaskId];
        
        Job_Task_Role__c jtrole = new Job_Task_Role__c();
        jtrole.name = teamRoleMap1.get(TeamateName);
        jtrole.Email__c = teamEmailMap1.get(TeamateName); 
        jtrole.User__c = TeamateName;   
        jtrole.Job_Task__c = TaskId; 
        //jtrole.Task_Final_Due__c = jTask.Due_Date__c;
        insert jtrole;
        return TaskId + ' ' + TeamateName + ' ' + teamRoleMap1.get(TeamateName)+ ' ' + teamEmailMap1.get(TeamateName);
    }
    webService static void removeTeam(String TaskId, String TeamateName) {
        list<Job_Task_Role__c> teamList1 = [select id, User__c , Job_Task__c from Job_Task_Role__c where Job_Task__c = :TaskId and User__c = :TeamateName ];
        delete teamList1;
    }*/

    // Global Variables
    public string tskid{get;set;}
    
    public string msg{get;set;}
    public string strTaskName{get;set;}
    public String campaignId{get;set;}
    public string strJTID{get;set;}
    public Id strJTID1{get;set;}
    public Id strJTID2{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public Id jobId{get;set;}
    Public Job__c JobRecord{get;set;}
    Map<String,Id> mp1 = new Map<String,Id>();
    Map<Id,Id> mp2 = new Map<Id,Id>();
    Set<Id> stScheduleTaskId = new Set<Id>();
    public List<Job_Team__c> lstJobTeam{get;set;}
    public String taskId{get;set;}
    public String updateRestScheduleRevDt{get;set;}
    public Date dt{get;set;}
    public String taskId1{get;set;}
    public id TaskId3{get;set;}
    public String updateRestScheduleDays{get;set;}
    public String days1{get;set;}
    public Set<Date> holidaysNew;
    public id strJTUID{get; set;}
    public id strJTDID{get; set;}
    public boolean ShowCopySceduleButton{get;set;}
    
    Public Boolean ShowoldTimesheetflow{get;set;}
    
    Public Boolean Showcalendarviewbutton{get;set;}
    Public Boolean showcampaignbutton{get;set;}
    Public Boolean showcopyschedulebutton{get;set;}
    Public Boolean showprintschedulebutton{get;set;}
    Public Boolean showprintclientschedulebutton{get;set;}
    Public Boolean showNewtimesheetentrybutton{get;set;}
    Public Boolean showoldtimesheetentrybutton{get;set;}
    Public Boolean showOldcopybutton{get;set;}
    Public Boolean Dateerror{get;set;}
    
    // variable for the hd org
    public boolean isHD {get;set;}    
    public Job_Task__c objJobTask
    {
         get {
      if (objJobTask == null)
        objJobTask = new Job_Task__c();
        //objJobTask.GL_Code__c = GLCName;
      return objJobTask;
    }
    set;
    }
    
    // End of Global variables
   public pagereference updateScheduleOnDays()
    {
        msg = 'Rerendered';
         System.debug('Days is : '+days1);
         System.debug('Task Id is : '+taskId1);
         System.debug('Value of updateRestScheduleDays : '+String.valueOf(updateRestScheduleDays));
         
        Integer newDaysValue = Integer.valueOf(days1);
        
          // If user clicks on Yes button then update the current task first and         
         // retrieve below task( not marked done) and update the revised date for all those tasks
           Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=:jobId];
           Boolean blnFroward = true;
            if(objJob.Schedule_Calc__c == 'End Date')
            {
               blnFroward = false;
            }
         
         Job_Task__c objTask1; 
              objTask1 = [Select Id, Name, Job__c, Job__r.Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Id =: taskId1 LIMIT 1];
              
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
                  
                  objTask1.Days__c = newDaysValue;
                  
                             if(blnFroward)
                             {
                                  objTask1.Revised_Due_Date__c = afterDaysUpdate;   
                             }
                             else
                             {
                                 objTask1.Start_Date__c = afterDaysUpdate;   
                             }
                  
                  update objTask1;  
         
          if(String.valueOf(updateRestScheduleDays) == 'true')
          {
                       
              // Update the current Task Revised Due Date and Days                  
                  
                  // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current Job
                  List<Job_Task__c> lstTaskBelow ;
                  
                    if(blnFroward)
                             {
                                 lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c >=: objTask1.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c ASC];   
                             }
                             else
                             {
                                 lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c <=: objTask1.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c DESC]; 
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
                                 lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                             }
                             else
                             {
                                 lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;
                             }
                        }
                        else
                        {
                            Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                           
                            if(blnFroward)
                             {
                                 lstTaskBelow[i].Start_Date__c = d4; 
                             }
                             else
                             {
                                 lstTaskBelow[i].Revised_Due_Date__c = d4; 
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
                    
                        lstTaskBelow[i].Days__c = lstTaskBelow[i].Days__c;
                    
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
                                  
                                   if(blnFroward){dtStartDate3=dtStartDate3.addDays(1);}
                                     else{ dtStartDate3=dtStartDate3.addDays(-1);}
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
                              lstTaskBelow[i].Revised_Due_Date__c=d1;
                         }
                         else
                         {
                              lstTaskBelow[i].Start_Date__c=d1;
                         }
                         
                         NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
               // system.debug('$$$$$$$$$$$$$'+Limits.getScriptStatements());
                update lstTaskBelow;
               
                System.debug('Updated Task : '+lstTaskBelow);
                System.debug('Size of Task : '+lstTaskBelow.size());
     
         }
    
         // After Schedule Update Navigate to Job
        //PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'#scheduleListView');
        //p.setRedirect(true);
        //return null; 
        lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate]; 
        
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
            pagereference pp = new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
            pp.setredirect(true);
            return pp;
        }
        return null;
    }
    // This method is called on to update Schedule when Days of particular Task has changed

    
    // End of method updateScheduleOnDays


        public pagereference updateRestSchedule()
    {
             System.debug('Due Date is : '+dt);
             
             dt = Date.valueOf(dt);
             
             System.debug('Task Id is : '+taskId);
             System.debug('Value of updateRestScheduleRevDt : '+String.valueOf(updateRestScheduleRevDt));
         
             DateTime NextTaskStartDate;
             //code for the update of the current schedule 
             Job_Task__c jobTask1,jobTask2,objJobTask;
             
              
              
                   //taskId = Id.valueOf(taskId);
                   jobTask1 = new Job_Task__c(Id=taskId,Revised_Due_Date__c = dt);
                   update jobTask1;
                   objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id LIMIT 1];
                        Boolean blnFroward = true;
                        if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
                        {
                           blnFroward = false;
                        }  
                    if(!blnFroward )
                    {
                       System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                                                 //code for updating the start date of the current task
                        Integer jCount = 0;
                        //Integer newDaysValue = objJobTask.Days__c;
                     Datetime dtStartDate=DateTime.newInstance(dt.Year(),dt.Month(),dt.Day());
                        System.debug('jCount value '+jCount);
                                    
                         while(true)
                            {
                             System.debug('jCount value in while '+jCount);
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
                                      System.debug('=====dtStartDate ===='+dtStartDate);                                          
                                      continue;
                                  }
                             }
                           Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                           system.debug('=========afterDaysUpdate =========='+afterDaysUpdate);
                           objJobTask.Start_Date__c = afterDaysUpdate;   
                           update objJobTask;
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
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                         }
                         else
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c DESC];
                         }
                        System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                        
                        System.debug('Size of Update Tasks : '+lstJobTasks.size());
                         
                        for(Integer i = 0; i <lstJobTasks.size(); i++)
                        {
                            System.debug('Value of i' +i);
                          DateTime dtStartDate3;
                                if(i == 0)
                                {
                                    lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                    if(blnFroward)
                                     {
                                      // dtStartDate3= lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                      
                                          lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                          dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                       
                                     }
                                     else
                                     {
                                     //  dtStartDate3= lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                       
                                          lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                          dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                          
                                          
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                    if(blnFroward)
                                     {
                                      //  dtStartDate3 = lstJobTasks[i].Start_Date__c = d4;
                                        
                                          lstJobTasks[i].Start_Date__c = d4;
                                         
                                         
                                          dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                     else
                                     {
                                      
                                      
                                      // dtStartDate3 = lstJobTasks[i].Revised_Due_Date__c = d4; 
                                         lstJobTasks[i].Revised_Due_Date__c = d4;
                                         dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                    
                                }
                               
                            
                               //  if(blnFroward)
                                //     {
                                //        dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                                //     }
                                //     else
                               //      {
                                //         dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                                //     }
                               
                                System.debug('Day is:'+dtStartDate3.format('E'));
                            
                                System.debug('Start Date is : ' +dtStartDate3);
                            
                                lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;
                            
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
                                      lstJobTasks[i].Revised_Due_Date__c=d1;
                                       system.debug('Revise due============' +lstJobTasks[i].Revised_Due_Date__c); 
                                   }
                                  else
                                   {
                                      lstJobTasks[i].Start_Date__c=d1;
                                   }    
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                              }
                            update lstJobTasks;
                            System.debug('Updated List : '+lstJobTasks);
                         }
                
                // system.debug('$$$$$$$$$$$$$Helloooo'+Limits.getScriptStatements());
         // After updating the schedule navigate to Job --> Schedule Tab
        lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate];
      /*  if(isLtng){
        PageReference p =  new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
        p.setRedirect(true);
        return p;
        }
        else{
        return null;
        }
        */
         JobTask();
        return null; 
    }
    
    //Start Update Schedule Hours
    Public void updateScheduleHours(){

        integer intIndex = integer.valueOf(Apexpages.currentpage().getParameters().get('index'));
        System.debug('Task is : '+lstJT[intindex]);
        if(intIndex != null){
            Job_Task__c objTask = new Job_Task__c();
            objTask.id = lstJT[intindex].id;
            objTask.Hours__c = lstJT[intindex].Hours__c;
            try{update objTask;}
            catch(exception e){}
        }
        
    }
    
    //End Update Schedule Hours
    
    public Pagereference createSchedule()
        {
            List<Job_Task__c> lstJT=new List<Job_Task__c>();
            lstJT=[Select Id from Job_Task__c where Job__c =: jobId];
            
            Set<Id> stScheduleTemplateId = new Set<Id>();
            Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=:jobId];
            String strScheduleTemplate=objJob.Schedule_Template__c;
            
            List<Schedule_Task__c> lstScheduleTask=new List<Schedule_Task__c>();          
            List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
            Datetime NTSD;
            Dateerror=false;
            if(objJob.Start_Date__c==null  && objJob.Due_Date__C==null)
            {
                Dateerror=true;
               /* ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must enter Start or Due Date Values in job');
                ApexPages.addMessage(myMsg);    */          
                return null;
            }
            
            else
            {
            
                if(lstJT.size() > 0) // To check Schedule Is not Created yet
                { 
                   delete lstJt;
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
               lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c,Hours__c,Roles__c  from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate ORDER BY Task_Order__c];
             }
             else
             {
                std=Date.newInstance(objJob.Due_Date__c.Year(),objJob.Due_Date__c.month(),objJob.Due_Date__c.Day());
                lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c,Hours__c,Roles__c,(select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate ORDER BY Task_Order__c desc];
             }
             System.debug('==========std is==========:'+std);
             
            
             
            
             //List<Schedule_Task__c> lstScheduleTask=new List<Schedule_Task__c>();
             //lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate ORDER BY Task_Order__c];
             //List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
             //Datetime NTSD;
            
             for(Integer i=0;i<lstScheduleTask.size();i++)
             {
                     stScheduleTaskId.add(lstScheduleTask[i].Id); 
                     Job_Task__c jt=new Job_Task__c();
                     system.debug('Value of i : '+i);
                     if(i==0)
                     {
                         if(blnFroward)
                         {
                            jt.Start_Date__c=std;
                         }
                         else
                         {
                            jt.Due_Date__c=std;
                         }
                     }
                    else
                     {
                         Date d2 = Date.newInstance(NTSD.Year(),NTSD.Month(),NTSD.Day());
                         if(blnFroward)
                         {
                            jt.Start_Date__c = d2;
                         }
                         else
                         {
                             jt.Due_Date__c=d2;
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
                    jt.Days__c=lstScheduleTask[i].Days__c;
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
                                  jt.Due_Date__c=d1;
                               }
                              else
                              {
                                jt.Start_Date__c=d1;
                              }
                     jt.Revised_Due_Date__c=jt.Due_Date__c;
                     System.debug('Due Date : '+jt.Due_Date__c);
                     
                      
                     NTSD=DateTime.valueOf(dtStartDate);
                     jt.Name=lstScheduleTask[i].Name;
                     jt.GL_Code__c=lstScheduleTask[i].GL_Code__c;
                     jt.Report__c=lstScheduleTask[i].Report__c;
                     jt.Locked__c=lstScheduleTask[i].Locked__c;
                     jt.Hours__c=lstScheduleTask[i].Hours__c;
                     jt.Schedule_Roles__c=lstScheduleTask[i].Roles__c;
                     
                     jt.Task_Order__c=lstScheduleTask[i].Task_Order__c;
                     
                     System.Debug('Task Order @@@@@@@@@@@@@@@@@@@@@@@@@'+jt.Task_Order__c);
                     
                     jt.Job__c=jobId;
                     mp1.put(lstScheduleTask[i].Name,lstScheduleTask[i].Id);
                     lstJobTask.add(jt);
                }
             insert lstJobTask;
             
              for(Job_Task__c jt:lstJobTask)
             {
                 mp2.put(mp1.get(jt.Name),jt.Id);
             }        
             
             List<ScheduleTaskRole__c> lstScheduleTaskRole=new List<ScheduleTaskRole__c>();
              
             lstScheduleTaskRole=[Select Id,Name,Schedule_Task__c,Schedule_Task__r.Schedule_Template__c,Schedule_Task__r.Name from ScheduleTaskRole__c where Schedule_Task__c IN : stScheduleTaskId];
            
             List<Job_Task_Role__c> lstJobTaskRole=new List<Job_Task_Role__c>();
          
             for(ScheduleTaskRole__c st1:lstScheduleTaskRole)
            {
               
     
               Job_Team__c[] objJobTeam=[Select Staff__c,Email__c from Job_Team__c where Role__c=: st1.Name and Job__c=:jobId ];
                for(Job_Team__c jteam:objJobTeam){
               Job_Task_Role__c objJobTaskRole=new Job_Task_Role__c();
               
                   objJobTaskRole.Name=st1.Name;
                   objJobTaskRole.Job_Task__c=mp2.get(st1.Schedule_Task__c);
                   String strStaff=jteam.Staff__c;           
                   objJobTaskRole.User__c=strStaff;
                   objJobTaskRole.Email__c=jteam.Email__c;
                   lstJobTaskRole.add(objJobTaskRole);
              }
           }  
            insert lstJobTaskRole;
    
            
            // After creating Schedule, Navigate To Schedules Tab
            
            
             if(isMob)
             {
                  PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=Schedule');
                  p.setRedirect(true);
                  return p; 
             }
             
             else if(isLtng)
             {
                    PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
                    p.setRedirect(true);
                    return p;
             }
             else
             {
                PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
                p.setRedirect(true);
                return p;
             }
             
                      
              }          
     
      }
    
    
    public Pagereference deltask(){
    
    lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where id =:tskid LIMIT:1];
    
    try{
          delete lstJT;
          
          lstJT=new list<Job_Task__c >();
            lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];

          
          }
    
     catch(System.DMLException e)
        {
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        
         PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
         p.setRedirect(true);
         return p;
    
    }
    
     public List<selectOption> getStatusList() 
    {
        List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job_Task__c.Status__c.getDescribe();
         optionList.add(new selectOption('all', 'All')); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
        
        return optionList;  
    }
    
    // End of method updateRestSchedule
    
     // This method is called on to handle Delete button
     public Pagereference DeleteJobTask()
     {
           Pagereference p=new Pagereference('/apex/DeleteJobTask?id='+strJTID);
           p.setRedirect(true);
           return p;
     }
    // End of method DeleteJobTask
   
    // This method is called on to handle Edit button
   public Pagereference EditJobTask()
   {
          Pagereference p=new Pagereference('/apex/EditJobTask?id='+strJTID);
          p.setRedirect(true);
          return p;
   }
   // End of Method EditJobTask
    
    
    // Standard Controller Constructor
   public string scheduletemp{get; set;}
   public Map<String, List<String>> taskStaffMap{get;set;}
   Public Map<String,Integer> AsignStaffNoMap {set;get;}
   
   public RetrieveTaskNewTesting(ApexPages.StandardController st)
    {
       CalDD='';
       isPopup=false;
        EditTask=new Job_Task__c();
        colormap=new map<integer,string>();
        strstaff = new List<string>();
        strrole= new List<string>();
        //
    
    
    
    
    
    
       islistview=true;
        msg = 'Testing Reloading Page';
       // DDate=ApexPages.CurrentPage().getParameters().get('Date');
        TaskId3=ApexPages.CurrentPage().getParameters().get('paramU');
        
        //this.JobRecord=(Job__c)st.getRecord();
        jobId = ApexPages.CurrentPage().getParameters().get('id');  
        
        teamRoleMap = new map<string, string>();
        teamEmailMap = new map<string, string>();
        list<Job_Team__c> teamList = [select id, staff__c, role__c, email__c from Job_Team__c where job__c =:jobId];
        for(Job_Team__c jjj:teamList){
            teamRoleMap.put(jjj.staff__c, jjj.role__c);
            teamEmailMap.put(jjj.staff__c, jjj.email__c);
        }
        
       
       // jobId = ApexPages.currentPage().getParameters().get('id');  
       // system.debug('Sjob record......'+jobId +JobRecord.name);     
        Job__c objJob=[Select Id,Campaign__c,Schedule_Template__c, Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=: jobId LIMIT 1];
        JobRecord = objJob;
        scheduletemp = objJob.Schedule_Template__c;
        //system.debug('Schedule Temp......'+scheduletemp);
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowCopySceduleButton=activeSettings.Copy_Schedule_Button__c;
        ShowoldTimesheetflow=activeSettings.Old_Time_Sheet_Flow__c;
        
     
        Schedule_Buttons__c buttonsactive = Schedule_Buttons__c.getOrgDefaults();
        
       
        
       Showcalendarviewbutton = buttonsactive.Calendar_View_Button__c;
       showcampaignbutton =  buttonsactive.Campaign_Button__c;
       showcopyschedulebutton = buttonsactive.Copy_Schedule_Button__c;
       showprintclientschedulebutton =  buttonsactive.Print_Client_Schedule_Button__c;
       showprintschedulebutton = buttonsactive.Print_Schedule_Button__c;
       shownewtimesheetentrybutton = buttonsactive.New_Time_Sheet_Entry_Button__c;
       showoldtimesheetentrybutton = buttonsactive.Old_Time_Sheet_Entry_Button__c;
       showOldcopybutton = buttonsactive.Old_Copy_Schedule_Button__c;
       
        
        
        campaignId=objJob.Campaign__c;
        lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.Status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate];       
        
        List<Job_Task__c> relatedJTR =[Select Id, Name,Email__c, (Select Id,User__c,Email__c From Job_Task_Roles__r) from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        
         System.debug('====relatedJTR ===='+relatedJTR);
        taskStaffMap = new Map<String, List<String>>();
        AsignStaffNoMap=new Map<String,Integer>();
       
       for (Job_Task__c jtask: relatedJTR) {
        if (jtask.Job_Task_Roles__r.size() > 0) {
            for (Job_Task_Role__c jtr: jtask.Job_Task_Roles__r) {
                if (taskStaffMap.containsKey(jtask.id)) {
                    list < String > stlist = taskStaffMap.get(jtask.id);
                    stlist.add(jtr.User__c);
                    taskStaffMap.put(jtask.id, stlist);
    
                } 
                else {
                    taskStaffMap.put(jtask.id, new list < string >{jtr.User__c});
                }
            }
        } 
        else {
            taskStaffMap.put(jtask.id, new list < string > {});
         }
         System.debug('====taskStaffMap final====' + taskStaffMap);
         AsignStaffNoMap.put(jtask.id, jtask.Job_Task_Roles__r.size());
       }
         holidaysNew= new Set<Date>();
         
         for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL])
         {
             holidaysNew.add(hc.Date__c);
         }
         
    //by defualt if is true, for the hd org and for the client contact we have to not show the crete schedule button
    
        isHD = true;
        
        Id profileId = UserInfo.getProfileId();
        Profile p = [Select Id, Name from Profile where Id =: profileId];

        if(UserInfo.getOrganizationName() == 'Healthy Directions' && (p.Name == 'Client Contact' || p.Name == 'SP Client Contact'))
        isHD = false;
        
      JobTask(); 
         
    }
    // End of Standard Controller Constructor
    
    // This save method is called for Inline Edit Save 
      public PageReference save()
     {    
         try
         {
             List<Job_Task__c> updatelstJT=new List<Job_Task__c>();
             
             for(Job_task__c objJT:lstJT)
             {  
             
                If(objJT.Marked_Done__c==True && objJT.Completion_Date__c==NULL)
                {
                    objJT.Completion_Date__c=System.Today();
                    objJT.Status__c='Completed';
                    
                    
                }
                else if (objJT.Marked_Done__c==False){
                
                    objJT.Completion_Date__c=NULL;
                    objJt.Status__c='Active';
                }
                updatelstJT.add(objJT);
             }
             
             update updatelstJT;
             
             }
         catch(System.DMLException e)
         {
           lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
            lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate]; 
            return null;
         }
 
         
         // After inline edit Save navigate to Schedules Tab
        
        lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c, Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate]; 
        PageReference p;
        if(isLtng){
        p=new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
        }
        else{
        p=new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
        }
        p.setRedirect(true);
        return p;
        
    }
    // End of method Save
    
     // This method is called on to handle Cancel button
     public PageReference cancelme()
     {
            PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&intFocus=2');
            p.setRedirect(true);
            return p;     
     }
     // End of method Cancel
    
      // This method is called on to handle Calendar View button
      public Pagereference displayTasksInCalendar()
      {
           // PageReference p =  new Pagereference('/apex/Calendar?id='+jobId);
            PageReference p =  new Pagereference('/apex/TaskCalendarNew?id='+jobId);
            p.setRedirect(true);
            return p;
       }
       // End of method displayTasksInCalendar
       
       
       public void toggleviewCalender(){
       //JobTask();
       refreshTasks();
       JobTask();
       islistview=false;
       //DDate=Apexpages.CurrentPage().getParameters().get('Date');
       }
       
        public void toggleviewList(){
         //islistview=true;
        //pagereference p = new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
        //p.setRedirect(true);
       // return p;
        refreshTasks();
        JobTask();
        islistview=true;
        //DDate=null;
        }
     
    
     // This method is called on to handle Insert Task button
    public Pagereference insertNewTask()
    {
            PageReference p =  new Pagereference('/apex/CreateNewJobTaskAbove?id='+strJTID1);
            p.setRedirect(true);
            return p;
    }
    public Pagereference insertNewTaskLight()
    {
            PageReference p =  new Pagereference('/apex/CreateNewJobTaskAboveLightning?id='+strJTID1);
            p.setRedirect(true);
            return p;
    }
    // End of method insertNewTask
    
   // Method called on to add New Task 
       public pagereference addNewTask()
       {
           Id jobid1;
           String theId=ApexPages.CurrentPage().getParameters().get('id');
         
           Job__c job = [Select Id from Job__c where id =: theID];
           jobid1=job.Id;
           
           PageReference p=Page.CreateNewJobTask;
           p.setRedirect(true);
           p.getParameters().put('jobid1',theId);
           return p;
       }
       public pagereference addNewTaskLight()
       {
           Id jobid1;
           String theId=ApexPages.CurrentPage().getParameters().get('id');
         
           Job__c job = [Select Id from Job__c where id =: theID];
           jobid1=job.Id;
           
           PageReference p=Page.CreateNewJobTaskLightning;
           p.setRedirect(true);
           p.getParameters().put('jobid1',theId);
           return p;
       }
       // End of method addNewTask
       
       //Method Called on Move Task Up and Down
       Public pagereference moveUpandDown()
       {
           objJobTask=[Select Job__c,Task_Order__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c from Job_Task__c where Id=: TaskId3];
           system.debug('objJobTask');
           return null;
       }
       
 
    
    
    
    public void RetrieveTaskNewTesting123()
    {
        
              
             
    }
    
    
    public string taskId123{get;set;}
    public Date dt123{get;set;}
    public string updateRestScheduleRevDt123{get;set;}
    
    public void saveOrder()
    {
    
             List<Job_Task__c> updatelstJT=new List<Job_Task__c>();
             
             for(Job_task__c objJT:lstJT)
             {  
             
                If(objJT.Marked_Done__c==True && objJT.Completion_Date__c==NULL)
                {
                    objJT.Completion_Date__c=System.Today();
                    objJT.Status__c='Completed';
                    
                    
                }
                else if (objJT.Marked_Done__c==False){
                
                    objJT.Completion_Date__c=NULL;
                    objJt.Status__c='Active';
                }
                updatelstJT.add(objJT);
             }
        try{update updatelstJT;}
        catch(exception e){}
             
             /*
             lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate];
             
    
            objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: taskId123 LIMIT 1];
            if(objJobTask.Job__r.Schedule_Calc__c == 'Start Date'){
                Integer NoOfDays = Integer.valueof(objJobTask.Days__c);
                dt123 = dt123.addDays(NoOfDays);
            }
            else if(objJobTask.Job__r.Schedule_Calc__c == 'End Date'){
                Integer NoOfDays = Integer.valueof(objJobTask.Days__c);
                dt123 = dt123.addDays(-1*NoOfDays);
            }
            
            updateRestScheduleRevDt123 = 'true';
             System.debug('Due Date is : '+dt123);
             System.debug('Task Id is : '+taskId123);
             System.debug('Value of updateRestScheduleRevDt123 : '+String.valueOf(updateRestScheduleRevDt123));
             
             DateTime NextTaskStartDate;
             //code for the update of the current schedule 
             Job_Task__c jobTask1,jobTask2,objJobTask;
             
              try
                {
                   //taskId123 = Id.valueOf(taskId123);
                   jobTask1 = new Job_Task__c(Id=taskId123,Revised_Due_Date__c = dt123);
                   update jobTask1;
                   objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id LIMIT 1];
                        Boolean blnFroward = true;
                        if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
                        {
                           blnFroward = false;
                        }  
                    if(!blnFroward )
                    {
                       System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                                                 //code for updating the start date of the current task
                        Integer jCount = 0;
                        //Integer newDaysValue = objJobTask.Days__c;
                     Datetime dtStartDate=DateTime.newInstance(dt123.Year(),dt123.Month(),dt123.Day());
                        System.debug('jCount value '+jCount);
                                    
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
                           Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                           objJobTask.Start_Date__c = afterDaysUpdate;   
                           update objJobTask;
                      } 
                    
                  
                   System.debug('Update current Job Task : '+jobTask1);
                   
                   if(String.valueOf(updateRestScheduleRevDt123) == 'true')
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
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                         }
                         else
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c DESC];
                         }
                        System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                        
                        System.debug('Size of Update Tasks : '+lstJobTasks.size());
                         
                        for(Integer i = 0; i <lstJobTasks.size(); i++)
                        {
                            System.debug('Value of i' +i);
                          DateTime dtStartDate3;
                                if(i == 0)
                                {
                                    lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                    if(blnFroward)
                                     {
                                      // dtStartDate3= lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                      
                                          lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                          dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                       
                                     }
                                     else
                                     {
                                     //  dtStartDate3= lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                       
                                          lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                          dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                          
                                          
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                    if(blnFroward)
                                     {
                                      //  dtStartDate3 = lstJobTasks[i].Start_Date__c = d4;
                                        
                                          lstJobTasks[i].Start_Date__c = d4;
                                         
                                         
                                          dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                     else
                                     {
                                      
                                      
                                      // dtStartDate3 = lstJobTasks[i].Revised_Due_Date__c = d4; 
                                         lstJobTasks[i].Revised_Due_Date__c = d4;
                                         dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                     }
                                    
                                }
                               
                            
                               //  if(blnFroward)
                                //     {
                                //        dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                                //     }
                                //     else
                               //      {
                                //         dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                                //     }
                               
                                System.debug('Day is:'+dtStartDate3.format('E'));
                            
                                System.debug('Start Date is : ' +dtStartDate3);
                            
                                lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;
                            
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
                                      lstJobTasks[i].Revised_Due_Date__c=d1;
                                       system.debug('Revise due============' +lstJobTasks[i].Revised_Due_Date__c); 
                                   }
                                  else
                                   {
                                      lstJobTasks[i].Start_Date__c=d1;
                                   }    
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                              }
                            update lstJobTasks;
                            System.debug('Updated List : '+lstJobTasks);
                         }
                }
                catch(Exception e)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,String.valueOf(e));
                    ApexPages.addMessage(myMsg);
                    lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate];
                    //return NULL;
                }
                // system.debug('$$$$$$$$$$$$$Helloooo'+Limits.getScriptStatements());
         // After updating the schedule navigate to Job --> Schedule Tab
        PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&intFocus=2');
        p.setRedirect(true);
        */
        lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Job__r.status__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate]; 
        dt123 = null;
        //return null;
        
    }
    
   
    
    public void refreshTasks()
    {
    
      isAllTasksDone=false;
         lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Job__r.status__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        
       
         List<Job_Task__c> relatedJTR =[Select Id, Name,Email__c, (Select Id,User__c,Email__c From Job_Task_Roles__r) from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
         System.debug('====relatedJTR ===='+relatedJTR);
       
        taskStaffMap = new Map<String, List<String>>();
        AsignStaffNoMap=new Map<String,Integer>();
        
        for (Job_Task__c jtask: relatedJTR) {
            if (jtask.Job_Task_Roles__r.size() > 0) {
                for (Job_Task_Role__c jtr: jtask.Job_Task_Roles__r) {
                    if (taskStaffMap.containsKey(jtask.id)) {
                        list < String > stlist = taskStaffMap.get(jtask.id);
                        stlist.add(jtr.User__c);
                        taskStaffMap.put(jtask.id, stlist);
        
                    } 
                    else {
                        taskStaffMap.put(jtask.id, new list < string >{jtr.User__c});
                    }
                }
            } 
            else {
                taskStaffMap.put(jtask.id, new list < string > {});
            }
            System.debug('====taskStaffMap final====' + taskStaffMap);
            AsignStaffNoMap.put(jtask.id, jtask.Job_Task_Roles__r.size());
        }
        
        
         for(Job_Task__c jtMark:lstJT){
           if(jtMark.Marked_Done__c==False){
                 isAllTasksDone=false;
                 break;
              }
            else{
            isAllTasksDone=true;
            }
         }
    }
    
    public pagereference Complete()
    {
         
         List<Job_Task__c> updateTsk=new List<Job_Task__c>();
         lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where id =:tskid LIMIT:1];
    
         try
         {
            
             for(Job_Task__c jtask:lstJT)
             {
                 jtask.Marked_Done__c=True;
                 jtask.Completion_Date__c=System.Today();
                 jtask.Status__c='Completed';
                 updateTsk.add(jtask);
             }
             
             update updateTsk;
             lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Job__r.status__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
         }
    
         catch(System.DMLException e)
         {
              apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
         }
         
            pagereference pp = new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
            pp.setredirect(true);
            return pp;
        
    }
    
    public pagereference Active()
    {
          List<Job_Task__c> updateTsk=new List<Job_Task__c>();
         lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Job__r.status__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where id =:tskid LIMIT:1];
    
         try
         {
            
             for(Job_Task__c jtask:lstJT)
             {
                 jtask.Marked_Done__c=False;
                 jtask.Completion_Date__c=Null;
                 jtask.Status__c='Active';
                 updateTsk.add(jtask);
             }
             
             update updateTsk;
             lstJT=[Select Name,Hours__c,Next_Task_Due__c,Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
         }
    
         catch(System.DMLException e)
         {
              apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
         }
         
         pagereference pp = new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules');
            pp.setredirect(true);
            return pp;
       
    }
    
    
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
        
        
       
       
        
        jobTask= new List<Job_Task__c>();
         Date myDate = system.today();
         String completed = 'completed';
         string jobTaskid = ApexPages.currentPage().getParameters().get('id');
          soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c';
       
          if(jobTaskid !=Null )
              soqlJobTask+=' where Job__c=:jobTaskid';
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
            */   
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
               
               System.debug('=========Revised_Due_Date__c========='+jobt.Revised_Due_Date__c);
                System.debug('=========Revised_Due_Date__c Adeed 1 day========'+jobt.Revised_Due_Date__c);
                 System.debug('=========endDT ========='+endDT);
                  System.debug('=========startString ========='+endDT.format());
                   System.debug('=========endstring========='+endDT.format());
               
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
                   j.Staff= TaskUsersname ;
                   J.className = 'event-Jobs';
                   events.add(J);
                   
                   
                   system.debug('=======events====='+events);
       
       }
       }
       else
       {
           //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'There are no Tasks to display on Calendar'));
       }
       return null;      
   } 
    
    
   public void calenderTaskEdit(){
  
  isPopup=true;
  String CalTaskId=Apexpages.CurrentPage().getParameters().get('CalTaskId');
  system.debug('=======CalTaskId======'+CalTaskId);
  EditTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:CalTaskId];
  }
  
  public void CaleEditSave(){
  String DueDate;
  
  try{
        if(EditTask.Status__c=='Completed')
            {
               if(EditTask.Completion_Date__c == Null)
                {
                    EditTask.Completion_Date__c=System.Today();
                }
                EditTask.Marked_Done__c=True;
               // objJobTask.Completion_Date__c=System.Today();
            }
        else if(EditTask.Status__c=='Active'||EditTask.Status__c=='Requested')
            {
                 EditTask.Marked_Done__c=False;
                 EditTask.Completion_Date__c=NULL;
            }
  
    update EditTask;
    //Date=EditTask.Revised_Due_Date__c;
    CalDD=DateTime.newInstance(EditTask.Revised_Due_Date__c.year(), EditTask.Revised_Due_Date__c.month(), EditTask.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
    
  }
  catch(System.DmlException e){
   //return null;
  }
  JobTask();
 isPopup=false;
  //pagereference pp = new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules&Date='+DueDate);
  //pp.setredirect(true);
  //return pp;
  
  }
  
  
  
 public void CalEditCancel(){
 //JobTask();
 isPopup=false;
 //JobTask();
 }  
    
    
  public void statusChangeUpdate(){
  String DueDate;
  String DTaskId=Apexpages.CurrentPage().getParameters().get('DTaskId');
  String DTaskStatus=Apexpages.CurrentPage().getParameters().get('DTaskStatus');
  
  try{
       Job_Task__c JStatusUpdate=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:DTaskId];
       
       if(JStatusUpdate.Status__c=='Completed' && JStatusUpdate.Completion_Date__c!=null ){
          JStatusUpdate.Status__c='Active';
          JStatusUpdate.Completion_Date__c=null;
          JStatusUpdate.Marked_Done__c=false;
        }
        
       else{
          JStatusUpdate.Status__c='Completed';
          JStatusUpdate.Completion_Date__c=System.Today();
          JStatusUpdate.Marked_Done__c=true;
        }
        update JStatusUpdate;
     CalDD=DateTime.newInstance(JStatusUpdate.Revised_Due_Date__c.year(), JStatusUpdate.Revised_Due_Date__c.month(), JStatusUpdate.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
   }
   
   Catch(System.DMLException e){
     //return null;
    }
    JobTask();
      //pagereference pp = new pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=schedules&Date='+DueDate);
      //pp.setredirect(true);
      //return pp;
      //return null;
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
   Job_Task__c DueDateUpdate=[Select Id,Name,Revised_Due_Date__c,Status__c,Start_Date__c,GL_Code__c,GL_Code__r.Name,Task_Start_Time_Text__c,Task_End_Time_Text__c,Completion_Date__c,Marked_Done__c,Days__c,Task_Order__c,Locked__c,Report__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id =:DCalTaskId];
   DueDateUpdate.Revised_Due_Date__c=sd;
  CalDD= DateTime.newInstance(DueDateUpdate.Revised_Due_Date__c.year(),DueDateUpdate.Revised_Due_Date__c.month(),DueDateUpdate.Revised_Due_Date__c.day()).format('yyyy-MM-dd');
   update DueDateUpdate;
   }
   
   catch(System.DMLException e){
   
   }
  JobTask();
  }
      
    
    
    
     
 /*
    @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate,string jn) 
    {
       
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
            jobTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID];
            jobTask.Revised_Due_Date__c = sd;
            upsert jobtask;   
           
            return true;
       
    }
     
  */  
    
    
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
        public string Tstatus {set;get;}
        public String className {get;set;}
    }
    
    
    
}
// End of class