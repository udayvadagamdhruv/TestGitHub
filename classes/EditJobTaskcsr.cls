// This class is used to edit Job Task (Schedules) under Job tab
public with sharing class EditJobTaskcsr
{
     // Global variables
    /*String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    private final Job_Task__c objJobTask;
    private final Job_Task__c oldobjJobTask;
    String strId1,strId2;
     // End of Global variables
 
    // Standard Controlle Constructor
    public EditJobTaskcsr(ApexPages.StandardController controller) 
    {
          this.oldobjJobTask = this.objJobTask=(Job_Task__c)controller.getrecord();
          Job_Task__c abc = [select id,Name,GL_Code__c from Job_Task__c  where id =: objJobTask.id Limit 1];
          GLCName = abc.GL_Code__c;
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
            if(GLCName == null)
            { 
                String strGLCode1 = Schema.Job_Task__c.fields.GL_Code__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strGLCode1+' : You must select a '+strGLCode1+'.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            else
            {    
                    GL_Code__c gc=[Select Id,Name from GL_Code__c where Id=:GLCName];
                    objJobTask.GL_Code__c=gc.Id;
                    if(objJobTask.Status__c=='Completed')
                    {
                       if(objJobTask.Completion_Date__c == Null)
                        {
                            objJobTask.Completion_Date__c=System.Today();
                        }
                        objJobTask.Marked_Done__c=True;
                       // objJobTask.Completion_Date__c=System.Today();
                    }
                    else if(objJobTask.Status__c=='Active'||objJobTask.Status__c=='Requested')
                    {
                         objJobTask.Marked_Done__c=False;
                         objJobTask.Completion_Date__c=NULL;
                    }
                    Job_Task__c oldObj = [select Id,Name,Days__c,Revised_Due_Date__c,Job__r.Schedule_Calc__c,Job__r.id from Job_Task__c where id =: objJobTask.id limit 1];
                    system.debug('Old value' + oldObj );
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
                              
                                updateRemainingTasks updCntrler = new updateRemainingTasks();
                                updCntrler.objTask1 = objJobTask;
                                updCntrler.jobId = oldObj.Job__r.Id;
                                updCntrler.blnFroward = blnFroward;
                                updCntrler.methodName = 'Datechange';
                                updCntrler.updateTask();
                                
                              
                             /***************** 
                              List<Job_Task__c> lstTaskBelow ;
                              
                                if(blnFroward)
                                         {
                                             lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :oldObj.Job__r.Id and Id !=: objJobTask.Id and Task_Order__c >=: objJobTask.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c ASC];   
                                         }
                                         else
                                         {
                                             lstTaskBelow = [Select Id, Job__c, Status__c, Name, Days__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c, Marked_Done__c, Task_Order__c from Job_Task__c where Job__c = :oldObj.Job__r.Id and Id !=: objJobTask.Id and Task_Order__c <=: objJobTask.Task_Order__c and Marked_Done__c =: False Order BY Task_Order__c DESC]; 
                                         }
                              
                                                     update lstTaskBelow;********
                 }
                else if(oldObj.Revised_Due_Date__c != objJobTask.Revised_Due_Date__c)
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
                        
                        updateRemainingTasks updCntrler = new updateRemainingTasks();
                                updCntrler.objTask1 = objJobTask;
                                updCntrler.jobId = oldObj.Job__r.Id;
                                updCntrler.blnFroward = blnFroward;
                                updCntrler.methodName = 'Datechange';
                                updCntrler.updateTask();

                        /*******
                        
                        if(blnFroward)
                         {
                            lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTaskNew.Task_Order__c and Job__c =: objJobTaskNew.Job__r.id and Id!=: objJobTaskNew.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                         }
                                                     update lstJobTasks;
                            System.debug('Updated List : '+lstJobTasks); ****
                       //  }
                }
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }   
        // After updating JobTask, navigate to Schedules Tab     
        PageReference p =  new Pagereference('/apex/JobListView?id='+strId1+'&intFocus=2');
        p.setRedirect(true);
        return p; 
  
        
    }
    
    // Method for Cancel button 
    Public PageReference cancelme()
    {
       strId2 =  objJobTask.Job__c;        
       PageReference p =  new Pagereference('/apex/JobListView?id='+strId2+'&intFocus=2');
       p.setRedirect(true);
       return p;
    } 
    // End of Cancel method


    // Test Coverage Code
    static testMethod void Test_EditJobTaskcsr()
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
                 
         Job_Task__c testJobTask=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,GL_Code__c=TestGL.id);
              insert testJobTask;
    
        Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 618',Job__c=testJob1.Id,GL_Code__c=TestGL.id);
              insert testJobTask1;
        Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 619',Job__c=testJob1.Id,GL_Code__c=TestGL.id);
              insert testJobTask2;
         // Instantiate the standard controller with the Job Task
         ApexPages.StandardController con=new ApexPages.StandardController(testJobTask);
        
         // Instantiate the extention instance with the standardcontroller 
         EditJobTaskcsr ext=new EditJobTaskcsr(con);
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
         result=ext.saveme();  
         
         
         
           Job__c testJob2=new Job__c(Name='Test Job 618',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c = 'End Date');
              insert testJob2;
          System.assertEquals('Test Job 618',testJob2.Name);
          
          Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 628',Job__c=testJob2.Id,GL_Code__c=TestGL.id);
              insert testJobTask3;
        Job_Task__c testJobTask4=new Job_Task__c(Name='Job Task 629',Job__c=testJob2.Id,GL_Code__c=TestGL.id);
              insert testJobTask4;
         // Instantiate the standard controller with the Job Task
         ApexPages.StandardController con1=new ApexPages.StandardController(testJobTask4);
        
         // Instantiate the extention instance with the standardcontroller 
         EditJobTaskcsr ext1=new EditJobTaskcsr(con1);
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