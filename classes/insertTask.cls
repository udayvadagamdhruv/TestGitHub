public with sharing class insertTask{
    /*public insertTask(){
        }
    public Double task_order_no{get;set;}
    public boolean blnFroward;
    public Job_Task__c objJobTask;
    public Boolean isFirst;
    public String strid;
    public date d1;
    public Set<Date> holidays;
 
    public void updatetasks()
    {   
        Date NTSD1;
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
       
        Double a=task_order_no+1;
        
        for(Job_Task__c jt1:lst)
        {
              //if() start date 
              if(blnFroward)
                     {
                          if(schema.SobjectType.Job_Task__c.Fields.Task_Order__c.isUpdateable()){  jt1.Task_Order__c=a;}
                        a++;
                     }
             
                if(isFirst)
                {
                    System.debug('This is First');
                    
                    
                     if(blnFroward)
                         {
                            if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){jt1.Start_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
                         }
                         else
                         {
                             if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){jt1.Revised_Due_Date__c=Date.newInstance(d1.Year(),d1.Month(),d1.Day());}
                         }
                    isFirst=false;
                }
                else
                {
                    
                    if(blnFroward)
                         {
                           if(schema.SobjectType.Job_Task__c.Fields.Start_Date__c.isUpdateable()){jt1.Start_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
                         }
                         else
                         {
                            if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){jt1.Revised_Due_Date__c=Date.newInstance(NTSD1.Year(),NTSD1.Month(),NTSD1.Day());}
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
              if(Schema.sObjectType.Job_Task__c.isUpdateable()){update lstJobTask;}
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
                
    }*/
    
}