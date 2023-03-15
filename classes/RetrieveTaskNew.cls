// This class is used as a controller to display Schedules under Schedule SubTab in Job Tab
public with sharing class RetrieveTaskNew
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
            if(objJob.Schedule_Calc__c == GlobalClass.END_DATE)
            {
               blnFroward = false;
            }
         
         Job_Task__c objTask1; 
              objTask1 = [Select Id, Name, Job__c, Job__r.Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Id =: taskId1 LIMIT 1];
              
              System.debug('Job Name is : '+objTask1.Job__r.Name);
             Datetime dtStartDate1;
               
                  if(blnFroward)
                     {
                         dtStartDate1  = Datetime.newInstance(objTask1.Start_Date__c,Time.newInstance(12, 0, 0, 0));
                     }
                     else
                     {
                         dtStartDate1 = Datetime.newInstance(objTask1.Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                     }
                  
                  System.debug('Start Date is : ' +dtStartDate1);
             
                  Date d3=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                  dtStartDate1=  GlobalClass.CalculateDays(d3,blnFroward,newDaysValue);
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
         // updateTasks(Job_Task__c objJobTask, Boolean blnFroward, Boolean blnUpdateTaskOrder, String strid, Double task_order_no, Date d1)
                  // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current Job
                  String strJobId = objTask1.Job__c;
                  Double dbTaskOrder = objTask1.Task_Order__c;
                 // updateTasks(Job_Task__c objJobTask, Boolean blnFroward, Boolean blnUpdateTaskOrder, String strid, Double task_order_no, Date d1)
                  GlobalClass.updateTasks(objTask1, blnFroward,  false, strJobId , dbTaskOrder , afterDaysUpdate,true);     
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
                        if(objJobTask.Job__r.Schedule_Calc__c == GlobalClass.END_DATE)
                        {
                           blnFroward = false;
                        }  
                    if(!blnFroward)
                    {
                           Double days = objJobTask.Days__c;
                           Datetime dtStartDate= GlobalClass.CalculateDays(dt, blnFroward, days);
                           Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                           objJobTask.Start_Date__c = afterDaysUpdate;   
                           update objJobTask;
                      } 
                      
                    
                  
                   System.debug('Update current Job Task : '+jobTask1);
                   
                   if(String.valueOf(updateRestScheduleRevDt) == 'true')
                   {                        
                    
                         // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current job
               
                       String strJobId = objJobTask.Job__c;
                       Double dbTaskOrder = objJobTask.Task_Order__c;
                 // updateTasks(Job_Task__c objJobTask, Boolean blnFroward, Boolean blnUpdateTaskOrder, String strid, Double task_order_no, Date d1)
                      GlobalClass.updateTasks(objJobTask, blnFroward,  false, strJobId , dbTaskOrder , objJobTask.Start_Date__c,true);       
                     
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
            if(objJob.Schedule_Calc__c == GlobalClass.END_DATE)
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
              
                  Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                  Double days = jt.Days__c;
                   //Date d1= GlobalClass.CalculateDays(d3, blnFroward, days);
               dtStartDate =  GlobalClass.CalculateDays(d3, blnFroward, days);
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
   public RetrieveTaskNew(ApexPages.StandardController st)
    {
        TaskId3=ApexPages.CurrentPage().getParameters().get('paramU');
        jobId = ApexPages.currentPage().getParameters().get('id');     
        Job__c objJob=[Select Id,Campaign__c from Job__c where Id=: jobId LIMIT 1];
        campaignId=objJob.Campaign__c;
        lstJT=[Select Name, Start_Date__c,Days__c,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c from Job_Task__c where Job__c =: jobId Order By Task_Order__c];
        lstJobTeam=[Select Id, Role__c,Staff__c, Job__r.Name from Job_Team__c where Job__c =: jobId order by createddate];
         
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
        static testMethod void Test_RetrieveTaskNew()
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

            RetrieveTaskNew ext1=new RetrieveTaskNew(con);

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

            RetrieveTaskNew ext2=new RetrieveTaskNew(con);

           // ext1.strJTID=testJobTask5.Id;
           
            ext1.strJTID=testJobTask6.Id;
         
            // Invoke the primary method on the extension
            
            result=ext1.save();
       
          
            ext1.strJTID=testJobTask6.Id;
           result=ext2.displayTasksInCalendar();
            result=ext2.cancelme();
       
          //result=ext2.createSchedule();
       
           result=ext2.deleteJobTask();
                   
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