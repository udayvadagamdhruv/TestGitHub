@isTest
public class TestCreateNewQuoteExtension {
	/*static testMethod void CreateNewQuotePositiveTest()
         {
             Job_Number_Setting__c customSetting951 = new  Job_Number_Setting__c(Name= 'yy');
             insert customSetting951;
            
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 606');
             
                  insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 606',Media_Types__c=testMedia.Id);
             
                  insert testST;
                 
              Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 607',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 606');
              
                  insert testSpec;
                
              Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 607');
                
                  insert testSpec1;
           
            
              Job__c testJob1=new Job__c(Name='Test Job 606',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
                {
                   insert testJob1;
                }
               catch(System.DMLException e)
                {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
                }
              System.assertEquals('Test Job 606',testJob1.Name); 
               
              GL_Department__c testGLD = new GL_Department__c(Name='TestGLD997');
               try
                {
                 insert testGLD;
                }
               catch(System.DMLException e)
                {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                }

              GL_Code__c testGL=new GL_Code__c(Name='Test GL Code 606',GL_ID__c='Test GL606',GL_Department__c=testGLD.id);
               insert testGL;
               
               Quote__c testQ=new Quote__c(Name='Quote 606',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
           
               ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
           
               ApexPages.StandardController con=new ApexPages.StandardController(testQ); 
          
          // Instantiate the extention instance with the standard controller
            
              CreateNewQuoteExtension  ext=new CreateNewQuoteExtension (con); 
              ext.GLDName = NULL; // To check GLDepartment as NULL
              String GLDName1 = ext.getGLDName();
              ext.setGLDName(GLDName1);
              List<SelectOption> options1 = ext.getGLDepartments(); 
           
              ext.GLCName =testGL.id;
              String GLCName2 = ext.getGLCName();
              ext.setGLCName(GLCName2);
              List<SelectOption> options2 = ext.getGLCodes();
          
             ApexPages.PageReference result1=ext.saveme();
      
             ext.GLDName = testGLD.id; 
             String GLDName3 = ext.getGLDName();
             ext.setGLDName(GLDName3);
             List<SelectOption> options3 = ext.getGLDepartments(); 
          
             ext.GLCName = NULL; // To Check when GL Codes as NULL
             String GLCName4 = ext.getGLCName();
             ext.setGLCName(GLCName4);
             List<SelectOption> options4 = ext.getGLCodes(); 
          
           // Invoke the primary method on the extension 
             result1=ext.saveme();
             ext.GLDName = testGLD.id;
             String GLDName5 = ext.getGLDName();
             ext.setGLDName(GLDName5);
             List<SelectOption> options5 = ext.getGLDepartments(); 
          
             ext.GLCName = testGL.id;
             String GLCName6 = ext.getGLCName();
             ext.setGLCName(GLCName6);
             List<SelectOption> options6 = ext.getGLCodes(); 
          
             result1=ext.saveme();
             result1=ext.cancelme();
            
             System.assertEquals('Quote 606', testQ.Name);
             result1=ext.saveme();
                       
            // Negative Test 
             Quote__c testQ2=new Quote__c();
             ApexPages.currentPage().getParameters().put('jobid',testJob1.Id);
             ApexPages.StandardController con1=new ApexPages.StandardController(testQ2); 
             CreateNewQuoteExtension ext1=new CreateNewQuoteExtension(con1);
             ApexPages.PageReference result3=ext.saveme();
             ApexPages.PageReference result4=ext.cancelme();
            
             Quote__c testQ1=new Quote__c(Name='Quote 607',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.Id,Request_Date__c=System.Today(),Due_Date__c=System.Today()+1,Approved__c=false);
             insert testQ1;
               
             GL_Department__c testGLD1 = new GL_Department__c(Name='EnterPrise');
             try
              {
              insert testGLD1;
              }
             catch(System.DMLException e)
              {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }     
           
             GL_Code__c testGL1=new GL_Code__c(Name='Test GL Code607',GL_ID__c='Test GL607',GL_Department__c=testGLD1.id);
             insert testGL1;
           
             Quote__c q =[Select id,Name,Job__c,Approved__c,GL_Code__c from Quote__c where id =: testQ1.id limit 1];
              q.Approved__c = true;
              q.GL_Code__c=testGL1.Id;
              try
               {
                 update q;
               }
              catch(System.DMLException e)
               {
                 System.assertEquals('FIELD_FILTER_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
               }
             
             Quote__c q1 =[Select id,Name,Job__c,Approved__c,GL_Code__c,Request_Date__c,Due_Date__c from Quote__c where id =: testQ1.id limit 1];
             q1.Request_Date__c=System.Today()+1;
             q1.Due_Date__c=System.Today();
             try
              {
                update q1;
              }
             catch(System.DMLException e)
              {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
              }
       }*/
}