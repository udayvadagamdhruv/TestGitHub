@isTest
public class TestScheduleTaskAboveExtension {
    /*static testMethod void Test_ScheduleTaskAboveExtension()
    {
          // Insert all required data to test functionality
         Schedule_Template__c testST1=new Schedule_Template__c(Name='Testing Schedule Template 1390',Active__c=True);
            insert testST1;
      
    
          GL_Department__c testGLD = new GL_Department__c(Name='TestGLD996');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
            GL_Code__c testGL=new GL_Code__c(Name='GL Code 9988',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
         
         Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 1',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=1);
             insert testSCT1;
           
         Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task 2',Schedule_Template__c=testST1.Id,GL_Code__c = testGL.id,Days__c=2,Task_Order__c=2);
             insert testSCT2;
             
         // Instantiate the standard controller with the Schedule Task
        ApexPages.CurrentPage().getParameters().put('ScheduleTaskId',testSCT2.id); 
        ApexPages.StandardController con=new ApexPages.StandardController(testSCT2);
        
        // Instantiate the extention instance with the standardcontroller
        ScheduleTaskAboveExtension ext=new ScheduleTaskAboveExtension(con);
        ext.getTaskName();
        ext.setTaskName(testSCT2.id);
         
        ext.GLCName = NULL; // to check GLCode as NULL
        String GLCName1 = ext.getGLCName();
        ext.setGLCName(GLCName1);
        List<SelectOption> options1 = ext.getGLCodes(); 
        ApexPages.PageReference result=ext.save();
        
        ext.GLCName = testGL.id;
        String GLCName = ext.getGLCName();
        ext.setGLCName(GLCName);
        List<SelectOption> options = ext.getGLCodes(); 
        
        // Invoke the primary method on the extension
       result=ext.save();
       result=ext.cancel(); 
        // To Cover Catch block
        delete testSCT1;
        result=ext.save();
        
    }*/
}