// This Method is Used in Edit Vendor Quote VF page 
public with sharing class EditVendorQuoteExtensions
{
   // Global variables
   /* private final Vendor_Quote__c objVendorQuote;
    String QuoteID;
    // End of Global variables
    
    //Constructor 
    public EditVendorQuoteExtensions(ApexPages.StandardController controller) 
    {
        this.objVendorQuote=(Vendor_Quote__c)controller.getrecord();
        QuoteID = objVendorQuote.Quote__c;
    }
    // End Of Constructor 
    
    //Method to Update Vendor Quote 
    Public PageReference saveme()
     {
      String strid,strid1;
      try
       {
            update objVendorQuote;
            strid1=objVendorQuote.Id;
       }
       catch(System.DMLException e)
        {
            return null;
        }        
      PageReference p =  new Pagereference('/apex/QuoteDetailPage?id='+QuoteID);
      p.setRedirect(true);
      return p;  
     }
   // End of Save Method 
    
        // Start Test Coverage Code
        static testMethod void Test_EditVendorQuoteExtensions()
         {
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 609');
             
                insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 609',Media_Types__c=testMedia.Id);
             
                insert testST;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 609');
            
                insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 609',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
              System.assertEquals('Test Job 609',testJob1.Name);
                
              GL_Department__c testGLD = new GL_Department__c(Name='TestGLD18');
               try
                {
                insert testGLD;
                }
               catch(System.DMLException e)
                {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                }  
   
              Quote__c testQ=new Quote__c(Name='Quote 609',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
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
              
                Vendor__c testVendor=new Vendor__c(Name='Vendor 609');
                insert testVendor;
             
                Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
                try
                 {
                   insert testVQ;
                 }
                catch(System.DMLException e)
                 {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
                 }
              
                Vendor_Quote__c editVQ=[Select id,Name,Amount__c from Vendor_Quote__c where id =: testVQ.id];
                editVQ.Amount__c = 600;
                
                // Instantiate the standard controller with the Vendor Quote
            
                ApexPages.StandardController con=new ApexPages.StandardController(editVQ);
                ApexPages.currentPage().getParameters().put('Id',editVQ.Id);
        
               // Instantiate the extention instance with the standard controller
            
               EditVendorQuoteExtensions ext=new EditVendorQuoteExtensions(con);
        
              // Invoke the primary method on the extension
           
              ApexPages.PageReference result1=ext.saveme();
            
              delete editVQ;
              result1=ext.saveme();
       }    
  /* End of Positive Test Case*/    
}
/* End of Test Class */