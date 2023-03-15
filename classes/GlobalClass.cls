//this class is used for handling all the common code in the entire application
global class GlobalClass
{
  public static final String START_DATE = 'Start Date';
  public static final String END_DATE = 'End Date';
  public GlobalClass()
  {
  }
  
  /*
  Author: Sushma
  Description: This function saves the current task
  Date: 24 Jan 2013
  */
  public static void SaveTask()
  {
  }
  
  /*
   Author: Sushma
  Description:  This function updates the rest of the tasks in the schedule
  Date: 24 Jan 2013 
  */
  public static void UpdateRestTasks()
  {
  }
  
   /*
   Author: Sushma
  Description:  This function calculates the days for the update excluding the holidays
  Paramters: Date d, Boolean blnFroward, Double days
  Return: none
  Date: 24 Jan 2013 
  */
  global static DateTime CalculateDays(Date d, Boolean blnFroward, Double days)
  {
   Set<Date> holidays=new Set<Date>();
   // Add Holiday Dates to Set, so that holidays will be skipped while calculating Schedule dates
   for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null WITH SECURITY_ENFORCED])
   {
     holidays.add(hc.Date__c );
   }
            
   Datetime dtStartDate=DateTime.newInstance(d.Year(),d.Month(),d.Day());
   Integer jCount=0;
   while(true)
   {
     Date d3 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
    // Skip holidays, sat, sun while calculating Schedule Dates : Due Date, Revised Due Date
    if((dtStartDate.format('E')!='Sat'&&dtStartDate.format('E')!='Sun') && ! (holidays.contains(d3)))
    {
      jCount=jCount+1;
      if(jCount>days)
      {
        break;
      }
      system.debug('jCount======' + jCount);
      system.debug('==========' + dtStartDate);
  
      system.debug('===========' + dtStartDate.format('E'));
      //if end calulate by -
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
      //if end calulate by -
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
   return dtStartDate;
  }
  
  /*
   Author: Sushma
  Description:  This function gets the list of the GLCodes
  Date: 24 Jan 2013 
  */
  global static  List<selectOption> GetGLCodes()
  {
     List<selectOption> optionList = new List<selectOption>();
     optionList.add(new selectOption('', '- None -'));  
     for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c WITH SECURITY_ENFORCED order by Name ]) 
     {  
       optionList.add(new selectOption(a.Id, a.Name));  
     }
     return optionList;  
  }
  
   
  /*
  Author: Sushma
  Description: This function deals with the updation of the tasks above or below the task
  Parameters: Job_Task__c objJobTask, Boolean blnFroward, Boolean blnUpdateTaskOrder, String strid, Double task_order_no, Date d1
  Date: 24 Jan 2013
  */
  global static void updateTasks(Job_Task__c objJobTask, Boolean blnFroward, Boolean blnUpdateTaskOrder, String strid, Double task_order_no, Date d1, Boolean blnSkipMarkDone)
  {
      Boolean isFirst=true;
      //section for the update of the tasks above or below the current task            
      List<Job_Task__c> lst=new List<Job_Task__c>();
      //if(end date do desc)
      if(blnFroward)
      {
          if(blnSkipMarkDone)
          {
            lst= [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :objJobTask.Job__c and Id !=: objJobTask.Id and Task_Order__c >=: objJobTask.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC]; 
          }
          else
          {
            lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: objJobTask.Id WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
          }
      }
      else
      {
      if(blnSkipMarkDone)
          {
            lst = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :objJobTask.Job__c and Id !=: objJobTask.Id and Task_Order__c <=: objJobTask.Task_Order__c and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC]; 
          }
          else
          {
            lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no-1 AND Id !=: objJobTask.Id WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC ];
          }
      }
         
       System.debug('Size of lst '+lst.size());
        
       List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
       Date NTSD1;
        
       Double a=task_order_no+1;
       
       for(Job_Task__c jt1:lst)
       {
          if(blnFroward)
          {
             if(schema.SobjectType.Job_Task__c.Fields.Task_Order__c.isUpdateable() ){
                 jt1.Task_Order__c=a;}
            a++;
          }
          if(isFirst)
          {
            if(blnFroward)
            {
                if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable() ){
                    jt1.Start_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
            }
            else
            {
                if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable() ){
                    jt1.Revised_Due_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
            }
            isFirst=false;
          }
          else
          {
            if(blnFroward)
            {
              if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable() ){
                  jt1.Start_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
            }
           else
            {
              if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable() ){
                  jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
            }
          }
            
          Datetime dtStartDate1;
           if(blnFroward)
           {
              dtStartDate1 =Datetime.newInstance(jt1.Start_Date__c.Year(),jt1.Start_Date__c.Month(),jt1.Start_Date__c.Day());
           }
           else
           {
              dtStartDate1=Datetime.newInstance(jt1.Revised_Due_Date__c.Year(),jt1.Revised_Due_Date__c.Month(),jt1.Revised_Due_Date__c.Day());
           }
           System.debug('Start Date is :'+dtStartDate1);
           Date d4=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
         
           Double day= jt1.Days__c;
           dtStartDate1= GlobalClass.CalculateDays(d4,blnFroward,day);
            
           Date  d5 = Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
           System.debug('D5 is as follows : '+d5);
           if(blnFroward)
           {
               if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable() ){jt1.Revised_Due_Date__c=d5;}
            }
           else
           {
               if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable() ){ jt1.Start_Date__c=d5;}
           }
           NTSD1=d5;
           system.debug('NTSD '+NTSD1);
           lstJobTask.add(jt1);
            // update jt1;
         } 
      if(schema.getGlobalDescribe().get('Job_Task__c').getDescribe().isUpdateable()){
          update lstJobTask;}

         if(blnUpdateTaskOrder)
         {
             //update the task order of the below tasks
             List<Job_Task__c> lstbelow =new List<Job_Task__c>();
             //if(end date do desc)
             lstbelow=[Select Id,Name,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: objJobTask.Id WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
             for(Job_Task__c jt1:lstbelow)
             {
               //if() start date 
               if(!blnFroward)
               {
                   if(schema.SobjectType.Job_Task__c.Fields.Task_Order__c.isUpdateable() ){jt1.Task_Order__c=a;}
                 a++;
               }                                  
             }
             if(schema.getGlobalDescribe().get('Job_Task__c').getDescribe().isUpdateable()){update lstbelow;}
          }
     }
    
}