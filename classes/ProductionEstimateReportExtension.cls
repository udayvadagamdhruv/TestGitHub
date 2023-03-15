public with sharing class ProductionEstimateReportExtension {

    // Global variables
     Public String theID;
     public List<Production_Estimate__c> vq{get;set;}
     Sobject sumCash; 
     public List<Document> lstDoc;
     public String imageBody{get;set;}
     public String imageURL{get;set;}
     public boolean imageNotFound{get;set;}
     public map<string,list<Production_Estimate__c>> MapPE{get;set;}
     // End Global variables
     
     // Start Constructor
    public ProductionEstimateReportExtension(ApexPages.StandardController controller) 
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
         vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,PE_Template__c,Job__c,Vendor__r.Name,Quote__r.Name,Amount__c,Calc_Unit__c,Total_Cost__c,Quantity__c,Restrict__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] WITH SECURITY_ENFORCED  Order By Sort_Order__c];
         
         
           MapPE = new map<string,list<Production_Estimate__c>>();
         
         for(Production_Estimate__c JS:vq)
         {
               if(MapPE.containsKey(js.PE_Template__c))
               {
                  List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                  PElist.add(js);
                  MapPE.put(js.PE_Template__c,PElist);  
                }
                else
                {
                  MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                }   
         
         }
    }
    // End of Constructor
    
   // This method is used to retrieve Total Cost
    public double getSumCash()
    { 
       sumCash = [SELECT SUM(Total_Cost__c) sum FROM Production_Estimate__c WHERE Job__c =: [Select id from Job__c where id =: theID] WITH SECURITY_ENFORCED];   
       return double.valueOf(sumCash.get('sum')); 
    }  
    // ENd of method getSumCash

}