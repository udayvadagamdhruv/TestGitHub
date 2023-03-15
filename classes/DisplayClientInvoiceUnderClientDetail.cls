public with sharing class DisplayClientInvoiceUnderClientDetail {

// Global variables
    public List<Client_Invoice__c> ClientInvoice{get;set;}
    Public String theID; 
    // End of Global variables

    // Start Constructor
    public DisplayClientInvoiceUnderClientDetail()
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        ClientInvoice = [Select id,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Job__r.Name,Notes__c,Term__c from Client_Invoice__c where Client_Name__c =: theID Order BY Name];
    }
    // End of Constructor

}