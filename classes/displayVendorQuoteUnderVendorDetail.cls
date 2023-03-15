// This page is used  to display Vendor Quotes undr Vendor Detail record
public with sharing class displayVendorQuoteUnderVendorDetail 
{/*
    // Global variables
    public List<Vendor_Quote__c> vq{get;set;}
    // End Global variables
    
    // Start Constructor
    public displayVendorQuoteUnderVendorDetail()
    {
        String theID = ApexPages.CurrentPage().getParameters().get('id');
        vq=[select id,Name,Date__c,Amount__c,Quote__r.Name,Vendor__r.Name,Vendor__c,Restrict__c,Quote__c,Quote__r.Job__c from Vendor_Quote__c where Vendor__c =: theID ORDER BY Quote__r.Name];
    }
    // End constructor

    // Start Test Coverage
    static testMethod void Test_displayVendorQuoteUnderVendorDetail()
      {
           Vendor__c testVendor=new Vendor__c(Name='V999');
                insert testVendor;
           System.assertEquals('V999',testVendor.Name);
         
            ApexPages.currentPage().getParameters().put('id',testVendor.Id);
            
            // Instantiate the extention instance with the standard controller 
            
            displayVendorQuoteUnderVendorDetail  ext=new displayVendorQuoteUnderVendorDetail();
       }*/
       // End of Test Coverage 
}
// End of Class