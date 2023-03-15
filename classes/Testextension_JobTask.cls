@isTest

Public Class Testextension_JobTask{
/*
 static testMethod void Test_extension_JobTask()
   {
          Holiday__c hc=new Holiday__c(Date__c=system.Today());
          insert hc;
          Job_Number_Setting__c customSetting999 = new  Job_Number_Setting__c(Name= 'yy');
          insert customSetting999;
         
          Media_Type__c testMedia=new Media_Type__c(Name='MT018');
          insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST018',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT018');
          insert testSpec;
                
          Job__c testJob1=new Job__c(Name='J018',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='Start Date');
          insert testJob1;
          
            GL_Department__c testGLD = new GL_Department__c(Name='GLD018');
            try
            {
            insert testGLD;
            }
            catch(System.DMLException e)
            {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GLC018',GL_ID__c='GLC012',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
             }
             catch(System.DMLException e)
             {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           Job_Team__c jt=new Job_Team__c(role__c='Test',Job__c=testJob1.id);
           insert jt;
           
                 
          Job_Task__c testJobTask=new Job_Task__c(Name='JT018',Job__c=testJob1.Id,Days__c=3,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today());
          insert testJobTask;
         
          Job_Task__c testJobTask1=new Job_Task__c(Name='JT019',GL_Code__c=TestGL.id,Days__c=2,Schedule_Roles__c='Test');
          
          
           Job__c testJob2=new Job__c(Name='J019',Start_Date__c=System.Today(),Due_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='End Date');
          insert testJob2;
           Job_Team__c jt1=new Job_Team__c(role__c='Test',Job__c=testJob2.id);
           insert jt1;
          
          
            Job_Task__c testJobTask2=new Job_Task__c(Name='JT019',Job__c=testJob2.Id,Days__c=3,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask2;
          Job_Task__c testJobTask4=new Job_Task__c(Name='JT029',Job__c=testJob2.Id,Days__c=5,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask4;
          Job_Task__c testJobTask5=new Job_Task__c(Name='JT021',Job__c=testJob2.Id,Days__c=1,GL_Code__c=TestGL.id,Revised_Due_Date__c=System.Today(),Start_Date__c=System.Today(),Due_Date__c=System.Today());
          insert testJobTask5;
         
          Job_Task__c testJobTask3=new Job_Task__c(Name='JT020',GL_Code__c=TestGL.id,Days__c=2,Schedule_Roles__c='Test');
        
          
        
       // Instantiate the standard controller with the Job 
        ApexPages.currentPage().getParameters().put('jobid1',testJob1.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testJobTask1);
        
       // Instantiate the extention instance with the standardcontroller 
          extension_JobTask ext=new extension_JobTask(con);
          ext.GLCName = testGL.id;
          String GLCName = ext.getGLCName();
          ext.setGLCName(GLCName);
          List<SelectOption> options = ext.getGLCodes();
           List<SelectOption> options2 = ext.getRoles();
         
           ext.RolesList='subway,Loves';
        
      // Invoke the primary method on the extension 
        ApexPages.PageReference result1=ext.save();    
        ApexPages.PageReference result2=ext.cancelme();
        
         ApexPages.currentPage().getParameters().put('jobid1',testJob2.Id);
         con=new ApexPages.StandardController(testJobTask3);
        
       // Instantiate the extention instance with the standardcontroller 
           ext=new extension_JobTask(con);
               ext.GLCName = testGL.id;
               ext.RolesList='subway,Loves';
          GLCName = ext.getGLCName();
          ext.setGLCName(GLCName);
          options = ext.getGLCodes() ;   
           result1=ext.save();    
           result2=ext.cancelme();
        
        Job_Task__c resultm=ext.objJobTask;
        
        delete testJobTask;
        result1=ext.save();   
          }
*/


}