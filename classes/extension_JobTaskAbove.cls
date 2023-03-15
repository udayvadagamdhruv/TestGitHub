// This class is used when user inserts new task above the current task 
public with sharing class extension_JobTaskAbove
{
   // Global variables 
  /*  public Double task_order_no{get;set;}
    
    String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    Boolean isFirst=true;
    public Id taskid{get;set;} 
    public Job_Task__c objJobTask1{get;set;}
    public Job__c objJob{get;set;}
    public Job_Task__c objJobTask
    {
         get {
      if (objJobTask == null)
        objJobTask = new Job_Task__c();
        objJobTask.GL_Code__c = GLCName;
      return objJobTask;
    }
    set;
    }
    // End of Global variables

   // Start Constructor 
     public extension_JobTaskAbove()
     {
        taskid=ApexPages.CurrentPage().getParameters().get('id');
        System.debug('tId1@@@@'+taskid);
        objJobTask1=[Select Job__c,Task_Order__c,Start_Date__c,Due_Date__c,Revised_Due_date__c,Job__r.Schedule_Calc__c from Job_Task__c where Id=: taskid]; 
        task_order_no=objJobTask1.Task_Order__c;
        //objJobTask.Job__c=objJobTask1.Job__c; 
     }
     // End Constructor 
  
   // Retrieve GL Codes into Picklist
   public List<selectOption> getGLCodes() 
    {
        List<selectOption> optionList = GlobalClass.GetGLCodes();
        return optionList;  
    }
    // End method getGLCodes
public pagereference saveNew()
    {
      String strid;
      strid = objJobTask1.Job__c; 
      if(GLCName == null)
      {
        String strGLCode1 = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, strGLCode1 + ' : You must select a '+ strGLCode1+'.');
        ApexPages.addMessage(myMsg);
        return null;
      }
      else
      {
        System.debug('tId1@@@@'+taskid);
       
          String Name1=objJobTask.Name;
          Double days=objJobTask.Days__c;
          String strGLCode=objJobTask.GL_Code__c;
       
          try
          {
            Datetime NTSD;
            Boolean blnFroward = true;
            if(objJobTask1.Job__r.Schedule_Calc__c == GlobalClass.END_DATE )
            {
               blnFroward = false;
            }
           Date d;
           d=Date.newInstance(objJobTask1.Start_date__c.Year(),objJobTask1.Start_date__c.Month(),objJobTask1.Start_date__c.Day());
           DateTime dtStartDate = GlobalClass.CalculateDays(d,blnFroward,days);
                 Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                system.debug('D1============' +dtStartDate);
                if(blnFroward)
                     {
                      objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d,Task_Order__c=task_order_no,Due_Date__c=d1,Revised_Due_date__c=d1,GL_Code__c=strGLCode);
                     }
                     else
                     {
                      objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no,Due_Date__c=d,Revised_Due_date__c=d,GL_Code__c=strGLCode);
                     }    
                     insert objJobTask;
           GlobalClass.updateTasks(objJobTask, blnFroward, true, strid, task_order_no, d1,false);    
             
       }
       catch(DMLException e)
       {
         return null;
       } 
            
        PageReference p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2');
        p.setRedirect(true);
        return p;
      }
    }
   // This method is called on to handle Save button operation 
 /*  public pagereference saveme()
    {
          String strid;
          strid = objJobTask1.Job__c; 
          
          System.debug('tId1@@@@'+taskid);
       
          String Name1=objJobTask.Name;
          Double days=objJobTask.Days__c;
          String strGLCode=objJobTask.GL_Code__c;
       
          try
          {
            Datetime NTSD;
            Set<Date> holidays=new Set<Date>();
            
             // Add Holiday Dates to Set, so that holidays will be skipped while calculating Schedule dates
             for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null])
            {
                holidays.add(hc.Date__c );
            }
            
             Boolean blnFroward = true;
            if(objJobTask1.Job__r.Schedule_Calc__c == 'End Date')
            {
               blnFroward = false;
            }
           
           Date d;
             d=Date.newInstance(objJobTask1.Start_date__c.Year(),objJobTask1.Start_date__c.Month(),objJobTask1.Start_date__c.Day());
               
           // Date db = Date.newInstance(objJobTask1.Revised_Due_date__c.Year(),objJobTask1.Revised_Due_date__c.Month(),objJobTask1.Revised_Due_date__c.Day()); 
            //for the new value the revised due date will be the stsrt date of the below value
            Datetime dtStartDate=DateTime.newInstance(d.Year(),d.Month(),d.Day());
            Integer jCount=0;
             // To Calculate Due Date, Revised Due Date
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
             system.debug('Calculation============' +dtStartDate);
            
                 Date d1 = Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                system.debug('D1============' +dtStartDate);
                if(blnFroward)
                     {
                      objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d,Task_Order__c=task_order_no,Due_Date__c=d1,Revised_Due_date__c=d1,GL_Code__c=strGLCode);
                     }
                     else
                     {
                         objJobTask=new Job_Task__c(Job__c=strid,Name=Name1,Days__c=days,Start_Date__c=d1,Task_Order__c=task_order_no,Due_Date__c=d,Revised_Due_date__c=d,GL_Code__c=strGLCode);
                     }
                     
               //here assign the new task the statrt date of next job and the calulated start date
               if(GLCName == null)
                  {
                    String strGLCode1 = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, strGLCode1 + ' : You must select a '+ strGLCode1+'.');
                    ApexPages.addMessage(myMsg);
                    return null;
                  }
                else
                {
                     insert objJobTask;
                    
                     
                     
                     
         List<Job_Task__c> lst=new List<Job_Task__c>();
         //if(end date do desc)
          if(blnFroward)
                     {
                           lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: objJobTask.Id ORDER BY Task_Order__c];
                     }
                     else
                     {
                         lst=[Select Id,Name,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c <=: task_order_no-1 AND Id !=: objJobTask.Id ORDER BY Task_Order__c DESC ];
                     }
         
        System.debug('Size of lst '+lst.size());
        
        List<Job_Task__c> lstJobTask=new List<Job_Task__c>();
        Date NTSD1;
        
        Double a=task_order_no+1;
        
        for(Job_Task__c jt1:lst)
        {
              //if() start date 
              if(blnFroward)
                     {
                        jt1.Task_Order__c=a;
                        a++;
                     }
             
                if(isFirst)
                {
                    System.debug('This is First');
                    
                    
                     if(blnFroward)
                         {
                           jt1.Start_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());
                         }
                         else
                         {
                            jt1.Revised_Due_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());
                         }
                    isFirst=false;
                }
                else
                {
                    
                    if(blnFroward)
                         {
                           jt1.Start_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());
                         }
                         else
                         {
                            jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());
                         }
                }
            
                System.debug('task Name'+jt1.Name);
                System.debug('ST Date'+jt1.Start_Date__c);
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
                Integer jCount1=0;
                System.debug('jCount value'+jCount1);
            
                while(true)
                {
                    Date d4=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                    
                             if((dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!='Sun')&&(!holidays.contains(d4)))
                             {
                                  jCount1=jCount1 +1;
                                  if(jCount1>jt1.Days__c)
                                  {
                                      break;
                                  }
                                  system.debug('jCount======' + jCount1);
                                  system.debug('==========' + dtStartDate1);
                          
                                  system.debug('===========' + dtStartDate1.format('E'));
                                  if(blnFroward)
                                         {
                                                  dtStartDate1=dtStartDate1.addDays(1);
                                         }
                                          else
                                         {
                                              dtStartDate1=dtStartDate1.addDays(-1);
                                         }
                                  system.debug('after adding 1 day==========' + dtStartDate1);
                                  
                             }
                            else
                               {
                                system.debug('==========' + dtStartDate1);
                                //system.debug('===========' + dtStartDate.format('E'));
                                if(blnFroward)
                                         {
                                               dtStartDate1=dtStartDate1.addDays(1);
                                         }
                                          else
                                         {
                                              dtStartDate1=dtStartDate1.addDays(-1);
                                         }
                               continue;
                             }
    
                    
                }   
            
                    Date  d5 = Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
                        System.debug('D5 is as follows : '+d5);
                    if(blnFroward)
                             {
                                  jt1.Revised_Due_Date__c=d5;
                             }
                              else
                             {
                                 jt1.Start_Date__c=d5;
                             }
                    NTSD1=d5;
                    system.debug('NTSD '+NTSD1);
                    lstJobTask.add(jt1);
                     // update jt1;
            }
         update lstJobTask;
          //update the task order of the below tasks
         List<Job_Task__c> lstbelow =new List<Job_Task__c>();
         //if(end date do desc)
         lstbelow=[Select Id,Name,Task_Order__c from Job_Task__c where Job__c=:strid and Task_Order__c >=: task_order_no AND Id !=: objJobTask.Id ORDER BY Task_Order__c];
         //if(!blnFroward)
                    // {
                        for(Job_Task__c jt1:lstbelow)
                        {
                              //if() start date 
                              if(!blnFroward)
                                     {
                                        jt1.Task_Order__c=a;
                                        a++;
                                     }
                                     
                                       // jt1.Task_Order__c=a;
                                      //  a++;
                        }
                        update lstbelow;
                }
        
      
                     //}
                     
        
        
         
        //} 
 
          
       }
       catch(DMLException e)
       {
      return null;
       } 
       
       
               
        PageReference p =  new Pagereference('/apex/JobListView?id='+strid+'&intFocus=2');
        p.setRedirect(true);
        return p;
  }
  // End Save method 
  
    //This method is called on to handle Cancel button operation 
    public pagereference cancelme()
    {
        String strid1 = ApexPages.CurrentPage().getParameters().get('id');
        Job_task__c jt = [select id,Job__c from Job_task__c where id =: strid1 Limit 1];
           
       PageReference p =  new Pagereference('/apex/JobListView?id='+jt.Job__c+'&intFocus=2');
       p.setRedirect(true);
       return p;
    }
    // End Cancel method 
*/

}
// End of Class