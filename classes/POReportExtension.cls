// This class is used for generating Purchase Report
public with sharing class POReportExtension 
{
    // Start Global variables
    public List<Purchase_Order__c> purchaseorder{get;set;} 
    public String theID;
    Sobject sumCash; 
    // End of Global variables
    
    // Start Constructor
    public POReportExtension(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        purchaseorder = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Vendor__r.Name,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID WITH SECURITY_ENFORCED Order BY Name];
    }
    // End of Constructor

   // This method is called on to retrieve Total cost in purchase order  
   public double getSumCash()
   { 
       sumCash = [SELECT SUM(Total_Amount__c) sum FROM Purchase_Order__c WHERE Job__c =: [Select id from Job__c where id =: theID] WITH SECURITY_ENFORCED ];   
       return double.valueOf(sumCash.get('sum')); 
   }  
   // End of method getSumCash
   
    
}// End of Class