@istest
public class Test_EditJobTaskExtension
{
/*
    static testMethod void Test_EditJobTaskExtension()
    {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 617');
              insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 617',Media_Types__c=testMedia.Id);
              insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 617');
              insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 617',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c = 'End Date');
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
                 
          Job__c testJob2=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='End Date');
         
                 insert testJob2;
                 
             System.assertEquals('Test Job 615',testJob2.Name);
                 
            Job_Task__c testJobTask4=new Job_Task__c(Name='Job Task 617',Job__c=testJob2.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 4);
        
                insert testJobTask4;
        
            
            Job_Task__c testJobTask8=new Job_Task__c(Name='Job Task 6188',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3,Task_Order__c = 4);
        
                insert testJobTask8;
                
            Job_Task__c testJobTask5=new Job_Task__c(Name='Job Task 619',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False, Task_Order__c = 5,Days__c=3);
        
                insert testJobTask5;
                
             Job_Task__c testJobTask6=new Job_Task__c(Name='Job Task 618',Job__c=testJob2.Id,Start_Date__c=System.Today(), Task_Order__c = 6,Days__c=3,Marked_Done__c=false,Revised_Due_Date__c=System.Today() );
        
                insert testJobTask6;
                
            Job_Task__c testJobTask7=new Job_Task__c(Name='Job Task 6191',Job__c=testJob2.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Task_Order__c = 7,Days__c=3,Revised_Due_Date__c=System.Today()+1);
        
                insert testJobTask7;
        
        
         // Instantiate the standard controller with the Job Task
        
         ApexPages.StandardController con=new ApexPages.StandardController(testJobTask7);
         // Instantiate the extention instance with the standardcontroller 
         EditJobTaskExtension ext=new EditJobTaskExtension(con);
        String GLCName;
         String GLCName1 = ext.getGLCName();
         ext.setGLCName(GLCName1);
         List<SelectOption> options1 = ext.getGLCodes(); 
        
         // Invoke the primary method on the extension
         testJobTask7.Days__c = 2;
         con=new ApexPages.StandardController(testJobTask7);
        ApexPages.PageReference result=ext.saveme();  
          GLCName = ext.getGLCName();
         ext.setGLCName(GLCName);
         List<SelectOption> options = ext.getGLCodes(); 
        
        // Invoke the primary method on the extension 
         result=ext.saveme();    
        result=ext.cancelme();
        
       
         result=ext.saveme();  
         
         
         
          Job__c testJob12=new Job__c(Name='Test Job 615',Due_Date__c=System.Today(),Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Schedule_Calc__c='start Date');
         
                 insert testJob12;
                 
             System.assertEquals('Test Job 615',testJob2.Name);
                 
            Job_Task__c testJobTask14=new Job_Task__c(Name='Job Task 617',Job__c=testJob12.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 4);
        
                insert testJobTask14;
        
            
            Job_Task__c testJobTask18=new Job_Task__c(Name='Job Task 6188',Job__c=testJob12.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Days__c=3,Task_Order__c = 4);
        
                insert testJobTask18;
                
            Job_Task__c testJobTask15=new Job_Task__c(Name='Job Task 619',Job__c=testJob12.Id,Start_Date__c=System.Today(),Marked_Done__c=False, Task_Order__c = 5,Days__c=3);
        
                insert testJobTask15;
                
             Job_Task__c testJobTask16=new Job_Task__c(Name='Job Task 618',Job__c=testJob12.Id,Start_Date__c=System.Today(), Task_Order__c = 6,Days__c=3,Marked_Done__c=false,Revised_Due_Date__c=System.Today() );
        
                insert testJobTask16;
                
            Job_Task__c testJobTask17=new Job_Task__c(Name='Job Task 6191',Job__c=testJob12.Id,Start_Date__c=System.Today(),Marked_Done__c=False,Task_Order__c = 7,Days__c=3,Revised_Due_Date__c=System.Today(),status__c='Active');
        
                insert testJobTask17;
 
         // Instantiate the standard controller with the Job Task
         ApexPages.StandardController con1=new ApexPages.StandardController(testJobTask17);
        
         // Instantiate the extention instance with the standardcontroller 
         EditJobTaskExtension ext1=new EditJobTaskExtension(con1);
      
        
         GLCName1 = ext1.getGLCName();
         ext1.setGLCName(GLCName1);
         options1 = ext1.getGLCodes(); 
         ext1.cancelme();
         // Invoke the primary method on the extension
        testJobTask17.Days__c = 2;
        con=new ApexPages.StandardController(testJobTask17);
        testJobTask17.Days__c = 0;
              update testJobTask17;

        ApexPages.PageReference result1=ext1.saveme();  
	}*/

}