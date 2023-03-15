public with sharing class updateRemainingTasks{
    /*    public updateRemainingTasks(){
    }
    public Job_Task__c objTask1;// =  ApexController.getParameters().get('objTask1') ;
    public Set<Date> holidaysNew;
    public boolean blnFroward;
    public string methodName;
    public Id jobId;
    
    public void updateTask(){
           
         holidaysNew = new Set<Date>();
         for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL])
         {
             holidaysNew.add(hc.Date__c);
         }                       
               
              DateTime NextTaskStartDate;
              Date startDateForNextTask;                 
                  
                  // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current Job
                  List<Job_Task__c> lstTaskBelow ;
                  if(blnFroward)
                      {
                        lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c >=: objTask1.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c ASC];   
                    
                        startDateForNextTask = Date.newInstance(objTask1.Revised_Due_Date__c.Year(),objTask1.Revised_Due_Date__c.month(),objTask1.Revised_Due_Date__c.Day());   
                        System.debug('Task below the updated Task : '+lstTaskBelow);
                  
                        System.debug('Size of Task Below the current Task : '+lstTaskBelow.size());
                  
                        for(Integer i = 0; i <lstTaskBelow.size(); i++)
                         {
                            System.debug('Value of i' +i);
    
                                if(i == 0)
                                {   
                                     lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                                     
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                   
                                    lstTaskBelow[i].Start_Date__c = d4; 
                                    
                                }
                                DateTime dtStartDate3;
                                if(methodName == 'Dayschange')
                                { 
                                    dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Start_Date__c,Time.newInstance(12, 0, 0, 0));
                                 }else{
                                 dtStartDate3 = lstTaskBelow[i].Start_Date__c;
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
                                          
                                           dtStartDate3=dtStartDate3.addDays(1);
                                           
                                          system.debug('After adding 1 day : ' +dtStartDate3);
                                      }
                                      else
                                         {
                                              system.debug('==========' + dtStartDate3);
                                             // dtStartDate3=dtStartDate3.addDays(1);
                                              dtStartDate3=dtStartDate3.addDays(1);
                                              continue;
                                         }
                                     }
                                 system.debug('Calculation============' +dtStartDate3);
                                 
                                 Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                                 system.debug('D1============' +dtStartDate3);
                                
                                 lstTaskBelow[i].Revised_Due_Date__c=d1;
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                               }
                     }
                     
                     
                     // Calculation backward Direction
                     else{
                             lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :jobId and Id !=: objTask1.Id and Task_Order__c <=: objTask1.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c DESC]; 
                            
                          
                            startDateForNextTask = Date.newInstance(objTask1.Start_Date__c.Year(),objTask1.Start_Date__c.month(),objTask1.Start_Date__c.Day()); 
                            System.debug('Task below the updated Task : '+lstTaskBelow);
                          
                            System.debug('Size of Task Below the current Task : '+lstTaskBelow.size());
                          
                            for(Integer i = 0; i <lstTaskBelow.size(); i++)
                            {
                                System.debug('Value of i' +i);
            
                                if(i == 0)
                                {   
                                     lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;
                                     
                                }
                                else
                                {
                                    Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                                   
                                    lstTaskBelow[i].Revised_Due_Date__c = d4;
                                    
                                }
                                DateTime dtStartDate3;
                                if(methodName == 'Dayschange')
                                { 
                                    dtStartDate3 = DateTime.NewInstance(lstTaskBelow[i].Revised_Due_Date__c,Time.newInstance(12, 0, 0, 0)); 
                                 }  else{
                                 dtStartDate3 = lstTaskBelow[i].Start_Date__c;
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
                                          
                                           dtStartDate3=dtStartDate3.addDays(-1);
                                           
                                          system.debug('After adding 1 day : ' +dtStartDate3);
                                     }
                                     else
                                     {
                                          system.debug('==========' + dtStartDate3);
                                         // dtStartDate3=dtStartDate3.addDays(1);
                                          dtStartDate3=dtStartDate3.addDays(-1);
                                          continue;
                                     }
                                 }
                                 system.debug('Calculation============' +dtStartDate3);
                                 
                                 Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                                 system.debug('D1============' +dtStartDate3);
                                
                                  lstTaskBelow[i].Start_Date__c=d1;
                                 NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                         }
                       }  
                update lstTaskBelow;
    
    }*/
}