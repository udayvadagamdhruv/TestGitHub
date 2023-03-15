// This class is used to Display Vendor Qupte when Quote Approved
public with sharing class DisplayVQwhenQuoteApproved 
{
 /*   // Global variables
    String theID;
    public List<Vendor_Quote__c> vq{get;set;} 
    // End of Global variables
    
    // Start constructor
    public DisplayVQwhenQuoteApproved(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        vq=[select id,Name,Vendor__c,Vendor__r.Name,Date__c,Amount__c,Restrict__c,Quote__c from Vendor_Quote__c where Quote__c =: [Select id from  Quote__c where id =: theID] Order By Name];
    }
    // End of Constructor
    
   // Test Method 
  static testMethod void Test_DisplayVQwhenQuoteApproved()
    {
       Quote__c q = new Quote__c();
       Vendor_Quote__c VQ = new Vendor_Quote__c();
       
       // Instantiate the standard controller with the Vendor Quote
       
       ApexPages.StandardController con=new ApexPages.StandardController(VQ);
       
        // Instantiate the extention instance with the standard controller
       DisplayVQwhenQuoteApproved ext=new DisplayVQwhenQuoteApproved(con);
       System.assertEquals(q.id,ext.theID);
    } */
 // End of test Method
}
// End of Class