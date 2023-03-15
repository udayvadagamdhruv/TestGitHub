// This class is used Display Spec Items when Quote Approved
public with sharing class DisplaySIwhenQuoteApproved 
{
    // Global variables
/*String theID;
    public List<Quote_Spec_Item__c> qsi{get;set;} 
    // End of Global variables
    
    // Start Constructor
    public DisplaySIwhenQuoteApproved(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        qsi=[select id,Name,Description__c,Quote__c from Quote_Spec_Item__c where Quote__c =: theID Order By CreatedDate];
    }
    // End of Constructor
    
    // Test Method 
  static testMethod void test_DisplaySIwhenQuoteApproved()
    {
        Quote_Spec_Item__c QSI = new Quote_Spec_Item__c();
        Quote__c q = new Quote__c();
        ApexPages.StandardController con=new ApexPages.StandardController(QSI);
        DisplaySIwhenQuoteApproved ext=new DisplaySIwhenQuoteApproved(con);
        System.assertEquals(q.id,ext.theID);
    } 
 // End of test Method     */   
}
// End of Class