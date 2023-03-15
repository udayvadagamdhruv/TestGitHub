@isTest
public class Test_DisplayEstimateunderJobTab{
/*
     // Test Coverage Code
     static testMethod void Test_DisplayEstimateunderJobTab()
      {
          test.starttest();
          DisplayEstimateunderJobTab ext=new DisplayEstimateunderJobTab();
           
          Job_Number_Setting__c customSetting621 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting621;
             
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 621');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 621',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 621');
                insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 621',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
           
            System.assertEquals('Test Job 621',testJob1.Name);
           
            GL_Department__c testGLD1 = new GL_Department__c(Name='GLD3');
            try
            {
                insert testGLD1;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }      
           Estimate_Line_Items__c testELINew=new Estimate_Line_Items__c(Name='Est361',Job__c=testjob1.Id,GL_Department__c=testGLD1.id);
              try
               {
                   insert testELINew;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
               
               test.stoptest();
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
            // Instantiate the extention instance with the controller
           DisplayEstimateunderJobTab ext1=new DisplayEstimateunderJobTab();
          
           ApexPages.PageReference result1=ext1.CreateELI();
          
           result1=ext1.save();
           result1=ext1.cancelme();
           result1=ext1.createPO();
           
         DisplayEstimateunderJobTab ext4=new DisplayEstimateunderJobTab();
         Double result=ext4.getSumCash();
        
         ApexPages.currentPage().getParameters().put('Id',testELINew.Id);
        
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD994');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
              
           GL_Code__c testGL=new GL_Code__c(Name='GL Code 9984',GL_ID__c='TestGL9984',GL_Department__c = testGLD.id);
            try
             {
                 insert testGL;
                 System.debug('GL Code inserted successfully@@@ '+testGL);
             }
             catch(System.DMLException e)
             {
                 System.debug(e.getMessage());
             }
            Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 8901',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
                insert testELI;
            
            Estimate_Line_Items__c testELI1=new Estimate_Line_Items__c(Name='Quote 601',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Amount__c=123456);
                insert testELI1;
            
         //   ext1.theID=testJob1.Id;
            result1=ext1.save();
             
    }  
    
 // End of test Method       
*/

}