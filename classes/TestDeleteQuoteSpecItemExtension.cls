@isTest
public class TestDeleteQuoteSpecItemExtension {
/*	static testMethod void DeleteQuotePositiveTest()
   {
   
      Job_Number_Setting__c customSetting985 = new  Job_Number_Setting__c(Name= 'yy');
      insert customSetting985;
      
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 603');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 603',Media_Types__c=testMedia.Id);
      insert testST;
                 
      Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 604',Media_Types__c=testMedia.Id);
      insert testST1;
                 
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 603');
      insert testSpec;
                
      Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 604');
      insert testSpec1;
           
      Job__c testJob1=new Job__c(Name='Test Job 603',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
          insert testJob1;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('DUPLICATE_VALUE'  , e.getDmlStatusCode(0));
         }
      System.assertEquals('Test Job 603',testJob1.Name);
               
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD995');
        try
         {
          insert testGLD;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }
              
      GL_Code__c testGL=new GL_Code__c(Name='GL Code 9986',GL_ID__c='TestGL9986',GL_Department__c = testGLD.id);
       try
        {
          insert testGL;
          System.debug('GL Code inserted successfully@@@ '+testGL);
        }
       catch(System.DMLException e)
        {
          System.debug(e.getMessage());
        }  
               
      Quote__c testQ=new Quote__c(Name='Quote 603',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id);
        try
         {
              insert testQ;
         }
        catch(System.DMLException e)
         {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
         }
      Quote_Spec_Item__c testQSI = new Quote_Spec_Item__c(Name='Spec Item 603',Quote__c=testQ.Id);
      insert testQSI; 
             
      // Instantiate the extention instance with the standard controller 
      ApexPages.StandardController con=new ApexPages.StandardController(testQSI);
      ApexPages.currentPage().getParameters().put('Id',testQSI.Id);
      DeleteQuoteSpecItemExtension ext=new DeleteQuoteSpecItemExtension(con);
        
      // Invoke the saveme method on the extension 
      ApexPages.PageReference result1=ext.checkDelete();
      ApexPages.PageReference result2=ext.checkDelete();
  }*/
}