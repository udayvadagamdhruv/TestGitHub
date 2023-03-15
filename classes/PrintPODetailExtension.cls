// This class is used for generating Quote Report.
public with sharing class PrintPODetailExtension 
{
      // Global variables
      public DateTime today{get;set;}
      String theID;
      public List<PO_Line_Item__c> poli{get;set;}
     // End Global variables

    public PrintPODetailExtension(ApexPages.StandardController controller) 
    {
    theID = ApexPages.CurrentPage().getParameters().get('id');
    poli=[select id,Name,Amount__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,GL_Code__c,GL_Code__r.Name,Unit_Type__c,Invoice_Created__c,Purchase_Order__c,Quantity__c from PO_Line_Item__c where Purchase_Order__c  =: [Select id from Purchase_Order__c  where id =: theID] WITH SECURITY_ENFORCED  Order By Name];
  //  poli=[select id,Name,Amount__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,(select id,Name,Description__c,Estimates__c from Estimate_Line_Item__r.Estimate_Spec_Item__c esi where Estimates__c =: poli1.Estimate_Line_Item__c),GL_Code__c,GL_Code__r.Name,Unit_Type__c,Invoice_Created__c,Purchase_Order__c,Quantity__c from PO_Line_Item__c poli1 where Purchase_Order__c  =: [Select id from Purchase_Order__c  where id =: theID] Order By Name];
  // poli=[select id,Name,Amount__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,GL_Code__c,GL_Code__r.Name,Unit_Type__c,Invoice_Created__c,Purchase_Order__c,Quantity__c,(Select Estimate_Line_Item__r.Id,Estimate_Line_Item__r.Name from Estimate_Line_Item__c) from PO_Line_Item__c where Purchase_Order__c  =: [Select id from Purchase_Order__c  where id =: theID] Order By Name];
     today=System.NOW();
    
    }
    
   
}
//End of Test Class