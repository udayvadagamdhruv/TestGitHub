// This class is used for generating Quote Report.
public with sharing class PrintQuoteExtension 
{
      // Global variables
      public DateTime today{get;set;}
      String theID;
      public List<Quote_Spec_Item__c> vqli{get;set;}
      public List<Document> lstDoc;
      public String imageBody{get;set;}
      public String imageURL{get;set;}
      public boolean imageNotFound{get;set;}
     // End Global variables

    public PrintQuoteExtension(ApexPages.StandardController controller) 
    {
         // Code to display Subsriber Organization Logo

        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
        
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo'  WITH SECURITY_ENFORCED LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }

        // End of code to display Subscriber Organization Logo
        
        theID = ApexPages.CurrentPage().getParameters().get('id');
        Vendor_Quote__c objVendorQ = [select Id,Quote__c from Vendor_Quote__c where id =: theID WITH SECURITY_ENFORCED];
        String qid = objVendorQ.Quote__c;
        vqli=[select id,Name,Description__c from Quote_Spec_Item__c where Quote__c =: qid WITH SECURITY_ENFORCED Order By CreatedDate];
        today=System.NOW();
    }
    
    // Test Method 
   
    // End Test Coverage
}
//End of Test Class