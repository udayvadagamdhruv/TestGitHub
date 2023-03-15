// This class is used to Display POLI When PO Status Is Sent
public with sharing class DisplayPOLIWhenPOStatusIsSent 
{
    // Global variables
    Public String theID;
    public List<PO_Line_Item__c> poli{get;set;} 
    Public Boolean ShowProductionEstimate{get;set;}
    // End of Global variables
    
    // Start Constructor
    public DisplayPOLIWhenPOStatusIsSent(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        poli=[select id,Name,Estimate_Line_Item__c,Production_Estimate__c,Estimate_Line_Item__r.name,Invoice_Created__c,Purchase_Order__c,Amount__c,GL_Code__c, Unit_Type__c, Quantity_production__c,Quantity__c from PO_Line_Item__c where Purchase_Order__c =: [Select id from  Purchase_Order__c where id =: theID] Order By Name];
       
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
    
    }
    // End of Constructor

    
} // End of Class