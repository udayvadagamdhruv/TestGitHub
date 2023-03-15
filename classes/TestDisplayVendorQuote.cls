@isTest
public class TestDisplayVendorQuote {
	/*static testMethod void DisplayVendorQuote()
    {
         DisplayVendorQuoteExtension ext=new DisplayVendorQuoteExtension();
           
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 370');
             
                insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 370',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 370');
                insert testSpec;
                
         Job__c testJob1=new Job__c(Name='Test Job 370',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
         System.assertEquals('Test Job 370',testJob1.Name);      
               
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD5');
             try
              {
               insert testGLD;
              }
             catch(System.DMLException e)
              {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
              }
               
         Quote__c testQ=new Quote__c(Name='Quote 370',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
            try
             {
              insert testQ;
             }
            catch(System.DMLException e)
             {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
         System.assertEquals('Quote 370',testQ.Name);     
         
         
         Vendor__c testVendor=new Vendor__c(Name='Vendor2220');
           try
            {
             insert testVendor;
            }
           catch(System.DMLException e)
            {
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
             
         Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500,Restrict__c=false);
         insert testVQ; 
         
         Vendor_Quote__c testVQ1=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=600,Restrict__c=false);
         insert testVQ1;  
           
           
        ApexPages.currentPage().getParameters().put('Id',testQ.Id);
           
        // Instantiate the extention instance with the Custom Controller
        DisplayVendorQuoteExtension ext1=new DisplayVendorQuoteExtension();
        ext1.strID = testVQ.id;
       ext1.Approve();
        Vendor_Quote__c testVQ3=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=600,Restrict__c=true);
         insert testVQ3;
        ext1.Approve();
          // Invoke the primary method on the extension
        ApexPages.PageReference result1=ext1.CreateVQ();
        result1=ext1.save();
        result1=ext1.ApproveVendor();
    }*/
    
}