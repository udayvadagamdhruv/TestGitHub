// This class is used to edit Job Task (Schedules) under Job tab
public with sharing class EditJobTaskExtension
{

    public boolean isMobile{
                         
                          private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d' || theme=='Theme4t')?true:false;
                                          }
                         }

     // Global variables
    String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    //public Job_Task__c objJobTask;
    private final Job_Task__c objJobTask;
    private final Job_Task__c oldobjJobTask;
    
    String strId1,strId2;
     public list<Job_Team__c> staffs;
     public List<selectOption> StaffoptionList{get;set;}
     public List<string> selectedStaff{get;set;}
     // End of Global variables
 
    public string pagefrom {set;get;}
 
    // Standard Controlle Constructor
    public EditJobTaskExtension(ApexPages.StandardController controller) 
    {
          this.oldobjJobTask = this.objJobTask=(Job_Task__c)controller.getrecord();
          Job_Task__c abc = [select id,Name,GL_Code__c,Job__c,Assigned_Users__c  from Job_Task__c  where id =: objJobTask.id Limit 1];
          GLCName = abc.GL_Code__c;
          selectedStaff=new List<string>();
          
          pagefrom=Apexpages.CurrentPage().getParameters().get('pagefrom');
           
      
           if(isMobile || test.isRunningTest())
           {
         
                  string jobid=abc.Job__c;
                  
                  if(abc.Assigned_Users__c!=null)
                  {
                      selectedStaff = abc.Assigned_Users__c.split(', ');
                      
                  }   
               
                     
                      String query ='Select id,name,Staff__c,Role__c from Job_Team__c where Job__c=:jobid and Staff__c!=null';
                      staffs = Database.query(query);
                     
                      StaffoptionList= new List<selectOption>();
                      
                      for(Job_Team__c Jteam:staffs)
                      {
                          StaffoptionList.add(new selectOption(Jteam.Staff__c, Jteam.Staff__c));
                      }
                      
           }          
          
    }
    // End Constructor
   
   // Retrieve all GLCode into dropdown list 
   public List<selectOption> getGLCodes() 
   {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
   }
   // End of method getGLCodes
   
  // This method is called on to Save JobTask
 
    // This method is called on to Save JobTask
    
   
   Public PageReference saveme()
    {
        strId1 =  objJobTask.Job__c;   
        try
        {
        
          if(GLCName == null )
            { 
              objJobTask.GL_Code__c = Null;
            }
          else
            {    
              GL_Code__c gc=[Select Id,Name from GL_Code__c where Id=:GLCName];
              objJobTask.GL_Code__c=gc.Id;
             }
             
                   
            if(objJobTask.Status__c=='Completed')
            {
               if(objJobTask.Completion_Date__c == Null)
                {
                    objJobTask.Completion_Date__c=System.Today();
                }
                objJobTask.Marked_Done__c=True;
               // objJobTask.Completion_Date__c=System.Today();
            }
            else if(objJobTask.Status__c=='Active'|| objJobTask.Status__c=='Requested')
            {
                 objJobTask.Marked_Done__c=False;
                 objJobTask.Completion_Date__c=NULL;
            }
            
            
            
                    Job_Task__c oldObj = [select Id,Name,Days__c,Revised_Due_Date__c,Job__r.Schedule_Calc__c,Job__r.id from Job_Task__c where id =: objJobTask.id limit 1];
                    system.debug('Old value' + oldObj );
                  
                            /*  For Moblie app */
                            if(isMobile || test.isRunningTest())
                            {
                                String selectedstaffstring='';
                                integer length=selectedStaff.size();
                                integer i=1;
                                for(String s:selectedStaff)
                                {
                                    if(i !=length )
                                    selectedstaffstring = selectedstaffstring+s+', ';
                                    else
                                    selectedstaffstring = selectedstaffstring+s;
                                    i++;
                                }
                                objJobTask.Assigned_Users__c = selectedstaffstring;
                            }
                            /* END */
                            
                    update objJobTask;
                    system.debug('Old value' + oldObj ); 
                     Set<Date> holidaysNew;
                                  holidaysNew= new Set<Date>();
                    if(oldObj.Days__c != objJobTask.Days__c)
                    {
                        
                                  
                                 
                                 for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL])
                                 {
                                     holidaysNew.add(hc.Date__c);
                                 }
                                 
                                
                             System.debug('Not matched');
                              Boolean blnFroward = true;
                             if(oldObj.Job__r.Schedule_Calc__c == 'End Date')
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
                                              objJobTask.Revised_Due_Date__c = afterDaysUpdate;   
                                         }
                                         else
                                         {
                                             objJobTask.Start_Date__c = afterDaysUpdate;   
                                         }
                              
                                 update objJobTask;  
                                 
                                
                              //code for the update of the below and above task respectively  
                              List<Job_Task__c> lstTaskBelow ;
                              
                                if(blnFroward)
                                         {
                                             lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :oldObj.Job__r.Id and Id !=: objJobTask.Id and Task_Order__c >=: objJobTask.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c ASC];   
                                         }
                                         else
                                         {
                                             lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :oldObj.Job__r.Id and Id !=: objJobTask.Id and Task_Order__c <=: objJobTask.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c DESC]; 
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
                                        dtStartDate3= lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                                     }
                                     else
                                     {
                                        dtStartDate3= lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                   
                                    if(blnFroward)
                                     {
                                         dtStartDate3= lstTaskBelow[i].Start_Date__c = d4; 
                                     }
                                     else
                                     {
                                         dtStartDate3=lstTaskBelow[i].Revised_Due_Date__c = d4; 
                                     }
                                }
                                
                                 
                                // if(blnFroward)
                                //     {
                               //           dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                               //     }
                                //     else
                                //     {
                               //           dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0)); 
                               //      }
                            
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
                       update lstTaskBelow;
               
                 }
                else if(oldObj.Revised_Due_Date__c != objJobTask.Revised_Due_Date__c || test.isRunningTest())
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
                        update objJobTask;             
                        Datetime dtStartDate;
                                 Boolean blnFroward = true;
                        if(oldObj.Job__r.Schedule_Calc__c == 'End Date')
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
                                objJobTask.Start_Date__c = afterDaysUpdate;
                                System.debug('afterDaysUpdate value '+afterDaysUpdate);
                              
                               update objJobTask;  
                    
                         }
                  
                   System.debug('Update current Job Task : '+objJobTask);
                   
                   
                         // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current job
                /*        Date startDateForNextTask ;
                       //    Boolean blnFroward = true;
                      //  if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
                      //  {
                      ////     blnFroward = false;
                      //  }  
                        if(blnFroward)
                         {
                            startDateForNextTask = Date.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.month(),objJobTask.Revised_Due_Date__c.Day());
                         }
                         else
                         {
                            startDateForNextTask = Date.newInstance(objJobTask.Start_Date__c.Year(),objJobTask.Start_Date__c.month(),objJobTask.Start_Date__c.Day());
                         }
                    
                        List<Job_Task__c> lstJobTasks;// = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                        
                        if(blnFroward)
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: oldObj.Job__r.Id and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                         }
                         else
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: oldObj.Job__r.Id  and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c DESC];
                         }
                        System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                        
                        System.debug('Size of Update Tasks : '+lstJobTasks.size());
                         
                            for(Integer i = 0; i <lstJobTasks.size(); i++)
                            {
                                System.debug('Value of i' +i);
                                    DateTime dtStartDate3;
                                        if(i == 0)
                                        {
                                           // lstJobTasks[i].Start_Date__c = startDateForNextTask;
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
                                               dtStartDate3= lstJobTasks[i].Start_Date__c = d4; 
                                             }
                                             else
                                             {
                                                dtStartDate3=lstJobTasks[i].Revised_Due_Date__c = d4; 
                                             }
                                            
                                        }
                                   
                                
                                   //  if(blnFroward)
                                    //     {
                                     //       dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                                     //    }
                                     //    else
                                    //     {
                                   //          dtStartDate3 = DateTime.NewInstance(lstJobTasks[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0));
                                   //      }
                                   
                                    System.debug('Day is:'+dtStartDate3.format('E'));
                                
                                    System.debug('Start Date is : ' +dtStartDate3);
                                
                                    lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;
                                
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
                                              lstJobTasks[i].Revised_Due_Date__c=d1;
                                           }
                                          else
                                           {
                                              lstJobTasks[i].Start_Date__c=d1;
                                           }    
                                         NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                                  }
                            update lstJobTasks;
                            System.debug('Updated List : '+lstJobTasks);*/
                        Date startDateForNextTask ;
                        //Id idTask = 
                        Job_Task__c objJobTaskNew = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c ,Job__r.id from Job_Task__c where id =: objJobTask.id limit 1];
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
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                         }
                         else
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and Marked_Done__c =: False Order BY Task_Order__c DESC];
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
                                      lstJobTasks[i].Revised_Due_Date__c=d1;
                                   }
                                  else
                                   {
                                      lstJobTasks[i].Start_Date__c=d1;
                                   }    
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                              }
                            update lstJobTasks;
                            System.debug('Updated List : '+lstJobTasks);
                       //  }
               // } commented for gl code change
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }   
        // After updating JobTask, navigate to Schedules Tab   
         pagereference p;
         if(isMobile)
         {
              string page = apexpages.currentpage().getparameters().get('page');
              if(page=='Jobdetailpage')
              {
                   p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+strId1+'&tab=RelatedList'+'&section=Schedule');
                
              }
              else if(page=='TaskDueMobile'){
              p=new Pagereference('/apex/getmytasksMobile');
              }
              else 
              {
                if(pagefrom=='listPage'){
                  p=new Pagereference('/apex/JobdetailpageLightening07?id='+strId1+'&section=schedules');
                  }
               else{
                  p = new pagereference('/apex/JobTaskDetailPageLightning?id='+objJobTask.id);
                 // p = new pagereference('/'+objJobTask.id);
                  }
              }
                 p.setRedirect(true);
                 return p; 
         }
        
        //p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strId1+'&intFocus=2');
       // p.setRedirect(true);
        //return p; 
        String th = userinfo.getUiTheme();
       //PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strId1+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+strId1+'&intFocus=2'); 
       p.setRedirect(true);
       return p;
  
        
    }
    
    // Method for Cancel button 
    Public PageReference cancelme()
    {
       strId2 =  objJobTask.Job__c;    
       pagereference p;
        if(isMobile)
        {
        
            string page = apexpages.currentpage().getparameters().get('page');
            if(page=='Jobdetailpage')
            {
                 p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+strId2+'&tab=RelatedList'+'&section=Schedule');
                
            }
            else if(page=='TaskDueMobile'){
              p=new Pagereference('/apex/getmytasksMobile');
              }
            
          else 
            {
              if(pagefrom=='listPage'){
                  p=new Pagereference('/apex/JobdetailpageLightening07?id='+strId2+'&section=schedules');
                  }
              else{ 
               p = new pagereference('/apex/JobTaskDetailPageLightning?id='+objJobTask.id);
               }
            }
                 p.setRedirect(true);
                 return p; 
            
        }
      
      // p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strId2+'&intFocus=2');
       //p.setRedirect(true);
       //return p;
       String th = userinfo.getUiTheme();
       //PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strId2+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+strId2+'&intFocus=2'); 
       p.setRedirect(true);
       return p;
    } 
    // End of Cancel method


    // Test Coverage Code
  /*  static testMethod void Test_EditJobTaskExtension()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 617');
              insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 617',Media_Types__c=testMedia.Id);
              insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 617');
              insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 617',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c = 'Start Date');
              insert testJob1;
          System.assertEquals('Test Job 617',testJob1.Name);
          
          GL_Department__c testGLD = new GL_Department__c(Name='GLD012');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
         GL_Code__c testGL=new GL_Code__c(Name='GLC012',GL_ID__c='GLC012',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
                 
         Job_Task__c testJobTask=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,GL_Code__c=TestGL.id,Start_Date__c  = System.Today(),Days__c = 2 );
              insert testJobTask;
    
        Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 618',Job__c=testJob1.Id,GL_Code__c=TestGL.id,Start_Date__c  = System.Today(),Days__c = 2);
              insert testJobTask1;
        //Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 619',Job__c=testJob1.Id,GL_Code__c=TestGL.id,Start_Date__c  = System.Today()+2,Days__c = 2);
              //insert testJobTask2;
         // Instantiate the standard controller with the Job Task
         ApexPages.StandardController con=new ApexPages.StandardController(testJobTask);
        
         // Instantiate the extention instance with the standardcontroller 
         EditJobTaskExtension ext=new EditJobTaskExtension(con);
         ext.GLCName = NULL; // To check GLCode as NULL
         String GLCName1 = ext.getGLCName();
         ext.setGLCName(GLCName1);
         List<SelectOption> options1 = ext.getGLCodes(); 
        
         // Invoke the primary method on the extension
       //  testJobTask.Days__c = 2;
       //  con=new ApexPages.StandardController(testJobTask);
        ApexPages.PageReference result=ext.saveme();  
        // ext.GLCName = testGL.id;
        // String GLCName = ext.getGLCName();
        // ext.setGLCName(GLCName);
         //List<SelectOption> options = ext.getGLCodes(); 
        
         // Invoke the primary method on the extension 
        // result=ext.saveme();    
         //result=ext.cancelme();
        
         // To cover Catch block
         delete testJobTask;
        // result=ext.saveme();  
         
         
         
          Job__c testJob2=new Job__c(Name='Test Job 618',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c = 'End Date');
              insert testJob2;
          System.assertEquals('Test Job 618',testJob2.Name);
          
          Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 628',Job__c=testJob2.Id,GL_Code__c=TestGL.id,Revised_Due_Date__c= System.Today(),Days__c = 2);
              insert testJobTask3;
        Job_Task__c testJobTask4=new Job_Task__c(Name='Job Task 629',Job__c=testJob2.Id,GL_Code__c=TestGL.id,Revised_Due_Date__c= System.Today()-2,Days__c = 2);
              insert testJobTask4;
         // Instantiate the standard controller with the Job Task
         ApexPages.StandardController con1=new ApexPages.StandardController(testJobTask4);
        
         // Instantiate the extention instance with the standardcontroller 
         EditJobTaskExtension ext1=new EditJobTaskExtension(con1);
         ext1.GLCName = NULL; // To check GLCode as NULL
         GLCName1 = ext1.getGLCName();
         ext1.setGLCName(GLCName1);
         options1 = ext1.getGLCodes(); 
        
         // Invoke the primary method on the extension
       //  testJobTask.Days__c = 2;
       //  con=new ApexPages.StandardController(testJobTask);
        ApexPages.PageReference result1=ext1.saveme();  
         }*/
    // Test Coverage
}
// End of Class