public with sharing class DisplayEstimateLIWhenApproved 
{
    // Global variables
    String theID;
    public List<Estimate_Spec_Item__c> vq{get;set;} 
    // End of Global variables
    
    // Start Constructor
    public DisplayEstimateLIWhenApproved(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        vq=[select id,Name,Description__c from Estimate_Spec_Item__c where Estimates__c =: theID Order By CreatedDate];
    }
    // End of Constructor
    
     // Test Method       
      static testMethod void DisplayELIWhenApproved()
      {
           Estimate_Spec_Item__c ESI = new Estimate_Spec_Item__c();
           
          // Instantiate the standard controller with the Estimate Spec Item
           ApexPages.StandardController con=new ApexPages.StandardController(ESI);
           
           // Instantiate the extention instance with the standardcontroller
           DisplayEstimateLIWhenApproved ext=new DisplayEstimateLIWhenApproved(con);
           System.assertEquals(ESI.id,ext.theID);    
    } 
 // End of test Method
}// End of Class