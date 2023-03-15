@isTest
Public Class Testextension_JobTaskAboveNew{
/*
 static testMethod void Test_extension_JobTaskAboveNew ()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1040');
             
                insert testMedia;
           
           Holiday__c hc=new Holiday__c(Date__c=system.Today());
          insert hc;  
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1040',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testSchedule=new Schedule_Task__c(Name='Test Schedule Task 1040',Days__c=2,Schedule_Template__c=testST.id);
              insert testSchedule;       
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1040');
                insert testSpec;
                
          Campaign__c testCamp=new Campaign__c(Name='Test Camp 1040');    
              insert testCamp;  
   
          Client__c testClient=new Client__c(Name='Test Account 1040');
               insert testClient;
               
          Client_Contact__c testContact=new Client_Contact__c(Name='Test Client ENG',First_Name__c='Test Client',Last_Name__c='ENG',Client__c=testClient.id,Email__c='test1040@SFDC.com');
               insert testContact;    
                      
          Job__c testJob1=new Job__c(Job_Auto_Number__c='1040',Name='Test Job 1040',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id,Schedule_Calc__c='Start Date');
               insert testJob1;
         
          Job_Team__c jt1=new Job_Team__c(role__c='Test',Job__c=testJob1.id);
           insert jt1;
               
          System.assertEquals('Test Job 1040',testJob1.Name);     
               
          GL_Department__c testGLD = new GL_Department__c(Name='GLD020');
           
               insert testGLD;
           
          GL_Code__c testGL=new GL_Code__c(Name='GL1040',GL_ID__c='GLC1040',GL_Department__c = testGLD.id);
           
                 insert testGL;
           
           Job_Task__c testJT=new Job_Task__c(Schedule_Roles__c='Test',Name='Test JT 1040',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id,Start_Date__c=System.Today());
           insert testJT;
          
           Job_Task__c testJT11=new Job_Task__c(Schedule_Roles__c='Test',Name='TestJT1189',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id,Start_Date__c=System.Today());
               
           ApexPages.currentPage().getParameters().put('id',testJT.id);    
           
           extension_JobTaskAboveNew  ext=new extension_JobTaskAboveNew ();
           List<SelectOption> options2 = ext.getRoles();
         
          
           ext.getGLCodes();
           ext.getGLCName();
           ext.setGLCName(testGL.id);
           ext.objJobTask=testJT11;
           ext.RolesList='subway,Loves';
           ApexPages.Pagereference result1=ext.saveme();
           ApexPages.Pagereference result=ext.cancelme();  
           
          Job__c testJob2=new Job__c(Name='Test Job 1012',Start_Date__c=System.Today(),Due_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCamp.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testContact.id,Schedule_Calc__c='End Date');
          insert testJob2;
          Job_Team__c jt11=new Job_Team__c(role__c='Test',Job__c=testJob2.id);
           insert jt11;
            Job_Task__c testJobTask2=new Job_Task__c(Name='JT019',Schedule_Roles__c='Test',Job__c=testJob2.Id,Days__c=3,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask2;
         // Job_Task__c testJobTask4=new Job_Task__c(Name='JT029',Job__c=testJob2.Id,Days__c=5,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
         // insert testJobTask4;
         // Job_Task__c testJobTask5=new Job_Task__c(Name='JT021',Job__c=testJob2.Id,Days__c=1,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
         // insert testJobTask5;
         
          Job_Task__c testJobTask3=new Job_Task__c(Name='JT020',GL_Code__c=TestGL.id,Days__c=2,Schedule_Roles__c='Test');
           
            ApexPages.currentPage().getParameters().put('id',testJobTask2.Id);
        // con=new ApexPages.StandardController(testJobTask3);
        
       // Instantiate the extention instance with the standardcontroller 
           //ext=new extension_JobTask(con);
              ext=new extension_JobTaskAboveNew ();
           ext.RolesList='subway,Loves';
          ext.getGLCodes();
           ext.getGLCName();
           ext.setGLCName(testGL.id);
            ext.objJobTask=testJobTask3;
           result1=ext.saveme();    
           result=ext.cancelme();
           
          
  }
*/
}