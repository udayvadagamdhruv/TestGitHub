@isTest
public class TestCreateNewQuoteSpecItemExtension {
	/*static testMethod void CreateQuoteSIPositiveTest()
     {
        Job_Number_Setting__c customSetting995 = new  Job_Number_Setting__c(Name= 'yy');
        insert customSetting995;
 
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 320');
        insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 320',Media_Types__c=testMedia.Id);
        insert testST;
                 
        Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 320',Media_Types__c=testMedia.Id);
         try
          {
          insert testST1;
          }
         catch(System.DMLException e)
          {
          System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
              
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 320');
        insert testSpec;
                
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 320');
         try
          {
          insert testSpec1;
          }
         catch(System.DMLException e)
          {
          System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
           
        Job__c testJob1=new Job__c(Name='Test Job 320',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         try
          {
          insert testJob1;
          }
         catch(System.DMLException e)
          {
          System.assert(e.getMessage().contains('Job with same name Exists'));
          }
         System.assertEquals('Test Job 320',testJob1.Name);      
       
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD11');
          try
           {
           insert testGLD;
           }
          catch(System.DMLException e)
           {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
           }
            
         Quote__c testQ=new Quote__c(Name='Quote 320',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
          try
           {
           insert testQ;
           }
          catch(System.DMLException e)
           {
           System.assert(e.getMessage().contains('Job with same name Exists'));
           }
               
         Quote_Spec_Item__c testQSI = new Quote_Spec_Item__c(Name='Spec Item 320',Quote__c=testQ.Id);
          
                  ApexPages.currentPage().getParameters().put('QId',testQ.id); 
         ApexPages.StandardController con=new ApexPages.StandardController(testQSI);
         CreateNewQuoteSpecItemExtension  ext=new CreateNewQuoteSpecItemExtension(con);
        
         ApexPages.PageReference result1=ext.saveme();
            
         Quote_Spec_Item__c testQSI1 = new Quote_Spec_Item__c();
            
          ApexPages.currentPage().getParameters().put('QId',testQ.id); 
         ApexPages.StandardController con1=new ApexPages.StandardController(testQSI1);
         CreateNewQuoteSpecItemExtension  ext1=new CreateNewQuoteSpecItemExtension(con1);
        
         ApexPages.PageReference result2=ext1.saveme();
         result2 = ext.cancelme();
     }*/
}