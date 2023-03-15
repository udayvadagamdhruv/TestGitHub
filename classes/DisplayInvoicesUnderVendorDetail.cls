// This class is used to display Invoice under Vendor Detail
public with sharing class DisplayInvoicesUnderVendorDetail 
{
     // Start Global variables
     /*   public List<Invoice__c> invoice{get;set;} 
        String theID;
    // End of Global variables
    
    // Start Constructor
     public DisplayInvoicesUnderVendorDetail()
     {
         theID = ApexPages.CurrentPage().getParameters().get('id');
         invoice = [Select id,Name,Job__r.Name,Purchase_Order__r.Name,Job__c,Vendor__c,Vendor__r.Name,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c from Invoice__c where Vendor__c =: theID Order By Name ];
     }
     // End constructor
 
    // Test Method 
     static testMethod void Test_DisplayInvoicesUnderVendorDetail()
     {
              Invoice__c INV = new Invoice__c();
          
            // Instantiate the extention instance with the custom controller
           DisplayInvoicesUnderVendorDetail ext=new DisplayInvoicesUnderVendorDetail();
           
            // Instantiate the extention instance with the Custom Controller
           DisplayInvoicesUnderVendorDetail ext1=new DisplayInvoicesUnderVendorDetail();
           System.assertEquals(INV.id,ext.theID);
      } */
     // End of test Method
}
// End of Class