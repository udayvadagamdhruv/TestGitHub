// This class is used to display PO Detail page
public with sharing class PODetailPageExtension 
{
    // Global variables
    public List<Purchase_Order__c> po{get;set;} 
    String theID;
    // End of Global variables
    
    // Start Constructor
    public PODetailPageExtension(ApexPages.StandardController controller) 
    {
         theID = ApexPages.CurrentPage().getParameters().get('id');
         po=[select id,Name,Status__c from Purchase_Order__c where id =: theID AND Status__c = 'Sent'];
         //  po=[select id,Name,Status__c from Purchase_Order__c where id =: theID];
    }
    // End of Constructor
     
    // Test Method 
  static testMethod void PODetail()
    {
       Purchase_Order__c PO = new Purchase_Order__c();
       ApexPages.StandardController con=new ApexPages.StandardController(PO);
       PODetailPageExtension ext=new PODetailPageExtension(con);
       System.assertEquals(PO.id,ext.theID);
    } 
 // End of test Method
} // End of Class