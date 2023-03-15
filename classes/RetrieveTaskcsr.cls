// This class is used as a controller to display Schedules under Schedule SubTab in Job Tab
public with sharing class RetrieveTaskcsr
{  
    // Global Variables
  /*  public string methodName;
    public string strTaskName{get;set;}
    public String campaignId{get;set;}
    public string strJTID{get;set;}
    public Id strJTID1{get;set;}
    public Id strJTID2{get;set;}
    public List<Job_Task__c> lstJT{get;set;}
    public Id jobId{get;set;}
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
                  // Update the current Task Revised Due Date and Days
          if(String.valueOf(updateRestScheduleDays) == 'true')
          {
                       
                               
                  
                  // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current Job
                  List<Job_Task__c> lstTaskBelow ;
                  updateRemainingTasks updCntrler = new updateRemainingTasks();
                  updCntrler.objTask1 = objTask1;
                  updCntrler.jobId = jobId;
                  updCntrler.blnFroward = blnFroward;
                  updCntrler.methodName = 'Dayschange';
                  updCntrler.updateTask();
                  
                    /**************if(blnFroward)
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
                              lstTaskBelow[i].Revised_Due_Date__c=d1;
                         }
                         else
                         {
                              lstTaskBelow[i].Start_Date__c=d1;
                         }
                         
                         NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                system.debug('$$$$$$$$$$$$$'+Limits.getScriptStatements());
                update lstTaskBelow;
               
                System.debug('Updated Task : '+lstTaskBelow);
                System.debug('Size of Task : '+lstTaskBelow.size());  ******
     
         }
    
         // After Schedule Update Navigate to Job
        PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
        p.setRedirect(true);
        return p; 
    }
    // This method is called on to update Schedule when Days of particular Task has changed

    
    // End of method updateScheduleOnDays


        public pagereference updateRestSchedule()
    {
             System.debug('Due Date is : '+dt);
             System.debug('Task Id is : '+taskId);
             System.debug('Value of updateRestScheduleRevDt : '+String.valueOf(updateRestScheduleRevDt));
         
             DateTime NextTaskStartDate;
             //code for the update of the current schedule 
             Job_Task__c jobTask1,jobTask2,objJobTask;
             
              try
                {
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
                                Date d3=Date.newInstance(dt.Year(),dt.Month(),dt.Day());
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
                        
                       updateRemainingTasks updCntrler = new updateRemainingTasks();
                       updCntrler.objTask1 = objJobTask;
                       updCntrler.jobId = jobId;
                       updCntrler.blnFroward = blnFroward;
                       updCntrler.methodName = 'Datechange';
                       updCntrler.updateTask();
                        /*************if(blnFroward)
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
                                       dtStartDate3= lstJobTasks[i].Start_Date__c = startDateForNextTask;
                                     }
                                     else
                                     {
                                       dtStartDate3= lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                    if(blnFroward)
                                     {
                                        dtStartDate3 = lstJobTasks[i].Start_Date__c = d4; 
                                     }
                                     else
                                     {
                                       dtStartDate3 = lstJobTasks[i].Revised_Due_Date__c = d4; 
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
                                   }
                                  else
                                   {
                                      lstJobTasks[i].Start_Date__c=d1;
                                   }    
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                              }
                            update lstJobTasks;
                            System.debug('Updated List : '+lstJobTasks);********
                         }
                }
                catch(Exception e)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,String.valueOf(e));
                    ApexPages.addMessage(myMsg);
                    return NULL;
                }
                 system.debug('$$$$$$$$$$$$$Helloooo'+Limits.getScriptStatements());
         // After updating the schedule navigate to Job --> Schedule Tab
        PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
        p.setRedirect(true);
        return p;
    }
    
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
           lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate ORDER BY Task_Order__c];
         }
         else
         {
            std=Date.newInstance(objJob.Due_Date__c.Year(),objJob.Due_Date__c.month(),objJob.Due_Date__c.Day());
            lstScheduleTask=[Select Name,Days__c,GL_Code__c,Locked__c,Report__c,Task_Order__c from Schedule_Task__c where Schedule_Template__c =: strScheduleTemplate ORDER BY Task_Order__c desc];
         }
         System.debug('std is:'+std);
        
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
           Job_Task_Role__c objJobTaskRole=new Job_Task_Role__c();
 
           Job_Team__c[] objJobTeam=[Select Staff__c from Job_Team__c where Role__c=: st1.Name and Job__c=:jobId limit 1];
           if(!objJobTeam.isEmpty())
           {
               objJobTaskRole.Name=st1.Name;
               objJobTaskRole.Job_Task__c=mp2.get(st1.Schedule_Task__c);
               String strStaff=objJobTeam[0].Staff__c;           
               objJobTaskRole.User__c=strStaff;
               lstJobTaskRole.add(objJobTaskRole);
          }
       }  
        insert lstJobTaskRole;

        
        // After creating Schedule, Navigate To Schedules Tab
        PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
        p.setRedirect(true);
        return p;
  
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
   public RetrieveTaskcsr(ApexPages.StandardController st)
    {
        TaskId3=ApexPages.CurrentPage().getParameters().get('paramU');
        jobId = ApexPages.currentPage().getParameters().get('id');     
        Job__c objJob=[Select Id,Campaign__c from Job__c where Id=: jobId LIMIT 1];
        campaignId=objJob.Campaign__c;
        lstJT=[Select Name, Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate];
         
        //String methodName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        //system.debug('Class Name ISSSSSSSSSSSSSSSSSSSSSSSSSSSSSS'+methodName);
        
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
                else if(objJT.Marked_Done__c==False)
                {
                    objJT.Completion_Date__c=NULL;
                    objJt.Status__c='Active';
                }
                updatelstJT.add(objJT);
             }
             update updatelstJT;
         }
         catch(System.DMLException e)
         {
           return null;
         }
         // After inline edit Save navigate to Schedules Tab
        PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
        p.setRedirect(true);
        return p; 
    }
    // End of method Save
    
     // This method is called on to handle Cancel button
     public PageReference cancelme()
     {
            PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=2');
            p.setRedirect(true);
            return p;     
     }
     // End of method Cancel
    
      // This method is called on to handle Calendar View button
      public Pagereference displayTasksInCalendar()
      {
            PageReference p =  new Pagereference('/apex/Calendar?id='+jobId);
            p.setRedirect(true);
            return p;
       }
       // End of method displayTasksInCalendar
    
     // This method is called on to handle Insert Task button
    public Pagereference insertNewTask()
    {
            PageReference p =  new Pagereference('/apex/CreateNewJobTaskAbove?id='+strJTID1);
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
       // End of method addNewTask
       
       //Method Called on Move Task Up and Down
       Public pagereference moveUpandDown()
       {
       
       objJobTask=[Select Job__c,Task_Order__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c from Job_Task__c where Id=: TaskId3];
       system.debug('objJobTask');
       return null;
       }
       
 
    
     // Start Test Coverage 
        static testMethod void Test_RetrieveTaskcsr()
        {
              
           Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
         
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 614');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 614',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 914',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule1;
                
            Schedule_Task__c testSchedule2=new Schedule_Task__C(Name='Test Schedule Task 915',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule2;
                
            ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Test Role 001',Schedule_Task__c=testSchedule1.id);
                insert testSTR1;
                
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 614');
                insert testSpec;
                
             Job__c testJob1=new Job__c(Name='Test Job 614',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
         
                 insert testJob1;
                 
             System.assertEquals('Test Job 614',testJob1.Name);
                 
            Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 615',Job__c=testJob1.Id,Marked_Done__c=True,Days__c=2);
        
                insert testJobTask1;
        
        
            // Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3);
        
             //   insert testJobTask2;
        
            Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3);
        
                insert testJobTask3;
        
            Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Job Task Role 615',Job_Task__c=testJobTask1.Id);
        
                insert testJTR1;
                
                
                
                 List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job__c.Schedule_Calc__c.getDescribe();
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
      
           Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='End Date');
         
                 insert testJob2;
                 
             System.assertEquals('Test Job 615',testJob2.Name);
                 
            Job_Task__c testJobTask4=new Job_Task__c(Name='Job Task 617',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2);
        
                insert testJobTask4;
        
        
             Job_Task__c testJobTask6=new Job_Task__c(Name='Job Task 618',Job__c=testJob2.Id,Marked_Done__c=False,Days__c=3);
        
                insert testJobTask6;
        
            Job_Task__c testJobTask5=new Job_Task__c(Name='Job Task 619',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3);
        
                insert testJobTask5;
        
            Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Job Task Role 618',Job_Task__c=testJobTask4.Id);
        
                insert testJTR2;
            ApexPages.currentPage().getParameters().put('id',testJob1.Id); 
       
            // Instantiate the standard controller with the Job
            
            ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
       
            // Instantiate the extention instance with the standard controller 

            RetrieveTaskcsr ext1=new RetrieveTaskcsr(con);

            ext1.strJTID=testJobTask1.Id;
           
  //          ext1.strJTID=testJobTask2.Id;
         
            // Invoke the primary method on the extension
            
            ApexPages.Pagereference result=ext1.save();
       
       DateTime dtnbew = System.Today().AddDays(2);
       Date d4 = Date.newInstance(dtnbew .Year(), dtnbew .Month(), dtnbew .Day());
        ext1.dt= d4 ;
       ext1.taskId1 = testJobTask5.id;
       //ext1.updateRestScheduleDays= 'true';
       result=ext1.updateRestSchedule();
       
           result=ext1.displayTasksInCalendar();
       
           result=ext1.createSchedule();
       
           result=ext1.addNewTask();
       
           result=ext1.insertNewTask();
       
           result=ext1.EditJobTask();
         
         
       
         
            Job_Task__c objTaskNew1 = [select id, name, Days__c,Start_date__c from Job_Task__c where id=: testJobTask5.id]  ;
       objTaskNew1.Days__c = 5;
       update objTaskNew1;
       ext1.days1= '5';
       ext1.taskId1 = objTaskNew1.id;
       //ext1.updateRestScheduleDays= 'true';
       result=ext1.updateScheduleOnDays();
       
      
       
       result=ext1.deleteJobTask();
         result=ext1.cancelme();
       
           result=ext1.createSchedule();
            
       
       
         ApexPages.currentPage().getParameters().put('id',testJob2.Id); 
       
            // Instantiate the standard controller with the Job
            
             con=new ApexPages.StandardController(testJob2);
       
            // Instantiate the extention instance with the standard controller 

            RetrieveTaskcsr ext2=new RetrieveTaskcsr(con);

           // ext1.strJTID=testJobTask5.Id;
           
            ext1.strJTID=testJobTask6.Id;
         
            // Invoke the primary method on the extension
            
            result=ext1.save();
       
          
            ext1.strJTID=testJobTask6.Id;
            
            
             // testJobTask5=new Job_Task__c(Name='Job Task 6177',Job__c=testJob1.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3);
        
              //  insert testJobTask5;
                
            //Job_Task__c objTaskNew2 = [select id, name, Days__c,Start_date__c,Revised_Due_Date__c from Job_Task__c where id=: testJobTask3.id]  ;
      // testJobTask5.Revised_Due_Date__c = ;
       //update testJobTask5;
      
       
        result=ext2.displayTasksInCalendar();
       
         //  result=ext2.createSchedule();
       
         //  result=ext2.addNewTask();
       
         //  result=ext2.insertNewTask();
       
          // result=ext2.EditJobTask();
         
           result=ext2.cancelme();
       
          //result=ext2.createSchedule();
       
           result=ext2.deleteJobTask();
       
       
       
         // Job__c testJob3=new Job__c(Name='Test Job 615',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
         
          //       insert testJob3;
                 
          // ApexPages.currentPage().getParameters().put('id',testJob3.Id); 
         
          // ApexPages.StandardController con2=new ApexPages.StandardController(testJob3);
        
          //  RetrieveTaskcsr ext3=new RetrieveTaskcsr(con2);
        
         //   result=ext3.createSchedule();
            
           // Delete Job Tasks
             List<Job_Task__c> lstTask=[select id from Job_Task__c where Job__c=:testJob2.Id];
             delete lstTask;
         
             // Delete Job Specs
         
             List<Job_Spec__c> lstSpecs=[select id from Job_Spec__c where Job__c=:testJob2.Id];
             delete lstSpecs;
         
             Job__c obj1=[Select id,Status__c from Job__c where Name=: 'Test Job 615'];
             obj1.Status__c='Cancelled';
             update obj1;
         
         // To cover catch block
         Job__c obj2=[Select id from Job__c where Name=: 'Test Job 615'];
         delete obj2;
 
     //   delete testJob1;
        result=ext1.save();
        }*/
    // End of Test Coverage
}
// End of class