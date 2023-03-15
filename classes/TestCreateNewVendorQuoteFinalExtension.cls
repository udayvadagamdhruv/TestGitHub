@isTest
public class TestCreateNewVendorQuoteFinalExtension {
/*	static testMethod void CreateNewVendorQuotePositiveTest()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 357');
             
                 insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 357',Media_Types__c=testMedia.Id);
             
                 insert testST;
    
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 357');
             
                 insert testSpec;
  
              Job__c testJob1=new Job__c(Name='Test Job 357',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
            
              GL_Department__c testGLD = new GL_Department__c(Name='TestGLD');
              try
              {
                insert testGLD;
              }
              catch(System.DMLException e)
              {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
        
              Quote__c testQ=new Quote__c(Name='Quote 357',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
              try
               {
                   insert testQ;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('REQUIRED_FIELD_MISSING',e.getDmlStatusCode(0));
               }
               catch(Exception f)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
               }
               
              System.assertEquals('Quote 357',testQ.Name);
               
              Quote_Spec_Item__c QSI=new Quote_Spec_Item__c(Name='Test QSI',Description__c='Des Test',Quote__c=testQ.Id);
               insert QSI;
              Quote_Spec_Item__c QSI1=new Quote_Spec_Item__c(Name='Test QSI1',Description__c='Des Test1',Quote__c=testQ.Id);
               insert QSI1;
               
              Vendor__c testVendor=new Vendor__c(Name='Vendor 357');
                insert testVendor;
             
              Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
              
             GL_Code__c glcode=new GL_Code__c(name='GL Code Test',GL_ID__c='111907',GL_Department__c=testGLD.id,Unit_Type__c='Days',Unit_Cost__c=100);
         	 insert glcode;  
             
             Vendor_GL_Code__c vendglcode=new Vendor_GL_Code__c(Vendor__c=testVendor.Id,GL_Code__c=glcode.id);
             insert vendglcode;
                 
                 
              ApexPages.currentPage().getParameters().put('qid',testQ.id);
              ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
            
              // Instantiate the extention instance with the standard controller
            
              CreateNewVendorQuoteFinalExtension  ext=new CreateNewVendorQuoteFinalExtension (con);
          
             //Example of calling a public method in the controller apex class
             List<SelectOption> options = ext.getVendor();
           
            // Invoke the primary method on the extension
            ApexPages.PageReference result1=ext.saveme();
            ApexPages.PageReference result2=ext.cancelme();
            ext.getVendorName();
             ext.setVendorName('vendor');
            System.assertEquals(testQ.Id,testVQ.Quote__c);

           } */
}