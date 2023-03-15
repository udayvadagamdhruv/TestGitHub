// This Class is used for Delete_Job_Task 

public with sharing class DeleteJobTaskExtension 
{
    // Global variables
    public Id JobId;
    private final Job_Task__c objJobTask; 
    public Double Task_Order_No{get;set;}
    // End of Global variables
    
    // Start Constructor 
    public DeleteJobTaskExtension(ApexPages.StandardController controller) 
     {
         this.objJobTask=(Job_Task__c)controller.getrecord();
         JobId = [Select Id, Job__c from Job_Task__c where Id =:objJobTask.Id limit 1].Job__c; 
         Task_Order_No= [Select Id, Task_Order__c from Job_Task__c where Id =:objJobTask.Id limit 1].Task_Order__c;
     }
     // End of Constructor
     
     // Method Used to delete JobTask
     public PageReference checkDelete()
      {
       try
        {  
            Job_Task__c objCurrentJobTask =  [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where id=: objJobTask.id Order BY Task_Order__c];
            Database.delete(objJobTask); 
            Set<Date> holidaysNew = new Set<Date>();
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL])
            { 
                   holidaysNew.add(hc.Date__c);
            }
                                 
                                 
            Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=:jobId];
            
           Boolean blnFroward = true;
           if(objJob.Schedule_Calc__c == 'End Date')
           {
              blnFroward = false;
           }
                                
            //Code added for Schedule Calc check
       //     if(objJob.Schedule_Calc__c == 'Start Date')
       //     {
                List<Job_Task__c> lstTaskBelow;
                System.debug('Below Task records after deletion : '+lstTaskBelow);
                if(blnFroward)
                {
                  lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No Order BY Task_Order__c];
                }
                else
                {
                  lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c <: Task_Order_No Order BY Task_Order__c desc];
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
                                      
                                       lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                                       dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                       
                                       lstTaskBelow[i].Task_Order__c = Task_Order_No;
                                     }
                                     else
                                     {
                                       lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;
                                       dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                                     }
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                    if(blnFroward)
                                     {
                                      //  dtStartDate3 = lstTaskBelow[i].Start_Date__c = d4; 
                                          
                                          lstTaskBelow[i].Start_Date__c = d4; 
                                         
                                           dtStartDate3 =DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                                         
                                      
                                        lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;
                                     }
                                     else
                                     {
                                        lstTaskBelow[i].Revised_Due_Date__c = d4; 
                                       
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
                                      lstTaskBelow[i].Revised_Due_Date__c=d1;
                                   }
                                  else {lstTaskBelow[i].Start_Date__c=d1;} 
                                  
                                  NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                              }
                            update lstTaskBelow;
                            
                            //update the task order for the backward calcuation for the tasks below.
                           
                            
                    }
                     if(!blnFroward)
                     {
                          lstTaskBelow = [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No Order BY Task_Order__c];
                          for(Integer i=0;i<lstTaskBelow.size();i++)
                          {
                            if(i==0)
                            {
                                lstTaskBelow[i].Task_Order__c = Task_Order_No;
                            }
                            else
                            {    
                                lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;
                            }
                           //updateTask.add(lstTaskAbove[i]);
                          }    
                        update lstTaskBelow;
                     }
                // 
                 
                
        /*    }  
           else
           {
               List<Job_Task__c> lstTaskAbove=[Select id,Task_Order__c from Job_Task__c where Job__c=: JobId AND Task_Order__c <: Task_Order_No Order BY Task_Order__c desc];
               Job_Task__c TaskBelow=[Select id,Task_Order__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No Order BY Task_Order__c limit 1];
                System.debug('Above Task records after deletion : '+lstTaskAbove);
                if(!lstTaskAbove.isEmpty())
                {
                    Date RevisedDateForNextTask =  Date.newInstance(TaskBelow.Start_Date__c.Year(),TaskBelow.Start_Date__c.month(),TaskBelow.Start_Date__c.Day());
                    for(Integer i=0;i<lstTaskAbove.size();i++)
                    {
                        if(i==0)
                        {
                            lstTaskAbove[i].Task_Order__c = Task_Order_No;
                        }
                        else
                        {    
                            lstTaskAbove[i].Task_Order__c= lstTaskAbove[i-1].Task_Order__c - 1;
                        }
                       // updateTask.add(lstTaskAbove[i]);
                    }
                // update updateTask;
                }
           } */
                   
        }
        catch(System.DMLException e){return null;}
        // After deletion of Job Task navigate to Schedules Tab
        //PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=2'); p.setRedirect(true);return p;
        String th = userinfo.getUiTheme();
       PageReference p;
       if(th == 'Theme4d')
           p =  new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&section=schedules');
       else
           p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=2'); 
       p.setRedirect(true);
       return p;
        }
    // End of check Delete Method 
     
   
} 
// End of Class