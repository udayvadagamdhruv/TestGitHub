// This class is used to Display PO's Under Vendor Detail
public with sharing class DisplayPOUnderVendorDetail 
{/*
    // Global variables
    public List<Purchase_Order__c> purchaseorder{get;set;}
    String theID; 
    // End of Global variables

    // Start Constructor
    public DisplayPOUnderVendorDetail()
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        purchaseorder = [Select id,Name,Due_Date__c,Job__r.Name,Approved_By_Staff__r.Name,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Vendor__c =: theID Order BY Name];
    }
    // End of Constructor
    
    // Test Coverage Code 
     static testMethod void DisplayPOUnderVendor()
    {
           Purchase_Order__c po = new Purchase_Order__c();
        
            // Instantiate the extention instance with the Custom Controller
    
           DisplayPOUnderVendorDetail ext=new DisplayPOUnderVendorDetail();
    
           DisplayPOUnderVendorDetail ext1=new DisplayPOUnderVendorDetail();
    
           System.assertEquals(po.id,ext.theID);       
    } // End of test Method*/
}// End of Class