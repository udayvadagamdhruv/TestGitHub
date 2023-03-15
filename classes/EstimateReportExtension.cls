// This class is used for generating Estimate Report.
public with sharing class EstimateReportExtension 
{
    // Global variables
     public String theID;
     public List<Estimate_Line_Items__c> vq{get;set;}
     Sobject sumCash; 
     public List<Document> lstDoc;
     public String imageBody{get;set;}
     public String imageURL{get;set;}
     public boolean imageNotFound{get;set;}
     // End Global variables
     
     // Start Constructor
    public EstimateReportExtension(ApexPages.StandardController controller) 
    {
        // Code to display Subsriber Organization Logo

        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }

        // End of code to display Subscriber Organization Logo
         theID = ApexPages.CurrentPage().getParameters().get('id');
         vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = True WITH SECURITY_ENFORCED Order By Name];
    }
    // End of Constructor
    
   // This method is used to retrieve Total Cost
    public double getSumCash()
    { 
       sumCash = [SELECT SUM(Total_Amount__c) sum FROM Estimate_Line_Items__c WHERE Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true WITH SECURITY_ENFORCED ];   
       return double.valueOf(sumCash.get('sum')); 
    }  
    // ENd of method getSumCash
    // Start Test Coverage
   
     
    
}// End of Class