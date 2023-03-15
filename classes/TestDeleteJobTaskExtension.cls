@isTest

 Public Class TestDeleteJobTaskExtension{
    /*  
     static testMethod void TestDeleteJobTaskExtension()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 605');
             
                insert testMedia;
                
           Holiday__c hc= new Holiday__c(name='Test', Date__c=system.today())     ;
           insert hc;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 605',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 605');
          
                insert testSpec;
                
          Job__c testJob1=new Job__c(Job_Auto_Number__c='605',Flag__c=True,Name='Test Job 605',Start_Date__c=System.Today()-2,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c = 'Start Date');
         
                insert testJob1;
          System.assertEquals('Test Job 605',testJob1.Name);
                 
          Job_Task__c testJobTask=new Job_Task__c(Name='Job Task 60512',Job__c=testJob1.Id,Task_Order__c =1,Start_Date__c=System.Today()-1,Days__c=2);
          insert testJobTask;
          
          Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 6052',Job__c=testJob1.Id,Task_Order__c =2,Days__c=4);
          insert testJobTask1;
          
          Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 605123',Job__c=testJob1.Id,Task_Order__c =3,Days__c=3);
          insert testJobTask2;
          
          
          System.assertEquals('Job Task 60512',testJobTask.Name);
         
                 
          // Instantiate the standard controller with the Job
        ApexPages.StandardController con=new ApexPages.StandardController(testJobTask);
        
        // Instantiate the extention instance with the standardcontroller
        DeleteJobTaskExtension ext=new DeleteJobTaskExtension(con);
        
        // Invoke the Delete method on the extension 
        ApexPages.PageReference result=ext.checkDelete();
     Job__c testJob2=new Job__c(Name='Test Job 606',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c = 'End Date');
         
                insert testJob2;
        System.assertEquals('Test Job 606',testJob2.Name);
        
         Job_Task__c testJobTask12=new Job_Task__c(Name='Job Task 60522',Job__c=testJob1.Id,Task_Order__c =2,Days__c=1,Revised_Due_Date__c=System.Today()-4);
          insert testJobTask12;
          
          Job_Task__c testJobTask23=new Job_Task__c(Name='Job Task 6052123',Job__c=testJob1.Id,Task_Order__c =3,Days__c=2,Revised_Due_Date__c=System.Today()-5);
          insert testJobTask23;
                 
        Job_Task__c testJobTask32=new Job_Task__c(Name='Job Task 606',Job__c=testJob2.Id,Task_Order__c =1,Revised_Due_Date__c=System.Today()-1,Days__c=3);
          insert testJobTask32;
          Job_Task__c testJobTask243=new Job_Task__c(Name='Job Task 60521243',Job__c=testJob1.Id,Task_Order__c =4,Days__c=2,Revised_Due_Date__c=System.Today()-2);
          insert testJobTask243;
                  
        System.assertEquals('Job Task 606',testJobTask32.Name);
        con=new ApexPages.StandardController(testJobTask32);
        
        // Instantiate the extention instance with the standardcontroller
         ext=new DeleteJobTaskExtension(con);
        
        ApexPages.PageReference result1=ext.checkDelete();
   
     }
     */
    
     
     
     
     

}